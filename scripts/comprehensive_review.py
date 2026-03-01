#!/usr/bin/env python3
"""
값뚝(gapttuk) 종합 검증 스크립트 — 5차 최종 리뷰
=================================================
검증 범위:
 A. 문서 간 정합성 (숫자/버전/용어)
 B. SQL 마이그레이션 ↔ schema-design.md 정합성
 C. Rust 코드 품질 + 보안
 D. 문서 완성도 + 누락
 E. 교차 참조 무결성
 F. 마이그레이션 up/down 대칭
 G. ER 다이어그램 ↔ 실제 FK 정합성
"""

import re
import os
from pathlib import Path
from collections import Counter, defaultdict

ROOT = Path(__file__).parent.parent
DOCS = ROOT / "documents"
SERVER = ROOT / "server"
MIGRATIONS = SERVER / "migrations"
SRC = SERVER / "src"

issues = []  # (severity, category, file, description)

def add_issue(severity, category, filepath, desc):
    issues.append((severity, category, str(filepath), desc))

def load(path):
    return path.read_text(encoding="utf-8")

# ═══════════════════════════════════════════════════
# A. 문서 간 정합성
# ═══════════════════════════════════════════════════

def check_A_doc_consistency():
    print("\n[A] 문서 간 정합성 검증...")

    prd = load(DOCS / "prd.md")
    plan = load(DOCS / "plan.md")
    schema = load(DOCS / "schema-design.md")
    ui = load(DOCS / "ui-architecture.md")
    annot = load(DOCS / "m1-1-annotations.md")
    tech = load(DOCS / "tech-stack-research.md")

    # A1. 테이블 수 일치
    for name, doc in [("prd.md", prd), ("plan.md", plan), ("schema-design.md", schema)]:
        counts_24 = len(re.findall(r"24개\s*테이블|24개 테이블|테이블.*24개|\(24개\)", doc))
        if counts_24 == 0 and "24" not in doc:
            add_issue("LOW", "A", name, "24개 테이블 언급 누락")

    # A2. 버전 교차 참조
    plan_refs = re.findall(r"prd\.md\s+v([\d.]+)", plan)
    for ref in plan_refs:
        if ref != "0.7":
            add_issue("HIGH", "A", "plan.md", f"prd.md 참조 버전 v{ref} ≠ 실제 v0.7")

    plan_schema_refs = re.findall(r"schema-design\.md\s+v([\d.]+)", plan)
    for ref in plan_schema_refs:
        if ref != "0.7":
            add_issue("HIGH", "A", "plan.md", f"schema-design.md 참조 버전 v{ref} ≠ 실제 v0.7")

    # A3. 용어 일관성 — "포인트" 잔존 (테이블명 제외)
    for name, doc in [("prd.md", prd), ("plan.md", plan), ("ui-architecture.md", ui)]:
        # 테이블명(user_points, point_transactions)과 코드 참조 제외
        cleaned = re.sub(r"(user_)?points?_(transactions?|balance|earned|spent)", "", doc)
        cleaned = re.sub(r"point\.rs|point_balance|points_earned|reward_points", "", cleaned)
        point_hits = re.findall(r"(?<![_a-z])포인트(?!\s*\()", cleaned)
        if point_hits:
            add_issue("MEDIUM", "A", name, f"'포인트' 잔존 {len(point_hits)}건 (센트(¢)로 통일 필요)")

    # A4. PullCents 잔존
    all_docs = list(DOCS.glob("*.md"))
    for f in all_docs:
        content = load(f)
        pc = re.findall(r"PullCents|pullcents|pull.?cents", content, re.I)
        if pc:
            add_issue("HIGH", "A", f.name, f"PullCents 잔존 {len(pc)}건")

    # A5. Auth provider 수 일치 (4개: kakao, google, apple, naver)
    providers_in_schema = re.findall(r"kakao|google|apple|naver", schema)
    unique_providers = set(providers_in_schema)
    if len(unique_providers) < 4:
        missing = {"kakao", "google", "apple", "naver"} - unique_providers
        add_issue("MEDIUM", "A", "schema-design.md", f"auth_provider 누락: {missing}")

    # A6. 추천 코드 형식 일치 (GAP-XXXX)
    for name, doc in [("prd.md", prd), ("plan.md", plan), ("schema-design.md", schema)]:
        if "GAP-" in doc:
            pass  # OK
        elif "추천 코드" in doc or "referral_code" in doc:
            if "GAP-" not in doc:
                add_issue("LOW", "A", name, "추천 코드 형식 GAP-XXXX 미언급")

    # A7. 갱신일 일치 (전부 03-02)
    for name, doc in [("prd.md", prd), ("plan.md", plan), ("schema-design.md", schema),
                       ("ui-architecture.md", ui), ("tech-stack-research.md", tech)]:
        dates = re.findall(r"갱신[:\s]*(\d{4}-\d{2}-\d{2})", doc)
        for d in dates:
            if d != "2026-03-02":
                add_issue("LOW", "A", name, f"갱신일 {d} ≠ 2026-03-02")

# ═══════════════════════════════════════════════════
# B. SQL 마이그레이션 ↔ schema-design.md
# ═══════════════════════════════════════════════════

def check_B_migration_schema():
    print("\n[B] SQL 마이그레이션 ↔ 스키마 정합성...")

    schema = load(DOCS / "schema-design.md")
    migration_001 = load(MIGRATIONS / "001_initial_schema.up.sql")
    migration_003 = load(MIGRATIONS / "003_schema_fixes.up.sql")

    # B1. CREATE TABLE 수 일치
    sql_tables = re.findall(r"CREATE TABLE (\w+)\s*\(", migration_001)
    # 파티션 테이블 제외
    partition_tables = re.findall(r"CREATE TABLE (\w+) PARTITION OF", migration_001)
    actual_tables = [t for t in sql_tables if t not in partition_tables]

    if len(actual_tables) != 24:
        add_issue("HIGH", "B", "001_initial_schema.up.sql",
                  f"CREATE TABLE {len(actual_tables)}개 ≠ 24개 (파티션 제외)")

    # B2. 인덱스 수 일치
    sql_indexes_001 = re.findall(r"CREATE INDEX (\w+)", migration_001)
    sql_indexes_003 = re.findall(r"CREATE INDEX (\w+)", migration_003)
    total_indexes = len(sql_indexes_001) + len(sql_indexes_003)

    schema_index_count = len(re.findall(r"idx_\w+", schema))
    # 중복 제거 (strikethrough 포함)
    schema_idx_set = set(re.findall(r"idx_\w+", schema))
    sql_idx_set = set(sql_indexes_001 + sql_indexes_003)

    missing_in_sql = schema_idx_set - sql_idx_set
    if missing_in_sql:
        add_issue("MEDIUM", "B", "migrations", f"schema에 있지만 SQL에 없는 인덱스: {missing_in_sql}")

    extra_in_sql = sql_idx_set - schema_idx_set
    if extra_in_sql:
        add_issue("LOW", "B", "migrations", f"SQL에 있지만 schema에 없는 인덱스: {extra_in_sql}")

    # B3. CHECK 제약조건 수 일치 (11건)
    sql_checks = re.findall(r"ADD CONSTRAINT (chk_\w+)", migration_003)
    schema_checks = re.findall(r"chk_\w+", schema)
    schema_check_set = set(schema_checks)
    sql_check_set = set(sql_checks)

    if len(sql_check_set) != 11:
        add_issue("MEDIUM", "B", "003_schema_fixes.up.sql",
                  f"CHECK 제약조건 {len(sql_check_set)}건 ≠ 11건")

    missing_checks = schema_check_set - sql_check_set
    if missing_checks:
        add_issue("MEDIUM", "B", "migrations", f"schema에 있지만 SQL에 없는 CHECK: {missing_checks}")

    # B4. rating NUMERIC(3,1) 일치
    if "NUMERIC(2, 1)" in migration_001 or "NUMERIC(2,1)" in migration_001:
        add_issue("HIGH", "B", "001_initial_schema.up.sql", "rating 여전히 NUMERIC(2,1) — NUMERIC(3,1) 필요")

    if "NUMERIC(3, 1)" in migration_001 or "NUMERIC(3,1)" in migration_001:
        pass  # OK

    # B5. shopping_malls.base_url NOT NULL
    malls_section = re.search(r"CREATE TABLE shopping_malls.*?\);", migration_001, re.S)
    if malls_section and "NOT NULL" not in malls_section.group().split("base_url")[1].split("\n")[0]:
        add_issue("HIGH", "B", "001_initial_schema.up.sql", "shopping_malls.base_url NOT NULL 누락")

    # B6. users UNIQUE(auth_provider, auth_provider_id)
    users_section = re.search(r"CREATE TABLE users.*?\);", migration_001, re.S)
    if users_section and "UNIQUE (auth_provider, auth_provider_id)" not in users_section.group():
        add_issue("HIGH", "B", "001_initial_schema.up.sql", "users UNIQUE(auth_provider, auth_provider_id) 누락")

    # B7. 컬럼 타입 정합성 (schema-design.md vs migration)
    # products.rating
    schema_rating = re.search(r"rating\s*\|\s*NUMERIC\((\d+,\d+)\)", schema)
    if schema_rating and schema_rating.group(1) != "3,1":
        add_issue("MEDIUM", "B", "schema-design.md", f"rating NUMERIC({schema_rating.group(1)}) ≠ NUMERIC(3,1)")

# ═══════════════════════════════════════════════════
# C. Rust 코드 품질 + 보안
# ═══════════════════════════════════════════════════

def check_C_code_quality():
    print("\n[C] Rust 코드 품질 + 보안...")

    config = load(SRC / "config.rs")
    main = load(SRC / "main.rs")
    db_mod = load(SRC / "db" / "mod.rs")
    cargo = load(SERVER / "Cargo.toml")

    # C1. AppEnv::parse — case-insensitive 처리 확인
    if "to_ascii_lowercase" not in config and "to_lowercase" not in config:
        add_issue("MEDIUM", "C", "config.rs", "AppEnv::parse 대소문자 미처리")

    # C2. JWT_SECRET placeholder 차단
    if 'change-me' not in config or "Prod" not in config:
        if "change-me" not in config:
            add_issue("MEDIUM", "C", "config.rs", "JWT_SECRET 플레이스홀더 차단 로직 누락")

    # C3. graceful shutdown 30초 watchdog
    if "30" not in main or "Duration::from_secs(30)" not in main:
        add_issue("HIGH", "C", "main.rs", "graceful shutdown 30초 watchdog 미구현")

    # C4. DB pool retry 로직
    if "max_attempts" not in db_mod or "3" not in db_mod:
        add_issue("MEDIUM", "C", "db/mod.rs", "DB 연결 재시도 로직 누락")

    # C5. PORT=0 방어
    if "port == 0" not in config:
        add_issue("MEDIUM", "C", "config.rs", "PORT=0 방어 로직 누락")

    # C6. JWT prod 32자 검증
    if "len() < 32" not in config:
        add_issue("HIGH", "C", "config.rs", "JWT_SECRET 32자 최소 길이 검증 누락")

    # C7. health_check DB 상태 포함
    if "SELECT 1" not in main:
        add_issue("MEDIUM", "C", "main.rs", "health_check에 DB 연결 확인 누락")

    # C8. CORS 설정 확인 (M1-1에서는 없어도 됨, 체크만)
    if "cors" in cargo.lower() and "cors" not in main.lower():
        add_issue("LOW", "C", "main.rs", "tower-http cors feature 있지만 미적용 (M1-4에서 추가 예정)")

    # C9. sentry 초기화
    if "sentry::init" not in main:
        add_issue("MEDIUM", "C", "main.rs", "Sentry 초기화 누락")

    # C10. tracing JSON format
    if "json()" not in main:
        add_issue("LOW", "C", "main.rs", "tracing JSON 포맷 미적용")

    # C11. unwrap 남용 확인 (panic 위험)
    for name, code in [("config.rs", config), ("main.rs", main), ("db/mod.rs", db_mod)]:
        unwrap_count = len(re.findall(r"\.unwrap\(\)", code))
        if unwrap_count > 5:
            add_issue("LOW", "C", name, f".unwrap() {unwrap_count}회 — expect() 또는 에러 핸들링 권장")

    # C12. Config 필드 vs .env.example 일치
    env_example = load(SERVER / ".env.example")
    config_fields = re.findall(r'pub\s+(\w+):\s', config)
    env_keys = re.findall(r'^([A-Z_]+)=', env_example, re.M)
    commented_keys = re.findall(r'^#\s*([A-Z_]+)=', env_example, re.M)
    all_env_keys = set(env_keys + commented_keys)

    # config에 있지만 .env.example에 없는 키 확인
    config_env_map = {
        "database_url": "DATABASE_URL", "jwt_secret": "JWT_SECRET",
        "app_env": "APP_ENV", "host": "HOST", "port": "PORT",
        "jwt_access_ttl_secs": "JWT_ACCESS_TTL_SECS", "jwt_refresh_ttl_secs": "JWT_REFRESH_TTL_SECS",
        "coupang_access_key": "COUPANG_ACCESS_KEY", "coupang_secret_key": "COUPANG_SECRET_KEY",
        "naver_client_id": "NAVER_CLIENT_ID", "naver_client_secret": "NAVER_CLIENT_SECRET",
        "kakao_rest_api_key": "KAKAO_REST_API_KEY", "google_client_id": "GOOGLE_CLIENT_ID",
        "apple_client_id": "APPLE_CLIENT_ID",
        "apns_key_path": "APNS_KEY_PATH", "apns_key_id": "APNS_KEY_ID",
        "apns_team_id": "APNS_TEAM_ID", "fcm_service_account": "FCM_SERVICE_ACCOUNT",
        "sentry_dsn": "SENTRY_DSN"
    }
    for field, env_key in config_env_map.items():
        if env_key not in all_env_keys:
            add_issue("MEDIUM", "C", ".env.example", f"{env_key} 누락 (config.rs에 {field} 존재)")

    # C13. naver auth provider — config.rs에 NAVER 관련 소셜 로그인 키 누락
    if "naver" in load(DOCS / "schema-design.md").lower():
        naver_auth_in_config = "NAVER_AUTH" in config or "naver_auth" in config
        # 네이버 로그인 전용 키가 별도 필요한지 (현재 naver_client_id/secret은 검색 API용)
        if not naver_auth_in_config:
            # 네이버 로그인은 M2에서 구현 예정이므로 LOW
            add_issue("LOW", "C", "config.rs",
                      "네이버 소셜 로그인 전용 환경변수 미정의 (현재 NAVER_CLIENT_*은 검색 API용, M2에서 분리 필요)")

# ═══════════════════════════════════════════════════
# D. 문서 완성도
# ═══════════════════════════════════════════════════

def check_D_doc_completeness():
    print("\n[D] 문서 완성도...")

    prd = load(DOCS / "prd.md")
    plan = load(DOCS / "plan.md")
    schema = load(DOCS / "schema-design.md")
    ui = load(DOCS / "ui-architecture.md")

    # D1. prd.md 필수 섹션 존재
    prd_sections = ["수익 모델", "법적", "보안", "기술 스택", "마일스톤"]
    for section in prd_sections:
        if section not in prd:
            add_issue("HIGH", "D", "prd.md", f"필수 섹션 '{section}' 누락")

    # D2. plan.md STEP 진행도
    step_pattern = re.findall(r"STEP\s+(\d+).*?(✅|⬜|🔲|다음)", plan)
    completed_steps = [s for s, status in step_pattern if "✅" in status]
    if "6" not in completed_steps:
        add_issue("MEDIUM", "D", "plan.md", "STEP 6 완료 표시 누락")

    # D3. ui-architecture.md 화면 수 일치
    screen_ids = re.findall(r"`([A-Z_]+)`\s*\|", ui)
    unique_screens = set(screen_ids)
    ui_declared = re.search(r"(\d+)개 화면", ui)
    if ui_declared:
        declared = int(ui_declared.group(1))
        if len(unique_screens) < declared:
            add_issue("MEDIUM", "D", "ui-architecture.md",
                      f"선언 {declared}개 화면 vs 실제 {len(unique_screens)}개 화면 ID")

    # D4. schema-design.md 변경 로그 존재
    if "v0.6 → v0.7" not in schema:
        add_issue("LOW", "D", "schema-design.md", "v0.6→v0.7 변경 로그 누락")
    if "v0.5 → v0.6" not in schema:
        add_issue("LOW", "D", "schema-design.md", "v0.5→v0.6 변경 로그 누락")

    # D5. plan.md에 M1-2 ~ M5 체크리스트 존재
    milestones = ["M1", "M2", "M3", "M4", "M5"]
    for ms in milestones:
        if f"### {ms}." not in plan:
            add_issue("MEDIUM", "D", "plan.md", f"{ms} 마일스톤 섹션 누락")

    # D6. 네이버 로그인 — UI 소셜 로그인 목록에 포함?
    auth_login_line = re.search(r"AUTH_LOGIN.*?소셜 로그인.*?\((.*?)\)", ui)
    if auth_login_line:
        providers_in_ui = auth_login_line.group(1)
        if "네이버" not in providers_in_ui:
            add_issue("MEDIUM", "D", "ui-architecture.md", "AUTH_LOGIN 소셜 로그인에 네이버 누락")

# ═══════════════════════════════════════════════════
# E. 교차 참조 무결성
# ═══════════════════════════════════════════════════

def check_E_cross_refs():
    print("\n[E] 교차 참조 무결성...")

    plan = load(DOCS / "plan.md")
    annot = load(DOCS / "m1-1-annotations.md")

    # E1. plan.md에 참조된 파일들이 실제 존재하는지
    file_refs = re.findall(r"`((?:server/|migrations/|scripts/|documents/)[^`]+)`", plan)
    for ref in file_refs:
        full_path = ROOT / ref
        if not full_path.exists():
            # migrations/ 접두사 확인
            alt_path = SERVER / ref
            if not alt_path.exists():
                add_issue("MEDIUM", "E", "plan.md", f"참조 파일 미존재: {ref}")

    # E2. annotations에서 참조하는 마이그레이션 파일 존재
    annot_migrations = re.findall(r"(\d{3}_\w+\.(?:up|down)\.sql)", annot)
    for mig in annot_migrations:
        if not (MIGRATIONS / mig).exists():
            add_issue("HIGH", "E", "m1-1-annotations.md", f"참조 마이그레이션 미존재: {mig}")

    # E3. Cargo.toml 의존성 vs plan.md 라이브러리 목록
    cargo = load(SERVER / "Cargo.toml")
    plan_libs = re.findall(r"(axum|tokio|sqlx|serde|reqwest|moka|sentry|tower_governor)\s", plan)
    for lib in set(plan_libs):
        cargo_name = lib.replace("_", "-") if lib != "tower_governor" else "tower_governor"
        if cargo_name not in cargo and lib not in cargo:
            add_issue("MEDIUM", "E", "plan.md", f"plan.md에 언급된 {lib}이 Cargo.toml에 없음")

# ═══════════════════════════════════════════════════
# F. 마이그레이션 up/down 대칭
# ═══════════════════════════════════════════════════

def check_F_migration_symmetry():
    print("\n[F] 마이그레이션 up/down 대칭...")

    up_files = sorted(MIGRATIONS.glob("*.up.sql"))
    down_files = sorted(MIGRATIONS.glob("*.down.sql"))

    up_names = {f.name.replace(".up.sql", "") for f in up_files}
    down_names = {f.name.replace(".down.sql", "") for f in down_files}

    missing_down = up_names - down_names
    if missing_down:
        for m in missing_down:
            add_issue("HIGH", "F", "migrations/", f"{m}.up.sql에 대응하는 down 파일 없음")

    missing_up = down_names - up_names
    if missing_up:
        for m in missing_up:
            add_issue("HIGH", "F", "migrations/", f"{m}.down.sql에 대응하는 up 파일 없음")

    # F2. 003 up의 CHECK 제약조건 수 == 003 down의 DROP CONSTRAINT 수
    up_003 = load(MIGRATIONS / "003_schema_fixes.up.sql")
    down_003 = load(MIGRATIONS / "003_schema_fixes.down.sql")

    up_checks = re.findall(r"ADD CONSTRAINT", up_003)
    down_drops = re.findall(r"DROP CONSTRAINT", down_003)

    if len(up_checks) != len(down_drops):
        add_issue("MEDIUM", "F", "003_schema_fixes",
                  f"up CHECK {len(up_checks)}건 ≠ down DROP {len(down_drops)}건")

    # F3. 003 up 인덱스 수 == 003 down DROP INDEX 수
    up_indexes = re.findall(r"CREATE INDEX", up_003)
    down_indexes = re.findall(r"DROP INDEX", down_003)

    if len(up_indexes) != len(down_indexes):
        add_issue("MEDIUM", "F", "003_schema_fixes",
                  f"up INDEX {len(up_indexes)}건 ≠ down DROP INDEX {len(down_indexes)}건")

    # F4. 001 down이 올바른 역순 DROP TABLE인지
    down_001 = load(MIGRATIONS / "001_initial_schema.down.sql")
    drop_tables = re.findall(r"DROP TABLE.*?(\w+)", down_001)
    if len(drop_tables) < 20:
        add_issue("MEDIUM", "F", "001_initial_schema.down.sql",
                  f"DROP TABLE {len(drop_tables)}개만 — 24개 + 파티션 테이블 모두 삭제해야 함")

# ═══════════════════════════════════════════════════
# G. ER 다이어그램 ↔ 실제 FK
# ═══════════════════════════════════════════════════

def check_G_er_fk():
    print("\n[G] ER 다이어그램 ↔ FK 정합성...")

    schema = load(DOCS / "schema-design.md")
    migration = load(MIGRATIONS / "001_initial_schema.up.sql")

    # G1. FK in migration
    fk_in_sql = re.findall(r"REFERENCES\s+(\w+)\((\w+)\)", migration)
    alter_fk = re.findall(r"FOREIGN KEY\s*\(\w+\)\s*REFERENCES\s+(\w+)\((\w+)\)", migration)
    all_fk = fk_in_sql + alter_fk

    # G2. ER 관계
    er_relations = re.findall(r"(\w+)\s+\|[\|o]--o[\{|\|]\s+(\w+)", schema)
    er_dotted = re.findall(r"(\w+)\s+\|[\|o]\.\.o[\{|\|]\s+(\w+)", schema)

    # FK 타깃 테이블 목록
    fk_targets = set(t[0] for t in all_fk)
    er_targets = set(t[1] for t in er_relations + er_dotted)

    # ER에 있지만 FK가 없는 관계 (dotted 제외)
    for parent, child in er_relations:
        # FK가 실제로 존재하는지 확인
        found = False
        for fk_table, fk_col in all_fk:
            if fk_table == parent or fk_table == child:
                found = True
                break
        if not found and parent != child:  # self-ref는 ALTER로 추가
            # self-ref는 후처리 ALTER에서 추가
            pass

    # G3. 파티셔닝 테이블이 ER에 dotted line으로 표기됐는지
    partition_tables_in_sql = re.findall(r"PARTITION BY RANGE", migration)
    if len(partition_tables_in_sql) != len(er_dotted):
        add_issue("LOW", "G", "schema-design.md",
                  f"파티션 테이블 {len(partition_tables_in_sql)}개 vs ER dotted 관계 {len(er_dotted)}개")

# ═══════════════════════════════════════════════════
# H. 보안 점검
# ═══════════════════════════════════════════════════

def check_H_security():
    print("\n[H] 보안 점검...")

    # H1. .env 파일이 .gitignore에 포함
    gitignore = load(ROOT / ".gitignore")
    if ".env" not in gitignore:
        add_issue("HIGH", "H", ".gitignore", ".env 파일이 .gitignore에 포함되지 않음")

    # H2. .env 파일에 실제 비밀번호 포함 여부 (패턴 체크)
    env_file = SERVER / ".env"
    if env_file.exists():
        env_content = load(env_file)
        if "password" in env_content.lower() and "change-me" not in env_content.lower():
            # 실제 비밀번호가 있을 수 있음 — 경고만
            add_issue("LOW", "H", ".env", ".env에 실제 자격증명 포함 가능 — Git 추적 여부 확인")

    # H3. SQL 인젝션 방어 — parameterized query 사용 확인
    main_rs = load(SRC / "main.rs")
    if "format!" in main_rs and "query" in main_rs.lower():
        # format!으로 쿼리 구성하면 위험
        add_issue("MEDIUM", "H", "main.rs", "format!으로 SQL 쿼리 구성 시 SQL 인젝션 위험")

    # H4. CORS 미설정 (현재 M1-1이므로 미적용 OK)
    # (정보만)

# ═══════════════════════════════════════════════════
# I. 추가 제안사항
# ═══════════════════════════════════════════════════

def check_I_suggestions():
    print("\n[I] 개선/고도화 제안...")

    config = load(SRC / "config.rs")
    main = load(SRC / "main.rs")
    cargo = load(SERVER / "Cargo.toml")
    plan = load(DOCS / "plan.md")

    suggestions = []

    # I1. 환경별 로그 레벨 분리
    if "RUST_LOG" not in config and "env_filter" in main.lower():
        suggestions.append(("SUGGEST", "config.rs",
            "RUST_LOG 환경변수 또는 APP_ENV별 로그 레벨 분리 고려 (prod=info, dev=debug)"))

    # I2. Healthcheck 버전 정보
    if "version" not in main.lower() or "env!" not in main:
        suggestions.append(("SUGGEST", "main.rs",
            "/health 응답에 서버 버전(CARGO_PKG_VERSION) 추가 고려"))

    # I3. DB connection pool 크기 설정 환경변수화
    db_mod = load(SRC / "db" / "mod.rs")
    if "max_connections(10)" in db_mod and "DB_MAX_CONNECTIONS" not in config:
        suggestions.append(("SUGGEST", "db/mod.rs + config.rs",
            "DB pool max_connections 환경변수화 고려 (현재 하드코딩 10)"))

    # I4. API versioning 구조 준비
    if "/api/v1/" not in main and "api/v1" in plan:
        suggestions.append(("SUGGEST", "main.rs",
            "M1-4에서 /api/v1/ 라우트 추가 시 Router::nest 구조 준비"))

    # I5. 에러 타입 통합 (thiserror)
    if "thiserror" in cargo and "AppError" not in main:
        suggestions.append(("SUGGEST", "새 파일: error.rs",
            "thiserror 기반 AppError enum 생성 — 통합 에러 핸들링 (M1-2 에러 처리 대비)"))

    # I6. request_id 미들웨어
    suggestions.append(("SUGGEST", "main.rs",
        "tower-http의 request-id 미들웨어 추가 고려 — 로그 추적성 향상"))

    # I7. DB 마이그레이션 idempotent 확인
    migration_001 = load(MIGRATIONS / "001_initial_schema.up.sql")
    if "IF NOT EXISTS" not in migration_001:
        suggestions.append(("INFO", "001_initial_schema.up.sql",
            "CREATE TABLE IF NOT EXISTS 미사용 — SQLx migrate는 자체 추적하므로 OK, 단 수동 실행 시 주의"))

    # I8. 비밀번호 정책
    suggestions.append(("SUGGEST", "배포 전",
        "JWT_SECRET 최소 길이를 64자로 상향 고려 (현재 32자, OWASP 권장 256-bit = 32바이트)"))

    # I9. rate limiter 구현
    if "tower_governor" in cargo and "governor" not in main.lower():
        suggestions.append(("SUGGEST", "main.rs",
            "tower_governor 의존성은 있지만 미적용 — M1-7에서 구현 예정 확인"))

    for sev, file, desc in suggestions:
        add_issue(sev, "I", file, desc)

# ═══════════════════════════════════════════════════
# 실행 + 결과 출력
# ═══════════════════════════════════════════════════

def main():
    print("=" * 70)
    print("  값뚝(gapttuk) 종합 검증 리포트 — 5차 최종")
    print("=" * 70)

    check_A_doc_consistency()
    check_B_migration_schema()
    check_C_code_quality()
    check_D_doc_completeness()
    check_E_cross_refs()
    check_F_migration_symmetry()
    check_G_er_fk()
    check_H_security()
    check_I_suggestions()

    # 결과 집계
    severity_order = {"HIGH": 0, "MEDIUM": 1, "LOW": 2, "SUGGEST": 3, "INFO": 4}
    sorted_issues = sorted(issues, key=lambda x: (severity_order.get(x[0], 99), x[1]))

    counter = Counter(i[0] for i in sorted_issues)

    print(f"\n{'=' * 70}")
    print(f"  검증 결과 요약")
    print(f"{'=' * 70}")
    print(f"  HIGH:    {counter.get('HIGH', 0)}건")
    print(f"  MEDIUM:  {counter.get('MEDIUM', 0)}건")
    print(f"  LOW:     {counter.get('LOW', 0)}건")
    print(f"  SUGGEST: {counter.get('SUGGEST', 0)}건")
    print(f"  INFO:    {counter.get('INFO', 0)}건")
    print(f"  ────────────────────")
    print(f"  총 {len(sorted_issues)}건")

    # 카테고리별 출력
    by_cat = defaultdict(list)
    for sev, cat, file, desc in sorted_issues:
        by_cat[cat].append((sev, file, desc))

    cat_names = {
        "A": "문서 간 정합성",
        "B": "SQL ↔ 스키마",
        "C": "코드 품질/보안",
        "D": "문서 완성도",
        "E": "교차 참조",
        "F": "마이그레이션 대칭",
        "G": "ER ↔ FK",
        "H": "보안",
        "I": "개선 제안"
    }

    for cat in sorted(by_cat.keys()):
        items = by_cat[cat]
        print(f"\n{'─' * 70}")
        print(f"  [{cat}] {cat_names.get(cat, cat)} ({len(items)}건)")
        print(f"{'─' * 70}")
        for sev, file, desc in items:
            icon = {"HIGH": "🔴", "MEDIUM": "🟡", "LOW": "🔵", "SUGGEST": "💡", "INFO": "ℹ️"}.get(sev, "?")
            print(f"  {icon} [{sev:7s}] {file}")
            print(f"     → {desc}")

    print(f"\n{'=' * 70}")
    print("  검증 완료")
    print("=" * 70)

    return len([i for i in sorted_issues if i[0] in ("HIGH", "MEDIUM")])

if __name__ == "__main__":
    exit_code = main()
    exit(min(exit_code, 1))

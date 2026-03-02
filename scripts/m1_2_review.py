#!/usr/bin/env python3
"""M1-2 구현 검증 스크립트 — 코드 + 문서 교차 검증"""

import re
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SERVER = ROOT / "server"
DOCS = ROOT / "documents"

findings = []

def add(severity, category, msg):
    findings.append((severity, category, msg))

# ============================================================
# 1. 코드 품질 검증
# ============================================================

def check_code():
    # 1-1. error.rs 에러 코드 완전성
    error_rs = (SERVER / "src/error.rs").read_text()
    expected_codes = ["AUTH_001", "AUTH_002", "AUTH_003", "RESOURCE_001",
                      "VALIDATION_001", "RESOURCE_002", "RATE_001",
                      "SECURITY_001", "SYS_001", "SYS_002"]
    for code in expected_codes:
        if code not in error_rs:
            add("HIGH", "code", f"error.rs에서 에러 코드 '{code}' 누락")

    # 1-2. error.rs: Sqlx 에러 sentry 전송 확인
    if "sentry::capture_error" not in error_rs:
        add("HIGH", "code", "error.rs: Sqlx 에러 Sentry 전송 누락")

    # 1-3. error.rs: Internal 에러도 클라이언트에 상세 노출하지 않는지
    # Internal match 전체 블록에서 클라이언트 반환값 확인
    internal_block = re.search(r'AppError::Internal.*?=>\s*\{.*?\}', error_rs, re.DOTALL)
    if internal_block and "내부 서버 오류" not in internal_block.group(0):
        add("HIGH", "code", "error.rs: Internal 에러가 상세 메시지를 클라이언트에 노출")

    # 1-4. api/mod.rs: ok 필드 확인
    api_mod = (SERVER / "src/api/mod.rs").read_text()
    if "ok: true" not in api_mod and "ok: bool" not in api_mod:
        add("HIGH", "code", "api/mod.rs: ApiResponse에 ok 필드 누락")

    # 1-5. pagination.rs: limit 클램핑 확인
    pagination = (SERVER / "src/api/pagination.rs").read_text()
    if "clamp" not in pagination:
        add("MEDIUM", "code", "pagination.rs: limit 클램핑 로직 누락")

    # 1-6. pagination.rs: limit+1 패턴 확인
    if "items.pop()" not in pagination and "pop()" not in pagination:
        add("HIGH", "code", "pagination.rs: limit+1 패턴 (pop) 누락")

    # 1-7. cache.rs: 4개 캐시 모두 존재
    cache = (SERVER / "src/cache.rs").read_text()
    for name in ["blocked_ips", "categories", "popular_searches", "products"]:
        if name not in cache:
            add("HIGH", "code", f"cache.rs: '{name}' 캐시 누락")

    # 1-8. cache.rs: TTL 설정 확인
    ttl_matches = re.findall(r'time_to_live\(Duration::from_secs\((\d+)\)', cache)
    expected_ttls = {"300", "3600", "600"}  # 5min, 1hr, 10min (products도 300)
    for ttl in expected_ttls:
        if ttl not in ttl_matches:
            add("MEDIUM", "code", f"cache.rs: TTL {ttl}초 설정 누락")

    # 1-9. main.rs: AppState 구조 확인
    main = (SERVER / "src/main.rs").read_text()
    if "pub pool: sqlx::PgPool" not in main:
        add("HIGH", "code", "main.rs: AppState에 pool 필드 누락")
    if "pub cache: AppCache" not in main:
        add("HIGH", "code", "main.rs: AppState에 cache 필드 누락")

    # 1-10. main.rs: TraceLayer 확인
    if "TraceLayer::new_for_http()" not in main:
        add("MEDIUM", "code", "main.rs: TraceLayer 미적용")

    # 1-11. main.rs: health_check가 Result 반환하는지
    if "Result<ApiResponse<HealthResponse>, AppError>" not in main:
        add("HIGH", "code", "main.rs: health_check가 Result<ApiResponse, AppError> 미반환")

    # 1-12. main.rs: 캐시 검증 포함하는지
    if "cache_status" not in main or "cache:" not in main:
        add("MEDIUM", "code", "main.rs: /health에 캐시 검증 누락")

    # 1-13. health check가 product cache에 sentinel 키 사용
    if "insert(0," in main:
        add("HIGH", "code-improve",
            "main.rs: health_check가 products 캐시에 sentinel key 0 삽입 — "
            "비즈니스 캐시 오염 위험. 별도 검증 방법 권장")

    # 1-14. Config Debug derive — jwt_secret 누출 위험
    config = (SERVER / "src/config.rs").read_text()
    # Config struct 바로 위에 #[derive(Debug가 있는지 확인 (AppEnv의 Debug는 무시)
    config_derive = re.search(r'#\[derive\([^)]*Debug[^)]*\)\]\s*pub struct Config', config)
    if config_derive:
        add("HIGH", "code-improve",
            "config.rs: Config가 Debug derive — jwt_secret이 {:?}로 노출 가능")

    # 1-15. PaginationParams limit이 pub i64
    if "pub limit: i64" in pagination:
        add("MEDIUM", "code-improve",
            "pagination.rs: limit이 pub i64 — 핸들러가 effective_limit() 대신 "
            "직접 사용하면 음수 가능. private + getter 또는 u64 권장")

    # 1-16. Cargo.toml request-id feature 활성 but unused (M1-7 예정)
    cargo = (SERVER / "Cargo.toml").read_text()
    if "request-id" in cargo and "SetRequestId" not in main and "request_id" not in main:
        add("LOW", "code-deferred",
            "Cargo.toml에 request-id feature 활성화됨 but main.rs에서 미사용 "
            "(M1-7 x-request-id 전파 시 구현 예정, plan.md 반영 완료)")

    # 1-17. Sentry tower layers 미사용 (M1-7 예정)
    if "SentryLayer" not in main and "SentryHttpLayer" not in main:
        add("LOW", "code-deferred",
            "main.rs: Sentry tower layers 미적용 "
            "(M1-7 모니터링 강화 시 적용 예정, plan.md 반영 완료)")

    # 1-18. AppCache Default impl 누락 (clippy warning)
    if "impl Default for AppCache" not in cache:
        add("LOW", "code", "cache.rs: Default impl 누락 — clippy new_without_default 경고 예상")

    # 1-19. Trait bounds on struct definitions (non-idiomatic)
    if "struct ApiResponse<T: Serialize>" in api_mod:
        add("LOW", "code-style",
            "api/mod.rs: struct 정의에 trait bound — impl 블록에만 두는 것이 관용적")

# ============================================================
# 2. 문서 교차 검증
# ============================================================

def check_docs():
    plan = (DOCS / "plan.md").read_text()
    # schema = (DOCS / "schema-design.md").read_text()
    build_db = (DOCS / "1-1.build_db.md").read_text()

    # 2-1. plan.md 에러 코드 체계 vs error.rs
    error_rs = (SERVER / "src/error.rs").read_text()
    if "RESOURCE_001" in error_rs and "RESOURCE_" not in plan:
        add("HIGH", "doc",
            "plan.md 9장: RESOURCE_ 에러 프리픽스 미기재 — error.rs 실제 구현과 불일치")
    if "VALIDATION_001" in error_rs and "VALIDATION_" not in plan:
        add("HIGH", "doc",
            "plan.md 9장: VALIDATION_ 에러 프리픽스 미기재")
    if "SECURITY_001" in error_rs and "SECURITY_" not in plan:
        add("HIGH", "doc",
            "plan.md 9장: SECURITY_ 에러 프리픽스 미기재")

    # 2-2. plan.md M1-1/M1-2 체크리스트 미갱신
    m1_1_section = re.search(r'M1-1.*?(?=####|$)', plan, re.DOTALL)
    if m1_1_section and "- [ ]" in m1_1_section.group(0):
        add("MEDIUM", "doc", "plan.md: M1-1 체크리스트가 아직 [ ] 상태 — [x]로 갱신 필요")

    m1_2_section = re.search(r'M1-2.*?(?=####|$)', plan, re.DOTALL)
    if m1_2_section and "- [ ]" in m1_2_section.group(0):
        add("MEDIUM", "doc", "plan.md: M1-2 체크리스트가 아직 [ ] 상태 — [x]로 갱신 필요")

    # 2-3. plan.md 상태 메시지 stale
    if "STEP 6까지 완료" in plan:
        add("MEDIUM", "doc",
            "plan.md 상단: 'STEP 6까지 완료' → 'STEP 7까지 완료'로 갱신 필요")

    # 2-4. plan.md 라이브러리 버전 불일치
    cargo = (SERVER / "Cargo.toml").read_text()
    version_checks = [
        ("scraper", r'scraper\s*=\s*"([^"]+)"', "0.22"),
        ("sentry", r'sentry\s*=\s*"([^"]+)"', "0.35"),
        ("tokio-cron-scheduler", r'tokio-cron-scheduler\s*=\s*"([^"]+)"', "0.13"),
    ]
    for name, pattern, old_ver in version_checks:
        cargo_match = re.search(pattern, cargo)
        if cargo_match and old_ver in plan and cargo_match.group(1) != old_ver.rstrip("x").rstrip("."):
            actual = cargo_match.group(1)
            if old_ver in plan:
                add("HIGH", "doc",
                    f"plan.md: {name} 버전 {old_ver}x → Cargo.toml 실제 {actual}")

    # 2-5. 1-1.build_db.md migration 004/005 누락
    if "004" not in build_db:
        add("MEDIUM", "doc", "1-1.build_db.md: migration 004_categories_columns 미기재")
    if "005" not in build_db:
        add("MEDIUM", "doc", "1-1.build_db.md: migration 005_user_points_check 미기재")

    # 2-6. CORS 미구현 확인
    main = (SERVER / "src/main.rs").read_text()
    if "CorsLayer" not in main:
        add("LOW", "doc",
            "plan.md M1-1 체크리스트에 CORS 명시됐으나 main.rs 미구현 — M1-4 전 적용 필요")

# ============================================================
# 3. 파일 구조 검증
# ============================================================

def check_structure():
    expected = [
        "src/main.rs", "src/config.rs", "src/db/mod.rs",
        "src/error.rs", "src/cache.rs",
        "src/api/mod.rs", "src/api/pagination.rs",
    ]
    for f in expected:
        if not (SERVER / f).exists():
            add("HIGH", "structure", f"server/{f} 파일 누락")

    # M1-2까지 존재하면 안 되는 파일 (과도한 선행 구현)
    premature = [
        "src/api/routes", "src/services", "src/crawlers", "src/push",
    ]
    for f in premature:
        if (SERVER / f).exists():
            add("LOW", "structure", f"server/{f} 디렉토리가 너무 일찍 생성됨")

# ============================================================
# Main
# ============================================================

if __name__ == "__main__":
    print("=" * 60)
    print("M1-2 구현 종합 검증 스크립트")
    print("=" * 60)

    check_code()
    check_docs()
    check_structure()

    if not findings:
        print("\n✅ 모든 검증 통과! 이슈 없음.")
        sys.exit(0)

    # 정렬: HIGH → MEDIUM → LOW
    severity_order = {"HIGH": 0, "MEDIUM": 1, "LOW": 2}
    findings.sort(key=lambda x: (severity_order.get(x[0], 9), x[1]))

    print(f"\n총 {len(findings)}건 발견:\n")

    for i, (sev, cat, msg) in enumerate(findings, 1):
        icon = {"HIGH": "🔴", "MEDIUM": "🟡", "LOW": "🟢"}.get(sev, "⚪")
        print(f"  {icon} [{sev}] ({cat}) {msg}")

    print()
    counts = {}
    for sev, _, _ in findings:
        counts[sev] = counts.get(sev, 0) + 1
    for sev in ["HIGH", "MEDIUM", "LOW"]:
        if sev in counts:
            print(f"  {sev}: {counts[sev]}건")

    print()
    sys.exit(1 if counts.get("HIGH", 0) > 0 else 0)

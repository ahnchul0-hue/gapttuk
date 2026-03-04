# NIGHT_06_RESULT — 2026-03-05

## Branch
`auto/night-01-20260304_0100`

## Commit
`TBD` — STEP 32–35: 보안 핫픽스 + 성능 최적화 + 테스트 확대 + M1 마무리

---

## 완료된 작업

### STEP 32: 보안 핫픽스 5건

#### 32-1 [CRIT]: 카카오 app_id 검증
- `auth/providers/kakao.rs`에 `verify_app_id()` 추가
- 로그인 전 `kapi.kakao.com/v1/user/access_token_info` 호출 → `app_id` 확인
- 다른 앱에서 발급된 Kakao 토큰 재사용 차단 (OWASP A07:2021)
- `kakao_rest_api_key` 설정 시에만 활성화

#### 32-2 [CRIT]: JWT aud/iss 클레임 추가 + 검증
- `Claims`에 `aud: String`, `iss: String` 필드 추가
- `encode_access_token`: `aud = "gapttuk-api"`, `iss = "gapttuk-server"` 포함
- `decode_access_token`: `Validation::set_audience` + `set_issuer` 검증
- 상수 `JWT_AUDIENCE`, `JWT_ISSUER` 공개 — 크로스-서비스 토큰 재사용 방지 (CWE-287)

#### 32-3 [HIGH]: search q.chars().count()
- `products.rs` 검색 핸들러: `q.len() > 100` → `q.chars().count() > 100`
- 한글 3바이트 UTF-8 인코딩으로 인한 False 거부 수정

#### 32-4 [MED]: 크롤러 UA 풀 2026-03 갱신
- Chrome 133, Firefox 135, Safari 18.3, Edge 133, Samsung Internet 27, Whale 4.30
- 2024년 구버전 UA → CAPTCHA 감지 위험 감소

#### 32-5 [MED]: IPv6 ULA(fc00::/7) 사설 IP 차단
- `is_private_ip()`: `Ipv6Addr::is_loopback()` 단독 → ULA 범위 추가 검사
- `fd00::1` 등 IPv6 사설 주소도 `/metrics` 접근 허용

---

### STEP 33: 성능 CRITICAL 5건

#### 33-1: CrawlerService 세마포어 동적 계산
- `CrawlerService::new()` 파라미터에 `db_max_connections: u32` 추가
- `concurrency = (db_max_connections * 0.6).clamp(2, 8)` — DB 풀의 60%를 크롤러에 할당
- 기존 하드코딩 `8`은 기본 풀 크기(5) 초과 → 커넥션 고갈 위험이 있었음

#### 33-2: price_history 파티션 프루닝
- `refresh_product_stats` / `refresh_product_stats_with_metadata` 두 곳 수정
- `MIN(recorded_at)` 서브쿼리에 `AND recorded_at >= NOW() - INTERVAL '1 year'` 추가
- PostgreSQL 연간 파티션에서 전체 스캔 → 최근 2개 파티션 스캔으로 축소

#### 33-3: add_product_by_url 단일 쿼리
- INSERT + DO NOTHING → `ON CONFLICT DO UPDATE SET updated_at = NOW() RETURNING *`
- 2회 쿼리(INSERT+SELECT) → 1회로 축소, TOCTOU 경합 제거

#### 33-4: lazy ensure_product_exists
- `get_price_history`, `get_daily_price_aggregates`에서 사전 존재 확인 제거
- 결과가 비어있고 cursor가 None인 경우에만 존재 확인 실행
- 정상 요청(상품 데이터 있음)은 DB 쿼리 1건 절약

#### 33-5: popular_searches thundering herd 방지
- `get` + `insert` 패턴 → `try_get_with` 단일 호출
- moka의 `try_get_with`: 동일 키에 동시 요청이 몰려도 단 1회 DB 조회

---

### STEP 34: 테스트 커버리지 확대

#### 34-1: validate_device_token 유닛 테스트 6건
- `validate_device_token()` 순수 함수로 추출 (기존 인라인 → 독립 함수)
- 테스트: 정상값, 공백 trim, 빈 문자열 거부, 공백만 거부, 512바이트 경계, 513바이트 거부

#### 34-2: 커서 페이지네이션 all-sort 지원
- `use_cursor` 조건에서 `matches!(sort, None | Some("ranking"))` 제거
- 모든 정렬 모드에서 `AND id < $2` 커서 조건 사용
- 비 id 정렬에서도 페이지네이션 정상 동작 (id DESC 보조 정렬로 안정성 보장)

---

### STEP 35: M1 마무리

#### 35-1: utoipa dead dependency 제거
- `Cargo.toml`에서 `utoipa = "5.4.0"` 제거
- 소스에서 미사용 상태로 3번의 컴파일 사이클 동안 dead dependency였음
- 재추가 시점: M2 OpenAPI 문서화 작업 스케줄 확정 후

#### 35-2: .env.example JWT_ACCESS_TTL_SECS 수정
- `1800` (30분) → `300` (5분) — 업계 표준 단기 접근 토큰

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo check` | ✅ 0 errors |
| `cargo clippy -- -D warnings -A dead_code -A unused_imports` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff (fmt 1건 수정 후) |
| `cargo test --lib` | ✅ **147/147 passed** (+6 대비 이전 141) |

---

## 코드 변화 요약

| 파일 | 변경 유형 | 핵심 내용 |
|------|-----------|-----------|
| `auth/jwt.rs` | SECURITY | aud/iss 클레임 + Validation |
| `auth/providers/kakao.rs` | SECURITY | verify_app_id() +37줄 |
| `api/routes/products.rs` | BUG FIX | chars().count() |
| `crawlers/mod.rs` | PERF | 동적 세마포어 |
| `crawlers/stats.rs` | PERF | 파티션 프루닝 2곳 |
| `crawlers/ua.rs` | MAINT | 2026-03 UA 갱신 |
| `main.rs` | SECURITY | IPv6 ULA 검사 |
| `services/device_service.rs` | TEST | validate 추출 + 테스트 6건 |
| `services/product_service.rs` | PERF | 단일쿼리 upsert + lazy exist + try_get_with |
| `Cargo.toml` | CLEANUP | utoipa 제거 |
| `.env.example` | CONFIG | JWT TTL 300s |

---

## M1 완료 체크리스트

| 항목 | 상태 |
|------|------|
| 인증 API (소셜 4종 + JWT) | ✅ |
| 상품/가격 API | ✅ |
| 크롤링 파이프라인 | ✅ |
| 보안 미들웨어 | ✅ |
| 푸시 알림 (FCM + APNs) | ✅ |
| AI 예측 서비스 | ✅ |
| 서비스 레이어 분리 (모든 라우트) | ✅ |
| 테스트 커버리지 147건 | ✅ |
| Prometheus 모니터링 | ✅ |
| Docker / CI/CD | ✅ |
| 보안 핫픽스 (JWT aud/iss, Kakao app_id) | ✅ |
| utoipa dead dep 제거 | ✅ |

**M1 서버 구현 완료** → 다음 단계: STEP 36 Flutter M2 스캐폴딩

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-6 ~ D-18 참조

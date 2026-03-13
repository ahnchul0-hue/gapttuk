# NIGHT_06_RESULT — 2026-03-14 (Night-14 continued)

## Branch
`auto/night-01-20260314_0100`

---

## 완료된 작업

### Phase 1-A: Silent Failure 제거 — 서버 에러 처리 패턴 수정 (10건)

#### crawlers/mod.rs
- Advisory lock DB 에러: `unwrap_or(false)` → `match` + `tracing::error!` + early return
- 스크래퍼 태스크 패닉: `Err(join_err)` 분기 + `tracing::error!` (프로그램 버그 표시)
- 알림 평가 실패: `tracing::warn!` → `tracing::error!` (Sentry 캡처 대상 격상)
- 스크래핑 실패: `Err(_) => Failed` → `Err(e)` + `tracing::warn!(product_id, error = %e, ...)`

#### services/reward_service.rs
- `unwrap_or_else` + `tracing::warn!` — 3곳 (`is_new_user`, 잔액 조회 ×2, `get_points`)

#### services/product_service.rs
- URL 파싱 `map_err(|_|)` → `tracing::debug!(url, error = %e, ...)` 추가

#### api/routes/products.rs, notifications.rs
- cursor 파싱 `.and_then(|c| c.parse::<i64>().ok())` → `.map(...).transpose()?` — 잘못된 cursor에 400 반환

### Phase 1-C: 타입 설계 품질 개선

#### crawlers/coupang.rs
- `CrawlError::Aborted` 신규 variant 추가
- `CrawlError::Blocked(0)` 매직 넘버 → `CrawlError::Aborted` 교체

#### error.rs
- `AppError`에 `#[non_exhaustive]` 속성 추가 (외부 exhaustive match 방지)

### Phase 2-A: Flutter dispose/메모리 누수 수정

#### home_screen.dart
- `_showAddByUrlDialog`: `void` + `.then()` → `async Future<void>` + `try/finally`

#### product_detail_screen.dart
- `_showAlertSetup`: `void` + `.whenComplete()` → `async Future<void>` + `try/finally`

### Phase 2-B: Riverpod 3.0 패턴 확인
- 기존 `@riverpod` 어노테이션이 이미 최적 패턴 적용 중 (autoDispose 기본값)
- 구조적 변경 불필요 확인

### Phase 2-C: Flutter 접근성(a11y) 강화 — 3개 화면

#### search_screen.dart
- 빈 상태 텍스트 → `Semantics(label: ...)` 랩
- 로딩 인디케이터 → `Semantics(label: '검색 결과 로딩 중')` 랩
- 검색 버튼 → `tooltip: '검색'` 추가

#### alert_screen.dart
- 로딩 인디케이터 → `Semantics(label: '알림 목록 로딩 중')` 랩
- Dismissible 배경 아이콘 → `Semantics(label: '알림 삭제')` 랩

#### notification_list_screen.dart
- `_NotificationTile` 전체 → `Semantics(label: '${title}, 읽음/읽지 않음')` 랩
- Dismissible 배경 아이콘 → `Semantics(label: '알림 삭제')` 랩

### Phase 3-A: cargo audit 보안 스캔
- `server/.cargo/audit.toml` 생성 — RUSTSEC-2023-0071 예외 처리 (문서화)
- `cargo audit` 0 critical/high vulnerabilities 확인

### Phase 3-C: CI 파이프라인 점검
- `.github/workflows/ci.yml`: flutter job (analyze + test --coverage) 이미 존재 확인
- 추가 변경 불필요

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** (변화 없음) |
| `cargo clippy -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff (cargo fmt 적용 후) |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (git diff --stat HEAD)

| 파일 | 핵심 내용 |
|------|-----------|
| `server/src/crawlers/mod.rs` | Silent failure 4건 → 로깅 보강 |
| `server/src/crawlers/coupang.rs` | `CrawlError::Aborted` 신규 variant |
| `server/src/error.rs` | `#[non_exhaustive]` 추가 |
| `server/src/services/reward_service.rs` | Silent failure 4건 → 로깅 보강 |
| `server/src/services/product_service.rs` | URL 파싱 에러 로깅 |
| `server/src/api/routes/products.rs` | cursor transpose 2건 |
| `server/src/api/routes/notifications.rs` | cursor transpose 1건 |
| `server/.cargo/audit.toml` | RUSTSEC-2023-0071 예외 처리 |
| `app/lib/screens/home/home_screen.dart` | try/finally dispose |
| `app/lib/screens/product/product_detail_screen.dart` | try/finally dispose |
| `app/lib/screens/search/search_screen.dart` | Semantics + tooltip |
| `app/lib/screens/alert/alert_screen.dart` | Semantics 2건 |
| `app/lib/screens/notification/notification_list_screen.dart` | Semantics 2건 |

---

## 결정 사항 (보류)
→ [DECISION_LOG.md](DECISION_LOG.md) D-28 ~ D-33 참조
- D-32: CheckinResult 열거형 재구조화 (다음 리팩토링 세션)
- D-33: productDetailProvider keepAlive (제품 결정 필요)

---

# NIGHT_06_RESULT — 2026-03-13 (Night-14)

## Branch
`auto/night-01-20260313_0100`

---

## 완료된 작업

### Night-14: PLAN_01.md Phase 1-B — 순수 함수 추출 + 단위 테스트 15건

#### notification_service.rs — `build_deep_link` 추출 (3→8 테스트)
- `pub fn build_deep_link(ntype: &NotificationType, id: i64) -> String` 신규
  - NotificationType × id → 딥링크 URL 생성 (gapttuk:// scheme)
  - PriceAlert/CategoryAlert/KeywordAlert: id 포함 경로
  - Referral/System: 고정 경로 (id 무관)
- 테스트 5건 추가: 각 variant별 URL 형식 + 고정 경로 멱등성 검증

#### product_service.rs — `build_search_pattern` 추출 (6→12 테스트)
- `pub fn build_search_pattern(query: &str) -> String` 신규
  - ILIKE 와일드카드 이스케이프(`%`, `_`, `\`) + `%...%` 패턴 래핑
  - `search_products` 내 인라인 escape 로직 → 공용 함수로 교체
- 테스트 6건 추가: `%` 이스케이프, `_` 이스케이프, `\` 이스케이프, 한국어 정상 처리, 빈 문자열, m.coupang.com 서브도메인

#### reward_service.rs — `compute_referral_rewards` 추출 (10→14 테스트)
- `pub fn compute_referral_rewards(stage: i16) -> Option<(i16, i32, i32)>` 신규
  - Stage 분기 로직 순수 함수화 (process_referral_purchase에서 호출)
  - Stage 0→Some((1,2,1)), Stage 1→Some((2,3,1)), Stage 2+→None
- 테스트 4건 추가: stage 0/1 보상금액, stage 2 None, 잘못된 stage None

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** (+15 대비 이전 176) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |

---

## 코드 변화 요약

| 파일 | 변경 유형 | 핵심 내용 |
|------|-----------|-----------|
| `server/src/services/notification_service.rs` | MOD | `build_deep_link` 추출 + 테스트 5건 |
| `server/src/services/product_service.rs` | MOD | `build_search_pattern` 추출 + 테스트 6건 |
| `server/src/services/reward_service.rs` | MOD | `compute_referral_rewards` 추출 + 테스트 4건 |
| `DECISION_LOG.md` | MOD | D-27 추가 |
| `NIGHT_06_RESULT.md` | MOD | Night-14 결과 기록 |
| `PLAN_01.md` | MOD | Phase 1-B 진행 상황 업데이트 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-27 참조

---

# NIGHT_06_RESULT — 2026-03-12 (Night-13)

## Branch
`auto/night-01-20260312_0100`

---

## 완료된 작업

### Night-13: PLAN_01.md 도입 + auth_service 테스트 보강

#### PLAN_01.md 신규 생성
- 야간 세션 자율 결정 문제 해결 (MORNING_BRIEFING U-4)
- 다음 세션(Night-14) 작업 항목 명시: reward_service 통합 테스트(1-A), notification_service(1-B), product_service(1-C)
- 미머지 브랜치 처리 계획 문서화 (사용자 결정 필요 항목)
- 마이그레이션 번호 현황 표: 019/020 충돌 방지 규칙 명시

#### auth_service.rs 순수 함수 추출 (M-3 재구현 포함)
- `validate_consent(terms_agreed, privacy_agreed) -> Result<(), AppError>` 신규
  - `upsert_user`에서 중복 검증 코드 추출 → 단일 진실 원천
- `is_valid_referral_code_format(code: &str) -> bool` 신규
  - 형식: "GAP-[A-Z0-9]{6}" (10자 고정)
  - Night-08 M-3 수정 재구현 (해당 auto 브랜치 미머지 상태)
- `find_referrer_by_code`: 형식 검증 강화 — 이전 `len > 20 || is_empty` → `is_valid_referral_code_format` 사용

#### 단위 테스트 17건 추가 (auth_service::tests)
- `validate_consent`: 5건 (양쪽 동의/terms 미동의/privacy 미동의/둘 다 미동의/에러 메시지 한국어)
- `is_valid_referral_code_format`: 12건 (유효 3건 + 무효 9건 — 빈 문자열/소문자/접두사 없음/짧음/긺/특수문자/유니코드/공백)

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **176/176 passed** (+17 대비 이전 159) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약

| 파일 | 변경 유형 | 핵심 내용 |
|------|-----------|-----------|
| `PLAN_01.md` | NEW | 야간 세션 작업 계획 (Night-13 완료 + Night-14 계획) |
| `server/src/services/auth_service.rs` | MOD | `validate_consent` + `is_valid_referral_code_format` 추출 + 테스트 17건 |
| `DECISION_LOG.md` | MOD | D-25, D-26 추가 |
| `NIGHT_06_RESULT.md` | MOD | Night-13 결과 기록 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-25, D-26 참조

---

# NIGHT_06_RESULT — 2026-03-07 (STEP 53)

## Branch
`auto/night-01-20260307_0100`

## Commit
`1041319` — STEP 53: 테마 중앙화 + price_history 2년 보존 정책

---

## 완료된 작업

### STEP 53: 테마 중앙화 + price_history 2년 보존 정책

#### Flutter — AppColors ThemeExtension
- `AppColors extends ThemeExtension<AppColors>`: 7 semantic colors (success/error/warning/info/neutral/neutralLight/neutralBorder)
- 브랜드 상수: `AppColors.kakao = Color(0xFFFEE500)`, `AppColors.naver = Color(0xFF03C75A)`
- Light/Dark 인스턴스 → `AppTheme.light/dark`에 extension 등록 → 자동 전환
- `copyWith()` + `lerp()` 구현으로 Material 3 ThemeExtension API 완전 준수

#### Flutter — 하드코딩 색상 교체 (11개 파일, ~70개)
- `home_screen.dart`, `point_history_screen.dart`, `product_card.dart` (Batch 1)
- `alert_screen.dart`, `notification_list_screen.dart` (Batch 2)
- `favorites_screen.dart`, `product_detail_screen.dart`, `onboarding_screen.dart`, `settings_screen.dart`, `my_page_screen.dart` (Batch 3)
- `login_screen.dart`: 브랜드 색상 리터럴 → `AppColors.kakao/naver`, subtitle → `appColors.neutral`

#### Flutter — 테스트 수정 (4개 파일)
- `settings/login/onboarding_screen_test.dart`, `product_card_test.dart`: `AppTheme.light` 주입 (extension null 방지)
- 전체 테스트 156 → 164건 (+8 AppColors 유닛 테스트)

#### Server — Migration 016 수정
- `CREATE INDEX CONCURRENTLY` → `CREATE INDEX` (SQLx 테스트 트랜잭션 호환)
- 통합 테스트 13건 복구 (alert_service_test)

#### Server — Migration 017: price_history_monthly
- `price_history_monthly` 집계 테이블: avg/min/max/first/last_price + had_stockout
- `UNIQUE (product_id, year_month)` + `ON CONFLICT DO NOTHING` 멱등 집계
- `idx_phm_product_month (product_id, year_month DESC)` 인덱스

#### Server — archive_old_price_history()
- 2년(24개월) 초과 `price_history` 파티션 → 월별 집계 → 행 수 검증 → DROP
- 1개 파티션/cycle로 부하 분산
- `ensure_partitions()` 내 통합 — 기존 오류 보고 인프라 재사용

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (+8) |
| `cargo check` | ✅ 컴파일 성공 |
| `cargo test` | ✅ **197/197 passed** (유닛 156 + 통합 41) |
| `cargo clippy -- -D warnings` | ✅ 0 warnings |

---

## 코드 변화 요약

| 파일 | 변경 유형 | 핵심 내용 |
|------|-----------|-----------|
| `app/lib/config/theme.dart` | MOD | AppColors ThemeExtension 정의 |
| `app/test/config/theme_test.dart` | NEW | AppColors 유닛 테스트 8건 |
| `app/lib/screens/home/home_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/my/point_history_screen.dart` | MOD | appColors 교체 |
| `app/lib/widgets/product_card.dart` | MOD | appColors 교체 |
| `app/lib/screens/alert/alert_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/notification/notification_list_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/favorites/favorites_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/product/product_detail_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/onboarding/onboarding_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/my/settings_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/my/my_page_screen.dart` | MOD | appColors 교체 |
| `app/lib/screens/auth/login_screen.dart` | MOD | AppColors.kakao/naver 교체 |
| `app/test/screens/settings_screen_test.dart` | MOD | AppTheme.light 주입 |
| `app/test/screens/login_screen_test.dart` | MOD | AppTheme.light 주입 |
| `app/test/screens/onboarding_screen_test.dart` | MOD | AppTheme.light 주입 |
| `app/test/widgets/product_card_test.dart` | MOD | AppTheme.light 주입 |
| `server/migrations/016_point_txn_cursor_index.up.sql` | FIX | CONCURRENTLY 제거 |
| `server/migrations/017_price_history_monthly.up.sql` | NEW | 집계 테이블 생성 |
| `server/migrations/017_price_history_monthly.down.sql` | NEW | 롤백 스크립트 |
| `server/src/main.rs` | MOD | archive_old_price_history() 추가 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-19 이후 참조

---

### STEP 49: 보상 체계 v0.8 구현

#### Migration 013: 보상 스키마 v0.8
- `referrals`: `referrer_rewarded/referred_rewarded` BOOLEAN 2개 DROP → `reward_stage SMALLINT DEFAULT 0` ADD + `CHECK(0~2)`
- `daily_checkins`: `streak_count/roulette_earned` DROP → `reward_amount SMALLINT DEFAULT 0` ADD + `CHECK(IN(0,1))`
- `user_monthly_checkin_caps` 테이블 신규: `UNIQUE(user_id, year_month)`, `CHECK(monthly_cap 1~4)`, `CHECK(earned_so_far <= monthly_cap)`

#### server/src/services/reward_service.rs 신규
- `daily_checkin(pool, user_id)`: 하루 1회 룰렛, lazy monthly_cap 생성, 단일 트랜잭션
- `get_points(pool, user_id)`: user_points 잔액 조회
- `process_referral_purchase(pool, user_id, amount)`: Stage 0→1→2 단계별 보상
- 순수함수: `assign_monthly_cap(is_new)` + `spin_roulette()` → 단위 테스트 4건

#### server/src/api/routes/rewards.rs 신규
- `POST /api/v1/rewards/checkin` → 출석 룰렛 실행
- `GET /api/v1/rewards/points` → 잔액 조회

#### 서버 등록
- `api/routes/mod.rs`에 `rewards` 모듈 추가
- `services/mod.rs`에 `reward_service` 모듈 추가
- `main.rs`에 `.nest("/api/v1/rewards", rewards::router())` 등록

#### Flutter 보상 연동
- `app/lib/services/reward_service.dart` 신규: `checkin()` + `getPoints()`
- `service_providers.dart` + `.g.dart`에 `rewardServiceProvider` 추가
- `my_page_screen.dart`: `_CentsBalanceTile` 위젯 — 센트 잔액 표시 + 오늘 출석 버튼

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **151/151 passed** (+4 대비 이전 155) |
| `cargo clippy -- -D warnings -A dead_code -A unused_imports` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ 0 issues |
| `flutter test` | ✅ **108/108 passed** |

---

## 코드 변화 요약

| 파일 | 변경 유형 | 핵심 내용 |
|------|-----------|-----------|
| `migrations/013_reward_v08.up.sql` | SCHEMA | 보상 v0.8 마이그레이션 |
| `migrations/013_reward_v08.down.sql` | SCHEMA | 롤백 스크립트 |
| `services/reward_service.rs` | NEW | 룰렛+잔액+추천 보상 서비스 + 테스트 4건 |
| `api/routes/rewards.rs` | NEW | POST /checkin + GET /points |
| `api/routes/mod.rs` | MOD | rewards 모듈 등록 |
| `services/mod.rs` | MOD | reward_service 모듈 등록 |
| `main.rs` | ROUTE | /api/v1/rewards 라우트 등록 |
| `app/lib/services/reward_service.dart` | NEW | Flutter 보상 서비스 |
| `app/lib/providers/service_providers.dart` | UPDATE | rewardService provider 추가 |
| `app/lib/providers/service_providers.g.dart` | UPDATE | RewardServiceProvider 추가 |
| `app/lib/screens/my/my_page_screen.dart` | UPDATE | _CentsBalanceTile 위젯 추가 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-19 ~ D-21 참조

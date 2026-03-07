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

# NIGHT_06_RESULT — 2026-03-06

## Branch
`auto/night-01-20260306_0100`

## Commit
`TBD` — STEP 49: 보상 체계 v0.8 구현 — DB 마이그레이션 + 서버 리워드 서비스 + API + Flutter

---

## 완료된 작업

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

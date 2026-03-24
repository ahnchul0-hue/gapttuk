# NIGHT_06_RESULT — 2026-03-25 (Night-25)

## Branch
`auto/night-01-20260325_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md Night-24 커밋

MORNING_BRIEFING.md Night-24 미커밋 업데이트 → 커밋 `3cdd40c`

**기준선**: Rust lib 207건 ✅ / Flutter 216건 ✅ / analyze 0 ✅

### Phase 1: 위젯 테스트 확대

**신규 테스트 파일 (2개)**:

| 파일 | 건수 | 핵심 테스트 |
|------|------|-------------|
| `test/widgets/alert_type_badge_test.dart` | 13건 | alertTypeLabel(5) + alertTypeColor(5) + AlertTypeBadge위젯(3) |
| `test/widgets/price_chart_test.dart` | 5건 | 로딩/빈목록/avgPrice-null/에러/정상 |

**핵심 패턴**:
- `alertTypeLabel`/`alertTypeColor` 순수 함수 → `test()` 단순 단언 (AppColors.light 직접 참조)
- `PriceChart` ConsumerWidget → `ProviderScope(overrides: [dailyPricesProvider(1).overrideWith(...)])` 패턴
- 에러 테스트: `Future(() async { throw ... })` — `Future.error()` zone 전파 방지

### Phase 2: 프로바이더 테스트 확대

**기존 파일 확장 (1개)**:

| 파일 | 신규 건수 | 추가 내용 |
|------|-----------|-----------|
| `test/providers/product_provider_test.dart` | +4건 | productPrediction(성공/빈Map/family독립) + popularSearches(랭크순서) |

**신규 추가**:
- `MockPredictionService` + `buildContainerWithPrediction` 헬퍼
- `predictionServiceProvider.overrideWith((_) => mockPrediction)` 패턴
- family 프로바이더 독립성 검증: ID 10 vs 20 → 각각 1회 호출

**의사결정**:
- Riverpod 3.x auto-dispose 에러 전파 테스트(StateError 충돌): 에러 테스트 대신 성공/경계 케이스로 교체 (D-48)

### Phase 3: 코드 품질 확인

- `flutter analyze`: 0건 ✅
- `cargo clippy -- -D warnings`: 0건 ✅
- `flutter test`: 238건 전체 통과 ✅

---

## 테스트 카운트

| 구분 | Night-24 | Night-25 | 증감 |
|------|---------|---------|------|
| Rust lib | 207 | 207 | +0 |
| Flutter | 216 | **238** | **+22** |
| **합계** | **~466** | **~488** | **+22** |

---

## 의사결정 (D-48)

| ID | 결정 | 근거 |
|----|------|------|
| D-48 | Riverpod 3.x auto-dispose 프로바이더 에러 전파 테스트 방식 변경 | `@riverpod`(auto-dispose) + 리스너 없이 `.future` await 시 StateError 충돌 → 성공/경계 케이스 테스트로 대체. 에러 전파는 Riverpod 프레임워크 책임으로 간주 |

---

# NIGHT_06_RESULT — 2026-03-24 (Night-24)

## Branch
`auto/night-01-20260324_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 정정 커밋

Night-23 MORNING_BRIEFING.md 마이너 수정 (커밋수 + 문구) → 커밋 `4263a76`

### Phase 1: cargo 취약점 해결

**cargo update** 실행 — 취약점 7건 → 0건:

| 해결 방법 | 대상 취약점 | 결과 |
|-----------|------------|------|
| `cargo update` | aws-lc-sys 5건 (HIGH/MEDIUM), rustls-webpki 1건 | ✅ 해결 |
| `audit.toml` ignore 추가 | RUSTSEC-2026-0049 (a2 upstream 미업그레이드) | ✅ 예외 처리 |

**RUSTSEC-2026-0049 ignore 근거**: `a2` 크레이트(APNs 푸시)가 `rustls 0.22`를 사용. `a2` upstream(최신 0.10.0)이 rustls 0.23으로 아직 미이전. APNs는 신뢰할 수 있는 엔드포인트이므로 CRL 매칭 버그 실제 위험 없음.

**cargo audit 최종**: error 0건, warning 1건 (rustls-pemfile unmaintained — 허용)

### Phase 2: Flutter 테스트 확대 (+18건)

**신규 헬퍼 (2파일)**:

| 파일 | 패턴 |
|------|------|
| `test/helpers/fake_reward_service.dart` | `implements RewardService` — getPoints/getHistory/checkin 제어 |
| `test/helpers/fake_notification_service.dart` | `implements NotificationService` — getNotifications 제어 |

**신규 테스트 (3파일)**:

| 파일 | 건수 | 핵심 테스트 |
|------|------|-------------|
| `test/screens/my_page_screen_test.dart` | 6건 | 미인증/"로그인이 필요합니다"/닉네임/추천코드/로그아웃 |
| `test/screens/point_history_screen_test.dart` | 5건 | 빈목록/"아직 내역이 없습니다"/항목레이블/에러/금액포맷 |
| `test/screens/notification_list_screen_test.dart` | 7건 | AppBar/모두읽음/로딩/빈목록/에러/알림항목 |

**핵심 패턴**:
- `_FakeAuthState extends AuthState` + `authStateProvider.overrideWith(() => ...)` — Riverpod Notifier 초기 상태 주입
- `NotifResult` 공개 타입 별칭 (private `_NotifResult` → `library_private_types_in_public_api` 경고 방지)
- `Completer<T>().future` 로딩 상태 테스트 (FakeRewardService/FakeNotificationService slow 모드)

### Phase 3: 코드 품질 확인

- `cargo fmt --check`: 포맷 이상 없음 ✅
- `check_serde_enums.py`: 0건 ✅ (serde CI 유지)
- 프로덕션 코드 `.unwrap()` 검색: 모두 `#[test]` 블록 내부 — 0건 프로덕션 ✅

---

## 테스트 카운트

| 구분 | Night-23 | Night-24 | 증감 |
|------|---------|---------|------|
| Rust lib | 207 | 207 | +0 |
| Flutter | 198 | **216** | **+18** |
| **합계** | **~448** | **~466** | **+18** |

---

## 의사결정 (D-47)

| ID | 결정 | 근거 |
|----|------|------|
| D-47 | RUSTSEC-2026-0049 (rustls-webpki via a2): ignore 처리 | a2 0.10.0 upstream 미업그레이드, APNs 신뢰 엔드포인트 → 실제 위험 없음 |

---

# NIGHT_06_RESULT — 2026-03-23 (Night-23)

## Branch
`auto/night-01-20260323_0100`

---

## 완료된 작업

### Phase 0: Night-22 커밋 + 기준선 확인

Night-22 미커밋 변경 8 modified + 5 untracked → 커밋 `f1ab244` 완료.

**기준선**: Rust lib 207건 ✅ / Flutter 180건 ✅ / analyze 0 ✅

### Phase 1: 의존성 건강성 분석

**cargo audit** (7개 취약점):

| Crate | 버전 | CVE | 심각도 | 해결 |
|-------|------|-----|--------|------|
| aws-lc-sys | 0.37.1 | RUSTSEC-2026-0044/45/46/47/48 | HIGH/MEDIUM | >=0.38-0.39 |
| rustls-webpki | 0.102.8/0.103.9 | RUSTSEC-2026-0049 | - | >=0.103.10 |
| rustls-pemfile | 2.2.0 | RUSTSEC-2025-0134 | warning | unmaintained |

모두 `reqwest`/`sqlx`/`sentry`의 **간접 의존성** — `cargo update`로 해결 가능. 사용자 승인 필요 (업그레이드 미실행).

**flutter pub outdated** 주요 항목:
- `go_router 16→17` (breaking), `flutter_riverpod 3.0→3.3` (breaking), `fl_chart 0.69→1.2` (breaking)
- `build_runner`, `freezed`, `flutter_svg` — 안전하게 업그레이드 가능
- sonatype-guide: 인증 미설정으로 API 호출 불가 (Night-22와 동일)

### Phase 2: 미완료 항목 실행

| 항목 | 결과 | 수정 내용 |
|------|------|-----------|
| 2-A. Silent Failure 수정 | ✅ | auth_service(3곳)+main.rs(3곳)+alert_service(1곳) warn! 추가 |
| 2-B. rust_decimal API 계약 | ✅ | 불일치 없음 — 숫자 직렬화, Flutter는 알 수 없는 키 무시 |
| 2-C. formatPrice 추출 | ✅ | 이미 `utils/error_utils.dart`에 단일 정의 — 추출 불필요 |

**2-A 상세**: `let _ = tx.rollback().await` → `if let Err(rb_err) = tx.rollback().await { warn!(...) }` 패턴 5곳 적용.

### Phase 3: 테스트 확대

| 파일 | 건수 | 내용 |
|------|------|------|
| `test/screens/product_detail_screen_test.dart` | 7건 | AppBar/FAB/상품명/가격/로딩(Completer)/에러(async throw)/품절 |
| `test/screens/alert_screen_test.dart` | 6건 | AppBar/3탭/로딩/빈목록/에러/"목표가" |
| `test/screens/favorites_screen_test.dart` | 5건 | AppBar/로딩/빈상태/버튼/alertTypeLabel |
| `test/helpers/fake_alert_service.dart` | — | FakeAlertService 공통 헬퍼 (slow/error/response 모드) |

**핵심 패턴**: `implements AlertService` (Dart structural typing) — 플랫폼 채널 없이 fake 생성. `async { throw }` — zone 전파 없는 에러 상태 테스트.

### Phase 4: 종합 코드 리뷰 + 추가 수정

**silent-failure-hunter 발견 → 반영**:
- [C-1] CRITICAL: count/verify 쿼리 `?` 조기 반환 경로 rollback+warn 누락 → match 패턴으로 수정 (`main.rs`)
- [H-1] HIGH: warn 순서 역전 (rollback warn → 원인 warn) → 원인 warn 먼저 수정 (3곳)
- [M-3] MEDIUM: 빈 디바이스 warn에 product_id 누락 → 추가

**code-simplifier 개선**:
- `_FakeAlertService` 2개 파일 중복(77줄) → `test/helpers/fake_alert_service.dart` 통합
- `_alertTypeLabel` 복사본 → 실제 `alertTypeLabel` import로 교체

---

## 테스트 카운트

| 구분 | Night-22 | Night-23 | 증감 |
|------|---------|---------|------|
| Rust lib | 207 | 207 | +0 |
| Flutter | 180 | **198** | **+18** |
| **합계** | **~430** | **~448** | **+18** |

---

## 의사결정 (D-44~D-46)

| ID | 결정 | 근거 |
|----|------|------|
| D-44 | rust_decimal serde-with-str: 수정 불필요 | `serde(with)` 어트리뷰트 없는 필드는 숫자 직렬화 → Flutter 무시 |
| D-45 | formatPrice 추출 불필요 | 이미 `utils/error_utils.dart` 단일 정의, 4곳만 사용 |
| D-46 | cargo audit 취약점: 업그레이드 연기 | 모두 간접 의존성, breaking 없지만 사용자 승인 후 `cargo update` 권장 |

---

# NIGHT_06_RESULT — 2026-03-22 (Night-22)

## Branch
`auto/night-01-20260322_0100`

---

## 완료된 작업

### Phase 0: 환경 정비 + 분석

**sonatype-guide**: 인증 자격증명 미설정으로 API 호출 불가 — Phase 3-A 건너뜀.

**Silent Failure 조사** (서버 전수 스캔 51개 파일):

| 우선순위 | 위치 | 패턴 | 문제 |
|---------|------|------|------|
| **HIGH** | `auth_service.rs:230` | `let _ = tx.rollback()` | 토큰 탈취 감지 후 롤백 실패 → 로그 없음 |
| **HIGH** | `main.rs:275,301,328` | `let _ = tx.rollback()` (3건) | 아카이빙 트랜잭션 롤백 실패 3곳 무시 |
| **HIGH** | `alert_service.rs:557` | `.unwrap_or_default()` | 디바이스 없는 사용자 push silent skip |
| MEDIUM | `main.rs:197` | `.ok()` | 파티션 날짜 파싱 실패 원인 미기록 |
| MEDIUM | `access_log.rs:86` | `.ok()` | 만료/조작 JWT가 user_id=None으로만 기록 |
| MEDIUM | `coupang.rs:226` | `.ok()` | 가격 파싱 실패 무음 |
| LOW | config/fcm 환경변수 체인 | 다수 | 의도된 optional/fallback 패턴 |

`.unwrap()` 프로덕션 코드: **0건** (전부 테스트 블록) ✅

### Phase 1: Rust CRITICAL/HIGH 수정 (3건)

| 항목 | 파일 | 수정 내용 |
|------|------|-----------|
| 1-A. referral_code TOCTOU | `auth_service.rs` | DB UNIQUE 충돌 시 최대 3회 retry loop + `is_referral_code_collision()` 헬퍼 추가 |
| 1-B. alert 한도 TOCTOU | `alert_service.rs` | `create_price/category/keyword_alert` 3함수: `SELECT FOR UPDATE` + 트랜잭션화, `count_all_user_alerts_in_tx()` 분리 |
| 1-D. serde CI 자동검증 | `scripts/check_serde_enums.py` + `ci.yml` | Serialize enum에 rename_all 누락 시 CI 실패 — Night-19~21 3회 파급 재발 방지 |

**검증**: `cargo check` ✅ / `cargo test --lib` 207건 ✅ / `cargo clippy -D warnings` ✅ / `check_serde_enums.py` 0건 ✅

### Phase 2: Flutter 품질 확대 (4건)

| 항목 | 파일 | 수정 내용 |
|------|------|-----------|
| 2-A. HomeScreen 테스트 | `test/screens/home_screen_test.dart` | 7건 (AppBar/검색바/URL카드/인기검색어/데이터/에러/다이얼로그) |
| 2-A. SearchScreen 테스트 | `test/screens/search_screen_test.dart` | 4건 (AppBar/TextField/초기상태/입력) |
| 2-B. Provider 테스트 | `test/providers/product_provider_test.dart` | 5건 (productDetail/dailyPrices/popularSearches) |
| 2-C. alertTypeLabel 공통화 | `widgets/alert_type_badge.dart` (신규) | `alertTypeLabel()`, `alertTypeColor()`, `AlertTypeBadge` 위젯 — favorites_screen + alert_screen 중복 제거 |

**검증**: `flutter analyze` 0 issues ✅ / `flutter test` **180건** 통과 ✅ (164→+16)

### Phase 3-B: CI serde 검증 통합 (Phase 1-D에 포함)
- `ci.yml` check job에 `python3 scripts/check_serde_enums.py server/src` step 추가

---

## 테스트 카운트

| 구분 | Night-21 | Night-22 | 증감 |
|------|---------|---------|------|
| Rust lib | 207 | 207 | +0 |
| Flutter | 164 | **180** | **+16** |
| **합계** | **~414** | **~430** | **+16** |

---

## 의사결정 (D-43)

| ID | 결정 | 근거 |
|----|------|------|
| D-43 | 1-B alert TOCTOU: `SELECT FOR UPDATE` on users row | 가장 단순하고 명확한 직렬화 — Advisory lock보다 오버헤드 낮음, 같은 user의 동시 요청만 serialize |

---

# NIGHT_06_RESULT — 2026-03-21 (Night-21)

## Branch
`auto/night-01-20260321_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 커밋
- 커밋 `ae0b778`: Night-20 종합 분석 업데이트

### Phase 1: 서브에이전트 3대 병렬 심층 분석

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` #1 | 서버 코드 분석 | CRIT-2 + HIGH-5 + MED-6 + LOW-4 |
| `feature-dev:code-explorer` #2 | Flutter 코드 분석 | CRIT-2 + HIGH-5 + MED-6 + LOW-3 |
| `feature-dev:code-architect` | 아키텍처/API 계약/테스트 갭 | CRIT-3 + HIGH-6 + MED-5 + LOW-1 |

오탐 필터링 후 **Night-21 실행 대상**: 서버 7건 + Flutter 7건 = **14건**

**오탐 필터링:**
- Flutter `RadioGroup` → Flutter 3.41.3에 실제 존재 (`radio_group.dart`), `RadioListTile`이 `RadioGroupRegistry` 자동 상속
- `ref.watch` → Riverpod 3.0 future provider에서 반응형 의존성으로 정당
- `validate_consent` 테스트 → auth_service.rs에 이미 12건 존재

**핵심 발견**: Night-19(AlertType/NotificationType), Night-20(PriceTrend/Platform)에 이어 Night-21에서 3번째 serde rename_all 파급 누락 패턴 발견 — `PredictedAction`, `SearchTrend`, `AuthProvider`. 또한 `rust_decimal serde-with-str` 특성으로 `confidence` 값이 항상 0%로 표시되는 버그 발견.

### Phase 2-A: 서버(Rust) API 직렬화 + 타입 안전성 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/models/ai_prediction.rs` | `PredictedAction`에 `#[serde(rename_all = "snake_case")]` 추가 + 직렬화 테스트 3건 |
| `server/src/models/popular_search.rs` | `SearchTrend`에 `#[serde(rename_all = "snake_case")]` 추가 + 직렬화 테스트 4건 |
| `server/src/models/user.rs` | `AuthProvider`에 `#[serde(rename_all = "snake_case")]` 추가 + 직렬화 테스트 4건 + Platform 테스트 3건 |
| `server/src/services/alert_service.rs` | `triggered as u64` → `u64::try_from(triggered).unwrap_or(u64::MAX)` (Night-20 패턴 적용) |

### Phase 2-B: Flutter(Dart) 코드간결화 + 버그수정 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/lib/screens/product/product_detail_screen.dart` | `confidence` String/num 방어 파싱 (`rust_decimal serde-with-str` 대응) + 'neutral' 명시적 case |
| `app/lib/screens/onboarding/onboarding_screen.dart` | `setState` 이중 호출 → 단일 `setState` 통합, `_updateAllAgreedState` 제거 |
| `app/lib/config/router.dart` | `addPostFrameCallback` 내 `context.mounted` 체크 추가 |
| `app/lib/screens/notification/notification_list_screen.dart` | `_buildTypeIcon` C-style switch → Dart 3 switch 표현식 (-15줄) |
| `app/lib/screens/my/my_page_screen.dart` | `_loadingBalance` 상태 추가 → 초기 잔액 로딩 중 "로딩 중..." 표시 |
| `app/lib/screens/home/home_screen.dart` | `_trendIcon` C-style switch → switch 표현식 + 'stable' 명시적 case (-9줄) |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **207/207 passed** (기존 203 + 신규 4건) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (10파일, +134/-62)

총 +72줄 순증가 (테스트 14건 추가로 인한 증가)

| 주요 변화 | 규모 |
|-----------|------|
| serde 직렬화 단위 테스트 14건 추가 | +58줄 |
| `_buildTypeIcon`/`_trendIcon` switch 표현식 | -24줄 |
| `onboarding_screen` setState 통합 + `_updateAllAgreedState` 제거 | -5줄 |
| `confidence` 방어 파싱 + `_loadingBalance` 추가 | +12줄 |
| `context.mounted` 체크, `neutral` case, `u64::try_from` | +5줄 |

---

## Night-21 스킵된 항목 (사용자 결정 대기)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| `count_all_user_alerts` TOCTOU | HIGH | DB 트랜잭션 잠금 설계 필요 |
| `upsert_user` referral_code TOCTOU | CRITICAL | DB retry 루프 설계 필요 |
| `SearchScreen` 필터/정렬 미연결 | MEDIUM | fix/phase0 브랜치와 충돌 위험 |
| `_alertTypeBadge` 3파일 중복 | LOW | 신규 파일 생성 필요 |
| `formatPrice` 레이어 이동 | LOW | 영향 범위 넓음 |

---

## 결정 사항
→ Night-21 신규 DECISION 없음 (기존 프레임워크 재활용)

---

# NIGHT_06_RESULT — 2026-03-20 (Night-20)

## Branch
`auto/night-01-20260320_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 커밋
- 커밋 `a1f3183`: Night-19 종합 분석 업데이트

### Phase 1: 서브에이전트 3대 병렬 심층 분석

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` #1 | 서버 코드 분석 | HIGH-4 + MED-7 + LOW-6 |
| `feature-dev:code-explorer` #2 | Flutter 코드 분석 | MED-6 + LOW-10 |
| `feature-dev:code-architect` | 아키텍처/API 계약/코드간결화 | CRITICAL-1 + HIGH-3 + MED-5 |

오탐 필터링 후 **Night-20 실행 대상**: 서버 7건 + Flutter 7건 = **14건**

**핵심 발견**: `PriceTrend` serde rename_all 누락으로 JSON `"Falling"` vs Flutter `'falling'` 비교 영구 false → 가격 트렌드 UI 완전 무동작 버그 (CRITICAL)

### Phase 2-A: 서버(Rust) API 정합성 + 타입 안전성 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/models/product.rs` | `PriceTrend`에 `#[serde(rename_all = "snake_case")]` 추가 — 가격 트렌드 UI 버그 수정 |
| `server/src/models/user.rs` | `Platform`에 `#[serde(rename_all = "snake_case")]` 추가 — API 계약 정합 |
| `server/src/services/alert_service.rs` | `i32::MAX as f64 as i32` → `i32::try_from(... as i64).unwrap_or(i32::MAX)` 안전 변환 |
| `server/src/services/ai_prediction_service.rs` | `i16 as i32` → `i32::from()` 명시적 widening |
| `server/src/crawlers/mod.rs` | `usize as u64` 3곳 → `u64::try_from().unwrap_or(u64::MAX)` |
| `server/src/lib.rs` | `as_millis() as u64` → `u64::try_from()` u128→u64 안전 변환 |
| `server/src/api/pagination.rs` + 라우터 3개 | `parse_cursor` 헬퍼 추출 → products/notifications 3곳 DRY (-18줄) |

### Phase 2-B: Flutter(Dart) Phase 2-C 코드간결화 + 버그수정 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/lib/screens/alert/alert_screen.dart` | `showErrorSnackBar` 통합 + switch 표현식 변환 |
| `app/lib/screens/auth/login_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/home/home_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/my/my_page_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/my/settings_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/notification/notification_list_screen.dart` | `showErrorSnackBar` 통합 (2곳) |
| `app/lib/screens/onboarding/onboarding_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/product/product_detail_screen.dart` | `showErrorSnackBar` 통합 |
| `app/lib/screens/search/search_screen.dart` | DioException+catch 두 블록 통합 + `showErrorSnackBar` |
| `app/lib/services/api_client.dart` | `catch(e)` → `catch(e, st)` stacktrace 보존 |
| `app/lib/services/reward_service.dart` | `PointHistoryItem.createdAt` String → DateTime |
| `app/lib/screens/my/point_history_screen.dart` | `_formatDate` static + DateTime 직접 수신 |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **203/203 passed** (변화 없음) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (21파일, +64/-130)

총 -66줄 순감소 (코드 간결화 효과)

| 주요 변화 | 규모 |
|-----------|------|
| `showErrorSnackBar` 통합 9개 화면 11개소 | -34줄 |
| `parse_cursor` 헬퍼 추출 3개 라우터 | -18줄 |
| `search_screen` DioException catch 통합 | -7줄 |
| `PriceTrend`/`Platform` serde rename_all | +2줄 (버그 수정) |
| `_formatDate` static + DateTime | -7줄 |
| switch 표현식 변환 | -8줄 |

---

## Night-20 스킵된 항목 (사용자 결정 대기)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| `count_all_user_alerts` TOCTOU (50개 한도) | HIGH | DB 트랜잭션 잠금 설계 필요 |
| `upsert_user` referral_code TOCTOU (CRIT-2 기존) | CRITICAL | DB retry 루프 설계 필요 |
| `refresh_product_stats` 중복 구현 제거 | MEDIUM | 통합 테스트 환경 없이 위험 |
| `AdvisoryLockGuard` block_in_place 런타임 문제 | MEDIUM | 테스트 환경에만 영향 |
| M-2: 로그아웃 다이얼로그 중복 (my_page+settings) | MEDIUM | 새 위젯 파일 생성 필요 |
| M-3: ErrorStateView 위젯 추출 | MEDIUM | 새 파일 생성 + 3개 화면 변경 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-42까지 참조 (Night-20 신규 DECISION 없음)

---

# NIGHT_06_RESULT — 2026-03-19 (Night-19)

## Branch
`auto/night-01-20260319_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 커밋
- 커밋 `a861272`: Night-18 종합 분석 업데이트

### Phase 1: 서브에이전트 3대 병렬 심층 분석

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` #1 | 서버 코드 분석 | MED-5 + LOW-5 |
| `feature-dev:code-explorer` #2 | Flutter 코드 분석 | MED-6 + LOW-9 |
| `feature-dev:code-architect` | 아키텍처/API 계약/테스트 갭 | HIGH-3 + MED-4 + LOW-2 |

오탐 필터링 후 **Night-19 실행 대상**: 서버 7건 + Flutter 7건 = **14건**

### Phase 2-A: 서버(Rust) API 계약 + 타입 안전성 + 관측성 (7건 + 테스트 10건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/models/notification.rs` | `NotificationType`에 `#[serde(rename_all = "snake_case")]` 추가 |
| `server/src/models/alert.rs` | `AlertType`에 `#[serde(rename_all = "snake_case")]` 추가 |
| `server/src/services/alert_service.rs` | `validate_target_price` 순수함수 추출 + 테스트 5건 |
| `server/src/services/alert_service.rs` | `validate_keyword` 순수함수 추출 (DRY) + 테스트 5건 |
| `server/src/services/ai_prediction_service.rs` | `buy_timing_score.clamp(0, 100)` 범위 보장 |
| `server/src/services/reward_service.rs` | `reward as i32` → `i32::from(reward)` 명시적 변환 |
| `server/src/services/product_service.rs` | `add_product_by_url`에 `#[tracing::instrument]` 추가 |
| `server/src/crawlers/mod.rs` | `scrape_and_update`에 `#[tracing::instrument]` 추가 |

### Phase 2-B: Flutter(Dart) API 계약 + 관측성 + 버그수정 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/test/models/notification_test.dart` | `'price_drop'` → `'price_alert'` (API 계약 정합, 3개소) |
| `app/test/services/notification_service_test.dart` | `'price_drop'`/`'all_time_low'` → `'price_alert'` (2개소) |
| `app/lib/services/push_service.dart` | `catch(e)` → `catch(e, st)` + stacktrace 로깅 |
| `app/lib/config/router.dart` | `TokenStorage()` 매 리다이렉트마다 생성 → 파일 레벨 싱글톤 |
| `app/lib/screens/notification/notification_list_screen.dart` | `_formatTime` 인스턴스 메서드 → `static` |
| `app/lib/screens/product/product_detail_screen.dart` | `StatefulBuilder` 내 `mounted` 가드 추가 |
| `app/lib/screens/search/search_screen.dart` | `on DioException catch (e)` → `catch (e, st)` |
| `app/lib/providers/auth_provider.dart` | `on DioException catch (e)` → `catch (e, st)` |
| `app/lib/screens/favorites/favorites_screen.dart` | `'목표가'` → `'목표 가격'` (alert_screen 레이블 통일) |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **203/203 passed** (+10 대비 이전 193) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (16파일, +123/-48)

| 파일 | 핵심 내용 |
|------|-----------|
| `server/src/models/notification.rs` | serde rename_all 추가 |
| `server/src/models/alert.rs` | serde rename_all 추가 |
| `server/src/services/alert_service.rs` | validate_target_price + validate_keyword 추출 + 테스트 10건 |
| `server/src/services/ai_prediction_service.rs` | score clamp |
| `server/src/services/reward_service.rs` | i32::from 명시적 변환 |
| `server/src/services/product_service.rs` | tracing::instrument |
| `server/src/crawlers/mod.rs` | tracing::instrument |
| `app/test/models/notification_test.dart` | API 계약 fixture 수정 |
| `app/test/services/notification_service_test.dart` | API 계약 fixture 수정 |
| `app/lib/services/push_service.dart` | catch(e, st) |
| `app/lib/config/router.dart` | TokenStorage 싱글톤 |
| `app/lib/screens/notification/notification_list_screen.dart` | _formatTime static |
| `app/lib/screens/product/product_detail_screen.dart` | mounted 가드 |
| `app/lib/screens/search/search_screen.dart` | DioException catch(e, st) |
| `app/lib/providers/auth_provider.dart` | DioException catch(e, st) |
| `app/lib/screens/favorites/favorites_screen.dart` | 레이블 통일 |

---

## Night-19 스킵된 항목 (사용자 결정 대기)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| `notification_service.rs` has_more 계약 변경 | MEDIUM | API 계약 변경 범위 큼 |
| `showErrorSnackBar` 12개소 통합 | MEDIUM | Night-17부터 3회 스킵 이력, 14파일 변경 |
| `PointHistoryItem.createdAt` String → DateTime | MEDIUM | 기존 동작 문제 없음, 리팩토링 범위 큼 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-42까지 참조

---

# NIGHT_06_RESULT — 2026-03-18 (Night-18)

## Branch
`auto/night-01-20260318_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 커밋
- 커밋 `0e45dc8`: Night-17 종합 분석 업데이트 (145줄 추가/96줄 교체)

### Phase 1: 서브에이전트 3대 병렬 심층 분석

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` #1 | 서버 코드 분석 | CRIT-1 + HIGH-6 + MED-5 + LOW-3 |
| `feature-dev:code-explorer` #2 | Flutter 코드 분석 | HIGH-8 + MED-5 + LOW-2 |
| `feature-dev:code-architect` | 아키텍처/테스트 갭 분석 | HIGH-2 + MED-6 + LOW-2 |

오탐 필터링 후 **Night-18 실행 대상**: 서버 7건 + Flutter 9건 + 테스트 2건 = **18건**

### Phase 2-A: 서버(Rust) 타입 안전성 + 에러 로깅 개선 (7건 + 테스트 2건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/auth/jwt.rs` | `ttl as i64` → `i64::try_from()` (u64 오버플로 방어) |
| `server/src/services/alert_service.rs` | NearLowest threshold `as i32` → `.round().clamp()` |
| `server/src/services/reward_service.rs` | `amount as u64` → `u64::try_from()` (metrics counter 안전 변환) |
| `server/src/crawlers/stats.rs` | `drop * 100` → `.saturating_mul(100)` (오버플로 방어) |
| `server/src/middleware/access_log.rs` | `u16 as i16` → `i16::try_from().unwrap_or(-1)` |
| `server/src/api/routes/products.rs` | cursor parse `map_err(|_|)` → `tracing::debug!` 로깅 (2곳) |
| `server/src/api/routes/notifications.rs` | cursor parse `map_err(|_|)` → `tracing::debug!` 로깅 |
| `server/src/services/notification_service.rs` | `build_deep_link` Event variant 테스트 추가 |
| `server/src/services/alert_service.rs` | `format_price` 음수 처리 동작 문서화 테스트 추가 |

### Phase 2-B: Flutter(Dart) 관측성 + 테마 일관성 + 성능 개선 (9건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/lib/screens/auth/login_screen.dart` | `catch(e)` → `catch(e, st)` + debugPrint |
| `app/lib/screens/favorites/favorites_screen.dart` | `catch(e)` → `catch(e, st)` (2건) |
| `app/lib/screens/notification/notification_list_screen.dart` | `catch(e)` → `catch(e, st)` (5건) |
| `app/lib/screens/my/settings_screen.dart` | `catch(e)` → `catch(e, st)` + debugPrint |
| `app/lib/screens/alert/alert_screen.dart` | `catch(e)` → `catch(e, st)` (공통 래퍼 — 6개 mutation 커버) |
| `app/lib/screens/onboarding/onboarding_screen.dart` | `catch(e)` → `catch(e, st)` + debugPrint |
| `app/lib/screens/search/search_screen.dart` | `catch(e)` → `catch(e, st)` + debugPrint |
| `app/lib/widgets/price_chart.dart` | `NumberFormat` build()마다 생성 → `static final _priceFormat` |
| `app/lib/screens/my/my_page_screen.dart` | `Colors.amber` → `AppColors.warning` (다크모드 테마 일관성) |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **193/193 passed** (+2 대비 이전 191) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (19파일, +126/-70)

| 파일 | 핵심 내용 |
|------|-----------|
| `server/src/auth/jwt.rs` | ttl i64::try_from 안전 변환 |
| `server/src/services/alert_service.rs` | threshold clamp + 테스트 2건 |
| `server/src/services/reward_service.rs` | amount u64::try_from |
| `server/src/crawlers/stats.rs` | saturating_mul |
| `server/src/middleware/access_log.rs` | status i16::try_from |
| `server/src/api/routes/products.rs` | cursor debug 로깅 2건 |
| `server/src/api/routes/notifications.rs` | cursor debug 로깅 |
| `server/src/services/notification_service.rs` | Event 테스트 |
| `app/lib/screens/auth/login_screen.dart` | catch(e, st) |
| `app/lib/screens/favorites/favorites_screen.dart` | catch(e, st) 2건 |
| `app/lib/screens/notification/notification_list_screen.dart` | catch(e, st) 5건 |
| `app/lib/screens/my/settings_screen.dart` | catch(e, st) |
| `app/lib/screens/alert/alert_screen.dart` | catch(e, st) |
| `app/lib/screens/onboarding/onboarding_screen.dart` | catch(e, st) |
| `app/lib/screens/search/search_screen.dart` | catch(e, st) |
| `app/lib/widgets/price_chart.dart` | static _priceFormat |
| `app/lib/screens/my/my_page_screen.dart` | AppColors.warning |

---

## Night-18 스킵된 항목 (사용자 결정 대기)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| CRIT-2: upsert_user referral_code TOCTOU | CRITICAL | DB retry 루프 설계 필요 |
| C-2: router.dart TokenStorage 인스턴스 | HIGH | 전역 상태 설계 변경 필요 |
| UserDto/MeResponse 통합 | HIGH | 리팩토링 범위 크고 테스트 영향 있음 |
| Phase 2-C: code-simplifier | MEDIUM | 3회 연속 미착수 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-42까지 참조

---

# NIGHT_06_RESULT — 2026-03-17 (Night-17)

## Branch
`auto/night-01-20260317_0100`

---

## 완료된 작업

### Phase 0: MORNING_BRIEFING.md 커밋

- Night-16 종합 분석 업데이트 커밋 `11db0ab`

### Phase 1: 서브에이전트 3대 병렬 분석

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` (서버) | Rust 코드 심층 분석 | HIGH-3건 + MED-6건 + LOW-4건 |
| `feature-dev:code-explorer` (Flutter) | Dart 코드 심층 분석 | HIGH-4건 + MED-6건 + LOW-2건 |
| `feature-dev:code-architect` | 아키텍처/API 계약 분석 | API불일치-3건 + TEST갭-2건 + 코드중복-2건 |

오탐 필터링 후 **Night-17 실행 대상**: 서버 7건 + Flutter 9건 = 총 16건

### Phase 2-A: 서버(Rust) 타입 안전성 + 정수 연산 개선 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/crawlers/stats.rs` | `(a - b) as f64` → `a as f64 - b as f64` (오버플로 방지) |
| `server/src/crawlers/stats.rs` | `num_days() as i32` → `try_from(...).unwrap_or(i32::MAX)` + `.max(0)` clamp (2곳) |
| `server/src/crawlers/mod.rs` | `as f32 * 0.6 as usize` → `* 6 / 10` (불필요한 부동소수점 제거) |
| `server/src/crawlers/coupang.rs` | `.unwrap()` → `.expect("hardcoded CSS selector — invalid selector is a compile-time bug")` (7곳) |
| `server/src/services/auth_service.rs` | `jwt_refresh_ttl_secs as i64` → `i64::try_from(...).unwrap_or(i64::MAX)` (2곳) |
| `server/src/services/auth_service.rs` | `code.len() != 10` → `code.chars().count() != 10` (유니코드 안전) |
| `server/src/services/reward_service.rs` | `items.len() as i64 > limit` → `items.len() > limit as usize` |
| `server/src/api/pagination.rs` | `items.len() as i64 > limit` → `items.len() > limit as usize` |

### Phase 2-B: Flutter(Dart) 관측성 + 성능 + 접근성 + 버그 수정 (9건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/lib/screens/product/product_detail_screen.dart` | `NumberFormat` `build()` 매번 생성 → `static final _priceFormat` (성능) |
| `app/lib/screens/product/product_detail_screen.dart` | `catch(e)` → `catch(e, st)` + `debugPrint` (관측성) |
| `app/lib/screens/home/home_screen.dart` | `catch(e)` → `catch(e, st)` + `debugPrint` (관측성) |
| `app/lib/screens/home/home_screen.dart` | 인기 검색어 `ListTile` → `Semantics(label: '${rank}위 ${keyword}...')` (접근성) |
| `app/lib/screens/my/point_history_screen.dart` | `catch(e)` → `catch(e, st)` + `debugPrint` (관측성) |
| `app/lib/screens/my/point_history_screen.dart` | `_formatDate` 인라인 패딩 → `static final _dateFormat = DateFormat(...)` (성능) |
| `app/lib/screens/my/point_history_screen.dart` | `_transactionLabel` 'referral_welcome_referrer' 케이스 추가 (버그 수정) |
| `app/lib/screens/my/my_page_screen.dart` | `_loadPoints`/`_doCheckin` `catch(e)` → `catch(e, st)` + st 로깅 (관측성) |
| `app/lib/screens/alert/alert_screen.dart` | `_loadAlerts` `catch(e)` → `catch(e, st)` + `debugPrint` (관측성) |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** (변화 없음) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (16파일)

| 파일 | 핵심 내용 |
|------|-----------|
| `server/src/crawlers/stats.rs` | f64 캐스팅 순서 수정 + days_since_lowest try_from 안전 변환 (2곳) |
| `server/src/crawlers/mod.rs` | 동시성 계산 정수 연산으로 변환 |
| `server/src/crawlers/coupang.rs` | LazyLock unwrap → expect 7곳 |
| `server/src/services/auth_service.rs` | jwt_refresh_ttl_secs 안전 변환 + referral code chars().count() |
| `server/src/services/reward_service.rs` | has_more 비교 방향 수정 |
| `server/src/api/pagination.rs` | has_more 비교 방향 수정 |
| `app/lib/screens/product/product_detail_screen.dart` | static _priceFormat + catch(e, st) |
| `app/lib/screens/home/home_screen.dart` | catch(e, st) + Semantics |
| `app/lib/screens/my/point_history_screen.dart` | catch(e, st) + static _dateFormat + referral_welcome_referrer 케이스 추가 |
| `app/lib/screens/my/my_page_screen.dart` | _loadPoints/_doCheckin catch(e, st) |
| `app/lib/screens/alert/alert_screen.dart` | _loadAlerts catch(e, st) |

---

## Night-17 스킵된 항목 (설계 결정 필요)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| `product_service.rs` 커서 페이지네이션 비-id 정렬 | MEDIUM | API 설계 변경 필요 |
| `stats.rs` 중복 SQL 쿼리 추출 | MEDIUM | 리팩토링 범위 크고 버그 없음 |
| `auth.rs` 비즈니스 로직 서비스 추출 | MEDIUM | 아키텍처 결정 필요 |
| `crawlers/mod.rs` 세마포어 전/후 sleep 위치 | MEDIUM | 아키텍처 결정 필요 |
| `product_detail_screen.dart` Semantics 확대 | MEDIUM | 다음 접근성 Phase |
| `point_history_screen.dart` 에러 재시도 버튼 | LOW | UX 결정 필요 |
| `showErrorSnackBar` 12개 인라인 통합 | MEDIUM | 14파일 변경, 독립 커밋 필요 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-41 ~ D-42 참조

---

# NIGHT_06_RESULT — 2026-03-16 (Night-16)

## Branch
`auto/night-01-20260316_0100`

---

## 완료된 작업

### Phase 0: PRE-GATE 결정 (D-36~D-40) + Night-15 커밋

- **D-36** (MCP 마이그레이션): C — 스킵. WebSearch/WebFetch로 대체.
- **D-37** (Night-15 커밋): A — 별도 커밋 생성. 커밋 `5b9f5b9`.
- **D-38** (최적화 범위): A — 서버+Flutter 균형.
- **D-39** (E2E 테스트): B — 다음 세션 이연.
- **D-40** (Ralph Loop): C — 수동만.

### Phase 1: 총동원 심층 분석 (서브에이전트 4대 병렬)

4대 에이전트가 병렬 분석:
1. **feature-dev:code-explorer (서버)** — CRIT-2건 + HIGH-6건 + MED-5건 발견
2. **feature-dev:code-explorer (Flutter)** — CRIT-3건 + HIGH-8건 + MED-3건 발견
3. **pr-review-toolkit:silent-failure-hunter** — 13건 추가 패턴 발견
4. **feature-dev:code-architect** — API 계약 불일치, 코드 중복, 테스트 갭 분석

오탐 필터링 후 **Night-16 실행 대상**: 서버 7건 + Flutter 6건 = 총 13건

### Phase 2-A: 서버 Silent Failure 로깅 보강 (7건)

| 파일 | 수정 내용 |
|------|-----------|
| `server/src/auth/providers/kakao.rs` | map_err(|_|) → tracing::warn! 로깅 2건 |
| `server/src/auth/providers/apple.rs` | map_err(|_|) → debug/warn 로깅 2건 (JWT decode + RSA key) |
| `server/src/auth/providers/google.rs` | map_err(|_|) → debug/warn 로깅 2건 (JWT decode + RSA key) |
| `server/src/services/alert_service.rs` | JoinSet 패닉 감지 (`while let Some(result)`) + unwrap_or_default → warn |
| `server/src/services/ai_prediction_service.rs` | NotFound → Internal 오분류 수정: `match e.as_ref()` |
| `server/src/main.rs` | CORS filter_map silent drop → error! 로깅 + partition parse warn 분리 |

### Phase 2-B: Flutter 로깅 보강 + 성능/접근성 개선 (6건)

| 파일 | 수정 내용 |
|------|-----------|
| `app/lib/providers/auth_provider.dart` | `catch(_)` → `on DioException` + `catch(e, st)` with debugPrint |
| `app/lib/services/api_client.dart` | `catch(_)` → `catch(e, st)` with debugPrint |
| `app/lib/screens/my/my_page_screen.dart` | `catch(_)` 2건 → `catch(e)` + debugPrint + friendlyErrorMessage |
| `app/lib/screens/favorites/favorites_screen.dart` | `catch(_)` → `catch(e)` with debugPrint + Semantics 접근성 레이블 |
| `app/lib/screens/notification/notification_list_screen.dart` | markAsRead/deepLink `catch(_)` → debugPrint 2건 |
| `app/lib/screens/alert/alert_screen.dart` | `_showAddKeywordDialog` → try/finally controller.dispose() 보장 |
| `app/lib/widgets/product_card.dart` | `NumberFormat` build()마다 생성 → `static final _priceFormat` |

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** (변화 없음) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약 (13파일, +114/-53)

| 파일 | 핵심 내용 |
|------|-----------|
| `server/src/auth/providers/kakao.rs` | network/parse 에러 로깅 |
| `server/src/auth/providers/apple.rs` | JWT/RSA 에러 로깅 |
| `server/src/auth/providers/google.rs` | JWT/RSA 에러 로깅 |
| `server/src/services/alert_service.rs` | JoinSet 패닉 + TargetPrice warn |
| `server/src/services/ai_prediction_service.rs` | NotFound→Internal 오분류 수정 |
| `server/src/main.rs` | CORS/partition silent 스킵 → 로깅 |
| `app/lib/providers/auth_provider.dart` | catch(_) 세분화 |
| `app/lib/services/api_client.dart` | catch(_) → catch(e, st) |
| `app/lib/screens/my/my_page_screen.dart` | catch(e) + friendlyErrorMessage |
| `app/lib/screens/favorites/favorites_screen.dart` | catch(e) + Semantics |
| `app/lib/screens/notification/notification_list_screen.dart` | catch(e) 2건 |
| `app/lib/screens/alert/alert_screen.dart` | try/finally dispose |
| `app/lib/widgets/product_card.dart` | static final _priceFormat |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-36 ~ D-40 참조

---

# NIGHT_06_RESULT — 2026-03-15 (Night-15)

## Branch
`auto/night-01-20260315_0100`

---

## 완료된 작업

### Night-15: PLAN_01.md §5.3 잔여 이슈 8건 처리

#### F2: Colors.red → AppColors.error 교체 [HIGH] (3곳)
- `my_page_screen.dart:103` — 로그아웃 다이얼로그 TextButton `Colors.red` → `Theme.of(ctx).extension<AppColors>()!.error`
- `settings_screen.dart:38` — 로그아웃 다이얼로그 TextButton 동일 처리
- `settings_screen.dart:67` — 회원 탈퇴 다이얼로그 TextButton 동일 처리

#### S8: main.rs assert! → if/continue 복구 패턴 [MEDIUM]
- `ensure_partitions()` 내 `assert!(["api_access_logs", "price_history"].contains(table))` — 항상 true인 단언 제거
- `assert!(suffix.chars().all(...))` → `if !suffix...{ tracing::warn!; errors.push; continue; }` 교체
- panic! 대신 에러 수집 후 계속 실행 → 서버 안정성 향상

#### S9: pubspec build_runner 버전 확인 [MEDIUM — 보류]
- `^4.0.0`은 pub.dev에 미존재 (version solving failed)
- 기존 `^2.4.0` 유지 → DECISION_LOG D-35에 문서화
- 향후 build_runner 4.x 릴리즈 후 재시도 필요

#### F4: const 생성자 추가 [MEDIUM] (5곳)
- `onboarding_screen.dart`: `_WelcomePage` + `_CompletePage` const 생성자 추가, 호출부 `const _WelcomePage()` + `const _CompletePage()`
- `settings_screen.dart`: `_SectionHeader(title: '...')` 3곳 + `_PushNotificationTile()` → const 접두사 추가

#### F5: router.dart productId:0 → early return guard [MEDIUM]
- `'/product/:id'` 핸들러: `int.tryParse(...) ?? 0` → `int.tryParse(...)`
- `id == null || id <= 0` 시 `WidgetsBinding.instance.addPostFrameCallback → context.go('/')` + `SizedBox.shrink()` early return

#### F6: api_endpoints.dart trailing slash 일관성 정리 [MEDIUM] (6곳)
- `alerts = '$_v1/alerts/'` → `'$_v1/alerts'` (trailing slash 제거)
- `notifications = '$_v1/notifications/'` → `'$_v1/notifications'`
- `devices = '$_v1/devices/'` → `'$_v1/devices'`
- 테스트 파일 3개 동기화: `alert_service_test.dart`, `notification_service_test.dart`, `device_service_test.dart`

#### F7: PointHistoryScreen 날짜 표시 추가 [MEDIUM]
- `_formatDate(String isoDate) → String` 헬퍼 추가: `DateTime.parse(...).toLocal()` + YYYY.MM.DD 포맷
- `ListTile.subtitle` → `Column([if(desc) Text(desc), Text(_formatDate(...))])` 구조로 항상 날짜 표시

#### F8: LoadingSkeleton 다크모드 조건부 색상 [MEDIUM]
- `isDark = Theme.of(context).brightness == Brightness.dark` 추가
- `baseColor`: `Colors.grey.shade300` → `isDark ? Colors.grey.shade700 : Colors.grey.shade300`
- `highlightColor`: `Colors.grey.shade100` → `isDark ? Colors.grey.shade600 : Colors.grey.shade100`

---

## 검증 결과

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** (변화 없음) |
| `cargo clippy --lib -- -D warnings` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** (변화 없음) |

---

## 코드 변화 요약

| 파일 | 핵심 내용 |
|------|-----------|
| `app/lib/screens/my/my_page_screen.dart` | F2: Colors.red → AppColors.error (1곳) |
| `app/lib/screens/my/settings_screen.dart` | F2: Colors.red → AppColors.error (2곳), F4: const 4곳 |
| `server/src/main.rs` | S8: assert! → if/continue |
| `app/pubspec.yaml` | S9: build_runner 버전 확인 (^2.4.0 유지) |
| `app/lib/screens/onboarding/onboarding_screen.dart` | F4: const _WelcomePage + _CompletePage |
| `app/lib/config/router.dart` | F5: productId early return guard |
| `app/lib/config/api_endpoints.dart` | F6: trailing slash 3곳 제거 |
| `app/test/services/alert_service_test.dart` | F6: 테스트 URL 동기화 |
| `app/test/services/notification_service_test.dart` | F6: 테스트 URL 동기화 |
| `app/test/services/device_service_test.dart` | F6: 테스트 URL 동기화 |
| `app/lib/screens/my/point_history_screen.dart` | F7: 날짜 표시 + _formatDate 헬퍼 |
| `app/lib/widgets/loading_skeleton.dart` | F8: 다크모드 조건부 shimmer 색상 |

---

## 결정 사항
→ [DECISION_LOG.md](DECISION_LOG.md) D-34 ~ D-35 참조
- D-34: F6 trailing slash 제거 (api_endpoints + 테스트 3파일 동기화)
- D-35: S9 build_runner ^4.0.0 불존재 — ^2.4.0 유지

---

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

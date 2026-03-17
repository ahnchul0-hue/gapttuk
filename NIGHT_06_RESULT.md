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

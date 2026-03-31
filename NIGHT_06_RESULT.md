# NIGHT_06_RESULT — 2026-04-01 (Night-31)

## Branch
`auto/night-01-20260401_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인

**기준선**: Flutter 296건 ✅ / Rust lib 207건 ✅ / analyze 0 ✅

---

### Phase 2/3: 프레임워크 패턴 GAP 분석 (코드베이스 탐색)

#### 서버 (Rust) — 최신 패턴 정합 현황

| 프레임워크 | 현재 패턴 | 최신 권장 | GAP |
|-----------|----------|----------|-----|
| **axum 0.8.8** | State 추출자, Router::new().nest(), AppState(Arc<Config>) | 동일 | 없음 |
| **sqlx 0.8.6** | `query!` 매크로, PgPool, `DATABASE_MAX_CONNECTIONS` 환경변수 | 동일 | 없음 |
| **tower 미들웨어** | ServiceBuilder, SmartIpKeyExtractor, auth_limiter GC | 동일 | 없음 |

#### Flutter — 최신 패턴 GAP

| 프레임워크 | 현재 패턴 | 최신 권장 | GAP 수준 |
|-----------|----------|----------|---------|
| **riverpod 3.0.3** | `@riverpod` 코드젠, `@Riverpod(keepAlive:true)` | 3.3.1 `ref.keepAlive()` 새 API | 🟡 Minor |
| **go_router 16.3.0** | `ShellRoute` + index 관리 | `StatefulShellRoute` (탭 상태 유지) | 🟡 Minor |
| **dio 5.x** | `whenComplete` 기반 토큰 갱신, CancelToken | Retry interceptor 도입 검토 | 🟢 Low |

#### Phase 2/3 결론

- **서버**: axum/sqlx/tower 패턴 최신 권장사항과 완전 정합. 추가 리팩토링 불필요.
- **Flutter**: riverpod 3.0→3.3 업그레이드 시 `family` 타입 안전성 개선, keepAlive 새 API 사용 가능. go_router `StatefulShellRoute` 전환 시 탭 간 네비게이션 상태 유지 개선. 두 항목 모두 현재 기능에 영향 없는 개선 사항.

---

### Phase 6: Flutter 테스트 커버리지 확대 (+12건)

**목표 달성**: 296건 → **308건** (+12건)

#### ProductDetailScreen (11 → 15, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| priceTrend rising → "상승" 칩 표시 | `find.text('상승')` `findsOneWidget` |
| priceTrend stable → "안정" 칩 표시 (default 분기) | `_TrendChip` switch `_` 케이스 간접 검증 |
| 최고가 ₩35,000 통계 카드 표시 | `find.text('₩35,000')` `findsOneWidget` |
| AI 예측 wait → "대기" 텍스트 표시 | `find.textContaining('대기')` `findsOneWidget` |

**핵심 패턴 (Night-31 신규, D-58)**:
- `priceTrend: 'stable'` → `switch` `_` 기본값 분기를 간접 검증. 미래 새 trend 값 추가 시 이 테스트가 regression guard 역할

#### MyPageScreen (10 → 14, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 로그인 — "센트(¢) 잔액" 타이틀 표시 | `find.text('센트(¢) 잔액')` `findsOneWidget` |
| 로그인 — "오늘 출석" 버튼 표시 | `find.text('오늘 출석')` `findsOneWidget` |
| 출석 탭 후 "1¢ 획득" 스낵바 표시 | `find.textContaining('1¢ 획득')` `findsOneWidget` |
| 포인트 에러 → "로드 실패" 메시지 표시 | `FakeRewardService(error:...)` → `_error = true` 분기 |

**핵심 패턴 (Night-31 신규, D-59)**:
- `_CentsBalanceTile.initState()` 에러 분기: `FakeRewardService(error: Exception('...'))` 주입 → `_loadPoints` catch → `_error = true` → "로드 실패 (탭하여 재시도)" 렌더링
- `pumpAndSettle()` 후 "오늘 출석" 탭 → `_doCheckin()` → checkin API 호출 → 스낵바 검증

#### NotificationListScreen (10 → 14, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 에러 시 "알림 내역을 불러오지 못했습니다" 텍스트 | `find.textContaining(...)` `findsOneWidget` |
| 읽음 알림(isRead: true) 항목 제목 표시 | `isRead: true` 명시 주입 → 제목 렌더링 |
| sentAt: 방금 전 → "방금" 시간 표시 | `DateTime.now()` → `_formatTime`: `diff.inMinutes < 1` → '방금' |
| sentAt: 1시간 전 → "1시간 전" 시간 표시 | `DateTime.now().subtract(Duration(hours: 1))` → '1시간 전' |

**핵심 패턴 (Night-31 신규, D-60)**:
- `_formatTime` 시간대별 분기 검증: `DateTime.now()` 기준 `Duration` 빼기로 '방금'/'1시간 전' 분기 정확히 재현. static mock 없이 안정적 동작.
- 에러 메시지 텍스트 검증: 기존 Night-28 테스트가 "다시 시도" 버튼만 검증했던 것을 보완.

---

### Phase 8: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **308건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/product_detail_screen_test.dart` | 11건 | 15건 | +4 |
| `test/screens/my_page_screen_test.dart` | 10건 | 14건 | +4 |
| `test/screens/notification_list_screen_test.dart` | 10건 | 14건 | +4 |
| **합계** | **296건** | **308건** | **+12** |

---

## Phase 2/3 GAP 분석 요약

### 즉시 적용 가능 개선
없음 (현재 코드 최신 패턴과 정합)

### 다음 마일스톤 후보
1. **riverpod 3.0 → 3.3** (minor): `family` 타입 안전성, `ref.keepAlive()` 새 API
2. **go_router StatefulShellRoute 전환** (minor): 탭 간 네비게이션 상태 유지

---

## 의사결정

### D-58: _TrendChip default 케이스 간접 검증 패턴

**배경**: `priceTrend: 'stable'`은 switch `_` default 분기 → '안정' 반환. 직접 'stable' case가 없음.

**결정**: 'stable' 문자열을 입력으로 `_` default를 간접 검증. 미래 'stable' case 명시 추가 시 이 테스트 제거 불필요 (동일 결과).

**Status**: IMPLEMENTED

---

### D-59: _CentsBalanceTile initState 에러 분기 테스트

**배경**: MyPageScreen 기존 테스트에서 `_CentsBalanceTile`의 에러 분기(포인트 로드 실패) 미커버.

**결정**: `FakeRewardService(error: Exception('...'))` 주입 + `pumpAndSettle()` → `_loadPoints` catch → `_error = true` → "로드 실패 (탭하여 재시도)" 렌더링 검증. 인라인 ProviderScope 사용 (기존 `_buildScreen` 헬퍼 변경 불필요).

**Status**: IMPLEMENTED

---

### D-60: _formatTime 동적 시간 분기 검증

**배경**: `_NotificationTile._formatTime`의 '방금'/'분 전'/'시간 전' 분기 미테스트.

**결정**: `DateTime.now()` (방금) + `DateTime.now().subtract(Duration(hours: 1))` (1시간 전)으로 두 분기 검증. static mock 불필요 — 테스트 실행 시간이 1분 미만임을 전제.

**Status**: IMPLEMENTED

---

## DECISION_LOG 연속성

Night-30 D-57까지. 이번 세션 D-58, D-59, D-60 추가.

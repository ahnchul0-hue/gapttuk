# NIGHT_06_RESULT — 2026-03-28 (Night-28)

## Branch
`auto/night-01-20260328_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인 + 미커밋 커밋

**기준선**: Rust lib 207건 ✅ / Flutter 260건 ✅ / analyze 0 ✅

MORNING_BRIEFING.md Night-27 종합 분석 완료 → 커밋 `f168637`.

### Phase 1: ProductDetailScreen 테스트 확대

**기존 파일 확장**: `test/screens/product_detail_screen_test.dart` (7건 → 11건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| priceTrend falling → "하락" 칩 표시 | `fakeProduct.priceTrend = 'falling'` → `_TrendChip` → `'하락'` |
| buyTimingScore 85 → "매수 타이밍 85점" 배지 표시 | `buyTimingScore: 85` → `_TimingBadge` → `'매수 타이밍 85점'` |
| 최저가 ₩25,000 통계 카드 표시 | `lowestPrice: 25000` → `_StatColumn` → `'₩25,000'` |
| AI 예측 buy_now → "지금 구매" 텍스트 표시 | `predictionFuture` 데이터 주입 → `_PredictionCard` → `'지금 구매'` |

**핵심 패턴**:
- `buildScreen(predictionFuture: Future.value({...}))` — `productPredictionProvider` override로 AI 예측 카드 상태 검증
- `_TrendChip`/`_TimingBadge`/`_StatColumn` private 위젯들은 상위 buildScreen()으로 간접 검증

### Phase 2: NotificationListScreen 테스트 확대

**기존 파일 확장**: `test/screens/notification_list_screen_test.dart` (6건 → 10건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 알림 본문(body) 텍스트 표시 | `body: '가격이 목표가에 도달했습니다.'` → `_NotificationTile` subtitle 렌더링 |
| 읽지 않은 알림(isRead: false) 항목 렌더링 | `isRead: false` 알림 → ListTile 정상 표시 |
| "모두 읽음" 탭 후 스낵바 표시 | `tap(find.text('모두 읽음'))` → `'모든 알림을 읽음 처리했습니다.'` 스낵바 |
| 두 개의 알림 항목 모두 제목 표시 | 2개 `AppNotification` 주입 → 두 제목 모두 `findsOneWidget` |

**핵심 패턴 (Night-28 신규)**:
- `FakeNotificationService.markAllAsRead()` → 즉시 성공 → `ScaffoldMessenger` 스낵바 검증
- `isRead: false` → `Semantics(label: '..., 읽지 않음')` 렌더링 — Semantics 접근성 레이블 간접 검증

### Phase 3: PointHistoryScreen 테스트 확대

**기존 파일 확장**: `test/screens/point_history_screen_test.dart` (6건 → 10건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 'referral_welcome' 타입 → "추천 가입 보상" 레이블 | `_transactionLabel('referral_welcome')` 분기 검증 |
| 'gifticon_exchange' 타입 → "기프티콘 교환" 레이블 | `_transactionLabel('gifticon_exchange')` 분기 검증 |
| 음수 금액 amount: -5 → "-5¢" 표시 | `isPositive=false` → `'${amount}¢'` ('+' 없음) |
| 날짜 "yyyy.MM.dd" 형식 표시 | `DateTime(2026, 3, 24)` → `'2026.03.24'` |

**핵심 패턴 (Night-28 신규)**:
- `_transactionLabel` switch 분기 전수 테스트: `daily_checkin`(기존) + `referral_welcome` + `gifticon_exchange` = 3/8 분기 커버
- 음수 금액: `amount: -5` → `isPositive=false` → trailing `'-5¢'` (접두어 없음) vs 양수 `'+3¢'` 대비

### Phase 4: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **272건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/product_detail_screen_test.dart` | 7건 | 11건 | +4 |
| `test/screens/notification_list_screen_test.dart` | 6건 | 10건 | +4 |
| `test/screens/point_history_screen_test.dart` | 6건 | 10건 | +4 |
| **합계** | **260건** | **272건** | **+12** |

---

## 의사결정 기록

**D-52**: NotificationListScreen — `_markAllAsRead` 스낵바 검증 패턴

- `FakeNotificationService.markAllAsRead()` → 즉시 `0` 반환 (에러 없음)
- `tap(find.text('모두 읽음'))` + `pumpAndSettle()` → `ScaffoldMessenger` 스낵바 텍스트 검증
- 기존 Fake에 이미 no-op 구현이 있어서 별도 수정 불필요 — `FakeNotificationService` 재사용성 검증
- **Status**: IMPLEMENTED

**D-53**: PointHistoryScreen — `_transactionLabel` switch 분기 단위 테스트 전략

- `_transactionLabel`은 private 메서드이므로 직접 호출 불가 → 위젯 통합 테스트로 간접 검증
- 각 분기별로 `PointHistoryItem(transactionType: '...')` 주입 → 렌더링된 텍스트로 switch 결과 검증
- 8개 분기 중 3개 커버 (`daily_checkin`/`referral_welcome`/`gifticon_exchange`)
- **Status**: IMPLEMENTED

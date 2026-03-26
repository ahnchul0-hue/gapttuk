# NIGHT_06_RESULT — 2026-03-27 (Night-27)

## Branch
`auto/night-01-20260327_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인 + 미커밋 커밋

**기준선**: Rust lib 207건 ✅ / Flutter 248건 ✅ / analyze 0 ✅

MORNING_BRIEFING.md Night-26 미커밋 변경 확인 → 커밋 `bea696b` 으로 정리.

### Phase 1: FavoritesScreen 테스트 확대

**기존 파일 확장**: `test/screens/favorites_screen_test.dart` (5건 → 9건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 에러 시 "즐겨찾기를 불러오지 못했습니다" 표시 | FakeAlertService(error) → 에러 메시지 |
| 에러 시 "다시 시도" 버튼 표시 | 에러 상태의 재시도 버튼 |
| 알림 1개 있을 때 AppBar "1개" 배지 | PriceAlert 1개 → `_priceAlerts.length`개 배지 |
| 알림 1개 있을 때 "상품 #100" 폴백 표시 | productDetailProvider 실패 → 폴백 텍스트 |

**핵심 패턴**:
- `_buildScreenWithProduct(service, productId)` 헬퍼: `alertServiceProvider` + `productDetailProvider(id)` 동시 override
- `productDetailProvider(100).overrideWith((ref) async { throw Exception('not found'); })` — product load 실패 시 폴백 `'상품 #${alert.productId}'` 검증

### Phase 2: MyPageScreen 테스트 확대

**기존 파일 확장**: `test/screens/my_page_screen_test.dart` (6건 → 10건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 로그인 — "알림 설정" 메뉴 항목 표시 | `ListTile(title: '알림 설정')` 존재 |
| 로그인 — "설정" 메뉴 항목 표시 | `ListTile(title: '설정')` 존재 |
| 로그인 — 이메일 표시 | `_fakeUser.email` 표시 |
| 로그인 — 포인트 로드 후 "5¢" 표시 | FakeRewardService 기본값 balance=5 → `'5¢'` |

### Phase 3: AlertScreen 탭 전환 테스트

**기존 파일 확장**: `test/screens/alert_screen_test.dart` (6건 → 10건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 카테고리 탭 전환 후 빈 상태 메시지 | `tester.tap(find.text('카테고리'))` → "카테고리 알림이 없습니다" |
| 키워드 탭 전환 후 빈 상태 메시지 | `tester.tap(find.text('키워드'))` → "키워드 알림이 없습니다" |
| 키워드 알림 있을 때 키워드 표시 | `KeywordAlert(keyword: '무선이어폰')` → 텍스트 렌더링 |
| 카테고리 알림 있을 때 "카테고리 #5" 표시 | `CategoryAlert(categoryId: 5)` → 텍스트 렌더링 |

**핵심 패턴 (Night-27 신규)**:
- `TabBar` 탭 전환: `tester.tap(find.text('탭명'))` + `pumpAndSettle()` — TabBarView 내용 전환 검증
- `AlertListResponse(categoryAlerts: [...])` / `AlertListResponse(keywordAlerts: [...])` — 탭별 데이터 분리 주입

### Phase 4: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **260건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/favorites_screen_test.dart` | 5건 | 9건 | +4 |
| `test/screens/my_page_screen_test.dart` | 6건 | 10건 | +4 |
| `test/screens/alert_screen_test.dart` | 6건 | 10건 | +4 |
| **합계** | **248건** | **260건** | **+12** |

---

## 의사결정 기록

**D-50**: FavoritesScreen — productDetailProvider(id) family override 패턴

- FavoritesScreen 내부에서 `ref.read(productDetailProvider(id).future)` 를 각 product ID별로 호출.
- 테스트에서 `productDetailProvider(100).overrideWith(...)` 로 특정 ID만 override — 상품 로드 실패 시 폴백 `'상품 #${alert.productId}'` 검증 가능.
- `_buildScreenWithProduct(service, productId)` 헬퍼로 alert + product 동시 override 패턴 확립.
- **Status**: IMPLEMENTED

**D-51**: AlertScreen TabBar 전환 테스트 — `tester.tap(find.text('탭명'))` 패턴

- `TabController`가 있는 `TabBar` 전환: `find.text('카테고리')` 탭 탭 → `pumpAndSettle()` → `TabBarView` 내용 검증.
- 각 탭의 데이터는 `AlertListResponse`의 해당 필드로 독립 주입.
- **Status**: IMPLEMENTED

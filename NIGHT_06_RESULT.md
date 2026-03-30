# NIGHT_06_RESULT — 2026-03-31 (Night-30)

## Branch
`auto/night-01-20260331_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인

**기준선**: Rust lib 207건 ✅ / Flutter 284건 ✅ / analyze 0 ✅

### Phase 1: 의존성 감사 (cargo audit + pub outdated)

**Sonatype MCP**: 인증 불가 → `cargo audit` + `pub outdated` 대체 실행

#### Dart 패키지 업그레이드 현황

| 패키지 | 현재 | 최신 | 비고 |
|--------|------|------|------|
| `fl_chart` | 0.69.2 | 1.2.0 | 메이저 업 — 호환성 검토 필요 |
| `flutter_riverpod` | 3.0.3 | 3.3.1 | 마이너 — Resolvable 불가 (constraint) |
| `flutter_secure_storage` | 9.2.4 | 10.0.0 | 메이저 업 |
| `go_router` | 16.3.0 | 17.1.0 | 메이저 업 |
| `google_sign_in` | 6.3.0 | 7.2.0 | 메이저 업 |
| `json_annotation` | 4.9.0 | **4.11.0** | ✅ 즉시 업그레이드 가능 |
| `sign_in_with_apple` | 6.1.4 | 7.0.1 | 메이저 업 |

**결론**: 메이저 업그레이드는 다음 마일스톤에서 Breaking change 검토 후 진행. `json_annotation` 마이너 업그레이드는 안전하나 이 세션에서 보류 (테스트 중점).

### Phase 2/3: 아키텍처 GAP 분석 (코드베이스 직접 탐색)

- SearchScreen: 필터/정렬 칩이 현재 브랜치에 없음 (fix/phase0-security-stability 브랜치에만 존재)
- SettingsScreen: 다이얼로그 미테스트 경로 확인 (로그아웃/탈퇴 확인 다이얼로그)
- FavoritesScreen: AlertTypeBadge + isActive=false 분기 미테스트 확인

### Phase 6: Flutter 테스트 커버리지 확대 (+12건)

**목표 달성**: 284건 → **296건** (+12건)

#### SettingsScreen (7 → 11, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 로그아웃 탭 → 확인 다이얼로그 표시 | `'정말 로그아웃 하시겠습니까?'` `findsOneWidget` |
| 로그아웃 다이얼로그 취소 탭 → 닫힘 | `AlertDialog` `findsNothing` |
| 회원 탈퇴 탭 → 확인 다이얼로그 표시 | `textContaining('정말 탈퇴하시겠습니까?')` `findsOneWidget` |
| 계정 섹션 아이콘 표시 | `Icons.logout` + `Icons.person_remove_outlined` `findsOneWidget` |

**핵심 패턴 (Night-30 신규)**:
- `showDialog` 확인 없이 다이얼로그 표시만 검증 — `confirmed == false` 분기로 navigate 호출 없음
- `alertDialog` tap '취소' → `Navigator.of(ctx).pop(false)` → `context.go()` 비호출 — GoRouter 없이 안전

#### SearchScreen (8 → 12, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 초기 텍스트 Semantics 위젯으로 감싸짐 | `widget<Semantics>().properties.label == '검색어를 입력하세요'` |
| TextField textInputAction.search | `tf.textInputAction == TextInputAction.search` |
| 검색 아이콘 버튼 tooltip "검색" | `iconBtn.tooltip == '검색'` |
| 빈 검색어 검색 탭 → 로딩 없음 | `CircularProgressIndicator` `findsNothing` |

**핵심 패턴 (Night-30 신규, D-56)**:
- `find.bySemanticsLabel()` 대신 `find.ancestor(...).first` + `widget<Semantics>().properties.label` — 접근성 트리 활성화 없이 위젯 속성 직접 검증

#### FavoritesScreen (9 → 13, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 알림 카드에 AlertTypeBadge 표시 | `find.byType(AlertTypeBadge)` `findsOneWidget` |
| 알림 2개 → AppBar "2개" 배지 | `find.text('2개')` `findsOneWidget` |
| 비활성 알림(`isActive: false`) → "비활성" 오버레이 | `find.text('비활성')` `findsOneWidget` |
| 에러 후 "다시 시도" 탭 → 에러 재표시 | `'즐겨찾기를 불러오지 못했습니다'` `findsOneWidget` |

**핵심 패턴**:
- 두 productId 동시 override: `productDetailProvider(100).overrideWith(...)` + `productDetailProvider(200).overrideWith(...)` (D-57)
- `isActive: false` 명시 주입으로 `PriceAlert(@Default(true))` 기본값 override → "비활성" 오버레이 검증

### Phase 8: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **296건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/settings_screen_test.dart` | 7건 | 11건 | +4 |
| `test/screens/search_screen_test.dart` | 8건 | 12건 | +4 |
| `test/screens/favorites_screen_test.dart` | 9건 | 13건 | +4 |
| **합계** | **284건** | **296건** | **+12** |

---

## 의사결정

### D-56: Semantics 위젯 검증 패턴 — `find.bySemanticsLabel` 대신 `properties.label`

**배경**: `find.bySemanticsLabel('검색어를 입력하세요')`가 0 matches 반환 (접근성 트리 비활성).

**결정**: `find.ancestor(of: find.text('...'), matching: find.byType(Semantics)).first` + `widget<Semantics>().properties.label` 직접 검증으로 대체.

**이유**: 접근성 트리는 `tester.ensureSemantics()` 없이는 활성화되지 않아 `find.bySemanticsLabel`이 빈 결과를 반환. 위젯 속성 직접 검증이 더 안정적.

**Status**: IMPLEMENTED

---

### D-57: 다중 productDetailProvider family override 패턴

**결정**: FavoritesScreen 알림 2개 테스트 시 `productDetailProvider(100)`와 `productDetailProvider(200)`을 별도 `overrideWith`로 각각 등록.

**Status**: IMPLEMENTED

---

## DECISION_LOG 연속성

Night-30 이전 D-55까지 기록됨. 이번 세션에서 D-56, D-57 추가.

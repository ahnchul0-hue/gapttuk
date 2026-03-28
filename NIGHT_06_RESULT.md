# NIGHT_06_RESULT — 2026-03-29 (Night-29)

## Branch
`auto/night-01-20260329_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인 + 미커밋 커밋

**기준선**: Rust lib 207건 ✅ / Flutter 272건 ✅ / analyze 0 ✅

MORNING_BRIEFING.md Night-28 엔트리 추가 → 커밋 `083a46a` (Phase 0 기준선).

### Phase 1: HomeScreen 테스트 확대

**기존 파일 확장**: `test/screens/home_screen_test.dart` (7건 → 11건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| trend up → trending_up 아이콘 표시 | `trend: 'up'` → `Icons.trending_up` `findsOneWidget` |
| trend down → trending_down 아이콘 표시 | `trend: 'down'` → `Icons.trending_down` `findsOneWidget` |
| trend new → "NEW" 텍스트 표시 | `trend: 'new'` → `Text('NEW')` `findsOneWidget` |
| 빈 인기 검색어 → "인기 검색어가 없습니다" 표시 | `data: []` → `'인기 검색어가 없습니다'` `findsOneWidget` |

**핵심 패턴**:
- `_trendIcon` switch expression 4개 분기를 `fakeSearches` trend 값 주입 + `pumpAndSettle()`로 간접 검증
- 빈 목록 분기(`searches.isEmpty`) — `data: <PopularSearch>[]` 직접 주입

### Phase 2: LoginScreen 테스트 확대

**기존 파일 확장**: `test/screens/login_screen_test.dart` (6건 → 10건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 카카오 버튼 chat_bubble 아이콘 표시 | `Icons.chat_bubble` `findsOneWidget` |
| Apple 버튼 apple 아이콘 표시 | `Icons.apple` `findsOneWidget` |
| 네이버 버튼 north_east 아이콘 표시 | `Icons.north_east` `findsOneWidget` |
| 초기 상태에서 로딩 표시기 없음 | `CircularProgressIndicator` `findsNothing` |

**핵심 패턴 (Night-29 신규)**:
- `_SocialLoginButton` 아이콘 분기: `isLoading=false` 초기 상태에서 `CircularProgressIndicator`가 없어야 함 — 로딩 상태 분기 간접 검증
- 버튼 아이콘 3종 (`chat_bubble`/`apple`/`north_east`) — `ElevatedButton.icon`의 icon 파라미터 렌더링 확인

### Phase 3: OnboardingScreen 테스트 확대

**기존 파일 확장**: `test/screens/onboarding_screen_test.dart` (7건 → 11건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 약관 페이지: 타이틀 텍스트 표시 | `textContaining('서비스 이용을 위해')` `findsOneWidget` |
| 약관 페이지: 추천 코드 보너스 안내 텍스트 표시 | `textContaining('1¢ 웰컴 보너스')` `findsOneWidget` |
| 약관 페이지: 전체 동의 탭 → "다음" 버튼 활성화 | `tap('전체 동의')` → `ElevatedButton.onPressed` isNotNull |
| 환영 페이지: 가격 알림 기능 설명 표시 | `'원하는 가격이 되면 즉시 알려드립니다.'` `findsOneWidget` |

**핵심 패턴 (Night-29 신규)**:
- `'전체 동의'` ListTile 탭 → `_onAllAgreedChanged(true)` → `_canProceedFromPage2 = true` → ElevatedButton.onPressed isNotNull — 상태 기반 버튼 활성화 검증
- `find.textContaining()` 사용: 긴 텍스트의 일부로 검색 — 레이아웃 변경에 강건한 패턴

### Phase 4: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **284건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/home_screen_test.dart` | 7건 | 11건 | +4 |
| `test/screens/login_screen_test.dart` | 6건 | 10건 | +4 |
| `test/screens/onboarding_screen_test.dart` | 7건 | 11건 | +4 |
| **합계** | **272건** | **284건** | **+12** |

---

## 의사결정 기록

**D-54**: HomeScreen `_trendIcon` switch 분기 간접 테스트 전략

- `_trendIcon`은 private 메서드 → 데이터 주입 + `pumpAndSettle()`로 렌더링된 Icon/Text 검증
- `trend: 'up'` → `Icons.trending_up`, `'down'` → `Icons.trending_down`, `'new'` → `Text('NEW')`
- 빈 목록 분기(`searches.isEmpty`) → `'인기 검색어가 없습니다'` 텍스트
- **Status**: IMPLEMENTED

**D-55**: OnboardingScreen 상태 기반 버튼 활성화 검증

- `'전체 동의'` CheckboxListTile 탭 → `setState(_allAgreed/termsAgreed/privacyAgreed/marketingAgreed = true)` → `_canProceedFromPage2 = true` → `ElevatedButton.onPressed isNotNull`
- `find.textContaining()` 패턴: 긴 문자열/멀티라인 텍스트에서 핵심 키워드만 추출해 검색 → 레이아웃 변경에 내성
- **Status**: IMPLEMENTED

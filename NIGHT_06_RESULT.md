# NIGHT_06_RESULT — 2026-03-26 (Night-26)

## Branch
`auto/night-01-20260326_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인

**기준선**: Rust lib 207건 ✅ / Flutter 238건 ✅ / analyze 0 ✅

MORNING_BRIEFING.md Night-25 미커밋 변경 확인 → Night-26 작업에 포함하여 커밋.

### Phase 1: AuthState 프로바이더 테스트

**신규 파일**: `test/providers/auth_provider_test.dart` (6건)

| 테스트 | 핵심 검증 |
|--------|-----------|
| 초기 상태 null | `authStateProvider` 초기값 null |
| login 성공 시 state = user | socialLogin → state.id/nickname 업데이트 + pushService 호출 |
| logout 후 state null | logout() → state = null, authService.logout() 검증 |
| refresh 성공 시 state = user | me() → state 업데이트 + pushService 호출 |
| refresh DioException 시 state null 유지 | 네트워크 오류 시 state = null (에러 전파 없음) |
| withdraw 후 state null | withdraw() → state = null, authService.withdraw() 검증 |

**핵심 패턴**:
- `MockAuthService extends Mock implements AuthService` + `MockPushService`
- `pushServiceProvider.overrideWith((_) => mockPush)` — login/refresh 시 pushService.registerDeviceIfNeeded() stub 필수
- `keepAlive: true` Notifier → ProviderContainer 직접 읽기로 상태 검증
- DioException 예외: AuthState.refresh()의 `on DioException catch` 분기 검증 (debugPrint 로그 정상 출력)

### Phase 2: SearchScreen 테스트 확대

**기존 파일 확장**: `test/screens/search_screen_test.dart` (4건 → 8건, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| 초기 "검색어를 입력하세요" 텍스트 표시 | 기존 `find.byType(TextField)` 중복 → 실제 텍스트 검증으로 교체 |
| 힌트 텍스트 "상품명 또는 URL 검색" 표시 | `TextField.decoration?.hintText` 직접 검증 |
| 검색 아이콘 버튼 표시 | `Icons.search` IconButton 존재 |
| 초기 로딩 인디케이터 없음 | `CircularProgressIndicator` findsNothing |
| 초기 상태에서 ListView 없음 | 검색 전 빈 상태 — ListView findsNothing |

**추가 개선**: `buildScreen()` 헬퍼 `AppTheme.light` 주입으로 통일 (중복 제거).

### Phase 3: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **248건 전체 통과** ✅ (+10건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/providers/auth_provider_test.dart` | 신규 | 6건 | +6 |
| `test/screens/search_screen_test.dart` | 4건 | 8건 | +4 |
| **합계** | **238건** | **248건** | **+10** |

---

## 의사결정 기록

**D-49**: AuthState 테스트 — PushService mock 주입 필수

- `AuthState.login()`과 `refresh()`는 성공 후 `pushServiceProvider.registerDeviceIfNeeded()` 호출.
- `pushServiceProvider` stub 없이 override만 하면 MissingStubError 발생.
- `when(() => mockPush.registerDeviceIfNeeded()).thenAnswer((_) async {})` → setUp에 배치.
- **Status**: IMPLEMENTED

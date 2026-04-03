# NIGHT_06_RESULT — 2026-04-04 (Night-34 추가)

> **Night-34 결과**: Flutter **344건** ✅ (+12) | analyze 0건 ✅
> **Night-33 이전 결과** (이하 원본 보존)

---

## Night-34 (2026-04-04) — Phase 6 계속

**브랜치**: `auto/night-01-20260404_0100`
**베이스라인**: 332건 → **344건** (+12건)

### D-67: HomeScreen +4건 (11 → 15건)

| 테스트 | 검증 대상 |
|--------|----------|
| trend stable → trending_flat 아이콘 표시 | `_trendIcon`: `'stable' \|\| _` → `Icons.trending_flat` |
| trend null → trailing 아이콘 없음 | `trailing: s.trend != null ? ... : null` → 3종 아이콘 모두 `findsNothing` |
| rank 1 → CircleAvatar에 "1" 표시 | `ListTile leading: CircleAvatar(child: Text('${s.rank}'))` |
| URL 다이얼로그 취소 탭 → 닫힘 | `TextButton('취소')` → `Navigator.pop()` → `AlertDialog findsNothing` |

**패턴**: `find.byIcon(Icons.trending_flat)` — `'stable' || _` default 분기 커버. Night-34 신규 **D-67**.

### D-68: ProductDetailScreen +4건 (15 → 19건)

| 테스트 | 검증 대상 |
|--------|----------|
| 평균가 ₩30,000 통계 카드 표시 | `_StatColumn('평균가', '₩30,000')` — `averagePrice: 30000` 렌더링 |
| AI 예측 neutral → "보합" 텍스트 표시 | `_PredictionCard`: `'neutral' \|\| _` → `actionText='보합'` |
| "요일별 평균 가격" 섹션 타이틀 표시 | 차트 섹션 헤더 `Text('요일별 평균 가격')` |
| buyTimingScore null → "매수 타이밍" 배지 없음 | `_TimingBadge` 조건부 렌더링 — `null` 시 `findsNothing` |

**패턴**: `findsNothing` 로 조건부 렌더링 부재 검증 — buyTimingScore null 케이스. Night-34 신규 **D-68**.

### D-69: OnboardingScreen +4건 (11 → 15건)

| 테스트 | 검증 대상 |
|--------|----------|
| 환영 페이지: "가격 히스토리" 설명 표시 | `_FeatureItem.description: '상품의 가격 변화를 한눈에 확인하세요.'` |
| 환영 페이지: "센트(¢) 보상" 설명 표시 | `_FeatureItem.description: '가격 제보와 활동으로 센트를 적립하세요.'` |
| 이용약관만 탭 → "다음" 버튼 여전히 비활성 | `termsAgreed=true`, `privacyAgreed=false` → `_canProceedFromPage2=false` |
| 완료 페이지: "준비 완료!" + "시작하기" 버튼 | 전체동의→Page 3 이동 → `_CompletePage` 렌더링 검증 |

**패턴**: `_canProceedFromPage2 = _termsAgreed && _privacyAgreed` 의 AND 조건을 개별 탭으로 분리 검증. 완료 페이지는 `_finish()` 호출 없이 Page 3 렌더링만 확인. Night-34 신규 **D-69**.

### Night-34 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **344건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

# NIGHT_06_RESULT — 2026-04-03 (Night-33 추가)

> **Night-33 결과**: Flutter **332건** ✅ (+12) | analyze 0건 ✅
> **Night-32 이전 결과** (이하 원본 보존)

---

## Night-33 (2026-04-03) — Phase 6 계속

**브랜치**: `auto/night-01-20260403_0100`
**베이스라인**: 320건 → **332건** (+12건)

### D-64: MyPageScreen +4건 (14 → 18건)

| 테스트 | 검증 대상 |
|--------|----------|
| 출석 탭 후 "출석 완료" 버튼으로 변경 | `_doCheckin()` → `_checkinDone=true` → TextButton '출석 완료' |
| 추천 코드 복사 버튼 tooltip "복사" | `_ReferralCodeTile` IconButton.tooltip |
| 로그아웃 탭 → AlertDialog 표시 | `MyPageScreen._showLogoutDialog` 실행 확인 |
| 로그아웃 다이얼로그 취소 탭 → 닫힘 | 취소 → `logout()` 미호출, AlertDialog 닫힘 |

**패턴**: `find.widgetWithText(ListTile, '로그아웃')` — 중복 텍스트를 위젯 타입으로 좁혀 tap.

### D-65: NotificationListScreen +4건 (13 → 17건)

| 테스트 | 검증 대상 |
|--------|----------|
| sentAt: 5분 전 → "5분 전" | `_formatTime`: `inMinutes < 60` 분기 |
| sentAt: 2일 전 → "2일 전" | `_formatTime`: `inDays < 7` 분기 |
| sentAt: 10일 전 → "M/D" 날짜 형식 | `_formatTime`: `inDays >= 7` 분기 — `'${date.month}/${date.day}'` 동적 계산 |
| notificationType "system" → Icons.info_outline | `_buildTypeIcon` switch 'system' case |

**패턴**: M/D 날짜는 `DateTime.now().subtract(Duration(days: 10))`으로 동적 계산해 하드코딩 회피.

### D-66: SettingsScreen +4건 (11 → 15건)

| 테스트 | 검증 대상 |
|--------|----------|
| 회원 탈퇴 다이얼로그 "탈퇴" 버튼 표시 | `_showDeleteAccountDialog` TextButton '탈퇴' |
| 회원 탈퇴 다이얼로그 취소 탭 → 닫힘 | 취소 → `withdraw()` 미호출 |
| 로그아웃 다이얼로그 "로그아웃" 확인 버튼 표시 | dialog actions TextButton '로그아웃' |
| 탈퇴 경고 문구 "데이터가 삭제됩니다" | AlertDialog content 포함 검증 |

### Night-33 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test` | **332건 전체 통과** ✅ (+12건) |
| `flutter analyze` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

# NIGHT_06_RESULT — 2026-04-02 (Night-32)

## Branch
`auto/night-01-20260402_0100`

---

## 완료된 작업

### Phase 0: 기준선 확인

**기준선**: Flutter 308건 ✅ / Rust lib 207건 ✅ / analyze 0 ✅

---

### Phase 6: Flutter 테스트 커버리지 확대 (+12건)

**목표 달성**: 308건 → **320건** (+12건)

#### AlertScreen (10 → 14, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| AppBar "키워드 알림 추가" 아이콘 버튼 표시 | `find.byIcon(Icons.add)` `findsOneWidget` |
| 에러 시 "다시 시도" 버튼 표시 | `find.text('다시 시도')` `findsOneWidget` (error state) |
| 가격 알림 1건 → 탭 Badge 표시 | `find.byType(Badge)` `findsAtLeastNWidgets(1)` |
| CategoryAlert thresholdPercent → "%이상 할인" 텍스트 | `find.textContaining('20% 이상 할인')` `findsOneWidget` |

**핵심 패턴 (Night-32 신규, D-61)**:
- `_buildTab` count > 0 → `Badge(label: Text('$count'), child: Icon(icon))` 렌더링을 `find.byType(Badge)`로 검증. 탭 배지 UI 회귀 방어.

#### LoginScreen (10 → 14, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| Google 버튼 g_mobiledata 아이콘 표시 | `find.byIcon(Icons.g_mobiledata)` `findsOneWidget` |
| 로고 Semantics "값뚝 로고" 레이블 | D-56 패턴 — `widget<Semantics>().properties.label == '값뚝 로고'` |
| TextButton (둘러보기) 1개 렌더링 | `find.byType(TextButton)` `findsOneWidget` |
| SafeArea 렌더링 | `find.byType(SafeArea)` `findsOneWidget` |

**핵심 패턴 (Night-32 신규, D-62)**:
- `Semantics(image: true, label: '값뚝 로고', ...)` 접근성 레이블을 D-56 ancestor 패턴으로 검증. `find.ancestor(of: icon, matching: Semantics).first` → `properties.label` 비교.

#### PointHistoryScreen (10 → 14, +4건)

| 신규 테스트 | 핵심 검증 |
|------------|-----------|
| "referral_welcome_referrer" → "추천인 웰컴 보상" | `_transactionLabel` switch 분기 간접 검증 |
| "referral_purchase_referrer" → "추천인 보상" | `_transactionLabel` switch 분기 간접 검증 |
| "admin_adjustment" → "운영자 조정" | `_transactionLabel` switch 분기 간접 검증 |
| description 있을 때 설명 텍스트 표시 | `PointHistoryItem(description: '3일 연속 출석 보너스')` → `find.text(...)` |

**핵심 패턴 (Night-32 신규, D-63)**:
- `_transactionLabel` switch의 미테스트 케이스 3개('referral_welcome_referrer', 'referral_purchase_referrer', 'admin_adjustment') 체계적 완성 (D-53 패턴 확장)
- `PointHistoryItem.description` nullable 필드의 조건부 렌더링 분기 검증 — `if (item.description != null) Text(item.description!)` 경로 커버

---

### Phase 8: 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **320건 전체 통과** ✅ (+12건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| Rust lib 변경 | 없음 (207건 유지) |

---

## 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/alert_screen_test.dart` | 10건 | 14건 | +4 |
| `test/screens/login_screen_test.dart` | 10건 | 14건 | +4 |
| `test/screens/point_history_screen_test.dart` | 10건 | 14건 | +4 |
| **합계** | **308건** | **320건** | **+12** |

---

## 의사결정

### D-61: AlertScreen 탭 Badge 렌더링 검증

**배경**: `_buildTab(label, icon, count)` — count > 0일 때 `Badge(label: Text('$count'), ...)` 위젯 생성. 기존 테스트는 탭 텍스트만 검증, Badge 렌더링 미커버.

**결정**: PriceAlert 1건 로드 후 `find.byType(Badge)` `findsAtLeastNWidgets(1)` 검증. count가 변경되어도 Badge 존재 여부로 회귀 방어.

**Status**: IMPLEMENTED

---

### D-62: LoginScreen Semantics label 접근성 검증

**배경**: `Semantics(image: true, label: '값뚝 로고', child: Icon(...))` — 로고 접근성 레이블 미테스트.

**결정**: D-56 패턴 적용 — `find.ancestor(of: find.byIcon(Icons.trending_down), matching: find.byType(Semantics)).first` → `widget<Semantics>().properties.label == '값뚝 로고'`.

**Status**: IMPLEMENTED

---

### D-63: PointHistoryScreen _transactionLabel 나머지 분기 완성

**배경**: `_transactionLabel` switch 8개 case 중 'referral_welcome_referrer'/'referral_purchase_referrer'/'admin_adjustment' 3개 미테스트 (Night-28 기준).

**결정**: D-53 패턴 동일 — transactionType 주입 → 렌더링된 레이블 텍스트 검증. switch 8개 중 7개 커버 완료 (미커버: `_` default case — type 원문 반환).

**Status**: IMPLEMENTED

---

## DECISION_LOG 연속성

Night-31 D-60까지. 이번 세션 D-61, D-62, D-63 추가.

# NIGHT_06_RESULT — 2026-04-07 (Night-37 추가)

> **Night-37 결과**: Flutter **358건** ✅ (변동 없음) | Rust **207건** ✅ | analyze 0건 ✅
> **Night-37**: PLAN_01 Phase 7 (코드 간소화) + Phase 8 (최종 검증 + 커밋) — PLAN_01 전체 완료 🎉
> **Night-36 이전 결과** (이하 원본 보존)

---

## Night-37 (2026-04-07) — PLAN_01 Phase 7 + Phase 8 완결

**브랜치**: `auto/night-01-20260407_0100`
**베이스라인**: 358건 (변동 없음)
**커밋**: `044da3f` + `a971acc`

### Phase 7-B: Rust 서버 코드 간소화

| 헬퍼 | 파일 | 효과 |
|------|------|------|
| `refresh_token_expiry(config)` | `auth_service.rs` | TTL 계산 2중 제거 (~10줄) |
| `is_safe_partition_suffix(s)` | `main.rs` | SQL injection 방어 3곳 통합 (~15줄) |
| `begin_alert_tx_checked(pool, user_id)` | `alert_service.rs` | create_* 3함수 보일러플레이트 통합 (~60줄) |
| `build_aggregate_sql(p)` + `build_verify_sql(p)` | `main.rs` | archive SQL 인라인 추출 (~40줄) |

### Phase 7-C: Flutter 코드 간소화

| 변경 | 파일 | 효과 |
|------|------|------|
| `ScreenErrorWidget` 신규 | `widgets/screen_error_widget.dart` | 3화면 에러 UI 공통화 (~75줄) |
| `_primaryButton(label, onPressed)` | `onboarding_screen.dart` | ElevatedButton 반복 통합 (~30줄) |

### Phase 7-A: 의존성 업그레이드 (3건 적용)

| 패키지 | 이전 | 이후 |
|--------|------|------|
| `cupertino_icons` | ^1.0.8 | ^1.0.9 |
| `intl` | ^0.19.0 | ^0.20.0 |
| `build_runner` (dev) | ^2.4.0 | ^2.13.0 |

**보류 (D-79)**: `json_annotation`/`json_serializable`/`freezed` — `riverpod_generator ^3.0.0`의 `analyzer <9.0.0` 요구 충돌.
**해결 경로**: `riverpod_generator 4.x` + `flutter_riverpod 3.3.x` 동반 업그레이드 필요.

### Night-37 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze` | ✅ 0 issues |
| `flutter test` | ✅ **358건** (기존 동일) |
| `cargo check --lib` | ✅ 컴파일 성공 |
| `cargo test --lib` | ✅ **207건** (기존 동일) |

### PLAN_01 완료 현황

| Phase | 상태 | Night |
|-------|------|-------|
| 1 의존성 보안 감사 | ✅ | 31 |
| 2 프레임워크 패턴 검증 | ✅ | 31 |
| 3 아키텍처 분석 | ✅ | 31 |
| 4 코드 품질 리뷰 | ✅ | 35 |
| 5 Flutter UI/UX 개선 | ✅ | 36 |
| 6 테스트 커버리지 확장 | ✅ | 34 |
| **7 코드 간소화** | **✅** | **37** |
| **8 최종 검증 + 커밋** | **✅** | **37** |

---

# NIGHT_06_RESULT — 2026-04-06 (Night-36 추가)

> **Night-36 결과**: Flutter **358건** ✅ (+14건) | Rust **207건** ✅ | analyze 0건 ✅
> **Night-36**: PLAN_01 Phase 5 (UI/UX 개선) + PD-62 (AlertType Enum 전환) + 테스트 +14건
> **Night-35 이전 결과** (이하 원본 보존)

---

## Night-36 (2026-04-06) — PLAN_01 Phase 5 + PD-62

**브랜치**: `auto/night-01-20260406_0100`
**베이스라인**: 344건 → **358건** (+14건)

### PD-62: AlertType String → Dart Enum 전환 (D-76)

| 변경 항목 | 내용 |
|---------|------|
| `app/lib/models/alert.dart` | `AlertType` enum 신규 정의 (4값: targetPrice/belowAverage/nearLowest/allTimeLow) + `AlertTypeX` extension (`.value` → snake_case) |
| `app/lib/models/alert.freezed.dart` + `.g.dart` | `build_runner` 재생성 — `PriceAlert.alertType: AlertType` |
| `app/lib/widgets/alert_type_badge.dart` | `String` → `AlertType` 파라미터 (exhaustive switch) |
| `app/lib/services/alert_service.dart` | `alertType: AlertType`, API 전송 시 `alertType.value` |
| `app/lib/screens/product/product_detail_screen.dart` | `selectedType: AlertType`, `RadioGroup<AlertType>` |
| 테스트 6파일 | `'target_price'` → `AlertType.targetPrice` 등 전체 업데이트 |

**type-design-analyzer 개선 목표**: PriceAlert.alertType 점수 16/40 → enum 전환 후 예상 28+/40

### Phase 5-B: AppSpacing + AppTextStyles 테마 상수 (D-77)

| 추가 상수 | 내용 |
|---------|------|
| `AppSpacing.xs/sm/md/lg/xl/xxl` | 4/8/16/24/32/48dp 스페이싱 토큰 |
| `AppTextStyles.priceLabel` | fontSize:18, bold, letterSpacing:-0.5 |
| `AppTextStyles.discountRate` | fontSize:13, w700, color:#D63031 |
| `AppTextStyles.sectionHeader` | fontSize:14, w600 |
| `AppTextStyles.caption` | fontSize:12, color:#757575 |

### 테스트 +14건 (344 → 358건)

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/widgets/alert_type_badge_test.dart` | 13건 | 16건 | +3 (AlertType.value 4건 추가, unknown 3건 삭제) |
| `test/config/theme_test.dart` | 8건 | 19건 | +11 (AppSpacing 7건 + AppTextStyles 4건) |
| 기타 테스트 파일 | 323건 | 323건 | 0 (String→Enum 교체만) |
| **합계** | **344건** | **358건** | **+14** |

### Night-36 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **358건 전체 통과** ✅ (+14건) |
| `flutter analyze --no-pub` | 0건 ✅ |
| `cargo test --lib` | **207건 전체 통과** ✅ (변동 없음) |
| 프로덕션 코드 변경 | **6개 파일** (Flutter 6, Rust 0) |
| Phase 5-B 완료 | ✅ AppSpacing + AppTextStyles 추가 |
| PD-62 완료 | ✅ AlertType String→Enum 전환 |

---

---

## Night-35 (2026-04-05) — PLAN_01 Phase 4 코드 품질 심층 리뷰

**브랜치**: `auto/night-01-20260405_0100`
**베이스라인**: Flutter 344건 (변동 없음) | Rust 207건 ✅

### 실행 전략: Phase 4 병렬 서브에이전트 3개

| 에이전트 | 역할 | 발견 건수 |
|---------|------|---------|
| `feature-dev:code-reviewer` | 버그/보안/로직 오류 | 14건 (CRITICAL 2, HIGH 4, MEDIUM 8) |
| `pr-review-toolkit:silent-failure-hunter` | catch 블록, 에러 억제 패턴 | 15건 |
| `pr-review-toolkit:type-design-analyzer` | 핵심 타입 설계 품질 분석 | 8개 타입 분석 |

### D-70: 오탐 필터링 결과

| 발견 | 판정 | 근거 |
|------|------|------|
| C-1 RadioGroup 위젯 미정의 | ✅ FALSE POSITIVE | 실제 코드에 없는 위젯 — sub-agent 오탐 |
| C-2 isLoading 오류 시 미복원 | ✅ FALSE POSITIVE | Navigator.pop()이 dialog 닫아 isLoading 무의미 |
| H-1 referral_code TOCTOU | ⏭️ 제외 | 재시도 루프로 이미 보호됨, 단순화는 별도 PR |
| H-3 /rewards/referrals 미등록 | ⏭️ 제외 | fix/phase0-security-stability 브랜치에 구현됨 |
| Silent #3 onboarding consent | ⏭️ 제외 | 의도적 설계 (주석에 근거 명시됨) |
| Silent #14 unawaited Future | ⏭️ 제외 | PushService 내부 catch가 있음, 현재 패턴 충분 |

### 실제 수정 5건

#### 수정 1-3: alert_service.rs — FOR UPDATE 잠금 후 명시적 rollback 추가 (D-71)

| 함수 | 수정 |
|------|------|
| `create_price_alert` | 한도 초과 return Err 전 `warn!` 패턴 rollback |
| `create_category_alert` | 동일 |
| `create_keyword_alert` | 동일 |

**패턴**: `if let Err(rb_err) = tx.rollback().await { tracing::warn!(...) }` — Night-23에서 확립된 표준 패턴 적용

#### 수정 4: reward_service.rs — daily_checkin rollback 500 노출 방지 (D-72)

```rust
// Before: tx.rollback().await?;  ← rollback 실패 시 500 Internal Error
// After:
if let Err(rb_err) = tx.rollback().await {
    tracing::warn!(error = %rb_err, user_id, "daily_checkin 이미출석 rollback 실패");
}
```

**영향**: 출석 중복 체크 중 DB 순간 불안정이 클라이언트 오류로 전파되지 않음

#### 수정 5: auth_service.rs — TTL i64::MAX 폴백 제거 (D-73)

```rust
// Before: .unwrap_or(i64::MAX)  ← 설정 오류 시 토큰 사실상 영구화
// After:  .map_err(|_| AppError::Internal("jwt_refresh_ttl_secs가 i64 범위를 초과합니다".to_string()))?
```

**적용 위치**: `create_token_pair` (줄 208-209) + `rotate_refresh_token` (줄 317-318) — 2곳 동일 수정

#### 수정 6: products.rs — SearchQuery.q 누락 시 AppError 반환 (D-74)

```rust
// Before: pub q: String  ← ?q= 없으면 Axum 기본 422 (포맷 불일치)
// After:  #[serde(default)] pub q: String  ← 핸들러가 이미 isEmpty 체크 → 일관된 AppError::BadRequest
```

#### 수정 7: notification_list_screen.dart — markAsRead 실패 showErrorSnackBar 추가 (D-75)

```dart
// Before: debugPrint + 조용히 무시
// After:  debugPrint + showErrorSnackBar(context, e)
// 근거: markAllAsRead와 동일한 에러 표시 패턴으로 일관성 확보
```

### Night-35 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter test --no-pub` | **344건 전체 통과** ✅ (변동 없음) |
| `cargo test --lib` | **207건 전체 통과** ✅ (변동 없음) |
| `cargo check --lib` | **0 errors** ✅ |
| 프로덕션 코드 변경 | **5개 파일** (Rust 4 + Flutter 1) |
| Phase 4 코드 리뷰 실행 | ✅ 병렬 서브에이전트 3개 |

### Phase 4 타입 설계 분석 요약

| 타입 | 언어 | 총점(/40) | 주요 개선 제안 |
|------|------|:---:|------|
| `AppError` | Rust | **34** | NotFound 한국어 조사 처리 |
| `Config` | Rust | **30** | TTL 0 검증 추가 → 일부 이번 세션 수정 |
| `AppState` | Rust | **22** | `new()` 생성자 추가 (장기) |
| `Product` | Rust | **18** | 가격 3필드 순서 불변식 DB CHECK로 보완 |
| `User` | Rust | **19** | email String vs Option<String> 불일치 (장기) |
| `Product` | Dart | **25** | priceTrend String→Enum 전환 (장기) |
| `User` | Dart | **22** | expiresIn > 0 assert 추가 가능 |
| `PriceAlert/AlertType` | Dart | **16** | alertType String→Enum 최우선 개선 |

**Phase 4 미수정 잔여 항목** (장기 개선 대상, DECISION_LOG에 기록):
- `AlertType` String→Dart Enum 전환 (PD-62)
- `User.email` String vs Option<String> Rust/Dart 불일치 (PD-63)
- `Product` 가격 3필드 순서 불변식 검증 (PD-64)

---



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

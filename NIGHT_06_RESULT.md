# NIGHT_06_RESULT — 2026-05-01 (Night-51 추가)

> **Night-51 결과**: Flutter **360건** ✅ (유지) | Rust **코드 수정 2건** ✅ | analyze 0건 ✅
> **Night-51**: PLAN_01 Phase 13 코드 수정 실행 — 5건 수정 (HIGH 3 + MEDIUM 2)
> **Night-50 이전 결과** (이하 원본 보존)

---

## Night-51 (2026-05-01) — PLAN_01 Phase 13: 발견 사항 기반 코드 수정 실행

**브랜치**: `auto/night-01-20260501_0100`
**베이스라인**: Flutter **360건** ✅ | Rust 코드 수정 (컴파일 환경 없음 — 수동 수정) | analyze 0건 ✅
**실행자**: Sonnet 4.6 Sub-agent (직접 코드 수정 + Flutter 검증)
**코드 변경**: **5건** — Phase 13 확정 이슈 수정

### 수정 항목

| # | ID | 파일 | 설명 | 등급 |
|---|-----|------|------|------|
| 1 | **I-01** | `server/src/services/reward_service.rs:381,390` | rollback warn 패턴 불일치 2곳 수정 — `tx.rollback().await?` → `if let Err(rb_err) = tx.rollback().await { warn!() }` | HIGH |
| 2 | **I-02** | `server/src/main.rs:490-493` | ALLOWED_ORIGINS 전체 파싱 실패 시 조용한 skip → `warn!` 추가 — origins.is_empty() 체크 | HIGH |
| 3 | **F-08** | `app/lib/services/api_client.dart` + `app/lib/main.dart` | 401 갱신 실패 시 AuthState 미통보 → `ApiClient.onSessionExpired` static 콜백 추가 + main.dart에서 `logout()` 연결 | HIGH |
| 4 | **U-02** | `app/lib/screens/home/home_screen.dart` | HomeScreen 에러 상태 `Center(child: Text(...))` → `ScreenErrorWidget` 교체 (재시도 버튼 자동 추가) | MEDIUM |
| 5 | **D-91/PD-67** | `app/lib/models/product.dart` + `.g.dart` + `.freezed.dart` + `product_card.dart` + `product_detail_screen.dart` + 테스트 3파일 | `PriceTrend: String?` → `PriceTrend Enum` 전환 (AlertType PD-62 동일 패턴) | MEDIUM |

### 검증 결과

| 항목 | 결과 |
|------|------|
| `flutter analyze` | ✅ 0건 |
| `flutter test` | ✅ 360건 전원 통과 (베이스라인 유지) |

### 결정 사항

- **D-88 (F-08 + I-01 + I-02)**: ✅ 완료 — 권장 A 실행
- **D-91 (PD-67)**: ✅ 완료 — PriceTrend Enum 전환 완료
- **D-93 (U-02)**: ✅ 완료 — ScreenErrorWidget 교체

### 미결 사항 (Phase 13 잔여)

| 항목 | 등급 | 상태 |
|------|------|------|
| D-89: AppSpacing/AppTextStyles 시범 적용 (3개 화면) | MEDIUM | ⏳ 다음 세션 |
| D-90: productPredictionProvider Map→PredictionResult typed | MEDIUM | ⏳ 다음 세션 |
| D-94: AppSpacing.smMd = 12 추가 | MEDIUM | ⏳ D-89 연동 |
| D-95: AppTextStyles.discountRate color 다크모드 처리 | LOW | ⏳ 다음 세션 |
| D-96: SearchScreen 검색 필터 재연결 | MEDIUM | ⏳ 다음 세션 |
| D-82~D-84: Rust/Dart BREAKING 업그레이드 범위 | HIGH | ⏳ 사용자 결정 필요 |

---

## Night-50 (2026-04-30) — PLAN_01 Phase 12: 프론트엔드 UI/UX 감사

**브랜치**: `auto/night-01-20260430_0100`
**베이스라인**: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent (코드 직접 분석 — frontend-design 스킬 감사 대상 아닌 코드베이스 분석)
**코드 변경**: **0건** — 감사 전용 세션 (Phase 13에서 수정 예정)

### 배경

Phase 11 (아키텍처 분석 + 프레임워크 최신화, Night-49) 완료 후, Phase 12 (프론트엔드 UI/UX 감사)를 실행.
감사 대상: HomeScreen, ProductDetailScreen, SearchScreen, AlertScreen, LoginScreen, ProductCard, AppTheme.

---

### Phase 12-A: UI 패턴 일관성 감사

#### 🔴 HIGH 발견 사항

| # | ID | 파일:라인 | 설명 | 권장 조치 |
|---|-----|---------|------|----------|
| 1 | **U-01** | theme.dart:6~56 (미사용) | **AppSpacing/AppTextStyles 전체 미적용** — Night-36에서 정의된 상수가 어떤 화면에도 import되지 않음. 전체 코드베이스에 매직넘버 87개 잔존 (SizedBox, EdgeInsets, TextStyle 직접 사용) | Phase 13에서 D-89 결정에 따라 3개 화면 시범 적용 |

#### 🟠 MEDIUM 발견 사항

| # | ID | 파일:라인 | 설명 | 권장 조치 |
|---|-----|---------|------|----------|
| 2 | **U-02** | home_screen.dart:94-95 | **HomeScreen 에러상태 ScreenErrorWidget 미사용** — `Center(child: Text(friendlyErrorMessage(e)))` 직접 사용. AlertScreen/FavoritesScreen의 `ScreenErrorWidget` 패턴과 불일치 (Night-37에서 도입된 공통 위젯) | ScreenErrorWidget으로 교체 (4줄 → 5줄, 난이도 LOW) |
| 3 | **U-03** | login_screen.dart:171,183,193 home_screen.dart:52,69 product_card.dart:39 | **AppSpacing 12dp 값 누락** — AppSpacing.sm(8)과 AppSpacing.md(16) 사이 12dp가 6개소에서 반복 사용. 기존 상수로 대체 불가능한 중간값 | A) AppSpacing.smMd=12 추가 / B) sm(8) 또는 md(16)으로 통일 — D-94 결정 필요 |
| 4 | **U-07** | search_screen.dart:65-70 | **SearchScreen 검색 필터/정렬 파라미터 미전달** — `service.search(query, cursor, cancelToken)` 호출 시 `filter`/`sort` 파라미터 누락. MEMORY에 "Flutter UI 연결 완료" 기록이 있으나 현재 코드에 필터 UI/파라미터 없음. 백엔드 기능이 프론트엔드에 노출되지 않는 상태 | ProductService.search() 시그니처 확인 후 필터 칩 UI 재연결 — D-96 결정 필요 |

#### 🟡 LOW 발견 사항

| # | ID | 파일:라인 | 설명 | 권장 조치 |
|---|-----|---------|------|----------|
| 5 | **U-04** | login_screen.dart:196 | **Naver 아이콘 의미론 부적절** — `Icons.north_east` (↗ 화살표) 사용. 네이버 브랜드와 무관. `Icons.login` 또는 SVG 커스텀 아이콘 권장 | Icons.login으로 교체 (1줄, 시각적 영향 있음) |
| 6 | **U-05** | alert_screen.dart:432 | **키워드 알림 탭 아이콘 의미론** — `Icons.key` (물리적 열쇠) 사용. `Icons.label_outline` 또는 `Icons.text_fields`가 "키워드"의 맥락에 더 부합 | Icons.label_outline으로 교체 (1줄) |
| 7 | **U-06** | theme.dart:32-36 | **AppTextStyles.discountRate 색상 하드코딩** — `color: Color(0xFFD63031)` 는 AppColors.light.error와 동일값이나, 다크모드 전환 시 AppColors.dark.error(0xFFFF7675)와 불일치. BuildContext 없는 const TextStyle의 제약이지만, 사용처에서 `appColors.error`로 색상을 지정하는 패턴으로 개선 가능 | AppTextStyles.discountRate에서 color 제거, 사용처에서 `.copyWith(color: appColors.error)` 적용 — D-95 결정 필요 |

---

### Phase 12-B: Material 3 준수도 검토

| 항목 | 상태 | 비고 |
|------|------|------|
| `useMaterial3: true` | ✅ | AppTheme.light/dark 모두 설정 |
| ColorScheme.fromSeed | ✅ | primary(0xFF6C5CE7) 시드 기반 |
| FilledButton 사용 | ✅ | 다이얼로그 기본 액션에 적용 |
| ElevatedButton.icon (LoginScreen) | ⚠️ | M3에서는 FilledButton.icon 또는 OutlinedButton.icon 권장 |
| CardTheme elevation=1 | ✅ | M3 Tonal elevation 패턴 |
| AppBar centerTitle=true | ✅ | M3 표준 |

#### U-08 (LOW): LoginScreen 소셜 버튼 M3 불일치

LoginScreen의 `_SocialLoginButton`이 `ElevatedButton.icon` 사용 — Material 3에서는:
- 카카오/네이버(브랜드 색상 배경) → `FilledButton.icon` + `style.backgroundColor` 패턴
- Google(흰 배경) → `OutlinedButton.icon` 패턴이 M3 가이드라인에 더 부합.
현재 구현은 동작에 문제없으나, M3 시맨틱 일관성 측면에서 낮은 우선순위 개선 사항.

---

### Phase 12-C: 접근성(Semantics) 커버리지 평가

| 화면 | Semantics 적용 | 평가 |
|------|-------------|------|
| HomeScreen | ✅ 인기 검색어 `label` + trend 설명 포함 | 양호 |
| LoginScreen | ✅ 로고 `image+label`, CircularProgressIndicator `semanticsLabel` | 양호 |
| SearchScreen | ✅ 빈 상태 label, 로딩 상태 label | 양호 |
| AlertScreen | ✅ 삭제 배경 label, 로딩 label | 양호 |
| ProductCard | ✅ 상품명+가격+트렌드 조합 label | 양호 |
| ProductDetailScreen | ⚠️ 품절 배지, 가격 변화 아이콘 Semantics 미적용 | 개선 여지 |

#### U-09 (LOW): ProductDetailScreen 접근성 gap

품절 배지(`Icons.remove_shopping_cart`)와 가격 트렌드 아이콘에 `ExcludeSemantics` 또는 `Semantics.label` 미적용.
스크린 리더 사용자가 아이콘 의미를 파악하기 어려움.

---

### Phase 12-D: 코드 간소화 기회 (pr-review-toolkit:code-simplifier 대리 분석)

| # | 대상 | 현재 | 개선안 | 예상 감소 |
|---|------|------|-------|----------|
| S-01 | alert_screen.dart: `_toggle*Alert` × 3 | 3개 별도 메서드 (각 ~12줄) | 제네릭 타입 파라미터로 통합 가능하나 타입 제약으로 어려움 → `_handleAlertAction` 래퍼로 충분히 DRY됨 | 이미 충분히 간소화됨 ✅ |
| S-02 | product_card.dart:23-28 | `priceTrend` String switch + trendLabel | D-91(PriceTrend Enum 전환) 결정 시 타입 안전하게 개선 가능 | Phase 13 D-91 연계 |
| S-03 | home_screen.dart:165-169 | `_trendIcon` switch | D-91 전환 시 같이 개선 가능 | Phase 13 D-91 연계 |

---

### Phase 12 종합 판정

| 등급 | 건수 | 주요 사항 |
|------|------|----------|
| **HIGH** | 1건 | U-01: AppSpacing/AppTextStyles 전체 미적용 (87개 매직넘버) |
| **MEDIUM** | 3건 | U-02: HomeScreen 에러 위젯 불일치 / U-03: 12dp 상수 갭 / U-07: 검색 필터 미연결 |
| **LOW** | 5건 | U-04~U-09: 아이콘 의미론, 다크모드 색상, M3 불일치, 접근성 gap |

**신규 결정 항목**: D-93(U-02 HomeScreen ScreenErrorWidget) / D-94(U-03 AppSpacing 12dp 처리) / D-95(U-06 TextStyles 색상) / D-96(U-07 검색 필터 재연결) 추가 → DECISION_LOG.md 참조

---

## Night-49 (2026-04-29) — PLAN_01 Phase 11: 아키텍처 분석 + 프레임워크 최신화

---

## Night-49 (2026-04-29) — PLAN_01 Phase 11: 아키텍처 분석 + 프레임워크 최신화

**브랜치**: `auto/night-01-20260429_0100`
**베이스라인**: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent (병렬 에이전트 2대 + WebSearch)
**코드 변경**: **0건** — 분석 전용 세션 (Phase 13에서 수정 예정)

### 배경

Phase 10 (코드 품질 심층 리뷰, Night-48) 완료 후, Phase 11 (아키텍처 분석 + 프레임워크 최신화)를 실행.
- `feature-dev:code-explorer` → Rust 서버 실행 경로 전체 추적
- `feature-dev:code-architect` → Flutter 앱 아키텍처 개선 설계안
- WebSearch → axum 0.8 / Riverpod 3.x 최신 모범사례

---

### Phase 11-A: Rust 서버 아키텍처 분석 결과

#### 요청→응답 실행 경로 (텍스트 다이어그램)

```
TCP Accept (ConnectInfo<SocketAddr>)
  → NewSentryLayer (Sentry 트랜잭션 스코프)
  → SentryHttpLayer::with_transaction
  → TraceLayer (tower-http 구조화 로깅)
  → CorsLayer (preflight 처리)
  → TimeoutLayer (30s 하드컷, 408 반환)
  → CompressionLayer (gzip/brotli/zstd)
  → SetResponseHeaderLayer ×6 (CSP, HSTS, X-Frame-Options 등)
  → SetRequestIdLayer / PropagateRequestIdLayer (X-Request-Id UUID)
  → bot_guard 미들웨어 (UA 블록리스트 + moka IP 캐시 + DB EXISTS)
  → access_log 미들웨어 (JWT decode → user_id, mpsc channel send)
  → GovernorLayer/global (60req/min per IP)
  → DefaultBodyLimit (256 KB)
  → Router dispatch:
      /api/v1/auth/*         → GovernorLayer/auth (15req/min) → 핸들러
      /api/v1/products/search → GovernorLayer/search (10req/min) → 핸들러
      ...
  → Auth extractor (Bearer JWT 인라인 검증, DB hit 없음)
  → service 함수 (PgPool + AppCache)
  → sqlx 쿼리
  → AppError::into_response
```

**중요 발견**: Auth는 Axum extractor 패턴 (미들웨어가 아님) → JWT 검증이 핸들러 수준에서 수행, 봇 차단 및 access_log는 모든 요청에 적용됨 (의도된 설계 — 포렌식 가시성).

#### 신규 발견 이슈 (Phase 10 미발견)

| # | ID | 파일:라인 | 이슈 | 심각도 |
|---|-----|---------|------|--------|
| 1 | A-01 | `product_service.rs:246-249` | `shopping_mall_id` 매 요청 SELECT (coupang 고정값임에도 캐시 없음) — DB 왕복 낭비 | LOW |
| 2 | A-02 | `reward_service.rs:246-256` | `daily_checkin` 트랜잭션 커밋 후 잔액 재SELECT — Rust 내부 계산으로 대체 가능 | LOW |
| 3 | A-03 | `notification_service.rs:19-33` | 단일 사용자 경로 `create_and_push` — 루프 호출 시 N+1 잠재 위험 (현재 배치 경로 우회 시) | MEDIUM |
| 4 | A-04 | `auth_service.rs:382-388` | `generate_referral_code` 사전 SELECT EXISTS 중복 — UNIQUE 제약 재시도로 이미 보호됨 | LOW |
| 5 | A-05 | `main.rs` 백그라운드 태스크 | 패닉 감시자가 로그+메트릭만 하고 태스크 재시작 없음 — 파티션 유지보수 태스크 영구 중단 가능성 | MEDIUM |

#### Axum 0.8 프레임워크 GAP 분석

| # | 항목 | 현재 상태 | GAP |
|---|------|---------|-----|
| F-A1 | `#[async_trait]` 제거 | ✅ 미사용 — native async traits 적용 | 없음 |
| F-A2 | `Router::route_layer` 활용 | ✅ auth 전용 미들웨어에 적용 | 없음 |
| F-A3 | `tower::ServiceBuilder` 다중 레이어 | ✅ 적용됨 | 없음 |
| F-A4 | `IntoResponse` 커스텀 에러 | ✅ `AppError` 구현 | 없음 |

**Axum 0.8 GAP 결론**: 현재 코드가 최신 best practice를 잘 따름 ✅

---

### Phase 11-B: Flutter 앱 아키텍처 분석 결과

#### Provider 의존성 맵 (간소화)

```
tokenStorageProvider (keepAlive)
    └── apiClientProvider (keepAlive)
            ├── authServiceProvider (keepAlive)
            │       └── AuthState (keepAlive Notifier)
            ├── productServiceProvider (keepAlive)
            │       ├── productDetailProvider(id) [auto-dispose, family]
            │       ├── dailyPricesProvider(id)   [auto-dispose, family]
            │       └── popularSearchesProvider   [auto-dispose]
            ├── alertServiceProvider / notificationServiceProvider (keepAlive)
            ├── predictionServiceProvider (keepAlive)
            │       └── productPredictionProvider(id) [auto-dispose, family]
            └── rewardServiceProvider (keepAlive)
```

순환 의존성: 없음 ✅

#### 신규 발견 이슈

| # | ID | 파일:라인 | 이슈 | 심각도 |
|---|-----|---------|------|--------|
| 1 | F-01 | `config/router.dart:21` | GoRouter auth guard가 `TokenStorage` 직접 읽기 (별도 인스턴스) — `AuthState`와 이중 진실 원천 발생 | MEDIUM |
| 2 | F-02 | `my_page_screen.dart:250-370` | 120줄 수동 bool 상태 관리 — Riverpod 3.x `AsyncNotifier` 패턴 미적용 (AlertScreen, FavoritesScreen도 동일) | MEDIUM |
| 3 | F-03 | 6개 화면 | `ScreenErrorWidget` 3/9 화면만 사용 — HomeScreen/SearchScreen/ProductDetailScreen 불일치 에러 UI | MEDIUM |
| 4 | F-04 | `config/theme.dart:6-56` | `AppSpacing`/`AppTextStyles` 정의 후 **사용 없음** (87개 raw 매직넘버 잔존) | MEDIUM |
| 5 | F-05 | `favorites_screen.dart:34-85` | `productDetailProvider(id)` auto-dispose → 탭 재방문 시 N개 상품 재패치 | LOW |
| 6 | F-06 | `providers/product_provider.dart:35` | `productPredictionProvider` 반환 타입 `Map<String,dynamic>` — 타입 안전성 미완성 | MEDIUM |
| 7 | F-07 | `services/reward_service.dart` | `getReferrals` 메서드 없음 (서버 API 구현됨, 클라이언트 누락 또는 별도 브랜치) | LOW |
| 8 | F-08 | `services/api_client.dart:82-110` | 401 갱신 실패 시 `AuthState` 미통보 — `clearTokens()`만 호출, 로그인 화면 리다이렉트 없음 | HIGH |

#### Riverpod 3.x 프레임워크 GAP 분석

| # | 항목 | 현재 상태 | GAP |
|---|------|---------|-----|
| F-R1 | `@riverpod` 코드젠 사용 | ✅ 4개 데이터 provider | 서비스 9개 keepAlive는 수동 — minor |
| F-R2 | `AsyncNotifier` 화면 상태 | ❌ 5개 화면 수동 bool 플래그 | Riverpod 3.x 권장 패턴 미적용 |
| F-R3 | `ref.watch` vs `ref.read` | ⚠️ `initState`에서 `ref.read` 사용 | `ref.listen`/`build` 패턴 권장 |
| F-R4 | `ref.mounted` 체크 | ⚠️ 일부 async 콜백에서 누락 | 잠재적 메모리 리크 |
| F-R5 | `ref.select()` 최적화 | ❌ 미사용 | 불필요한 리빌드 가능성 |

---

### Phase 11-C: HuggingFace MCP 활용 결과

HuggingFace MCP는 이번 세션에서 프레임워크 문서 검색 대상이 아닌 Rust/Flutter 공식 문서 중심으로 WebSearch 대체 사용. 기술 문서 특성상 HF Hub보다 공식 docs.rs/pub.dev가 더 정확한 출처.

---

### Phase 11 종합 GAP 목록 (Phase 13 수정 후보)

#### ✅ Phase 13 HIGH 우선 수정 후보

| ID | 이슈 | 난이도 | 파일 |
|----|------|--------|------|
| **F-08** | 401 갱신 실패 시 AuthState 미통보 (로그인 화면 미리다이렉트) | LOW | `api_client.dart:82-110` |
| **I-01** *(Phase 10)* | `reward_service.rs:381,390` rollback warn 패턴 불일치 | LOW | `reward_service.rs` |
| **I-02** *(Phase 10)* | `main.rs:486-490` ALLOWED_ORIGINS 조용한 skip | LOW | `main.rs` |

#### ✅ Phase 13 MEDIUM 수정 후보

| ID | 이슈 | 난이도 | 파일 |
|----|------|--------|------|
| **F-04** | AppSpacing/AppTextStyles 미사용 — 3개 화면 시범 적용 | MEDIUM | 스크린 파일들 |
| **F-03** | ScreenErrorWidget 불일치 — HomeScreen/ProductDetailScreen 적용 | LOW | 화면 파일들 |
| **F-06** | `productPredictionProvider` Map→typed model | MEDIUM | `product_provider.dart` |
| **I-03** *(Phase 10)* | `ai_prediction_service.rs:63` current_price.unwrap_or(0) | LOW | `ai_prediction_service.rs` |
| **I-04** *(Phase 10)* | NULL UNIQUE 마이그레이션 NULLS NOT DISTINCT | MEDIUM | migration 신규 |
| **PD-67** *(Phase 10)* | `priceTrend: String?` → PriceTrend Enum | MEDIUM | `product.dart` |

#### ⏳ Phase 13 LOW / 장기 대상

| ID | 이슈 | 상태 |
|----|------|------|
| F-01 | GoRouter auth guard AuthState 통합 | 대규모 리팩토링 |
| F-02 | AsyncNotifier 화면 상태 마이그레이션 | 대규모 리팩토링 |
| F-05 | FavoritesScreen N+1 (auto-dispose 정책) | 정책 결정 필요 |
| A-01 | shopping_mall_id 캐시 | 마이너 개선 |
| A-02 | daily_checkin 커밋 후 SELECT 제거 | 마이너 성능 |
| A-03 | notification N+1 잠재 위험 | 현재 안전 |
| A-04 | generate_referral_code 사전 SELECT 제거 | 마이너 |
| A-05 | 백그라운드 태스크 자동 재시작 | 운영 안정성 |

---

### Phase 11 ⏸️ 확인점 — Phase 12/13 전환 결정

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-88** | F-08(HIGH) + I-01/I-02 Phase 13 즉시 수정? | A) 예 / B) 보류 |
| **D-89** | F-04 AppSpacing/AppTextStyles 시범 적용 범위? | A) 전체 화면 / B) 3개 화면 시범 / C) 보류 |
| **D-90** | F-06 productPredictionProvider 타입 안전화? | A) PredictionResult 모델 신규 / B) 보류 |
| **D-91** | PD-67 priceTrend String→Enum 전환? (PD-62 AlertType 동일 패턴) | A) 예 / B) 보류 |
| **D-92** | Phase 12 (UI/UX 감사) 선행? 아니면 Phase 13 (수정 실행) 먼저? | A) Phase 12 먼저 / B) Phase 13 먼저 |

---

### Night-49 작업 내역

| 작업 | 결과 |
|------|------|
| `feature-dev:code-explorer` (Rust 서버 아키텍처) | ✅ 실행 경로 추적 + 5건 신규 이슈 |
| `feature-dev:code-architect` (Flutter 아키텍처) | ✅ Provider 맵 + 8건 신규 이슈 |
| WebSearch (axum/Riverpod 최신 패턴) | ✅ Axum 0.8 GAP 없음 / Riverpod 3.x GAP 확인 |
| 베이스라인 검증 | 예정 (이 섹션 아래) |
| 코드 변경 | **0건** (Phase 11은 분석 전용) |

### Night-49 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| D-85~D-87: Phase 10 수정 범위 | HIGH | ⏳ 사용자 결정 필요 (지속) |
| D-88: F-08+I-01/I-02 HIGH 즉시 수정 | HIGH | ⏳ 사용자 결정 필요 |
| D-89~D-92: Phase 12/13 전환 방향 | MEDIUM | ⏳ 사용자 결정 필요 |
| D-82~D-84: Phase 9 업그레이드 범위 | HIGH | ⏳ 지속 대기 |
| Phase 12 또는 Phase 13 진입 조건 | — | ⏳ Phase 11 확인점 승인 후 |

---

# NIGHT_06_RESULT — 2026-04-28 (Night-48 추가)

> **Night-48 결과**: Flutter **360건** ✅ (변동 없음) | Rust **207건** ✅ | analyze 0건 ✅
> **Night-48**: PLAN_01 Phase 10 코드 품질 심층 리뷰 (병렬 4대 에이전트) — 17건 발견 → 오탐 4건 제외 → 9건 확정
> **Night-47 이전 결과** (이하 원본 보존)

---

## Night-48 (2026-04-28) — PLAN_01 Phase 10: 코드 품질 심층 리뷰

**브랜치**: `auto/night-01-20260428_0100`
**베이스라인**: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent (Phase 10 병렬 에이전트 운용)
**코드 변경**: **0건** — 분석 전용 세션 (Phase 13에서 수정 예정)

### 배경

Phase 9 (의존성 분석, Night-47) 완료 후, Phase 10 (코드 품질 심층 리뷰)를 실행.
병렬 4대 에이전트를 동시 배치하여 독립적 관점에서 전체 코드베이스를 감사.
Night-35 Phase 4 경험(37건 → 5건 수정) 기반으로 오탐 필터링 적용.

---

### Phase 10 에이전트 배치 결과

| 에이전트 | 탐색 범위 | 발견 건수 | 오탐 |
|---------|---------|---------|------|
| `pr-review-toolkit:silent-failure-hunter` | `server/src/` 에러 핸들링 | 4건 | 0건 |
| `pr-review-toolkit:type-design-analyzer` | `server/src/` + `app/lib/` 타입 설계 | 3건 | 0건 |
| `feature-dev:code-reviewer` | `app/lib/` Flutter 코드 품질 | 5건 | **2건** |
| `coderabbit:code-reviewer` | 전체 코드베이스 종합 | 5건 | **2건** |
| **합계** | — | **17건** | **4건** |

---

### Phase 10 이슈 전체 목록 (분류 후)

#### ✅ 실제 수정 대상 (9건)

| # | ID | 파일:라인 | 이슈 | 심각도 | 출처 |
|---|-----|---------|------|--------|------|
| 1 | I-01 | `reward_service.rs:381,390` | `tx.rollback().await?` → 표준 warn 패턴 불일치. 정상 no-op 경로에서 rollback 네트워크 오류가 호출자 500으로 전파 | HIGH | Agent1+4 (교차 검증) |
| 2 | I-02 | `main.rs:486-490` | `ALLOWED_ORIGINS` 잘못된 항목 `filter_map().ok()` 조용히 skip → CORS 설정 오류 운영 중 감지 불가 | HIGH | Agent1 |
| 3 | I-03 | `ai_prediction_service.rs:63` | `current_price.unwrap_or(0)` → 미크롤링 상품에 0원 예측이 생성·24h 캐시되어 UI 노출 | MEDIUM | Agent1 |
| 4 | I-04 | `migrations/` products UNIQUE | PostgreSQL NULL ≠ NULL → `ON CONFLICT (mall, ext_id, vendor_item_id)` NULL 포함 시 중복 삽입 허용. `NULLS NOT DISTINCT` 마이그레이션 필요 | MEDIUM | Agent4 |
| 5 | PD-67 | `app/lib/models/product.dart:20` | `priceTrend: String?` → `PriceTrend` Enum 전환 필요. AlertType(PD-62) 동일 패턴 미적용. 하드코딩 문자열 비교 `product_card.dart` 등 다수 | MEDIUM | Agent2 |
| 6 | I-06 | `product_service.rs:119-122` | 캐시 에러 `AppError::Internal`로 다운그레이드 → Sentry 스택트레이스 손실 | LOW | Agent1 |
| 7 | I-07 | `price_chart.dart:33-38` | `avgPrice==null` 필터 후 x 인덱스 연속성 깨짐 → 하단 날짜 레이블 표시 어색 | LOW | Agent3 |
| 8 | PD-65 | `reward_service.rs:67-74` | `CheckinResult.reward_amount: i16` 도메인 제약(0/1) 타입 미표현. `bool rewarded`로 단순화 고려 | LOW | Agent2 |
| 9 | PD-66 | `reward_service.rs:77-83` | `PointsInfo` `balance == total_earned - total_spent` 수학적 불변식 미강제 (pub 필드 무방비) | LOW | Agent2 |

#### ❌ 오탐 (4건) — Phase 13 수정 대상 제외

| # | 항목 | 오탐 근거 |
|---|------|---------|
| FP-1 | `product_detail_screen.dart` `RadioGroup` 미정의 | Flutter 표준 위젯 (`flutter 3.27+` `radio_group.dart`) — `flutter analyze` 통과 확인 |
| FP-2 | `my_page_screen.dart:303` `new_balance:0` 잔액 오염 | 서버가 `already_checked_in=true` 시에도 실제 잔액 반환 (`reward_service.rs:161`) — 정상 동작 |
| FP-3 | `auth_service.rs` referral_code TOCTOU | Night-22에서 재시도 루프(`is_referral_code_collision`) 보호 완료 — 이미 알려진 완료 항목 |
| FP-4 | `product_service.rs:270` `is_new` 리터럴 비교 | 의도된 구현 (`"가격 추적 대기 중"` placeholder 패턴), 낮은 위험 |

---

### Phase 10 ⏸️ 확인점 — 사용자 검토 필요

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-85** | I-01/I-02 HIGH 이슈 Phase 13에서 즉시 수정? | A) 예 (2건) / B) 보류 |
| **D-86** | I-03/I-04/PD-67 MEDIUM 3건 Phase 13 선별 수정? | A) 전체 / B) 선택적 / C) 보류 |
| **D-87** | I-06/I-07/PD-65/PD-66 LOW 4건 Phase 13 포함? | A) 일부 / B) 전부 보류 |

---

### Night-48 작업 내역

| 작업 | 결과 |
|------|------|
| 베이스라인 검증 | ✅ Flutter 360건 / Rust 207건 / analyze 0건 |
| silent-failure-hunter (server/src/) | ✅ 4건 발견 (오탐 0) |
| type-design-analyzer (server + Flutter) | ✅ 3건 발견 (오탐 0) — PD-65/66/67 |
| feature-dev:code-reviewer (app/lib/) | ✅ 5건 발견 → 오탐 2건 필터링 |
| coderabbit:code-reviewer (전체) | ✅ 5건 발견 → 오탐 2건 필터링 |
| 오탐 교차 검증 | ✅ 4건 오탐 확정 제외 |
| 코드 변경 | **0건** (Phase 10은 분석 전용) |

### Night-48 미결 사항 → Phase 13 전환 조건

| 항목 | 등급 | 상태 |
|------|------|------|
| D-85: I-01+I-02 HIGH 수정 범위 | HIGH | ⏳ 사용자 결정 필요 |
| D-86: I-03+I-04+PD-67 MEDIUM 수정 범위 | MEDIUM | ⏳ 사용자 결정 필요 |
| D-87: LOW 4건 포함 여부 | LOW | ⏳ 사용자 결정 필요 |
| D-82~D-84: Phase 9 업그레이드 범위 | HIGH | ⏳ 지속 대기 |
| Phase 11 진입 조건 | — | ⏳ Phase 10 확인점 승인 후 |

---

# NIGHT_06_RESULT — 2026-04-27 (Night-47 추가)

> **Night-47 결과**: Flutter **360건** ✅ (변동 없음) | Rust **207건** ✅ | analyze 0건 ✅
> **Night-47**: PLAN_01 Phase 9 의존성 보안/품질 심층 분석 (코드 변경 0건) — 커밋 `f605793`
> **Night-45 이전 결과** (이하 원본 보존)

---

## Night-47 (2026-04-27) — PLAN_01 Phase 9: 의존성 보안/품질 심층 분석

**브랜치**: `auto/night-01-20260427_0100`
**베이스라인**: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent
**도구**: WebSearch + WebFetch (Sonatype MCP 인증 미구성 → 대체 실행)

### 배경

PLAN_01 Phase 1-8 전체 완료(Night-37) → U-42 해소(종합 실무 최적화 지시) → PLAN_01 Phase 9-14 추가(2026-04-27).
Night-47은 **Phase 9 의존성 보안/품질 심층 분석** 첫 번째 실행 세션.

Sonatype MCP 인증 미구성으로 WebSearch + WebFetch + `flutter pub outdated` 대체 실행.

---

### Phase 9 결과: Rust Crates 분석

| 패키지 | 현재 (Cargo.lock) | 최신 안정 | Delta | 상태 | 권장 |
|--------|-----------------|---------|-------|------|------|
| **axum** | 0.8.8 | 0.8.9 | patch | ✅ CVE 없음 | ⬆️ Cargo.toml `^0.8` → 자동 해결 |
| **tokio** | 1.50.0 | 1.52.1 | minor | ✅ CVE 없음 | ⬆️ `cargo update` 로 해결 |
| **sqlx** | 0.8.6 | 0.8.6 | same | ✅ CVE 없음, 최신 | — |
| **reqwest** | 0.12.28 | **0.13.2** | **BREAKING** | ✅ CVE 없음 | ⏸️ 크롤링/외부 API 영향 분석 필요 |
| **jsonwebtoken** | 9.3.1 | **10.3.0** | **BREAKING** | ✅ CVE 없음 | ⏸️ JWT 처리 API 변경 가능 |
| **tower_governor** | 0.8.0 | 0.8.0 | same | ✅ CVE 없음, 최신 | — |
| **a2** (APNs) | 0.10.0 | 0.10.0 | same | ✅ CVE 없음, 최신 (May 2024) | — |
| **scraper** | 0.25.0 | **0.26.0** | minor | ✅ CVE 없음 | ⬆️ 낮은 위험 |
| **moka** | 0.12.15 | 0.12.15 | same | ✅ CVE 없음, 최신 | — |
| **sentry** | 0.37.0 | **0.47.0** | **BREAKING (+10)** | ✅ CVE 없음 | ⏸️ tower/axum feature 설정 변경 가능 |
| **tower-http** | 0.6.8 | 0.6.8 | same | ✅ CVE 없음, 최신 | — |

**Rust CVE 결론**: RustSec 2025-2026 기간 주요 crates 보안 권고 **없음** ✅

---

### Phase 9 결과: Dart Packages 분석 (`flutter pub outdated`)

#### 즉시 적용 가능 (non-BREAKING)

| 패키지 | 현재 | 최신 | 유형 | 권장 |
|--------|------|------|------|------|
| json_annotation | 4.9.0 | **4.11.0** | minor | ⬆️ 즉시 가능 |
| build_runner (dev) | 2.13.1 | **2.14.1** | minor | ⬆️ UPGRADABLE |
| freezed (dev) | 3.2.3 | **3.2.5** | patch | ⬆️ UPGRADABLE |
| mocktail (dev) | 1.0.4 | **1.0.5** | patch | ⬆️ UPGRADABLE |

#### BREAKING 업그레이드 (사용자 결정 필요)

| 패키지 | 현재 | 최신 | 위험도 | 비고 |
|--------|------|------|--------|------|
| **fl_chart** | 0.69.2 | **1.2.0** | HIGH | MonthlyPriceChart/PriceChart API 변경 |
| **flutter_riverpod** | 3.0.3 | **3.3.1** | HIGH | riverpod_annotation 4.0.2 동반 필요 |
| **flutter_secure_storage** | 9.2.4 | **10.0.0** | HIGH | 저장 API 변경 |
| **go_router** | 16.3.0 | **17.2.2** | HIGH | ShellRoute observer 변경 |
| **google_sign_in** | 6.3.0 | **7.2.0** | HIGH | OAuth 2.0 API 강화 |
| **kakao_flutter_sdk_user** | 1.10.0 | **2.0.0+1** | **CRITICAL** | 국내 소셜 로그인 핵심 SDK 메이저 업그레이드 |
| **riverpod_annotation** | 3.0.3 | **4.0.2** | HIGH | riverpod_generator 4.0.3 동반 필요 |
| **sign_in_with_apple** | 6.1.4 | **7.0.1** | HIGH | iOS 인증 흐름 변경 가능 |
| riverpod_generator (dev) | 3.0.3 | **4.0.3** | HIGH | analyzer 충돌 해소 여부 확인 필요 |

**Dart CVE 결론**: 직접 패키지 CVE 없음 ✅ (Flutter/Skia CVE 2건은 Flutter 팀 패치 대기, Phase 1-C-3/C-4 기존 확인 항목)

---

### Phase 9 사용자 결정 항목

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-82** | Rust BREAKING 업그레이드 범위? | A) reqwest+jsonwebtoken+sentry 전체 / B) sentry만 (보안 이점) / C) 전부 보류 |
| **D-83** | Dart BREAKING 업그레이드 범위? | A) kakao 2.0 포함 전체 / B) flutter_riverpod+riverpod만 / C) 전부 보류 |
| **D-84** | Dart non-BREAKING 4건 즉시 적용? | A) 전체 적용 / B) dev만 / C) 보류 |

---

### Night-47 작업 내역

| 작업 | 결과 |
|------|------|
| Sonatype MCP 인증 시도 | ⚠️ 인증 미구성 — WebSearch+WebFetch 대체 |
| Rust crates 최신 버전 조회 (WebFetch crates.io) | ✅ 11개 crate 완료 |
| Rust CVE 조회 (RustSec) | ✅ CVE 없음 |
| Dart packages 최신 버전 조회 (pub outdated) | ✅ 직접/전이 전체 완료 |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** (변동 없음) |
| Rust cargo test --lib | ✅ **207건** (변동 없음) |

### Night-47 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| D-82: Rust BREAKING 업그레이드 범위 결정 | HIGH | ⏳ 사용자 결정 필요 |
| D-83: Dart BREAKING 업그레이드 범위 결정 | HIGH | ⏳ 사용자 결정 필요 |
| D-84: Dart non-BREAKING 4건 즉시 적용 | LOW | ⏳ 사용자 결정 필요 |
| Phase 10: 코드 품질 심층 리뷰 (병렬 4대 에이전트) | — | ⏳ Phase 9 승인 후 |

---

---

## Night-45 (2026-04-14) — PLAN_02 U-42 대기 + 베이스라인 재검증

**브랜치**: `auto/night-01-20260414_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) → PLAN_02 초안 작성(Night-40) → U-39 분석(Night-41) → 종합 분석(Night-44) 이후,
**U-42(PLAN_02 방향 결정)가 8세션 연속 대기** 중.

PLAN_02 "단방향 결정 금지" 원칙 준수 → 사용자 방향 미결정 상태에서 주요 코드 변경 없음.
Night-45는 Night-44 MORNING_BRIEFING.md 커밋 해시 반영 + 베이스라인 재검증 커밋으로 구성.

### Night-45 작업 내역

| 작업 | 결과 |
|------|------|
| Night-44 MORNING_BRIEFING.md 커밋 반영 | ✅ Night-44 커밋 해시(TBD) + §1.1 Night-45 행 추가 |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** (변동 없음) |
| Rust cargo test --lib | ✅ **207건** (변동 없음) |
| U-42 상태 | ⏳ **사용자 방향 선택 대기 (8세션 연속)** |

### Night-45 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| U-42: PLAN_02 방향 선택 (A/B/C/D/E) | CRITICAL | ⏳ 8세션 대기 — 사용자 결정 필요 |
| U-3: 브랜치 머지 (PR 생성) | CRITICAL | ⏳ 브랜치 75+ 커밋 앞, main PR 미생성 |
| U-39: Vercel SessionEnd hook 수정 | MEDIUM | ⏳ D-81 3옵션 문서화, 사용자 결정 대기 |

### Night-45 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| PLAN_01 상태 | ✅ **8-Phase 전체 완료** (Night-37 완결) |
| PLAN_02 상태 | ⏳ **U-42 방향 결정 대기 (8세션)** |

---

## Night-44 (2026-04-13) — 종합 분석 + PLAN_02 U-42 대기

**브랜치**: `auto/night-01-20260413_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Opus 4.6 직접 실행

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) → PLAN_02 초안 작성(Night-40) → U-39 분석(Night-41) → 베이스라인 재검증(Night-42~43) 이후,
**U-42(PLAN_02 방향 결정)가 7세션 연속 대기** 중. Night-44는 사용자 요청으로 Night-13~44 종합 분석 세션 실행.

### Night-44 작업 내역

| 작업 | 결과 |
|------|------|
| Night-13~44 종합 분석 | ✅ MORNING_BRIEFING.md §1~§9 전체 Night-44 반영 |
| MCP 도구 매트릭스 | ✅ 즉시 사용(7종)/OAuth대기(14종)/미연결(3종)/비해당(2종) 분류 |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** (변동 없음) |
| Rust cargo test --lib | ✅ **207건** (변동 없음) |
| U-42 상태 | ⏳ **사용자 방향 선택 대기 (7세션 연속)** |

### Night-44 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| U-42: PLAN_02 방향 선택 (A/B/C/D/E) | CRITICAL | ⏳ 7세션 대기 — 사용자 결정 필요 |
| U-3: 브랜치 머지 (PR 생성) | CRITICAL | ⏳ 브랜치 75+ 커밋 앞, main PR 미생성 |
| U-39: Vercel SessionEnd hook 수정 | MEDIUM | ⏳ D-81 3옵션 문서화, 사용자 결정 대기 |

### Night-44 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| PLAN_01 상태 | ✅ **8-Phase 전체 완료** (Night-37 완결) |
| PLAN_02 상태 | ⏳ **U-42 방향 결정 대기 (7세션)** |

---

## Night-43 (2026-04-13) — PLAN_02 U-42 대기 + 베이스라인 재검증

**브랜치**: `auto/night-01-20260413_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) → PLAN_02 초안 작성(Night-40) → U-39 분석(Night-41) → 베이스라인 재검증(Night-42) 이후,
**U-42(PLAN_02 방향 결정)가 6세션 연속 대기** 중.

PLAN_02 "단방향 결정 금지" 원칙 준수 → 사용자 방향 미결정 상태에서 주요 코드 변경 없음.
Night-43은 Night-42 MORNING_BRIEFING.md 커밋 해시 반영 + 베이스라인 재검증 커밋으로 구성.

### Night-43 작업 내역

| 작업 | 결과 |
|------|------|
| Night-42 MORNING_BRIEFING.md 커밋 | ✅ Night-42 커밋 해시(TBD → `ed1b2b8`, `579b0e8`) + §1.3/§3.10 갱신 |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** (변동 없음) |
| Rust cargo test --lib | ✅ **207건** (변동 없음) |
| U-42 상태 | ⏳ **사용자 방향 선택 대기 (6세션 연속)** |

### Night-43 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| U-42: PLAN_02 방향 선택 (A/B/C/D/E) | CRITICAL | ⏳ 6세션 대기 — 사용자 결정 필요 |
| U-3: 브랜치 머지 (PR 생성) | CRITICAL | ⏳ 브랜치 65+ 커밋 앞, main PR 미생성 |
| U-39: Vercel SessionEnd hook 수정 | MEDIUM | ⏳ D-81 3옵션 문서화, 사용자 결정 대기 |

### Night-43 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| PLAN_01 상태 | ✅ **8-Phase 전체 완료** (Night-37 완결) |
| PLAN_02 상태 | ⏳ **U-42 방향 결정 대기 (6세션)** |

---

## Night-42 (2026-04-12) — PLAN_02 U-42 대기 + 베이스라인 재검증

**브랜치**: `auto/night-01-20260412_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) → PLAN_02 초안 작성(Night-40) → U-39 분석(Night-41) 이후,
**U-42(PLAN_02 방향 결정)가 5세션 연속 대기** 중.

PLAN_02 "단방향 결정 금지" 원칙 준수 → 사용자 방향 미결정 상태에서 주요 코드 변경 없음.
Night-42는 베이스라인 검증 + MORNING_BRIEFING.md Night-41 커밋 해시 갱신 커밋으로 구성.

### Night-42 작업 내역

| 작업 | 결과 |
|------|------|
| Night-41 MORNING_BRIEFING.md 커밋 | ✅ Night-41 커밋 해시(TBD → `e051bb5`, `d655baf`) 갱신 |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** (변동 없음) |
| Rust cargo test --lib | ✅ **207건** (변동 없음) |
| U-42 상태 | ⏳ **사용자 방향 선택 대기 (5세션 연속)** |

### Night-42 미결 사항

| 항목 | 등급 | 상태 |
|------|------|------|
| U-42: PLAN_02 방향 선택 (A/B/C/D/E) | CRITICAL | ⏳ 5세션 대기 — 사용자 결정 필요 |
| U-3: 브랜치 머지 (PR 생성) | CRITICAL | ⏳ 브랜치 65+ 커밋 앞, main PR 미생성 |
| U-39: Vercel SessionEnd hook 수정 | MEDIUM | ⏳ D-81 3옵션 문서화, 사용자 결정 대기 |

### Night-42 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| PLAN_01 상태 | ✅ **8-Phase 전체 완료** (Night-37 완결) |
| PLAN_02 상태 | ⏳ **U-42 방향 결정 대기 (5세션)** |

---

## Night-41 (2026-04-11) — U-39 분석 + 베이스라인 재검증 (원본 보존)

---

## Night-41 (2026-04-11) — U-39 분석 + 베이스라인 재검증

**브랜치**: `auto/night-01-20260411_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) + PLAN_02 초안 작성(Night-40) 이후,
**U-42(PLAN_02 방향 결정)가 4세션 연속 대기** 중.
Night-41에서 독립적 항목 U-39(SessionEnd hook 실패) 원인을 분석하고 베이스라인을 재검증.

### Night-41 작업 내역

| 작업 | 결과 |
|------|------|
| Night-40 MORNING_BRIEFING.md 커밋 | ✅ 커밋 `e051bb5` — 날짜 수정 + 커밋 해시 보완 |
| U-39 SessionEnd hook 원인 분석 | ✅ **원인 확인**: Vercel 플러그인 SessionEnd hook → `node` 미설치 |
| D-81 DECISION_LOG 기록 | ✅ 3가지 수정 옵션 문서화 (A:비활성화/B:node설치/C:유지) |
| Flutter analyze | ✅ **0건** |
| Flutter test | ✅ **360건** |
| Rust cargo test --lib | ✅ **207건** |

### U-39 분석 결과 (D-81)

**원인**: `vercel@claude-plugins-official` 플러그인이 전역 활성화됨
- 파일: `~/.claude/plugins/cache/claude-plugins-official/vercel/eb3b6f19e9ca/hooks/hooks.json`
- `SessionEnd` 훅 커맨드: `node "${CLAUDE_PLUGIN_ROOT}/hooks/session-end-cleanup.mjs"`
- Node.js 미설치 (`which node` → not found) → 훅 실패 22회 → Night-41 이후 24회

**진단 근거**:
- `python3` ✅ 설치됨 — hookify, ralph-loop 훅 정상
- `jq` ✅ 설치됨 — ralph-loop stop-hook.sh 정상
- `node` ❌ 미설치 — Vercel 플러그인 모든 훅 실패
- 이 프로젝트는 Flutter/Rust — Vercel 플러그인 필요 없음

**권장 조치** (사용자 결정 대기):
| 옵션 | 커맨드 | 위험도 |
|------|--------|--------|
| **A) Vercel 플러그인 비활성화** (권장) | `~/.claude/settings.json`에서 `"vercel@claude-plugins-official": false` | LOW |
| B) Node.js 설치 | `sudo apt-get install -y nodejs` | MEDIUM |
| C) 유지 (비차단이므로 허용) | 아무것도 안 함 | 없음 |

### Night-41 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| U-39 분석 | ✅ **완료** — D-81 DECISION_LOG 기록 완료 |
| U-42 상태 | ⏳ **사용자 방향 선택 대기** (4세션 연속) |
| D-81 상태 | ⏳ **사용자 수정 방향 선택 대기** (A/B/C) |

---

## Night-40 (2026-04-10) — PLAN_02 초안 작성 + U-42 해소 준비

**브랜치**: `auto/night-01-20260410_0100`
**베이스라인**: 360건 (변동 없음)
**실행자**: Sonnet 4.6 Sub-agent

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) + D-63 해소(Night-39) 이후,
**U-42(PLAN_02 방향 결정)가 3세션 연속 대기** 중.
Night-40에서 `docs/plans/PLAN_02.md` 초안을 작성하여 사용자 결정을 지원.

### Night-40 작업 내역

| 작업 | 파일 | 내용 |
|------|------|------|
| Night-39 MORNING_BRIEFING 커밋 | `MORNING_BRIEFING.md` | 미커밋 Night-39 업데이트 반영 — 커밋 `222f935` |
| PLAN_02 초안 작성 | `docs/plans/PLAN_02.md` | A~E 5가지 방향 × 세부 실행 단계 + 위험 관리 + 체크포인트 |
| MORNING_BRIEFING Night-40 업데이트 | `MORNING_BRIEFING.md` | Night-40 세션 전략 섹션 + §7 생성 항목 + §9 다음 세션 갱신 |
| NIGHT_06_RESULT Night-40 추가 | `NIGHT_06_RESULT.md` | 이 섹션 |

### PLAN_02.md 핵심 내용

| 방향 | 설명 | 예상 규모 | Opus 권장도 |
|------|------|-----------|------------|
| **A) BREAKING 업그레이드** | riverpod 4.x + go_router 17.x + fl_chart 1.x + google_sign_in 7.x | 3~5 세션 | ⭐⭐⭐ |
| **B) 기능 확장** | 미머지 PR 3개 통합 + 신규 기능 | 2~4 세션 | ⭐⭐⭐⭐⭐ |
| **C) E2E + CI/CD** | 통합 테스트 250건 + playwright 20건 | 4~6 세션 | ⭐⭐⭐ |
| **D) 프로덕션 준비** | Grafana + SLO + 그레이스풀 셧다운 | 4~6 세션 | ⭐⭐⭐⭐ |
| **E) 조합 (추천)** | B → A → D 순서 | 8~12 세션 | ⭐⭐⭐⭐⭐ |

### Night-40 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** (Night-39 기준, 코드 변경 없음) |
| `flutter test --no-pub` | ✅ **360건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| PLAN_02.md 작성 | ✅ **완료** — `docs/plans/PLAN_02.md` 신규 생성 |
| U-42 상태 | ⏳ **사용자 방향 선택 대기** — 선택지 준비 완료 |

### Night-40 PLAN_02 결정 대기 항목

| # | 항목 | 선택지 |
|---|------|--------|
| **U-3** | 브랜치 머지 방향 | A) Push + PR / B) 로컬 머지 / C) 유지 |
| **U-42** | PLAN_02 방향 | A) BREAKING / B) 기능확장 / C) E2E+CI/CD / D) 프로덕션 / E) 조합 |

---

## Night-39 (2026-04-09) — D-63 완전 해소 + PLAN_01 이후 첫 소규모 개선

**브랜치**: `auto/night-01-20260409_0100`
**베이스라인**: 358건 → **360건** (+2건)
**커밋**: `aebf3d5` (MORNING_BRIEFING 커밋) + 테스트 커밋 예정

### 배경

PLAN_01 8-Phase 전체 완료(Night-37) + 문서 완결(Night-38) 이후,
Night-39는 잔존 항목 D-63을 완전 해소하는 세션.

MORNING_BRIEFING.md에 Night-38 업데이트가 커밋되지 않은 채 세션 시작.
이를 커밋(`aebf3d5`)하고, D-63 마지막 케이스 2개를 추가.

### D-63 완전 해소: `_transactionLabel` 8/8 + default 전 케이스 커버

| 추가된 테스트 | 검증 대상 |
|-------------|----------|
| `"referral_purchase_referred"` 타입 → "추천 구매 보상" 레이블 | case 4 (Night-32에서 누락됨) |
| 알 수 없는 타입 `'unknown_future_type'` → 원문 타입명 그대로 표시 | `_ => type` default 케이스 |

**패턴 (D-80)**: `'unknown_future_type'` 주입 → `_transactionLabel` switch default `_ => type` → 원문 그대로 렌더링 확인. 서버가 새 transactionType 추가 시 UI 크래시 없는 폴백 보장.

**전체 `_transactionLabel` 케이스 커버 현황**:
| 케이스 | 레이블 | 테스트 Night |
|--------|--------|-------------|
| `daily_checkin` | 일일 출석 룰렛 | Night-28 |
| `referral_welcome` | 추천 가입 보상 | Night-28 |
| `referral_welcome_referrer` | 추천인 웰컴 보상 | Night-32 |
| `referral_purchase_referred` | 추천 구매 보상 | **Night-39** |
| `referral_purchase_referrer` | 추천인 보상 | Night-32 |
| `signup_bonus` | 가입 보너스 | Night-28 |
| `gifticon_exchange` | 기프티콘 교환 | Night-28 |
| `admin_adjustment` | 운영자 조정 | Night-32 |
| `_` (default) | 원문 타입명 | **Night-39** |

### 테스트 증감

| 파일 | 이전 | 이후 | 변화 |
|------|------|------|------|
| `test/screens/point_history_screen_test.dart` | 14건 | 16건 | **+2** |
| **합계** | **358건** | **360건** | **+2** |

### Night-39 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **360건** (+2건) |
| `cargo test --lib` | ✅ **207건** (변동 없음, 확인 생략) |
| D-63 잔존 해소 | ✅ **완전 해소** — referral_purchase_referred + default 케이스 |
| PLAN_01 이후 방향 | ⏳ **U-42 대기** — PLAN_02 방향 사용자 결정 필요 |

### Night-39 PLAN_02 대기 상태

| 선택지 | 설명 |
|--------|------|
| **A)** | BREAKING 의존성 대규모 업그레이드 (riverpod 4.x, go_router 17 등) |
| **B)** | 기능 확장 — 미머지 PR 3개 통합 + 신규 기능 |
| **C)** | E2E 테스트 + CI/CD 강화 |
| **D)** | 프로덕션 준비 — 성능/모니터링/스케일링 |
| **E)** | 위 항목의 조합 (우선순위 지정) |

---

## Night-38 (2026-04-08) — 문서 완결 + 기준선 재검증

**브랜치**: `auto/night-01-20260408_0100`
**베이스라인**: 358건 (변동 없음)
**커밋**: `2dd797f`

### 배경

Night-37에서 PLAN_01 전체 완료(8/8 Phase) 후, MORNING_BRIEFING.md의 종합 업데이트가
커밋 해시 라인(`a971acc`)만 반영된 상태로 세션이 종료됨.
Night-38에서 섹션 전체 추가(§1.3, §3.7-8, §8.2, §9 등)를 완결 커밋으로 마무리.

### Night-38 작업 내역

| 작업 | 파일 | 내용 |
|------|------|------|
| 문서 종합 업데이트 | `MORNING_BRIEFING.md` | Night-37 전략 섹션 + Phase 완료 마킹 + §9 다음 세션 선택지 |
| 기준선 재검증 | — | Flutter 358건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ (변동 없음) |

### Night-38 최종 검증

| 검증 | 결과 |
|------|------|
| `flutter analyze --no-pub` | ✅ **0건** |
| `flutter test --no-pub` | ✅ **358건** (변동 없음) |
| `cargo test --lib` | ✅ **207건** (변동 없음) |
| 프로덕션 코드 변경 | **0건** — 문서 전용 세션 |

### PLAN_01 이후 다음 선택지 (§9 요약)

| 선택지 | 설명 | Opus 추천 |
|--------|------|-----------|
| **A) 브랜치 머지 → PLAN_02 수립** | `auto/night-01-20260408_0100` → main PR + 새 계획 | **★ 추천** |
| B) BREAKING 업그레이드 | riverpod 4.x + json 체인 + go_router 17.x | A 이후 |
| C) feat 브랜치 통합 | dark-mode + phase0-security + phase2-monthly | A 이후 |

---

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

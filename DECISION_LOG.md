# DECISION_LOG — Night-01 Session (2026-03-04)

---

## Night-69 Phase 22 실행 (2026-05-17) — 의존성 최신화 + BREAKING 분석

> **Sonnet 4.6 Sub-agent** 실행 | Phase 22 (의존성 최신화)
> **브랜치**: `auto/night-01-20260517_0100`

### Phase 22-A: WebSearch 데이터 수집 결과

| 패키지 | 현재 | Latest | 유형 |
|--------|------|--------|------|
| flutter_riverpod | 3.0.3 | 3.3.1 | MINOR (but riverpod_generator 4.x 동반 BREAKING) |
| riverpod_generator | 3.0.3 | 4.0.3 | **BREAKING** (D-101) |
| riverpod_annotation | 3.0.3 | 4.0.2 | **BREAKING** (D-101 연동) |
| go_router | 16.3.0 | 17.2.3 | **BREAKING** (D-102) |
| fl_chart | 0.69.2 | 1.2.0 | **BREAKING** (D-102) |
| flutter_secure_storage | 9.2.4 | 10.2.0 | **BREAKING** (D-102) |
| google_sign_in | 6.3.0 | 7.2.0 | **BREAKING** (D-102) |
| sign_in_with_apple | 6.1.4 | **8.0.0** | **BREAKING ×2** (D-102 — 7.x→8.x 추가 업버전!) |
| kakao_flutter_sdk_user | 1.10.0 | **2.0.0+1** | **BREAKING** (**신규 발견 — D-102 미포함!**) |
| json_annotation | 4.9.0 | 4.12.0 | MINOR — **BLOCKED** (analyzer 제약) |
| freezed | 3.2.3 | 3.2.5 | PATCH — **BLOCKED** (analyzer <9.0.0) |
| json_serializable | 6.11.2 | 6.14.0 | MINOR — **BLOCKED** (analyzer <9.0.0) |

### Phase 22-C: 트랜지티브 의존성 자동 업그레이드 (24개)

> `flutter pub upgrade` — pubspec.yaml 변경 없이 lock파일 갱신  
> 검증: Flutter **380건** ✅ | analyze **0건** ✅ | 베이스라인 완전 보존

| 주요 업데이트 | 이전 | 이후 |
|-------------|------|------|
| async | 2.13.0 | 2.13.1 |
| build | 4.0.4 | 4.0.6 |
| flutter_svg | 2.2.3 | 2.3.0 |
| mockito | 5.6.3 | 5.6.4 |
| path_provider_android | 2.2.22 | 2.3.1 |
| shared_preferences | 2.5.4 | 2.5.5 |
| source_gen | 4.2.0 | 4.2.3 |
| url_launcher_android | 6.3.28 | 6.3.29 |
| vector_graphics | 1.1.19 | 1.2.1 |
| vm_service | 15.0.2 | 15.2.0 |
| jni / jni_flutter | (신규) | 1.0.0 / 1.0.1 |

### D-84 잔여분 재분류 (BLOCKED)

> **핵심 발견**: `freezed 3.2.5`, `json_serializable 6.14.0`, `json_annotation 4.12.0` 모두
> `riverpod_generator 3.x`의 `analyzer <9.0.0` 제약에 막혀 개별 업그레이드 불가.
> **D-101(riverpod_generator 4.x) 실행 시 함께 해제됨** — D-84는 D-101 의존 결정으로 재분류.

### Phase 22-B: BREAKING 변경 상세 분석

#### D-101: flutter_riverpod 3.0→3.3 + riverpod_generator 3→4 (MEDIUM)

| 항목 | 내용 |
|------|------|
| 대상 패키지 | flutter_riverpod 3.3.1 + riverpod_generator 4.0.3 + riverpod_annotation 4.0.2 |
| 동반 해제 | freezed 3.2.5 + json_serializable 6.14.0 + json_annotation 4.12.0 (D-84 잔여) |
| 코드 변경 범위 | `@riverpod` 어노테이션 문법 변화 검토 필요 — 파일 수 최대 15개 |
| analyzer 전환 | 8.x → 9.x (build tool 체인 전체 갱신) |
| 위험도 | **MEDIUM** — 코드젠 문법 변경 시 regeneration 필요 |
| 검증 소요 | `flutter pub run build_runner build` + 380건 테스트 |
| 추천 | ✅ **권장** — Flutter 앱 품질 향상 + D-84 완전 해소 |

#### D-102: BREAKING 5+2종 상세

| 패키지 | 현재→최신 | 핵심 변경점 | 위험도 | 추천 |
|--------|---------|-----------|--------|------|
| **go_router** | 16.3→17.2.3 | `BuildContext` 일부 제거, ShellRoute 개선 | HIGH | ⏸️ 분석 후 결정 |
| **fl_chart** | 0.69→1.2.0 | `tooltipBgColor→getTooltipColor`, `colors→color/gradient`, titles 구조 변경, touch callback 시그니처 변경 | **HIGH** | ⏸️ 회귀 위험 큼 (TrendChart/DemographicChart 영향) |
| **flutter_secure_storage** | 9.2→10.2.0 | Android: Jetpack→Tink 마이그레이션, min SDK 19→23 | MEDIUM | ⏸️ Android 대상 앱 검증 필요 |
| **google_sign_in** | 6.3→7.2.0 | platform interface 2.x→3.x, iOS SDK 7.0 | MEDIUM | ⏸️ 소셜 로그인 흐름 검증 필요 |
| **sign_in_with_apple** | 6.1→**8.0.0** (**+2 major!**) | 7.x + 8.x 두 단계 BREAKING (예상보다 큰 변경) | **HIGH** | ⏸️ 8.x CHANGELOG 별도 확인 필요 |
| **kakao_flutter_sdk_user** | 1.10→**2.0.0** (**신규 발견!**) | D-102 미포함 — 카카오 SDK 전면 개편 | **HIGH** | ⏸️ 카카오 로그인/사용자 API 재검토 필요 |

### 신규 발견 결정 항목

| 결정 ID | 내용 | 결정 | 비고 |
|---------|------|------|------|
| **D-119** | kakao_flutter_sdk_user 2.x 업그레이드 | ⏸️ 사용자 결정 대기 | D-102에 추가, HIGH 위험도 |
| **D-120** | sign_in_with_apple 8.x (vs 7.x 예상) | ⏸️ 사용자 결정 대기 | CHANGELOG 8.x 별도 검토 필요 |

### 결정 기록

| 결정 ID | 내용 | 결정 | 근거 |
|---------|------|------|------|
| **D-84 재분류** | json_annotation/freezed/json_serializable 업그레이드 | D-101 의존으로 재분류 | analyzer <9.0.0 제약 (riverpod_generator 3.x) |
| **Phase 22-C** | 트랜지티브 24개 업그레이드 | ✅ 즉시 적용 | pubspec.yaml 변경 불필요, 테스트 보존 |
| **D-101** | riverpod 3.3 + generator 4.x | ⏸️ 사용자 결정 대기 | D-84 해소 효과 포함, 코드 변경 필요 |
| **D-102** | BREAKING 5→7종 (kakao/apple 추가) | ⏸️ 사용자 결정 대기 | 각 패키지별 선별 적용 권장 |

---

## Night-68 Phase 20+21 실행 (2026-05-16) — MCP 검증 + 인구통계 파이프라인 구축

> **Sonnet 4.6 Sub-agent** 실행 | Phase 20(MCP 전수 실측) + Phase 21(인구통계 분석 파이프라인)
> **브랜치**: `auto/night-01-20260516_0100`

### 검증 결과

| 항목 | 결과 |
|------|------|
| Flutter 테스트 | **380건** ✅ (+10) |
| Flutter analyze | **0건** ✅ |
| Rust 테스트 | **221건** ✅ (+5) |
| 신규 파일 | **5개** (Rust 1 + Flutter 4) |

### Phase 20: MCP 전수 실측 결과

| 항목 | 결과 |
|------|------|
| `naver_price_service.rs` NaverShopItem 14필드 | **0 불일치** ✅ |
| `trend_data_service.rs` TrendResult/TrendPeriodData | **0 불일치** ✅ |
| migration 019 카테고리 코드 | 50001780/50000215/50000151 **확인** ✅ |
| CoinInfo/OpenDart/UsStockInfo | 쇼핑앱 비해당 (D-113/D-114) |

### Phase 21: 인구통계 파이프라인 신규 파일

| 파일 | 유형 | 설명 |
|------|------|------|
| `server/src/services/demographic_trend_service.rs` | NEW | 연령/성별/기기 5회 병렬 API 호출, compute_score, 단위테스트 4건 |
| `app/lib/models/demographic_trend.dart` | NEW | freezed DemographicTrend + DemographicPeriodData |
| `app/lib/providers/demographic_trend_provider.dart` | NEW | @riverpod demographicTrends family provider |
| `app/lib/services/naver_trend_service.dart` | MOD | getDemographicTrends() 메서드 추가 |
| `app/lib/widgets/demographic_chart.dart` | NEW | fl_chart BarChart(age) + LinearProgressIndicator(gender/device) |

### 결정 기록

| 결정 ID | 내용 | 결정 | 근거 |
|---------|------|------|------|
| **D-112** | Phase 20 필드 불일치 수정 필요 여부 | A) 수정 불필요 | 실측 결과 0건 불일치 |
| **D-113** | CoinInfo MCP 활용 방안 | B) 보류 | 가격추적 쇼핑앱과 암호화폐 무관 |
| **D-114** | OpenDart/UsStockInfo MCP 활용 방안 | B) 비해당 | 상장사 분석 기능 없음 |
| **D-115** | DemographicChartWidget 배치 위치 | A) ProductDetailScreen 내 탭 | D-107 결정과 일관성 |
| **D-116** | 인구통계 moka 캐시 전략 | A) 신규 슬롯 1h TTL max 100 | 카테고리 수 제한적, API 비용 절감 |
| **D-117** | Phase 21 코드 생성 범위 | A) 전체 생성 (B1-B6) | 베이스라인 유지 + 완전한 파이프라인 |

### Rust 수정 상세

| 오류 | 파일 | 내용 |
|------|------|------|
| `AppColors.brand` 미존재 | `demographic_chart.dart:104` | `brand` → `success` 수정 |
| E0716 임시값 수명 | `demographic_trend_service.rs:104,141` | `serde_json::json!` → `let` 바인딩으로 수명 연장 |

---

## Night-67 상태 확인 (2026-05-15) — 5세대 브랜치 첫 세션 + D-87 I-06/I-07 수정

> **Sonnet 4.6 Sub-agent** 실행 | 5세대 브랜치(20260515) 첫 세션 + 고아 수정 2건
> **브랜치**: `auto/night-01-20260515_0100`

### 검증 결과

| 항목 | 결과 |
|------|------|
| Flutter 테스트 | **370건** ✅ |
| Flutter analyze | **0건** ✅ |
| Rust 테스트 | **216건** ✅ |
| 코드 변경 | **2건** (I-06 + I-07) |

### 수정 내역

| ID | 파일 | 수정 내용 |
|----|------|---------|
| **I-06** | `server/src/services/product_service.rs:121` | `AppError::Internal` fallback에 `tracing::error!` 추가 — Sentry 스택트레이스 보존 |
| **I-07** | `app/lib/widgets/price_chart.dart:33-38,62-69` | 요일 x좌표 `e.key` → `e.dayOfWeek`, 레이블 `sorted[idx]` → `_dayLabels[dow]` |

### 미결 결정사항 (사용자 결정 대기 지속)

| 결정 ID | 내용 | 우선도 | 대기 세션 |
|---------|------|--------|----------|
| **D-110** | main 머지 PR: 108 커밋 → main | 🔴 즉시 | **17세션** |
| **D-111** | PLAN_02 방향 선택 | 🔴 즉시 | **17세션** |
| **D-87 PD-65** | `CheckinResult.reward_amount: i16` → `bool rewarded` API 변경 | 🟡 중간 | — |
| **D-87 PD-66** | `PointsInfo` pub 필드 → private + 불변식 생성자 | 🟡 중간 | — |
| **D-101** | Riverpod MINOR 업그레이드 (riverpod_generator 4.x) | 🟡 중간 | — |
| **D-102** | BREAKING 의존성 업그레이드 5종 | 🟡 중간 | — |

**Status**: ⏳ D-87 LOW 2건(I-06/I-07) 해소. 잔여 PD-65/PD-66는 API 설계 결정 필요. D-110/D-111 결정 시 방향 확정.

---

## Night-64 상태 확인 (2026-05-12) — 신규 브랜치 베이스라인 검증

> **Sonnet 4.6 Sub-agent** 실행 | 신규 브랜치 첫 세션 + 베이스라인 3중 재검증
> **브랜치**: `auto/night-01-20260512_0100`

### 검증 결과

| 항목 | 결과 |
|------|------|
| Flutter 테스트 | **370건** ✅ |
| Flutter analyze | **0건** ✅ |
| Rust 테스트 | **216건** ✅ (`~/.cargo/bin/cargo test --lib`) |
| 코드 변경 | **0건** |

### 커밋

| 해시 | 내용 |
|------|------|
| `447f3c4` | `docs(night-64): MORNING_BRIEFING Night-63 결합 분석 + Phase 20+ 전략 방향 반영` |

### 미결 결정사항 (사용자 결정 대기 지속)

| 결정 ID | 내용 | 우선도 |
|---------|------|--------|
| **D-110** | main 머지 PR: 브랜치 100+ 커밋 → main 머지 | 🔴 즉시 |
| **D-111** | PLAN_02 방향: A(BREAKING 업그레이드+main 머지) / B(신규 MCP 기능 확장) / C(조합 A+B) | 🔴 즉시 |
| **D-101** | Flutter MINOR/PATCH 의존성 즉시 적용 여부 | 🟡 중간 |
| **D-102** | BREAKING 의존성 업그레이드 범위 (go_router 17/fl_chart 1/google_sign_in 7/flutter_secure_storage 10) | 🟡 중간 |

**Status**: ⏳ 사용자 결정 대기 — D-110/D-111이 다음 세션 방향 결정의 전제 조건

---

## Night-63 상태 확인 (2026-05-11) — PLAN_01 완전 종결 사후 검증

> **Sonnet 4.6 Sub-agent** 실행 | 베이스라인 재검증 + 문서 갱신
> **브랜치**: `auto/night-01-20260511_0100`

### 검증 결과

| 항목 | 결과 |
|------|------|
| Flutter 테스트 | **370건** ✅ |
| Flutter analyze | **0건** ✅ |
| Rust 테스트 | **216건** ✅ (cargo 미설치 환경) |
| 코드 변경 | **0건** |

### 미결 결정사항 (사용자 결정 대기)

| 결정 ID | 내용 | 우선도 |
|---------|------|--------|
| **D-110** | main 머지 PR: `auto/night-01-20260510_0100` (98+ 커밋) → main | 🔴 즉시 |
| **D-111** | PLAN_02 방향: A(BREAKING 업그레이드) / B(기능 확장) / C(E2E+CI/CD) / D(프로덕션) / E(조합) | 🔴 즉시 |
| **D-101** | Flutter MINOR/PATCH 즉시 적용 여부 | 🟡 중간 |
| **D-102** | BREAKING 의존성 업그레이드 범위 (go_router 17/fl_chart 1/google_sign_in 7/flutter_secure_storage 10) | 🟡 중간 |
| **D-82~D-84** | Rust BREAKING 업그레이드 범위 (reqwest/jsonwebtoken/sentry) | 🟢 낮음 |

**Status**: ⏳ 사용자 결정 대기 — D-110/D-111 결정 시 다음 세션 방향 확정됨

---

## Night-61 결정 (2026-05-09) — Phase 18 코드 품질 점검 + 수정 실행

> **Sonnet 4.6 Sub-agent** 실행 | silent-failure-hunter + type-design-analyzer + code-reviewer 3대 병렬

### D-107: 트렌드 데이터 표시 위치

**현황**: Night-58 N56-05에서 TrendChartWidget이 이미 `ProductDetailScreen`에 통합됨. Phase 18 감사 결과 현재 통합 위치가 맥락상 적절하다고 확인됨 (상품 상세에서 해당 카테고리의 검색 트렌드를 보여주는 것이 자연스러움).

**선택지**:
- A) **상품 상세 내** (현재 상태) — 카테고리 트렌드가 상품 맥락에서 표시
- B) 별도 탭 — 앱 구조 변경 필요, 탐색 흐름 분리
- C) 홈 대시보드 — 홈화면 리팩토링 필요

**결정**: **A — 현재 ProductDetailScreen 유지** (N56-05 통합 결과 확인, 추가 변경 불필요)

**Status**: ✅ CONFIRMED (Night-61) — 현재 구조 확정

---

### D-108: 디자인 시스템 규칙 범위

**현황**: Phase 13(Night-52)에서 HomeScreen/LoginScreen/ProductDetailScreen 3화면에 AppSpacing 파일럿 적용. code-simplifier 분석 결과 `trend_chart.dart`에 AppSpacing.xs(4) 활용 가능한 위치 다수 발견. 단, `AppTextStyles.caption(12px)`과 차트 축 레이블(10px)의 사이즈 불일치로 직접 치환 불가.

**선택지**:
- A) 신규 위젯만 (trend_chart.dart 내 적용 가능 위치 한정)
- B) 기존 위젯 포함 전면 적용 (전체 화면 일괄 치환 — 별도 전용 세션 필요)

**결정**: **A — 신규 위젯 한정** (Night-61에서 `TrendSummaryCard` isUp 반복 삼항 제거 + redundant isEmpty 가드 제거로 코드 품질 향상. 전면 AppSpacing 적용은 Phase 19 전용 세션으로 이연)

**Status**: ✅ DECIDED (Night-61) — A 선택, Phase 19에서 B 재검토

---

### Phase 18 수정 5건 (Night-61 실행)

| ID | 대상 | 수정 | 심각도 |
|----|------|------|--------|
| **I-03** | `trend_data_service.rs:141` `Duration::days(180)` → `Months::new(6)` | 6개월 날짜 계산 정확도 (최대 6일 오차) | MEDIUM |
| **I-04** | `main.rs:379` `debug!` → `warn!` (부분 자격증명 미설정 시) | 설정 오류 운영자 인지 보장 | MEDIUM |
| **I-05** | `naver_price_service.rs` `NaverShopResponse`/`NaverShopItem` `pub` → `pub(crate)` | 내부 DTO 과도한 공개 제한 | LOW |
| **F-09** | `trend_chart.dart` TrendSummaryCard `isUp` 삼항 반복(4회) → 로컬 변수 추출 | 코드 중복 제거 | LOW |
| **F-10** | `trend_chart.dart` `_buildTitlesData` 중복 `trends.isEmpty` 가드 제거 | 불필요한 중복 방어 | LOW |

**검증**: Rust 216건 ✅ | Flutter 370건 ✅ | analyze 0건 ✅

---

## Night-59 결정 (2026-05-07) — Phase 17 아키텍처 분석 + 코드 품질

> **Sonnet 4.6 Sub-agent** 실행 | feature-dev 3대 병렬 분석 결과 기반

### D-104: 캐시 전략 (NaverSearch 트렌드 데이터)

**현황**: `get_naver_trends()` 핸들러가 매 요청마다 Naver Datalab API를 직접 호출함. `AppCache`에 trend_data 슬롯 없음. 월별 데이터 특성상 24시간 TTL 캐시가 적절.

**선택지**:
- A) **moka 확장** — `AppCache`에 `trend_data: Cache<String, Vec<CategoryTrendScore>>` 추가, TTL 24h, max 50 entries. 코드 변경 ~15줄, Redis 추가 불필요
- B) Redis 도입 — 다중 인스턴스 지원, 현재 단일 서버 환경에서 오버엔지니어링
- C) 하이브리드 (moka + Redis) — 불필요한 복잡도

**권장**: **A — moka 확장** (현재 개발/스테이징 단계에서 최적)

**thundering herd 방어**: `try_get_with("default", ...)` 패턴으로 동시 요청 coalescing 가능 — `ai_prediction_service.rs` 기존 패턴 재사용.

**Status**: ✅ IMPLEMENTED (Night-60) — A 선택: `cache.rs`에 `trend_data` 슬롯 추가, TTL 24h/max 50

---

### D-105: NaverSearch 호출 빈도

**현황**: 현재 요청당 실시간 Datalab API 호출. Naver API rate limit(~1,000회/일), 응답 지연 ~500ms.

**선택지**:
- A) 실시간 (요청당) — 현재 방식, API 쿼터 소진 위험
- B) **배치 (1시간마다)** — `main.rs` 기존 background task 패턴 재사용, 24회/일(97.6% 여유), 데이터 신선도 1시간 지연(월별 데이터이므로 비즈니스 무해)
- C) 이벤트 기반 — 복잡도 높음, 적합한 트리거 없음

**권장**: **B — 1시간 배치** + 캐시 웜업(서버 시작 직후 1회 즉시 호출)

**구현 파일**: `server/src/main.rs` — `h_trend` 백그라운드 태스크 추가 (~35줄), `tokio::time::interval(3600s)`, panic watcher 등록

**Status**: ✅ IMPLEMENTED (Night-60) — B 선택: `warmup_trend_cache()` + `h_trend` 1h 배치 태스크 (`main.rs`)

---

### D-106: 서비스 계층 리팩토링 범위

**현황**: `naver_price_service.rs`(NAVER_CLIENT, 10s)와 `trend_data_service.rs`(TREND_CLIENT, 15s) 각각 독립 OnceLock<reqwest::Client>. `AppState.http_client`(30s)가 이미 존재.

**선택지**:
- A) 신규 서비스만 — OnceLock 유지, 3개 커넥션 풀 병존
- B) **AppState.http_client 공유** — OnceLock 제거, 함수 시그니처에 `client: &reqwest::Client` + `config: &Config` 추가, 커넥션 풀 3→1개 통합. `trends.rs`에 `State<AppState>` 추가 (현재 미추출). 변경 파일: `trend_data_service.rs`(+40/-5줄), `trends.rs`(+5줄)

**권장**: **B** — 아키텍처 일관성 + Naver 자격증명을 Config 단일 진실 원천으로 통합

**주의**: `naver_price_service.rs`는 현재 어떤 라우트에서도 호출되지 않음. 리팩토링 후 미연결 상태 유지 (향후 상품별 가격 검증 라우트 연결 시 일관성 확보).

**Status**: ✅ IMPLEMENTED (Night-60) — B 선택: OnceLock 제거, `trends.rs` State<AppState> 추가, 커넥션 풀 3→1 통합

---

### M-1 즉시 수정 (Night-59 실행)

**버그**: `app/test/screens/product_detail_screen_test.dart:92-110` 에러 상태 테스트에서 `categoryTrendsProvider` override 누락 → CI 환경에서 실제 네트워크 호출 시도 가능성.

**수정**: `buildScreen(productFuture: Future(() async { throw Exception('네트워크 오류'); }))` 패턴으로 교체 — `buildScreen()` 헬퍼의 `categoryTrendsProvider` override 자동 포함.

**Status**: IMPLEMENTED (Night-59)

---

## Night-58 결정 (2026-05-06) — Phase 16 의존성 분석 + N56 해소

### D-101: Dart MINOR/PATCH 즉시 적용 여부

**현황**: flutter_riverpod 3.0→3.3.1은 minor이나, 이 업그레이드를 하면 riverpod_generator도 3.x→4.x(BREAKING)로 올려야 함. 모든 `@riverpod` 어노테이션과 `.g.dart` 파일 재생성 필요.

**선택지**:
- A) flutter_riverpod + riverpod_generator BREAKING 세트 즉시 적용
- B) 별도 전용 세션에서 처리 (테스트 영향 최소화)
- C) 보류 (현재 버전 정상 동작)

**권장**: B — 370건 테스트 기반이 있지만 BREAKING 변경은 별도 리스크 관리 필요.

**Status**: ⏳ 사용자 결정 대기

---

### D-102: Dart BREAKING 업그레이드 범위 (go_router/fl_chart/google_sign_in/flutter_secure_storage)

**현황**: go_router 16→17.2.3, fl_chart 0.69→1.2.0, google_sign_in 6.2→7.2.0, flutter_secure_storage 9.2→10.0.0 — 모두 BREAKING.

**선택지**:
- A) 전체 한 번에 (높은 리스크, 대규모 테스트 수정 필요)
- B) 보안 이점 있는 것만 먼저 (google_sign_in — OAuth 2.0 강화)
- C) 전부 보류 (현재 버전 기능 정상)
- D) 패키지별 순차 처리 (세션당 1개)

**권장**: D → 순서: flutter_secure_storage(보안 최우선) → google_sign_in → riverpod 세트 → go_router → fl_chart

**Status**: ⏳ 사용자 결정 대기

---

### D-103: Rust BREAKING 업그레이드 포함 여부

**현황**: Rust crate는 모두 semver 범위(`^0.8`, `^1`, etc.) 내 최신 자동 포함. reqwest 1.x(현재 0.12), sentry 0.38은 BREAKING이나 현재 기능 정상.

**결론**: **불필요** — cargo update만으로 범위 내 최신 유지됨. BREAKING 업그레이드 시기 없음.

**Status**: DECIDED — 현행 유지

---

### N56-01 해소 결정: datalab_shopping_keywords API 제약 문서화

**현황**: 가전(디지털/가전) 중분류 코드(50000151=노트북) → API 작동 확인 ✅. 식품·생활용품은 4단계 계층 구조로 중분류 전용 코드 없음 → API 호환 불가.

**결론**: `datalab_shopping_keywords`는 가전 카테고리에만 사용 가능. 식품·생활은 `datalab_shopping_category`(기존 코드)로 유지. **N56-01 해소 완료**.

**Status**: DECIDED

---

## Night-50 결정 (2026-04-30) — PLAN_01 Phase 12 UI/UX 감사

### D-93: U-02 HomeScreen 에러상태 ScreenErrorWidget 교체

**현황**: `home_screen.dart:94-95`에서 인기 검색어 에러 상태를 `Center(child: Text(friendlyErrorMessage(e)))` 직접 표시. Night-37에서 도입된 `ScreenErrorWidget`(AlertScreen/FavoritesScreen/NotificationListScreen에서 사용)과 불일치.

**선택지**:
- A) ScreenErrorWidget으로 교체 (4줄 변경, 재시도 기능 자동 추가, 난이도 MINIMAL)
- B) 보류 (기능상 문제없음)

**권장**: A — 코드 4줄, 화면 일관성 + 재시도 UX 개선. Phase 13에 포함 권장.

**Status**: ⏳ 사용자 결정 대기

---

### D-94: U-03 AppSpacing 12dp 갭 처리 방식

**현황**: `AppSpacing`에 12dp 상수가 없으나 `login_screen.dart`(3곳), `home_screen.dart`(2곳), `product_card.dart`(1곳)에서 `SizedBox(height: 12)` / `EdgeInsets.symmetric(vertical: 6)` 등으로 12dp가 반복 사용됨. D-89(AppSpacing 적용) 결정 시 함께 해결 필요.

**선택지**:
- A) `AppSpacing.smMd = 12` 추가 후 6개소 교체 (theme.dart +1줄, 사용처 교체)
- B) 기존 sm(8) 또는 md(16)으로 통일 (시각적 변화 있음)
- C) D-89가 보류면 현행 유지

**권장**: A — 매직넘버 12가 6곳에서 일관되게 사용됨, 별도 상수 값어치 있음. D-89(B 이상) 결정과 연동.

**Status**: ⏳ 사용자 결정 대기 (D-89 결정에 종속)

---

### D-95: U-06 AppTextStyles.discountRate 색상 제거 여부

**현황**: `theme.dart:35`에서 `AppTextStyles.discountRate`가 `color: Color(0xFFD63031)`를 하드코딩. `AppColors.light.error`와 동일값이나, 다크모드 전환 시 `AppColors.dark.error(0xFFFF7675)`와 불일치 → 다크모드에서 할인율 텍스트 색상이 잘못 표시됨.

**선택지**:
- A) `AppTextStyles.discountRate`에서 `color` 필드 제거 → 사용처에서 `.copyWith(color: appColors.error)` 적용 (BuildContext 필요)
- B) 보류 (현재 다크모드 미활성 상태, 실질 영향 없음)

**권장**: A — 다크모드 브랜치(`feat/dark-mode`)가 있으므로 조기 수정이 병합 충돌 방지. 단, 사용처 확인 후 적용.

**Status**: ⏳ 사용자 결정 대기

---

### D-96: U-07 SearchScreen 검색 필터/정렬 파라미터 재연결

**현황**: `search_screen.dart:65-70`에서 `service.search()` 호출 시 백엔드 지원 필터(near_stockout/all_time_low/declining/under_10k)와 정렬(ranking/discount_rate/discount_amount/lowest_price) 파라미터가 전달되지 않음. MEMORY에 "Phase 1E: 검색 필터 Flutter UI 연결 완료" 기록과 실제 코드 불일치 — 필터 UI가 없거나 다른 브랜치에 존재.

**선택지**:
- A) SearchScreen에 FilterChip(4종) + DropdownButton(4종) 재추가 + service.search() 파라미터 연결 (Phase 1E 작업 재현)
- B) fix/phase0-security-stability 브랜치에서 해당 변경 cherry-pick 검토
- C) 보류 (기능 사용 빈도 미검증)

**권장**: B → A 순서로 확인. cherry-pick 가능하면 B, 그 외 A 신규 구현. 필터는 UX 핵심 기능.

**Status**: ⏳ 사용자 결정 대기

---

## Night-49 결정 (2026-04-29) — PLAN_01 Phase 11 아키텍처 분석

### D-88: Phase 11 신규 HIGH 이슈 F-08 + Phase 10 HIGH I-01/I-02 수정 범위

**현황**: Phase 11에서 발견된 F-08(401 갱신 실패 시 AuthState 미통보)과 Phase 10의 I-01(rollback warn 패턴), I-02(ALLOWED_ORIGINS 조용한 skip)가 Phase 13 즉시 수정 후보.

**선택지**:
- A) 전체 즉시 수정 (F-08 + I-01 + I-02 — 3건, 모두 LOW 난이도)
- B) I-01/I-02만 수정 (F-08은 auth 흐름 변경으로 별도 검토)
- C) 보류

**권장**: A — 3건 모두 난이도 LOW, 안전성·UX 개선 효과 명확.

**Status**: ⏳ 사용자 결정 대기

---

### D-89: F-04 AppSpacing/AppTextStyles 적용 범위

**현황**: Night-36에서 도입된 `AppSpacing`/`AppTextStyles` 상수가 **어떤 화면에서도 사용되지 않음**. 87개 raw 매직넘버(SizedBox, EdgeInsets, TextStyle) 잔존. 설계 드리프트 진행 중.

**선택지**:
- A) 전체 화면 일괄 적용 (대규모, 테스트 영향 없음)
- B) 3개 화면 시범 적용 (HomeScreen/ProductDetailScreen/LoginScreen)
- C) 보류

**권장**: B — 시범 적용으로 패턴 확인 후 나머지 화면 확대.

**Status**: ⏳ 사용자 결정 대기

---

### D-90: F-06 productPredictionProvider 타입 안전화

**현황**: `productPredictionProvider` 반환 타입이 `Map<String,dynamic>` — 다른 모든 provider는 강타입 freezed 모델 사용. 타입 안전성 불일치.

**선택지**:
- A) `PredictionResult` freezed 모델 신규 생성 + provider 타입 변경
- B) 보류 (기능 정상 동작 중)

**권장**: A — AlertType(PD-62) 패턴과 동일, 타입 안전성 완성.

**Status**: ⏳ 사용자 결정 대기

---

### D-91: PD-67 priceTrend String? → PriceTrend Enum 전환

**현황**: `Product.priceTrend: String?` — AlertType(PD-62)에서 동일 패턴이 Night-36에 완료됨. `product_card.dart` 등 다수에서 하드코딩 문자열 비교 잔존.

**선택지**:
- A) PriceTrend Enum 신규 정의 + Product 모델 재생성 (AlertType PD-62 동일 방식)
- B) 보류

**권장**: A — Phase 10 확정 이슈(PD-67), AlertType 패턴 재사용으로 난이도 낮음.

**Status**: ⏳ 사용자 결정 대기

---

### D-92: Phase 12 (UI/UX 감사) vs Phase 13 (수정 실행) 순서

**현황**: Phase 10+11 합산 18건 이슈(HIGH 3 + MEDIUM 7 + LOW 8). Phase 12 UI/UX 감사를 먼저 하면 더 많은 수정 대상이 도출될 수 있음. Phase 13 먼저 하면 이미 확정된 이슈를 빠르게 해소 가능.

**선택지**:
- A) Phase 12(UI/UX 감사) 먼저 → 종합 수정 목록 확정 후 Phase 13
- B) Phase 13(수정 실행) 먼저 → HIGH/MEDIUM 확정 이슈 즉시 해소, Phase 12는 그 다음
- C) Phase 12+13 병렬 실행 (다른 파일 영역 — 충돌 없음)

**권장**: B — 이미 확정된 HIGH 3건(F-08/I-01/I-02)을 먼저 해소해 안전성 확보. Phase 12는 추가 분석이므로 순서 유연.

**Status**: ⏳ 사용자 결정 대기

---

## Night-41 결정 (2026-04-11) — U-39 분석 + 베이스라인 검증

### D-81: SessionEnd hook 실패 원인 규명 (U-39)

**결정**: U-39 원인 확인. 즉각 수정 보류 — 전역 설정 변경으로 사용자 승인 필요.

**근거**:
- **원인**: `vercel@claude-plugins-official` 플러그인이 전역 활성화됨
  - `~/.claude/settings.json`: `"vercel@claude-plugins-official": true`
  - Vercel 플러그인의 `SessionEnd` 훅: `node "${CLAUDE_PLUGIN_ROOT}/hooks/session-end-cleanup.mjs"` 실행
  - 이 프로젝트 환경에는 `node` 미설치 → 훅 실패 22회 누적
- **영향**: 비차단(non-blocking) — 세션 종료 자체는 정상 진행됨
- **Flutter/Rust 프로젝트와 관계**: Vercel 플러그인은 이 프로젝트에서 불필요

**수정 옵션**:
| 옵션 | 방법 | 영향 범위 | 위험도 |
|------|------|-----------|--------|
| A) Vercel 플러그인 전역 비활성화 | `~/.claude/settings.json` `"vercel@..."` → `false` | 모든 프로젝트 | LOW (Vercel 미사용 시 영향 없음) |
| B) Node.js 설치 | `sudo apt-get install -y nodejs` | 시스템 전체 | MEDIUM (시스템 변경) |
| C) 현 상태 유지 | 아무것도 안 함 | 없음 | 없음 (비차단이므로) |

**권장**: 옵션 A — `vercel@claude-plugins-official: false` 전역 설정. 이 프로젝트(Flutter/Rust)에서 Vercel 플러그인이 필요한 순간이 없음.

**다음 단계**: 사용자가 옵션 A/B/C 중 선택 후 실행.

**Status**: DIAGNOSED — 사용자 방향 결정 대기

---

## Night-36 결정 (2026-04-06) — PLAN_01 Phase 5 + PD-62

### D-76: AlertType String → Dart Enum 전환 (PD-62 해소)

**결정**: `PriceAlert.alertType: String` → `AlertType enum` 전환. `@JsonValue` 어노테이션으로 JSON 역직렬화 자동 처리, `AlertTypeX extension`으로 API 직렬화.

**근거**:
- type-design-analyzer Night-35에서 PriceAlert/AlertType 점수 16/40 (최저) — DEFERRED PD-62
- Exhaustive switch 강제로 새 값 추가 시 컴파일 오류 → 런타임 버그 방지
- 서버 `AlertType` enum (TargetPrice/BelowAverage/NearLowest/AllTimeLow)과 1:1 대응
- `alertTypeLabel`/`alertTypeColor` 함수의 `_ => type` 폴백 케이스 제거 (컴파일타임 완전성)

**변경 파일**: `alert.dart`, `alert.freezed.dart`(재생성), `alert.g.dart`(재생성), `alert_type_badge.dart`, `alert_service.dart`, `product_detail_screen.dart`, 테스트 6파일

**Status**: IMPLEMENTED — `test/widgets/alert_type_badge_test.dart` +3건 (344→347건)

---

### D-77: AppSpacing + AppTextStyles 테마 상수 추가 (Phase 5-B)

**결정**: `app/lib/config/theme.dart`에 `AppSpacing` (6단계 간격) + `AppTextStyles` (4종 텍스트) 추가.

**근거**:
- PLAN_01.md Phase 5-B "간격/여백 상수화 + 타이포그래피 시스템 표준화" 요구사항
- 현재 각 화면에서 `EdgeInsets.all(16)`, `SizedBox(height: 8)` 등 하드코딩 → 통일된 토큰으로 교체 가능
- `abstract final class`로 인스턴스화/상속 방지, `static const`로 컴파일타임 상수 보장

**구체적 값**:
- `xs:4, sm:8, md:16, lg:24, xl:32, xxl:48` — Material Design 8pt 그리드 기반
- `priceLabel(18,bold)`, `discountRate(13,w700,#D63031)`, `sectionHeader(14,w600)`, `caption(12,#757575)`

**Status**: IMPLEMENTED — `test/config/theme_test.dart` +11건 (347→358건)

---

## Night-35 결정 (2026-04-05) — PLAN_01 Phase 4

### D-70: Phase 4 서브에이전트 오탐 필터링

**결정**: code-reviewer C-1(RadioGroup), C-2(isLoading), H-1(referral TOCTOU), H-3(/referrals 미등록) 4건 제외

**근거**:
- C-1: 실제 코드에 없음 (sub-agent hallucination)
- C-2: Navigator.pop()이 dialog 닫아 isLoading 미복원 무의미
- H-1: 재시도 루프(`is_referral_code_collision`)가 이미 보호
- H-3: fix/phase0-security-stability 브랜치에 구현됨, 현재 브랜치 미머지 상태

**Status**: IMPLEMENTED (오탐 제외 처리)

---

### D-71: alert_service.rs FOR UPDATE 잠금 후 명시적 rollback 추가

**결정**: `create_price_alert`, `create_category_alert`, `create_keyword_alert` 3함수에서 한도 초과 `return Err` 전에 `warn!` 패턴 rollback 추가

**근거**: Night-23에서 확립된 표준 패턴. `SELECT FOR UPDATE` 잠금이 걸린 상태에서 Transaction::drop() 비동기 롤백이 완료를 보장하지 않아 잠금 해제가 지연될 수 있음.

**Status**: IMPLEMENTED — `server/src/services/alert_service.rs` (3곳)

---

### D-72: reward_service.rs daily_checkin rollback ? 제거

**결정**: `tx.rollback().await?` → `if let Err(rb_err) = tx.rollback().await { warn!(...) }` 패턴으로 변경

**근거**: 읽기 전용 경로(이미 출석)에서 rollback 실패를 500으로 전파하는 것은 과도한 오류 노출. warn으로 충분.

**Status**: IMPLEMENTED — `server/src/services/reward_service.rs:154`

---

### D-73: auth_service.rs TTL i64::MAX 폴백 제거

**결정**: `unwrap_or(i64::MAX)` → `map_err(|_| AppError::Internal(...))?` 명시적 오류 처리

**근거**: `jwt_refresh_ttl_secs` 설정 오류(u64>i64::MAX) 시 292년 TTL의 영구 토큰이 발행되는 보안 결함 방지. 서버 시작 실패가 부적절한 토큰 발행보다 안전.

**Status**: IMPLEMENTED — `server/src/services/auth_service.rs` (2곳: create_token_pair, rotate_refresh_token)

---

### D-74: products.rs SearchQuery.q serde(default) 추가

**결정**: `q: String` → `#[serde(default)] q: String` — 핸들러 내 isEmpty 체크는 이미 존재

**근거**: q 파라미터 누락 시 Axum 기본 422(비표준 포맷)가 반환됨. `#[serde(default)]` 추가 후 핸들러의 `AppError::BadRequest` 경로가 일관된 포맷으로 응답.

**Status**: IMPLEMENTED — `server/src/api/routes/products.rs`

---

### D-75: notification_list_screen.dart markAsRead showErrorSnackBar 추가

**결정**: markAsRead 실패 시 `debugPrint`만 있던 catch를 `showErrorSnackBar` 추가

**근거**: markAllAsRead는 이미 showErrorSnackBar를 사용. 동일 화면 내 에러 표시 일관성. "UX를 위해 무시" 주석은 의도적이나 사용자 피드백 없는 것은 좋지 않음.

**Status**: IMPLEMENTED — `app/lib/screens/notification/notification_list_screen.dart`

---

### PD-62: AlertType String→Dart Enum 전환 (장기 미결)

**결정**: 이번 세션 미실행 — Phase 5/7에서 처리

**근거**: freezed 모델 전체 재생성 + 테스트 대규모 수정 필요. Night-35 범위 초과. type-design-analyzer 점수 16/40 (최저) — 차기 우선 개선 대상.

**Status**: DEFERRED — PLAN_01 Phase 5/7에서 처리

---

### PD-63: User.email Rust String vs Flutter String? 불일치 (장기 미결)

**결정**: 이번 세션 미실행

**근거**: DB 스키마(users.email NOT NULL 여부) 확인 후 결정 필요. 소셜 로그인에서 email이 없을 수 있음.

**Status**: DEFERRED

---

### PD-64: Product 가격 3필드 순서 불변식 검증 (장기 미결)

**결정**: 이번 세션 미실행 — DB CHECK 제약 확인 후 처리

**근거**: `lowest_price <= current_price <= highest_price` 불변식이 타입으로 표현되지 않음. 단기적으로 DB CHECK 제약 + 통합 테스트 추가로 보완 가능.

**Status**: DEFERRED

---

## Context
Sub-agent session on branch `auto/night-01-20260304_0100`.
PLAN_01.md was not found in the repository; decisions are inferred from the uncommitted diff.

---

## D-1: Service Layer Extraction for Devices

**Decision**: Extract inline SQL from `devices.rs` into `services/device_service.rs`.

**Rationale**: `alerts.rs`, `notifications.rs`, and `product_service.rs` already follow the service layer pattern. `devices.rs` was the last route file with inline `sqlx::query_as` calls, creating inconsistency.

**Trade-offs**:
- Consistency with rest of codebase ✓
- Slightly more indirection, but test isolation improves ✓
- `device_service.rs` adds `token.trim()` + length validation (1–512 bytes), fixing silent acceptance of empty/oversized tokens ✓

**Status**: IMPLEMENTED

---

## D-2: utoipa Dependency Added (Not Yet Integrated)

**Decision**: Add `utoipa = { version = "5.4.0", features = ["axum_extras"] }` to Cargo.toml without any source usage.

**Rationale**: OpenAPI documentation was listed in STEP 29 progress notes as a pending item. Adding the dependency now unblocks the next session to annotate handlers with `#[utoipa::path]` macros.

**Risk**: Dead dependency until integrated — Clippy allows with `-A dead_code`. Cargo.lock updated.

**Status**: REVERSED in STEP 35 — dependency removed as dead_code; re-add when OpenAPI integration is scheduled.

---

## D-3: Background Task Metrics (main.rs)

**Decision**: Add `metrics::counter!("background_task_exit", ...)` to the panic watcher loop.

**Rationale**: Silent task exits were invisible to Prometheus. Adding `"reason" => "normal"` vs `"reason" => "panic"` distinguishes graceful stop from crash — enabling alert rules on panic count.

**Status**: IMPLEMENTED

---

## D-4: Migration Cleanup (010_seed_shopping_malls.sql deleted)

**Decision**: Delete `server/migrations/010_seed_shopping_malls.sql` (no .up/.down suffix) from working tree.

**Rationale**: STEP 28 added the correct `.up.sql` and `.down.sql` versions but left the old unsuffixed file tracked in git. SQLx `migrate!` runs `.up.sql` files; the duplicate could cause confusion.

**Status**: STAGED FOR DELETION

---

## D-5: cargo fmt Applied

**Decision**: Run `cargo fmt` before commit.

**Rationale**: `cargo fmt --check` returned exit 1 due to line-length reformatting in `devices.rs`, `main.rs`, `auth.rs`, `products.rs`. All changes are cosmetic (no logic changes).

**Status**: APPLIED

---

# Night-02 Session (2026-03-05) — STEP 32–35

## D-6: JWT aud/iss Claims (STEP 32-2)

**Decision**: Add `aud: "gapttuk-api"` and `iss: "gapttuk-server"` to JWT Claims struct and enforce validation in `decode_access_token`.

**Rationale**: Without `aud`/`iss` validation, a token issued by any HS256 service sharing the secret could authenticate to this API (CWE-287: Improper Authentication). OWASP API Security Top 10 — API2:2023.

**Constants**: `JWT_AUDIENCE` and `JWT_ISSUER` exported from `auth/jwt.rs` for use in tests and future token consumers.

**Status**: IMPLEMENTED

---

## D-7: Kakao app_id Verification (STEP 32-1)

**Decision**: Before calling `/v2/user/me`, call `kapi.kakao.com/v1/user/access_token_info` to validate the token's `app_id` matches `KAKAO_REST_API_KEY`.

**Rationale**: Attacker could obtain a valid Kakao token from a different app and reuse it against this service. `app_id` verification ensures the token was issued for our app. Only applies when `kakao_rest_api_key` is set in config.

**Trade-off**: Extra HTTP round-trip per login. Acceptable because login is infrequent and the security benefit is significant.

**Status**: IMPLEMENTED

---

## D-8: search q.chars().count() (STEP 32-3)

**Decision**: Replace `q.len() > 100` with `q.chars().count() > 100` in `products.rs` search handler.

**Rationale**: Korean characters are 3 bytes each in UTF-8. `len()` counts bytes, not characters. A 34-character Korean query would incorrectly exceed the 100-byte limit, rejecting valid input.

**Status**: IMPLEMENTED (also already fixed in alert_service and device_service in earlier steps)

---

## D-9: Crawler UA Pool Update (STEP 32-4)

**Decision**: Update all 12 User-Agent strings to 2026-03 browser versions (Chrome 133, Firefox 135, Safari 18.3, Edge 133, Samsung Internet 27, Whale 4.30).

**Rationale**: Stale UAs from 2024 increase CAPTCHA detection risk. Browser UAs are typically 6-12 months ahead of server versions used by bots.

**Status**: IMPLEMENTED

---

## D-10: IPv6 ULA Detection (STEP 32-5)

**Decision**: Add `fc00::/7` (IPv6 ULA) detection to `is_private_ip()` in `main.rs`.

**Rationale**: IPv6 Unique Local Addresses (RFC 4193) are private but `Ipv6Addr::is_loopback()` only matches `::1`. Without this, a request from `fd00::1` (a private IPv6 address) could access `/metrics`.

**Status**: IMPLEMENTED

---

## D-11: Dynamic Crawler Semaphore (STEP 33-1)

**Decision**: Replace hardcoded `Semaphore::new(8)` with `((db_max_connections * 0.6) as usize).clamp(2, 8)`.

**Rationale**: With `DATABASE_MAX_CONNECTIONS=5` (default), 8 concurrent crawlers could exhaust the pool. Dynamic calculation reserves 40% of the pool for API requests.

**Status**: IMPLEMENTED — `CrawlerService::new()` now takes `db_max_connections: u32`

---

## D-12: Partition Pruning for price_history (STEP 33-2)

**Decision**: Add `AND recorded_at >= NOW() - INTERVAL '1 year'` to the MIN(recorded_at) subquery in `refresh_product_stats` and `refresh_product_stats_with_metadata`.

**Rationale**: Without a time bound, PostgreSQL scans all partitions to find the minimum date. With the bound, it prunes to the last 2 partitions at most. Lowest-price events older than 1 year are edge cases that don't affect user-visible buy signals.

**Status**: IMPLEMENTED

---

## D-13: Single-Query Upsert for add_product_by_url (STEP 33-3)

**Decision**: Replace INSERT-DO-NOTHING + separate SELECT with `INSERT … ON CONFLICT DO UPDATE SET updated_at = NOW() RETURNING *`.

**Rationale**: Two-query approach had a TOCTOU gap and doubled DB round-trips. `DO UPDATE` ensures RETURNING always returns a row (both insert and conflict paths). `updated_at = NOW()` is a no-op semantically but required to satisfy PostgreSQL's RETURNING constraint on conflict paths.

**Status**: IMPLEMENTED

---

## D-14: Lazy ensure_product_exists (STEP 33-4)

**Decision**: Remove upfront `ensure_product_exists()` calls from `get_price_history` and `get_daily_price_aggregates`. Check existence only when the result set is empty AND cursor is None.

**Rationale**: >99% of requests are for valid products that have data. The existence check was wasted for these cases. The lazy check still returns 404 for invalid product IDs on first page requests.

**Status**: IMPLEMENTED

---

## D-15: validate_device_token Pure Function (STEP 34-1)

**Decision**: Extract the `trim` + length validation logic from `register_device` into a standalone `validate_device_token(raw: &str) -> Result<&str, AppError>` function.

**Rationale**: Pure functions are testable without a database. Enables 6 unit tests to run in ~0ms. Pattern follows `alert_service` where validate functions are extracted for testability.

**Status**: IMPLEMENTED — 6 tests added, total: 147

---

## D-16: Cursor Pagination for All Sort Modes (STEP 34-2)

**Decision**: Remove `matches!(sort, None | Some("ranking"))` restriction on cursor use. All sort modes now use `AND id < $2`.

**Rationale**: All ORDER BY clauses include `id DESC` as a secondary sort key, which guarantees stable ordering and prevents duplicates. The old restriction meant non-ranking sorts returned all results on page 1 (ignoring cursor), breaking pagination.

**Trade-off**: Non-id sorts may skip items when prices change between pages (cursor is `id`-based, not value-based). Documented in comment. Acceptable for this use case.

**Status**: IMPLEMENTED

---

## D-17: utoipa Dead Dependency Removed (STEP 35-1)

**Decision**: Remove `utoipa = "5.4.0"` from Cargo.toml.

**Rationale**: Added in STEP 31 but never used in source. Dead dependencies increase compile time and surface area. Re-add when OpenAPI annotation work is explicitly scheduled.

**Status**: IMPLEMENTED

---

## D-18: JWT_ACCESS_TTL_SECS Default Changed

**Decision**: Change `.env.example` default from `1800` (30 min) to `300` (5 min).

**Rationale**: Shorter access token TTL reduces the window for token misuse. Refresh tokens (7 days) handle session continuity. 5 minutes is industry standard for high-security APIs.

**Status**: IMPLEMENTED (example only — production value set via environment)

# Night-06 Session (2026-03-06) — STEP 49

## D-19: reward_service.rs 신규 설계

**Decision**: `reward_service.rs`를 신규 서비스 모듈로 생성, 일일 룰렛 + 잔액 조회 + 추천 보상 처리 포함.

**Rationale**: v0.8 보상 체계 문서가 STEP 48a에서 완성됐으나 서버/앱 구현이 누락. 단일 트랜잭션으로 원자성 보장(잔액+출석기록+월한도 동시 변경). 순수 함수 `assign_monthly_cap`/`spin_roulette` 추출로 단위 테스트 가능.

**Status**: IMPLEMENTED — 테스트 4건 추가 (총 151건)

---

## D-20: user_monthly_checkin_caps Lazy 생성 전략

**Decision**: 월 첫 출석 시 `user_monthly_checkin_caps` 레코드를 lazy INSERT.

**Rationale**: 모든 사용자의 매월 레코드를 사전에 생성하면 batch job이 필요. Lazy 생성은 단순하고 에러 없이 동작. `UNIQUE(user_id, year_month)` 제약으로 race condition 방지.

**Trade-off**: 첫 출석 시 쿼리 1건 추가되지만, 이후 모든 출석은 레코드가 존재해 분기 없음.

**Status**: IMPLEMENTED

---

## D-21: reward_stage SMALLINT 단일 상태

**Decision**: `referrals` 테이블의 `referrer_rewarded/referred_rewarded` BOOLEAN 2개 → `reward_stage SMALLINT(0~2)` 단일 컬럼으로 교체.

**Rationale**: BOOLEAN 2개로는 "초대자 보상 완료 but 피초대자 미완료" 같은 불일치 상태가 가능. SMALLINT 단일 상태머신으로 정확한 진행 단계를 표현하고 `CHECK(0~2)` 제약으로 무결성 보장.

**Status**: IMPLEMENTED (migration 013)

---

# Night-07 Session (2026-03-07) — STEP 53

## D-19: Merge auto/night-01-20260306_0100 (STEP 49-52) into current branch

**Decision**: Merge STEP 49-52 commits from previous night branch before implementing STEP 53.

**Rationale**: Current branch (auto/night-01-20260307_0100) was branched from main at STEP 48a.
STEP 53 (theme centralization) depends on RewardService/PointHistoryScreen (STEP 50),
Phase A/B/C fixes (STEP 51), and accessibility labels (STEP 52) which are on the previous night branch.
PLAN_01.md was not present; STEP 53 implementation plan found at `docs/plans/2026-03-06-step53-implementation.md`.

**Status**: IMPLEMENTED — fast-forward merge, 15 commits ahead of main incorporated.

---

# Night-13 Session (2026-03-12) — auth_service 테스트 보강 + PLAN_01.md

## D-25: PLAN_01.md 도입

**Decision**: `PLAN_01.md`를 저장소 루트에 생성하여 야간 세션의 작업 범위를 명시.

**Rationale**: MORNING_BRIEFING.md(U-4)에서 지적한 대로, 야간 세션이 PLAN_01.md 부재 시 자율 추론하여 중복/불필요 작업이 발생함. 이 파일 도입으로 세션이 명시된 항목만 수행하도록 제약.

**규칙**: 마이그레이션 019/020이 `fix/phase0-security-stability`에만 존재하므로, 야간 세션은 그 브랜치 머지 전까지 DB 마이그레이션 추가 금지.

**Status**: IMPLEMENTED

---

## D-27: notification/product/reward_service 순수 함수 추출 + 단위 테스트 15건 (Night-14)

**Decision**: 3개 서비스에서 비즈니스 로직을 순수 함수로 추출하고 단위 테스트 15건 추가.

**추출 함수**:
- `build_deep_link(ntype, id) -> String` (notification_service): NotificationType × id → 딥링크 URL
- `build_search_pattern(query) -> String` (product_service): ILIKE 와일드카드 이스케이프 + 패턴 래핑
- `compute_referral_rewards(stage) -> Option<(i16, i32, i32)>` (reward_service): stage 분기 → 보상금액 순수 변환

**Rationale**:
1. PLAN_01.md Phase 1-B 이행: notification(3→8), product(6→12), reward(10→14)
2. `build_search_pattern`: ILIKE 이스케이프 누락 시 SQL injection-like 결과 발생 가능 — 분리로 독립 검증
3. `compute_referral_rewards`: 보상 규칙(Stage 0→1: 초대자 2¢/피초대자 1¢)을 DB 없이 테스트 가능
4. `process_referral_purchase` 내부 match를 `compute_referral_rewards` 호출로 교체 — 단일 진실 원천

**Status**: IMPLEMENTED — Rust lib 176 → 191건 (+15), clippy 0경고, fmt 통과

---

## D-26: auth_service 순수 함수 추출 + 단위 테스트 17건

**Decision**: `auth_service.rs`에서 두 가지 validation 로직을 순수 함수로 추출하고 단위 테스트 17건 추가.

**추출 함수**:
- `validate_consent(terms_agreed, privacy_agreed) -> Result<(), AppError>`: 동의 검증 — `upsert_user`에서 중복 코드 제거
- `is_valid_referral_code_format(code: &str) -> bool`: GAP-XXXXXX 형식 검증 — `find_referrer_by_code`에서 사용

**Rationale**:
1. 로드맵 Phase 2 P0 항목(auth_service 테스트) 이행
2. Night-08 M-3(GAP- 형식 검증)이 main에 미머지 상태 → 이번에 재구현
3. `device_service.rs`의 `validate_device_token` 패턴 일관 적용

**Trade-off**: DB 의존 함수(upsert_user, rotate_refresh_token 등)는 통합 테스트 범주 — 이번 세션에서는 순수 함수만 추출

**Status**: IMPLEMENTED — Rust lib 159 → 176건 (+17), clippy 0경고, Flutter 164건 유지

---

# Night-14 Session (2026-03-14) — Silent Failure 제거 + Flutter 접근성

## D-28: Silent Failure 10건 → 로깅 보강 (Phase 1-A)

**Decision**: 서버에서 에러를 조용히 무시하는 패턴 10건을 찾아 로깅 보강 처리.

**변경 파일**: `crawlers/mod.rs`, `services/reward_service.rs`, `services/product_service.rs`, `api/routes/products.rs`, `api/routes/notifications.rs`

**핵심 패턴**:
1. `unwrap_or(false)` (advisory lock DB 에러) → `Err(e)` 분기 + `tracing::error!` 후 early return
2. `unwrap_or(0)` (잔액 조회 실패) → `unwrap_or_else` + `tracing::warn!`
3. `map_err(|_|)` (URL 파싱) → `tracing::debug!` 추가
4. cursor `.and_then(|c| c.parse::<i64>().ok())` → `.transpose()?` 로 400 에러 반환
5. 스크래퍼 태스크 패닉 → `Err(join_err)` 분기 + `tracing::error!`
6. 알림 평가 실패 `warn` → `error` (Sentry 캡처 대상으로 격상)

**Status**: IMPLEMENTED — Rust lib 191건 통과, clippy 0경고

---

## D-29: CrawlError::Aborted 신규 Variant (Phase 1-C)

**Decision**: 매직 넘버 `CrawlError::Blocked(0)` → 의미 있는 `CrawlError::Aborted` variant로 교체.

**Rationale**: `Blocked(0)`은 "0개 블록 → 아직 감지 안됨"처럼 읽힐 수 있어 혼란스러움. `Aborted`는 전역 abort 플래그로 인한 조기 종료임을 명확히 표현.

**Status**: IMPLEMENTED

---

## D-30: AppError #[non_exhaustive] 적용 (Phase 1-C)

**Decision**: `AppError` 열거형에 `#[non_exhaustive]` 속성 추가.

**Rationale**: 외부 크레이트가 `AppError`를 exhaustive match하면 새 variant 추가 시 컴파일 에러 발생. `#[non_exhaustive]`로 방지. 라이브러리 설계 모범 사례.

**Status**: IMPLEMENTED

---

## D-31: Flutter 접근성 강화 — Semantics 3개 화면 (Phase 2-C)

**변경 내역**:
- `SearchScreen`: 빈 상태 텍스트 + 로딩 인디케이터 `Semantics(label: ...)`, `IconButton tooltip` 추가
- `AlertScreen`: 로딩 인디케이터 Semantics 랩, Dismissible 배경 `Semantics(label: '알림 삭제')`
- `NotificationListScreen`: 타일 전체 `Semantics(label: '${title}, 읽음/읽지 않음')` 랩
- Phase 2-A: `_showAddByUrlDialog` + `_showAlertSetup` → async + `try/finally` 패턴 (controller 항상 dispose 보장)

**Status**: IMPLEMENTED — flutter analyze 0 이슈, flutter test 164건 통과

---

# Night-15 Session (2026-03-15) — 잔여 이슈 F2~F8, S8

## D-34: api_endpoints.dart trailing slash 제거 + 테스트 동기화

**Decision**: `alerts`, `notifications`, `devices` 엔드포인트 상수에서 trailing slash 제거. 테스트 mock URL도 동기화.

**변경 전**: `'$_v1/alerts/'` / `'$_v1/notifications/'` / `'$_v1/devices/'`
**변경 후**: `'$_v1/alerts'` / `'$_v1/notifications'` / `'$_v1/devices'`

**Rationale**: REST API 경로 일관성 — 나머지 32개 엔드포인트는 trailing slash 없음. Axum 라우터는 trailing slash 없이 등록되므로 이 3개만 trailing slash 있으면 서버 404 위험 (Axum은 기본적으로 trailing slash redirect를 하지 않음).

**영향**: `alert_service_test.dart`, `notification_service_test.dart`, `device_service_test.dart` mock URL 동시 수정. Flutter test 164건 통과 확인.

**Status**: IMPLEMENTED

---

## D-35: build_runner ^4.0.0 업그레이드 불가 (보류)

**Decision**: build_runner `^2.4.0` → `^4.0.0` 시도했으나 해당 버전 미존재. 원복 (`^2.4.0` 유지).

**근거**: pub.dev에서 build_runner 4.x 버전이 존재하지 않음 (2026-03-15 기준). flutter pub add 결과: "doesn't match any versions". S9 항목의 원본 요구사항이 비현실적인 버전 번호였음.

**향후 조치**: build_runner 2.x 최신 버전 확인 후 범위 확대 (`^2.4.0` → `>=2.4.0 <3.0.0`) 또는 pub.dev 공식 릴리즈 대기.

**Status**: 보류 — build_runner 현행 유지

---

## D-32: CheckinResult 열거형 재구조화 (보류)

**현재**: `CheckinResult { rewarded: bool, cents_earned: i32 }` 구조체.

**제안**: `AlreadyCheckedIn | Rewarded { cents_earned, new_balance } | Missed { new_balance }` 열거형.

**보류 이유**: API 응답 직렬화 + Flutter 모델 동시 수정 필요. 현재 작동에 문제 없음.

---

## D-33: productDetailProvider keepAlive 5분 캐시 (보류)

**제안**: 상품 상세 provider에 5분 keepAlive 추가 → 뒤로가기 후 재진입 시 네트워크 절감.

**보류 이유**: 가격 데이터 실시간성과 상충 가능. 제품 결정 필요.

---

# Night-16 Session (2026-03-16) — PRE-GATE 결정 + Night-15 커밋

## D-36: MCP 마이그레이션 결정 (PRE-GATE)

**Decision**: C — 마이그레이션 스킵. 모든 외부 문서 참조는 WebSearch/WebFetch 사용.

**Rationale**: pullcents→gapttuk MCP 마이그레이션은 현재 세션에 영향이 없고, WebSearch/WebFetch로 동일한 결과를 얻을 수 있음. 다음 Claude 세션 시작 시 수동으로 복사하는 것이 더 안전.

**Status**: SKIPPED

---

## D-37: Night-15 unstaged 커밋 방향 (PRE-GATE)

**Decision**: A — 별도 커밋 생성. Night-14 커밋과 분리하여 히스토리 추적성 유지.

**Rationale**: Night-15 변경사항(15파일, +511/-187)은 Night-14와 논리적으로 분리된 작업(잔여 이슈 소진). amend 대신 신규 커밋으로 히스토리를 명확히 유지.

**Status**: IMPLEMENTED

---

## D-38: Night-16 최적화 범위 (PRE-GATE)

**Decision**: A — 서버+Flutter 균형. Phase 1 분석 후 CRITICAL/HIGH에 집중.

**Rationale**: 단일 영역 집중은 기술 부채를 한쪽에 축적함. 균형 접근이 전체 품질 향상에 유리.

**Status**: CONFIRMED

---

## D-39: E2E 테스트 착수 여부 (PRE-GATE)

**Decision**: B — 다음 세션으로 이연. 이번 세션은 코드 품질 최적화에 집중.

**Rationale**: Flutter Web E2E 테스트는 별도 환경(Chromium) 설정이 필요. 현재 세션의 Phase 2 최적화가 먼저 완료되어야 E2E 기반이 안정적.

**Status**: DEFERRED

---

## D-40: Ralph Loop 시작 여부 (PRE-GATE)

**Decision**: C — 수동만. Ralph Loop 미사용.

**Rationale**: 이번 세션은 단순 반복 모니터링보다 심층 분석 + 코드 수정이 주 목적. Ralph Loop는 장기 모니터링 세션에 더 적합.

**Status**: SKIPPED

---

# Night-17 Session (2026-03-17) — 타입 안전성 + Flutter 관측성

## D-41: is_valid_referral_code_format len() → chars().count() 적용

**Decision**: `code.len() != 10` → `code.chars().count() != 10`으로 변경.

**Rationale**: Rust `str::len()`은 바이트 길이를 반환. "GAP-ÄÄ" 같은 멀티바이트 문자 포함 코드가 바이트 수는 10이지만 문자 수는 10 미만일 때 길이 검사를 통과할 수 있음. `chars().all(is_ascii)` 최종 검사가 방어하지만, `chars().count()`가 의도를 명확히 표현. Night-13 서버 수정(chars().count() for keyword search)과 동일한 컨벤션 유지.

**Status**: IMPLEMENTED

---

## Night-56 결정 (2026-05-04) — PLAN_01 Phase 15 NaverSearch 실시간 데이터 파이프라인

> **Sonnet 4.6 Sub-agent** 결정 | Opus Main Agent 검토 필요

### D-97: CoinInfo 암호화폐 가격 추적 확장

**Decision**: **B: 미포함**

**Rationale**: 값뚝은 생활 쇼핑(생활용품/식품/가전) 가격 추적 서비스. 암호화폐는 도메인 외. CoinInfo/cryptoGuardian MCP는 Phase 15 범위 밖.

**Status**: DECIDED — 사용자 확인 시 번복 가능

---

### D-98: OpenDart 기업 재무 데이터 연동

**Decision**: **B: 미포함**

**Rationale**: 기업 재무 지표는 소비자 가격 추적과 직접 관련 없음.

**Status**: DECIDED — 사용자 확인 시 번복 가능

---

### D-99: NaverSearch 수집 카테고리 (A: 3종)

**Decision**: **A: 생활용품+식품+가전**

**실측 카테고리 코드**: 생활용품=50001780, 식품=50000215, 디지털/가전=50000151

**6개월 트렌드**: 디지털/가전 ratio=100(1월), 생활용품=7.08(2월 명절), 식품=1.3~1.8(안정)

**주의**: datalab_shopping_keywords 400 오류 — leaf-node 코드 거부, 중분류 코드 별도 필요.

**Status**: DECIDED

---

### D-100: 15-B 코드 생성 범위 (A: 전체 B1-B5)

**Decision**: **A: 전체**

**생성 파일**: naver_price_service.rs / 019_naver_category_mapping.sql / trend_data_service.rs / naver_trend_provider.dart / trend_chart.dart

**Status**: DECIDED

---

## D-42: _transactionLabel 'referral_welcome_referrer' 케이스 추가

**Decision**: `point_history_screen.dart`의 `_transactionLabel` switch에 `'referral_welcome_referrer' => '추천인 웰컴 보상'` 추가.

**Rationale**: `auth_service.rs`의 `upsert_user`에서 추천 코드 가입 시 추천인(referrer)에게 `add_points_and_record(pool, referrer_id, 1, "referral_welcome_referrer", ...)` 로 포인트 지급. 이 트랜잭션 타입이 `_transactionLabel` switch에 없어 raw 영문 문자열 `"referral_welcome_referrer"`가 UI에 노출되는 버그. 아키텍처 에이전트가 발견.

**Impact**: 사용자 대면 버그 수정 — 추천인의 포인트 내역에서 "추천인 웰컴 보상"으로 정상 표시.

**Status**: IMPLEMENTED

---

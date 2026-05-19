# NIGHT_06_RESULT — Night-59 (2026-05-07)

> **Phase 17: 아키텍처 고도화 + 문서 품질 (feature-dev + HuggingFace)**
> **실행자**: Sonnet 4.6 Sub-agent
> **브랜치**: `auto/night-01-20260507_0100`
> **베이스라인**: Flutter **370건** ✅ | Rust **216건** ✅ | analyze 0건 ✅

---

## 실행 요약

| 항목 | 결과 |
|------|------|
| Phase 17 아키텍처 분석 | ✅ feature-dev 3대 병렬 실행 완료 |
| HuggingFace MCP | ⚠️ axum/riverpod 직접 문서 없음 (ML 플랫폼 특성) — 가격 예측 논문 3건 확인 |
| 발견 이슈 | H-1(1건) + M-1(1건) + M-2(1건) |
| 즉시 수정 | M-1 수정 완료 (1건) |
| 신규 결정 포인트 | D-104~D-106 (3건) |
| Flutter 테스트 | 370건 유지 (변경 없음, M-1 수정은 테스트 격리 개선) |
| Rust 테스트 | 216건 유지 (코드 변경 없음) |

---

## Phase 17-A: feature-dev 병렬 분석 결과

### 17-A1: code-explorer — 의존성 맵

#### 아키텍처 다이어그램

```
[Flutter 앱]
  ProductDetailScreen
    ├── ref.watch(productDetailProvider(42))    → ProductService → GET /products/{id}
    └── ref.watch(categoryTrendsProvider)       → NaverTrendService → GET /api/v1/trends/naver

[Rust 서버]
  GET /api/v1/trends/naver
    └── get_naver_trends()  ← ❌ State<AppState> 미추출
            └── trend_data_service::get_default_category_trends()
                    └── TREND_CLIENT (OnceLock, 15s) ← ❌ AppState.http_client와 별개
                            → POST Naver Datalab API (매 요청마다 직접 호출)
                                    → Vec<CategoryTrendScore>

  naver_price_service.rs  ← ❌ 어떤 라우트에서도 미호출 (고아 모듈)
    └── NAVER_CLIENT (OnceLock, 10s) ← ❌ 별도 커넥션 풀
```

#### 발견된 구조적 패턴 불일치 (5건)

| # | 불일치 | 위치 |
|---|--------|------|
| P-1 | `get_naver_trends()`가 `State<AppState>` 미추출 — 기존 핸들러와 달리 DI 우회 | `trends.rs:15` |
| P-2 | `naver_price_service`가 어떤 라우트에서도 호출되지 않음 | `services/mod.rs:5` |
| P-3 | 두 독립 OnceLock 클라이언트 (NAVER_CLIENT 10s, TREND_CLIENT 15s) vs AppState.http_client 30s | 두 서비스 파일 |
| P-4 | Naver 자격증명이 두 서비스에서 각각 `env::var()` 직접 호출 — Config 단일 진실 원천 우회 | `trend_data_service.rs:100-103` |
| P-5 | `trends.rs` 엔드포인트에 rate limit 없음 — 인증도 없는 공개 엔드포인트로 Naver API quota 소진 공격 가능 | `main.rs:523` |

#### 캐싱 갭

| # | 갭 | 영향 |
|---|---|------|
| C-1 | 서버: trend_data 캐시 없음 — 매 요청마다 Datalab API 호출 | API 쿼터 소진 |
| C-2 | thundering herd 방어 없음 — 동시 요청 N번 API 호출 | rate limit 초과 |
| C-3 | Flutter: categoryTrendsProvider auto-dispose — 화면 재방문 시마다 재요청 | C-1과 중첩 |

### 17-A2: code-architect — 아키텍처 청사진

#### 권장 아키텍처 (D-104=A, D-105=B, D-106=B 적용 후)

```
[서버 시작]
  t=0s  → h_trend 배치 태스크 즉시 tick → Datalab API 1회 → cache.trend_data["default"] 웜업
  t=1h  → 재호출 → 캐시 갱신 (24시간 이내 반복)

[Flutter 요청 흐름]
  GET /api/v1/trends/naver
    → trends::get_naver_trends(State<AppState>)      ← D-106: AppState 주입
            → cache.trend_data.try_get_with("default", ...)  ← D-104: moka 캐시
            → 히트: ~1ms 즉시 반환
            → 미스: get_default_category_trends_cached()
                    → Naver Datalab API (~500ms)
                    → 결과 캐시 저장 (TTL 24h)

AppCache 확장:
  기존 4개: blocked_ips | popular_searches | products | predictions
  신규 1개: trend_data (Cache<String, Vec<CategoryTrendScore>>, TTL 24h, max 50)
```

#### 구현 범위 (D-104=A, D-105=B, D-106=B 가정)

| 파일 | 변경 | 줄 수 |
|------|------|-------|
| `server/src/cache.rs` | trend_data 필드 + builder + metric | +15줄 |
| `server/src/services/trend_data_service.rs` | OnceLock 제거, 파라미터 주입, cached/inner 분리 | +40/-5줄 |
| `server/src/api/routes/trends.rs` | State<AppState> 추가, 캐시 경유 호출 | +5줄 |
| `server/src/main.rs` | h_trend 배치 태스크 + watcher 등록 | +35줄 |
| Flutter 앱 | 변경 없음 | 0 |
| **합계** | — | **~90줄** |

**기존 테스트 영향**: compute_trend_score 4건(pure function) + 직렬화 2건 = 영향 없음 ✅

### 17-A3: code-reviewer — 코드 품질 검증

#### CRITICAL (0건) ✅

#### HIGH (1건)

| ID | 파일:라인 | 내용 | 심각도 |
|----|----------|------|--------|
| H-1 | `trends.rs:15-17`, `trend_data_service.rs:97-146` | 캐싱 없이 매 요청마다 Naver Datalab API 직접 호출 — API 쿼터 소진 위험 | HIGH |

#### MEDIUM (2건)

| ID | 파일:라인 | 내용 | 처리 |
|----|----------|------|------|
| M-1 | `product_detail_screen_test.dart:92-110` | 에러 테스트에서 `categoryTrendsProvider` override 누락 → CI 불안정 | ✅ **Night-59 수정 완료** |
| M-2 | `naver_price_service.rs:77`, `trend_data_service.rs:7` | 두 OnceLock 클라이언트 타임아웃 불일치 (10s vs 15s) — D-106 수정 시 함께 해소 | ⏳ D-106 결정 후 처리 |

#### M-1 수정 내용

**변경 전** (`product_detail_screen_test.dart:92-110`):
```dart
// categoryTrendsProvider override 없음 → 실제 네트워크 경로 실행 가능
await tester.pumpWidget(ProviderScope(
  overrides: [
    productDetailProvider(productId).overrideWith(...),
    dailyPricesProvider(productId).overrideWith(...),
    productPredictionProvider(productId).overrideWith(...),
    // ❌ categoryTrendsProvider 누락
  ],
  ...
));
```

**변경 후** (`product_detail_screen_test.dart:92-101`):
```dart
// buildScreen() 헬퍼 사용 → categoryTrendsProvider override 자동 포함
await tester.pumpWidget(buildScreen(
  productFuture: Future(() async { throw Exception('네트워크 오류'); }),
));
```

---

## Phase 17-B: HuggingFace MCP 결과

| 검색 쿼리 | 결과 | 활용도 |
|----------|------|--------|
| "axum service layer pattern" | ML 라이브러리 문서 (비해당) | 없음 — HuggingFace는 웹 프레임워크 문서 미보유 |
| "riverpod async notifier caching" | Diffusers/TGI 캐시 문서 (비해당) | 없음 |
| hub_repo_search "price tracking flutter rust" | 결과 없음 | 없음 |
| paper_search "e-commerce price prediction time series" | **LSTM 주가예측 논문 120건** | 낮음 — 주가 예측 중심, 소비재 가격 적용 간접 참조 가능 |

**결론**: HuggingFace는 ML/AI 플랫폼 특성상 Axum/Riverpod 웹 프레임워크 패턴 문서를 보유하지 않음. 프레임워크 패턴 조회는 WebSearch가 적합. 가격 예측 알고리즘(ai_prediction_service.rs 개선) 시 LSTM 논문 참조 가능.

---

## 신규 결정 포인트 (D-104~D-106)

| ID | 질문 | 권장 | 상태 |
|----|------|------|------|
| D-104 | NaverSearch 트렌드 캐시 전략? A)moka 확장 / B)Redis / C)하이브리드 | **A** | ⏳ 사용자 대기 |
| D-105 | NaverSearch 호출 빈도? A)실시간 / B)배치 1h / C)이벤트 기반 | **B** | ⏳ 사용자 대기 |
| D-106 | 서비스 계층 리팩토링? A)신규만 / B)AppState.http_client 공유 | **B** | ⏳ 사용자 대기 |

---

## 기존 결정 현황

| ID | 내용 | 상태 |
|----|------|------|
| D-101 | flutter_riverpod MINOR + riverpod_generator BREAKING | ⏳ 사용자 대기 |
| D-102 | BREAKING 5종 순차 처리 | ⏳ 사용자 대기 |
| D-103 | Rust BREAKING 불필요 | ✅ DECIDED |

---

## Night-59 총평

- **코드 변경**: M-1 테스트 격리 수정 1건 (10줄 → 3줄, 간결화)
- **아키텍처 분석**: Phase 15 신규 서비스의 구조적 갭 5건 + 캐싱 갭 3건 확인
- **다음 Phase**: D-104/D-105/D-106 사용자 결정 후 **Phase 17 코드 구현** (~90줄)
  - 우선: D-104(moka) + D-105(배치) 확정 시 `cache.rs` + `main.rs` 수정
  - 이후: D-106(공유 클라이언트) 확정 시 `trend_data_service.rs` + `trends.rs` 리팩토링
- **naver_price_service.rs 미연결**: Phase 17 또는 그 이후 세션에서 상품 가격 검증 라우트 연결 검토 필요 (D-107 추가 예정)

---

## 커밋 대상

| 파일 | 변경 내용 |
|------|----------|
| `app/test/screens/product_detail_screen_test.dart` | M-1 수정: categoryTrendsProvider override 추가 |
| `DECISION_LOG.md` | D-104/D-105/D-106/M-1 추가 |
| `docs/NIGHT_06_RESULT.md` | Night-59 결과 |
| `MORNING_BRIEFING.md` | Night-59 항목 추가 |

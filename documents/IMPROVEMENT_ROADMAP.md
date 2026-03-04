# 값뚝 개선 로드맵 — STEP 32~

> **작성일**: 2026-03-04 | **근거**: 종합 분석 (아키텍처·보안·성능 3-way 교차 검증)
> **분석 범위**: 서버 50개 파일(7,930줄) + 문서 12건 + 경쟁사 6사
> **분석 에이전트**: Opus 4.6(주) + Sonnet 4.6(서브에이전트 3개 병렬)

---

## 전체 로드맵 개요

```
현재 위치: STEP 31 완료 (M1 백엔드 ~95%)

STEP 32  ━━━━  [보안+버그 핫픽스] ────────────── 반나절
STEP 33  ━━━━  [성능 CRITICAL 수정] ─────────── 반나절
STEP 34  ━━━━  [테스트 커버리지 확대] ─────────── 1일
STEP 35  ━━━━  [OpenAPI + M1 마무리] ──────────── 1일
─── M1 완료 경계선 ───
STEP 36  ━━━━  [Flutter M2 스캐폴딩] ──────────── 3일
STEP 37+ ━━━━  [M2 Flutter 화면 구현] ─────────── 12주
```

---

## STEP 32: 보안 + 버그 핫픽스 (예상: 반나절)

### 32-1. [CRITICAL] 카카오/네이버 소셜 로그인 앱 키 검증

**문제**: 다른 카카오/네이버 앱에서 발급된 access_token으로도 로그인 가능
**OWASP**: A07:2021 — Identification and Authentication Failures

**카카오 수정안** (`auth/providers/kakao.rs`):
```rust
// 기존: 사용자 정보만 조회
// 수정: 토큰 정보 먼저 검증하여 app_id 확인
async fn verify_kakao_token(client: &reqwest::Client, access_token: &str, expected_app_id: &str) -> Result<(), AppError> {
    let resp = client
        .get("https://kapi.kakao.com/v1/user/access_token_info")
        .bearer_auth(access_token)
        .send()
        .await
        .map_err(|_| AppError::Unauthorized)?;

    if !resp.status().is_success() {
        return Err(AppError::Unauthorized);
    }

    #[derive(serde::Deserialize)]
    struct TokenInfo { app_id: i64 }

    let info: TokenInfo = resp.json().await.map_err(|_| AppError::Unauthorized)?;

    if info.app_id.to_string() != expected_app_id {
        tracing::warn!(app_id = info.app_id, "Kakao token from wrong app");
        return Err(AppError::Unauthorized);
    }
    Ok(())
}
```

**네이버 수정안** (`auth/providers/naver.rs`):
- 네이버 API는 `client_id`+`client_secret`으로 토큰 유효성 검증 불가
- 대안: 토큰 발급 시 `client_id` 검증은 클라이언트 측에서만 가능
- **서버 측 완화**: profile API 응답에서 반환된 `email`의 도메인 또는 `response.id` 일관성 확인
- 장기: 네이버 OIDC(id_token) 지원 시 전환 검토

**Config 추가 필요**:
```rust
// config.rs에 추가
pub kakao_rest_api_key: String,   // KAKAO_REST_API_KEY 환경변수
```

### 32-2. [CRITICAL] JWT access token에 aud/iss claim 추가

**문제**: 크로스-서비스 토큰 재사용 가능 (dev/prod 동일 secret 시)
**CWE**: CWE-287

**수정안** (`auth/jwt.rs`):
```rust
// Claims 구조체에 추가
#[derive(Serialize, Deserialize)]
pub struct Claims {
    pub sub: i64,
    pub exp: i64,
    pub iat: i64,
    pub aud: String,  // 추가: "gapttuk-api"
    pub iss: String,  // 추가: "gapttuk-server"
}

// encode_access_token 수정
let claims = Claims {
    sub: user_id,
    exp: now + ttl as i64,
    iat: now,
    aud: "gapttuk-api".to_string(),
    iss: "gapttuk-server".to_string(),
};

// decode 시 검증 추가
let mut validation = Validation::new(Algorithm::HS256);
validation.set_audience(&["gapttuk-api"]);
validation.set_issuer(&["gapttuk-server"]);
```

### 32-3. [HIGH] 검색어 바이트 검증 버그 수정

**문제**: `q.len() > 100` 바이트 검증 → 한글 34자에서 차단
**위치**: `api/routes/products.rs:104-108`

**수정안**:
```rust
// 변경 전
if q.len() > 100 {
// 변경 후
if q.chars().count() > 100 {
```

> 참고: alert_service에서는 이미 `chars().count()`로 수정 완료 (STEP 27a)

### 32-4. [HIGH] 크롤러 UA 풀 업데이트

**문제**: Chrome 124 (2024년) → 쿠팡 봇 탐지 위험 증가
**위치**: `crawlers/ua.rs`

**수정안**: Chrome 130+, Edge 131+, Safari 18+ 기준으로 갱신
```rust
static USER_AGENTS: &[&str] = &[
    // Windows - Chrome 131
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    // macOS - Chrome 131
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    // Windows - Edge 131
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0",
    // macOS - Safari 18
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15",
    // ... (12개 이상 유지)
];
```

### 32-5. [MEDIUM] /metrics IPv6 ULA 주소 차단

**문제**: IPv6 ULA(fc00::/7) 주소에서 Prometheus 메트릭 접근 가능
**위치**: `main.rs:51-56`

**수정안**:
```rust
fn is_private_ip(ip: IpAddr) -> bool {
    match ip {
        IpAddr::V4(v4) => v4.is_loopback() || v4.is_private(),
        IpAddr::V6(v6) => {
            v6.is_loopback()
                || { let segments = v6.segments(); segments[0] & 0xfe00 == 0xfc00 } // ULA fc00::/7
        }
    }
}
```

---

## STEP 33: 성능 CRITICAL 수정 (예상: 반나절)

### 33-1. [CRITICAL] DB 커넥션 풀 ↑ Semaphore ↓ 조정

**문제**: 풀 기본값 5 vs Semaphore 8 → 크롤링 시 커넥션 부족
**위치**: `db/mod.rs`, `crawlers/mod.rs`

**수정안**:
- `.env.example`에 `DATABASE_MAX_CONNECTIONS=15` 추가
- 또는 Semaphore를 `min(pool_max * 0.6, 8)` = 5로 축소

```rust
// crawlers/mod.rs에서 Semaphore를 config 기반으로
pub fn new(pool: sqlx::PgPool, cache: AppCache, push_client: Arc<PushClient>) -> Self {
    let pool_size = pool.options().get_max_connections();
    let concurrency = std::cmp::min((pool_size as f32 * 0.6) as usize, 8).max(2);
    // ...
    semaphore: Arc::new(Semaphore::new(concurrency)),
}
```

### 33-2. [CRITICAL] price_history 파티션 pruning 활성화

**문제**: `MIN(recorded_at)` 서브쿼리가 전체 파티션 스캔
**위치**: `crawlers/stats.rs:81-84`

**수정 방향 2가지**:

**방안 A** (권장): `products` 테이블에 `lowest_price_date` 캐싱
```sql
-- 마이그레이션 012
ALTER TABLE products ADD COLUMN lowest_price_date DATE;
```
```rust
// refresh_product_stats_with_metadata에서 서브쿼리 대신 직접 계산
// 새 최저가 갱신 시에만 lowest_price_date = today 설정
if new_price <= current_lowest {
    // products.lowest_price = new_price, lowest_price_date = NOW()::date
}
```

**방안 B**: recorded_at 범위 제한 (1년)
```sql
-- 서브쿼리에 파티션 pruning 힌트 추가
(SELECT MIN(ph.recorded_at) FROM price_history ph
 WHERE ph.product_id = $1
   AND ph.price = p.lowest_price
   AND ph.recorded_at >= NOW() - INTERVAL '1 year')
```

### 33-3. [HIGH] add_product_by_url 단일 쿼리화

**문제**: INSERT ON CONFLICT DO NOTHING + 별도 SELECT = 2 라운드트립
**위치**: `services/product_service.rs:237-259`

**수정안**:
```sql
INSERT INTO products (product_url, shopping_mall_id, product_name, ...)
VALUES ($1, $2, '가격 추적 대기 중', ...)
ON CONFLICT (product_url) DO UPDATE SET updated_at = NOW()
RETURNING *, (xmax = 0) AS is_new
```

### 33-4. [HIGH] ensure_product_exists 불필요 쿼리 제거

**문제**: get_price_history, get_daily_price_aggregates에서 매번 상품 존재 확인 쿼리 추가
**위치**: `services/product_service.rs:297,327`

**수정안**: 본 쿼리 결과가 0건이면 NotFound 반환 (별도 EXISTS 불필요)
```rust
// 기존
ensure_product_exists(pool, product_id).await?;
let rows = sqlx::query_as(...).fetch_all(pool).await?;

// 수정
let rows = sqlx::query_as(...).fetch_all(pool).await?;
if rows.is_empty() {
    // 상품 자체가 없는지 확인하는 최소 쿼리 (결과 0건일 때만)
    let exists: bool = sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM products WHERE id = $1)")
        .bind(product_id).fetch_one(pool).await?;
    if !exists { return Err(AppError::NotFound("상품".to_string())); }
}
```

### 33-5. [HIGH] popular_searches thundering herd 방어

**문제**: 캐시 미스 시 동시 DB 쿼리 다수 실행
**위치**: `services/product_service.rs:351-372`

**수정안**: `get` + `insert` → `try_get_with` 패턴 (ai_prediction과 동일)
```rust
pub async fn get_popular_searches(pool: &PgPool, cache: &AppCache, limit: usize) -> Result<Vec<PopularSearch>, AppError> {
    let all = cache.popular_searches
        .try_get_with("top".to_string(), async {
            let rows = sqlx::query_as::<_, PopularSearch>(
                "SELECT keyword, search_count FROM popular_searches ORDER BY search_count DESC LIMIT 50"
            )
            .fetch_all(pool)
            .await
            .map_err(|e| std::sync::Arc::new(e))?;
            Ok::<_, std::sync::Arc<sqlx::Error>>(rows)
        })
        .await
        .map_err(|e| AppError::Sqlx(sqlx::Error::Protocol(e.to_string())))?;

    Ok(all.into_iter().take(limit).collect())
}
```

### 33-6. [MEDIUM] access_log 배치 INSERT 전환

**문제**: 매 요청마다 `tokio::spawn` + DB INSERT → 커넥션 풀 경쟁
**위치**: `middleware/access_log.rs`

**수정 방향**: `tokio::sync::mpsc` 채널로 버퍼링 → 100건 또는 5초마다 배치 INSERT
```rust
// main.rs에서 채널 생성
let (log_tx, log_rx) = tokio::sync::mpsc::channel::<AccessLogEntry>(1000);

// access_log 미들웨어에서는 tx.send() (non-blocking)
// 별도 백그라운드 태스크에서 rx.recv() → 배치 INSERT
```

---

## STEP 34: 테스트 커버리지 확대 (예상: 1일)

### 34-1. device_service 유닛 테스트 (4건)
- `list_devices` — 정상 조회
- `register_device` — 빈 토큰 거부, 512자 초과 거부
- `toggle_push` — ON/OFF 토글

### 34-2. 통합테스트 확대 (12건+)
- `devices` 엔드포인트: register → list → toggle → unregister
- `alerts` 엔드포인트: create_price → list → toggle → delete
- `notifications` 엔드포인트: list → mark_read → unread_count

### 34-3. search_products 커서 페이지네이션 수정 + 테스트
- **버그**: 비-ranking 정렬 시 커서 무시
- **수정**: keyset 페이지네이션을 discount_rate 등에도 적용
- **테스트**: 커서로 2번째 페이지 조회 시 중복 없음 검증

---

## STEP 35: OpenAPI + M1 마무리 (예상: 1일)

### 35-1. utoipa 통합 또는 제거 결정
- **통합 시**: 주요 6개 엔드포인트에 `#[utoipa::path]` 매크로 추가
  - GET /products/:id, GET /products/search, POST /products/url
  - POST /auth/{provider}, POST /auth/refresh, GET /auth/me
- **제거 시**: Cargo.toml에서 utoipa 의존성 삭제

### 35-2. progress.md STEP 29~35 업데이트

### 35-3. M1 완료 체크리스트
- [ ] `cargo check` 0 errors
- [ ] `cargo clippy -- -D warnings` 0 warnings
- [ ] `cargo test` 전체 통과 (유닛 + 통합)
- [ ] `.env.example` 모든 변수 문서화
- [ ] Dead dependencies 0건

---

## M2 진입: STEP 36+ Flutter 앱 개발

### STEP 36: Flutter 스캐폴딩 (3일)

```bash
cd /home/code/gapttuk
flutter create --org com.gapttuk --project-name gapttuk_app app
```

**핵심 의존성** (pubspec.yaml):
```yaml
dependencies:
  flutter_riverpod: ^3.0.0    # 상태관리 (Mutations, auto-retry 지원)
  go_router: ^14.0.0           # 라우팅 (웹 딥링크)
  dio: ^5.0.0                  # HTTP 클라이언트
  fl_chart: ^0.70.0            # 가격 차트
  freezed_annotation: ^2.0.0   # 모델 코드 생성
  json_annotation: ^4.0.0
  flutter_secure_storage: ^9.0.0  # JWT 토큰 저장
  cached_network_image: ^3.0.0    # 이미지 캐싱
  shimmer: ^3.0.0                 # 로딩 스켈레톤
  intl: ^0.19.0                   # 숫자 포맷 (₩1,234)

dev_dependencies:
  freezed: ^2.0.0
  json_serializable: ^6.0.0
  build_runner: ^2.0.0
```

**디렉토리 구조**:
```
app/lib/
├── main.dart
├── config/
│   ├── router.dart          # GoRouter 21개 화면 경로
│   ├── theme.dart           # 라이트/다크 테마
│   └── constants.dart       # API URL, 기본값
├── models/                  # freezed 데이터 모델
│   ├── product.dart
│   ├── price_history.dart
│   ├── alert.dart
│   └── user.dart
├── providers/               # Riverpod 상태관리
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   └── alert_provider.dart
├── services/                # dio API 호출
│   ├── api_client.dart      # dio + JWT 인터셉터
│   ├── auth_service.dart
│   └── product_service.dart
├── screens/
│   ├── home/
│   ├── product/
│   ├── search/
│   ├── alert/
│   └── auth/
└── widgets/                 # 공용 위젯
    ├── product_card.dart
    ├── price_chart.dart
    └── loading_skeleton.dart
```

### M2 우선순위 (12주 → 핵심 3개 화면 먼저)

| 주차 | 화면 | 기능 | 차별화 연결 |
|------|------|------|------------|
| 1-2 | **HOME + SEARCH** | 인기검색어, 상품 카드, 필터/정렬 | 웹 풀기능 |
| 3-4 | **PRODUCT_DETAIL** | fl_chart 가격 그래프, 가격하락확률, 요일별 | 역대가+지니알림 기능 통합 |
| 5-6 | **ALERT_CENTER + SETTING** | 4단계 프리셋, 카테고리/키워드 패시브 | **핵심 차별점** |
| 7-8 | AUTH + ONBOARDING | 소셜 로그인 4종, JWT 연동 | - |
| 9-10 | FAVORITES + MY_PAGE | 즐겨찾기, 프로필, 설정 | - |
| 11-12 | WEB 대응 + 테스트 | 반응형, Web Push, Widget 테스트 | 웹 풀기능 |

---

## 차별화 전략 실행 타임라인

```
        M1 완료    M2 MVP       M3 베타   M4 출시    M5 확장
          ↓        ↓             ↓        ↓          ↓
   ══════╤════════╤═════════════╤════════╤══════════╤════════
STEP 32  │        │             │        │          │
~35      │        │             │        │          │
         │  STEP 36~            │        │          │
         │  Flutter 스캐폴딩    │        │          │
         │        │             │        │          │
         │        │  핵심 차별점 │        │          │
         │        │  패시브 알림 │        │          │
         │        │  가격 그래프 │        │          │
         │        │  검색+필터  │        │          │
         │        │             │        │          │
         │        │             │ QA     │          │
         │        │             │ 베타   │ 스토어   │ AI 예측
         │        │             │ 테스트 │ 출시    │ 센트(¢)
         │        │             │        │          │ 네이버
   ══════╧════════╧═════════════╧════════╧══════════╧════════
```

---

## 보안 체크리스트 (프로덕션 출시 전 필수)

- [ ] 카카오 앱 키 검증 (STEP 32-1)
- [ ] JWT aud/iss claim (STEP 32-2)
- [ ] `cargo audit` 실행 — CVE 0건 확인
- [ ] `.env` 파일 git history 확인 (커밋된 적 없는지)
- [ ] CORS `ALLOWED_ORIGINS` 프로덕션 설정
- [ ] `JWT_SECRET` 32자+ 무작위 생성
- [ ] DB 비밀번호 프로덕션용 교체 (현재 `glovis1234`)
- [ ] HTTPS 인증서 설정 (Cloudflare or Let's Encrypt)
- [ ] Sentry DSN 프로덕션 설정
- [ ] 쿠팡파트너스 API 키 확보 (블로커!)

---

## 성능 벤치마크 목표

| 지표 | 현재 | 목표 (M3) |
|------|------|----------|
| API P95 응답시간 | 미측정 | < 200ms |
| 크롤링 사이클 (1,800건) | ~90분 추정 | < 20분 |
| 앱 콜드스타트 | N/A | < 3초 |
| DB 커넥션 풀 활용률 | 5개 고정 | 15개, peak 70% |
| 메모리 (RSS) | 미측정 | < 128MB |

---

## 경쟁사 대비 차별화 핵심

### 폴센트(350만 DL) 대비 값뚝의 이길 수 있는 포인트

1. **모든 기능 무료** — 폴센트 프리미엄 연 ~9,900원 vs 값뚝 0원
2. **패시브 인텔리전스** — 카테고리/키워드 1번 등록 → 영구 자동 모니터링
3. **웹 풀기능** — 폴센트는 웹 기능 심하게 제한, 값뚝은 Flutter Web으로 풀기능
4. **경쟁사 장점 통합** — 역대가(하락확률) + 지니알림(N일최저가) + 로우차트(필터/정렬)

### 폴센트 대비 이기기 어려운 포인트 (인정 + 대응)

1. **사용자 기반** — 350만 vs 0 → 초기 바이럴(센트 보상)에 집중
2. **데이터 축적** — 폴센트 2022~, 값뚝 2026~ → 크롤링 히스토리 단기 열세
3. **카드 할인가** — 폴센트 독자 기능 → M5에서 구현 예정
4. **앱스토어 평점** — 4.9★ → 최초 출시 품질이 사활

---

> 이 문서는 종합 분석 결과를 기반으로 작성되었으며,
> 각 STEP은 독립적으로 실행 가능하도록 설계되었습니다.
> 실행 전 반드시 해당 STEP의 수정 대상 파일을 최신 상태로 Read한 후 진행하세요.

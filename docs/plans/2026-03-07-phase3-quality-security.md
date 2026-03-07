# Phase 3: Quality & Security Fixes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** CRITICAL 4건 + HIGH 7건 보안/품질 결함을 수정하여 프로덕션 배포 가능한 상태로 만든다

**Architecture:** 서버 보안(IP 신뢰체인, 접근 로그, 추천 보상, 알림 중복 방지) + Flutter UI 결함(CancelToken, dispose, 에러 표시) + CI 보안 스캔 추가. 각 태스크는 독립적이며 순서대로 적용.

**Tech Stack:** Rust/Axum/SQLx (서버), Flutter/Dart (클라이언트), GitHub Actions (CI)

---

## Task 1: 서버 — TRUSTED_PROXIES XFF 검증 (C-1)

**Files:**
- Modify: `server/src/config.rs`
- Modify: `server/src/middleware/bot_guard.rs`
- Modify: `server/.env.example`

**Step 1: Config에 trusted_proxies 필드 추가**

`server/src/config.rs` — `Config` struct에 필드 추가:

```rust
// --- 보안 ---
pub trusted_proxies: Vec<IpNetwork>,
```

import 추가: `use ipnetwork::IpNetwork;`

`Config::load()`의 `Self { ... }` 블록에 추가:

```rust
trusted_proxies: env::var("TRUSTED_PROXIES")
    .ok()
    .filter(|v| !v.is_empty())
    .map(|v| {
        v.split(',')
            .filter_map(|s| {
                let s = s.trim();
                s.parse::<IpNetwork>().map_err(|e| {
                    tracing::warn!(value = %s, error = %e, "Invalid TRUSTED_PROXIES entry — skipping");
                    e
                }).ok()
            })
            .collect()
    })
    .unwrap_or_default(),
```

`test_config()`에도 추가: `trusted_proxies: vec![],`

`config_debug_redacts_secrets` 테스트의 Config 리터럴에도 추가: `trusted_proxies: vec![],`

**Step 2: extract_client_ip에 프록시 검증 로직 추가**

`server/src/middleware/bot_guard.rs` — `extract_client_ip` 시그니처 변경:

```rust
fn extract_client_ip(
    req: &Request,
    fallback: std::net::IpAddr,
    trusted_proxies: &[ipnetwork::IpNetwork],
) -> std::net::IpAddr {
    // trusted_proxies가 비어있으면 → 기존 동작 (XFF 첫번째 IP 신뢰, 개발 호환)
    // trusted_proxies가 있으면 → fallback(ConnectInfo)이 trusted 범위에 있을 때만 XFF 파싱
    let trust_xff = trusted_proxies.is_empty()
        || trusted_proxies.iter().any(|net| net.contains(fallback));

    if trust_xff {
        if let Some(xff) = req
            .headers()
            .get("x-forwarded-for")
            .and_then(|v| v.to_str().ok())
        {
            if let Some(first) = xff.split(',').next() {
                if let Ok(ip) = first.trim().parse::<std::net::IpAddr>() {
                    return ip;
                }
            }
        }
        if let Some(xri) = req.headers().get("x-real-ip").and_then(|v| v.to_str().ok()) {
            if let Ok(ip) = xri.trim().parse::<std::net::IpAddr>() {
                return ip;
            }
        }
    }
    fallback
}
```

`bot_guard` 함수의 호출부 변경:

```rust
let client_ip = extract_client_ip(&req, addr.ip(), &state.config.trusted_proxies);
```

**Step 3: 기존 테스트 업데이트 + 신규 테스트 추가**

기존 `extract_client_ip_xff`, `extract_client_ip_x_real_ip`, `extract_client_ip_fallback` 테스트의 호출부에 `&[]` 추가.

신규 테스트:

```rust
#[test]
fn extract_client_ip_untrusted_proxy_ignores_xff() {
    let mut req = Request::builder()
        .uri("/test")
        .body(axum::body::Body::empty())
        .unwrap();
    req.headers_mut()
        .insert("x-forwarded-for", "1.2.3.4".parse().unwrap());
    let fallback: std::net::IpAddr = "192.168.1.1".parse().unwrap();
    // 10.0.0.0/8만 trusted → 192.168.1.1은 untrusted → XFF 무시
    let trusted = vec!["10.0.0.0/8".parse::<ipnetwork::IpNetwork>().unwrap()];
    assert_eq!(extract_client_ip(&req, fallback, &trusted), fallback);
}

#[test]
fn extract_client_ip_trusted_proxy_uses_xff() {
    let mut req = Request::builder()
        .uri("/test")
        .body(axum::body::Body::empty())
        .unwrap();
    req.headers_mut()
        .insert("x-forwarded-for", "1.2.3.4".parse().unwrap());
    let fallback: std::net::IpAddr = "10.0.0.1".parse().unwrap();
    let trusted = vec!["10.0.0.0/8".parse::<ipnetwork::IpNetwork>().unwrap()];
    assert_eq!(
        extract_client_ip(&req, fallback, &trusted),
        "1.2.3.4".parse::<std::net::IpAddr>().unwrap()
    );
}
```

**Step 4: .env.example 업데이트**

`server/.env.example`에 추가:

```
# 신뢰할 수 있는 리버스 프록시 IP/CIDR (쉼표 구분, 비어있으면 XFF 무조건 신뢰)
# TRUSTED_PROXIES=10.0.0.0/8,172.16.0.0/12
```

**Step 5: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test && cargo clippy -- -D warnings`
Expected: 전체 PASS

**Step 6: 커밋**

```bash
git add server/src/config.rs server/src/middleware/bot_guard.rs server/.env.example
git commit -m "fix(security): TRUSTED_PROXIES — XFF IP 스푸핑 방지"
```

---

## Task 2: 서버 — access_log 클라이언트 IP 추출 (C-4)

**Files:**
- Modify: `server/src/middleware/access_log.rs`
- Modify: `server/src/middleware/bot_guard.rs` (extract_client_ip pub 변경)

**Step 1: extract_client_ip를 pub(crate)로 변경**

`server/src/middleware/bot_guard.rs:15` — `fn` → `pub(crate) fn`:

```rust
pub(crate) fn extract_client_ip(
```

**Step 2: access_log에서 클라이언트 IP 사용**

`server/src/middleware/access_log.rs` — import 추가:

```rust
use super::bot_guard::extract_client_ip;
```

line 106 변경:

```rust
// 기존: let ip_net: IpNetwork = addr.ip().into();
let client_ip = extract_client_ip(&req, addr.ip(), &state.config.trusted_proxies);
let ip_net: IpNetwork = client_ip.into();
```

**문제**: `req`는 line 87에서 `next.run(req)`으로 소비됨. IP 추출을 응답 전에 해야 함.

실제 수정 — line 63 근처에서 IP를 미리 추출:

```rust
let start = std::time::Instant::now();
let method = req.method().to_string();
let raw_path = req.uri().path().to_string();
let client_ip = extract_client_ip(&req, addr.ip(), &state.config.trusted_proxies);
// ... (기존 코드)
let response = next.run(req).await;
// ... line 106:
let ip_net: IpNetwork = client_ip.into();
```

**Step 3: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test && cargo clippy -- -D warnings`

**Step 4: 커밋**

```bash
git add server/src/middleware/access_log.rs server/src/middleware/bot_guard.rs
git commit -m "fix(log): access_log에 실제 클라이언트 IP 기록"
```

---

## Task 3: 서버 — consent 추천 경로 referrals + 보상 (C-3)

**Files:**
- Modify: `server/src/api/routes/auth.rs:289-325`

**Step 1: update_consent의 추천 코드 처리를 트랜잭션으로 변경**

`server/src/api/routes/auth.rs` — `update_consent` 함수의 추천 코드 처리 블록(line 301-322)을 수정:

```rust
// 추천 코드가 있으면 추천인 보상 처리 (아직 referred_by가 없는 경우만)
if let Some(ref code) = body.referral_code {
    let code = code.trim();
    if !code.is_empty() {
        if let Some(referrer_id) =
            auth_service::find_referrer_by_code(&state.pool, code).await?
        {
            if referrer_id != claims.sub {
                let mut tx = state.pool.begin().await?;

                // 원자적 UPDATE: referred_by IS NULL일 때만 설정
                let result = sqlx::query(
                    "UPDATE users SET referred_by = $1, updated_at = NOW() \
                     WHERE id = $2 AND referred_by IS NULL AND deleted_at IS NULL",
                )
                .bind(referrer_id)
                .bind(claims.sub)
                .execute(&mut *tx)
                .await?;

                // 실제로 referred_by가 설정된 경우에만 referrals + 보상 처리
                if result.rows_affected() > 0 {
                    // referrals 레코드 생성
                    sqlx::query(
                        "INSERT INTO referrals (referrer_id, referred_id, referral_code) \
                         VALUES ($1, $2, $3)",
                    )
                    .bind(referrer_id)
                    .bind(claims.sub)
                    .bind(code)
                    .execute(&mut *tx)
                    .await?;

                    // Stage 0 웰컴 보상: 피초대자 1¢
                    crate::services::reward_service::add_points_and_record(
                        &mut tx,
                        claims.sub,
                        1,
                        "referral_welcome",
                        "추천 코드 가입 웰컴 보상",
                        None,
                    )
                    .await?;

                    // Stage 0 웰컴 보상: 초대자 1¢
                    crate::services::reward_service::add_points_and_record(
                        &mut tx,
                        referrer_id,
                        1,
                        "referral_welcome_referrer",
                        "추천인 웰컴 보상",
                        None,
                    )
                    .await?;
                }

                tx.commit().await?;
            }
        }
    }
}
```

import 확인: `crate::services::reward_service` 사용 가능 여부 확인. 이미 `use crate::services::auth_service;` 가 있을 것.

**Step 2: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test && cargo clippy -- -D warnings`

**Step 3: 커밋**

```bash
git add server/src/api/routes/auth.rs
git commit -m "fix(referral): consent 경로에서 referrals 레코드 + 웰컴 보상 지급"
```

---

## Task 4: Flutter — CancelToken 전달 (C-2)

**Files:**
- Modify: `app/lib/services/product_service.dart`
- Modify: `app/lib/screens/search/search_screen.dart`

**Step 1: ProductService.search에 cancelToken 파라미터 추가**

`app/lib/services/product_service.dart` — `search()` 메서드 시그니처 변경:

```dart
Future<({List<Product> products, String? cursor, bool hasMore})> search({
  required String query,
  String? sort,
  String? filter,
  String? cursor,
  int limit = AppConstants.defaultPageSize,
  CancelToken? cancelToken,
}) async {
  final response = await _api.dio.get(
    ApiEndpoints.productSearch,
    queryParameters: {
      'q': query,
      'limit': limit,
      'sort': ?sort,
      'filter': ?filter,
      'cursor': ?cursor,
    },
    cancelToken: cancelToken,
  );
```

import 추가: `import 'package:dio/dio.dart';`

**Step 2: SearchScreen에서 cancelToken 전달**

`app/lib/screens/search/search_screen.dart:66-69` 변경:

```dart
final result = await service.search(
  query: query,
  cursor: _cursor,
  cancelToken: _cancelToken,
);
```

catch 블록에서 DioException cancel 무시 추가 (line 77):

```dart
} on DioException catch (e) {
  if (e.type == DioExceptionType.cancel) return;
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(friendlyErrorMessage(e))),
    );
  }
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(friendlyErrorMessage(e))),
    );
  }
}
```

**Step 3: flutter analyze + test**

Run: `/home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 4: 커밋**

```bash
git add app/lib/services/product_service.dart app/lib/screens/search/search_screen.dart
git commit -m "fix(search): CancelToken 전달 — 검색 결과 경쟁 조건 해결"
```

---

## Task 5: 서버 — 카테고리/키워드 알림 중복 방지 (H-1)

**Files:**
- Create: `server/migrations/018_alert_unique_constraints.up.sql`
- Create: `server/migrations/018_alert_unique_constraints.down.sql`

**Step 1: Migration 작성**

`018_alert_unique_constraints.up.sql`:

```sql
-- 동일 사용자+카테고리 중복 알림 방지
ALTER TABLE category_alerts
  ADD CONSTRAINT uq_category_alerts_user_category
  UNIQUE (user_id, category_id);

-- 동일 사용자+키워드 중복 알림 방지
ALTER TABLE keyword_alerts
  ADD CONSTRAINT uq_keyword_alerts_user_keyword
  UNIQUE (user_id, keyword);
```

`018_alert_unique_constraints.down.sql`:

```sql
ALTER TABLE category_alerts DROP CONSTRAINT IF EXISTS uq_category_alerts_user_category;
ALTER TABLE keyword_alerts DROP CONSTRAINT IF EXISTS uq_keyword_alerts_user_keyword;
```

**Step 2: 서비스에 ON CONFLICT 처리 추가**

`server/src/services/alert_service.rs` — `create_category_alert` (line 212-222):

INSERT 쿼리 변경:

```rust
let alert = sqlx::query_as::<_, CategoryAlert>(
    r#"
    INSERT INTO category_alerts (user_id, category_id, alert_condition)
    VALUES ($1, $2, 'any_drop')
    ON CONFLICT (user_id, category_id) DO UPDATE SET updated_at = NOW()
    RETURNING *
    "#,
)
```

`create_keyword_alert`도 동일 패턴 적용:

```rust
ON CONFLICT (user_id, keyword) DO UPDATE SET updated_at = NOW()
```

**Step 3: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test && cargo clippy -- -D warnings`

**Step 4: 커밋**

```bash
git add server/migrations/018_alert_unique_constraints.up.sql server/migrations/018_alert_unique_constraints.down.sql server/src/services/alert_service.rs
git commit -m "fix(alert): 카테고리/키워드 알림 중복 방지 UNIQUE 제약조건"
```

---

## Task 6: 서버 — Naver 토큰 앱 검증 (H-2)

**Files:**
- Modify: `server/src/auth/providers/naver.rs`

**Step 1: verify 함수에 client_id 검증 추가**

Naver는 `/v1/nid/verify`로 토큰 유효성을 검증하지만 앱 구분은 `/v1/nid/me` 응답에 포함되지 않음. 대안: `NAVER_CLIENT_ID`가 설정된 경우에만 `/v1/nid/verify`를 호출하여 토큰 자체의 유효성을 이중 확인.

실질적 수정 — client_id 기반 앱 검증은 Naver API 한계로 불가. 대신 토큰 verify API를 추가 호출:

```rust
pub async fn verify(state: &AppState, access_token: &str) -> Result<SocialUserInfo, AppError> {
    // 1. 토큰 유효성 사전 검증 (선택적 — NAVER_CLIENT_ID 설정 시)
    if state.config.naver_client_id.is_some() {
        let verify_resp = state
            .http_client
            .get("https://openapi.naver.com/v1/nid/verify")
            .bearer_auth(access_token)
            .send()
            .await
            .map_err(|e| AppError::Internal(format!("Naver verify request failed: {e}")))?;

        if !verify_resp.status().is_success() {
            return Err(AppError::Unauthorized);
        }
    }

    // 2. 사용자 정보 조회 (기존 로직)
    let resp = state
        .http_client
        // ... (기존 코드 유지)
```

**Step 2: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test && cargo clippy -- -D warnings`

**Step 3: 커밋**

```bash
git add server/src/auth/providers/naver.rs
git commit -m "fix(auth): Naver 토큰 verify API 이중 검증"
```

---

## Task 7: Flutter — FavoritesScreen 병렬 요청 제한 (H-6)

**Files:**
- Modify: `app/lib/screens/favorites/favorites_screen.dart:47-57`

**Step 1: Future.wait를 청크 단위로 변경**

`favorites_screen.dart` — `_loadData()` 내 Future.wait 블록 변경:

```dart
// 최대 5개씩 병렬 요청 (서버 과부하 방지)
final productIds = priceAlerts.map((a) => a.productId).toSet().toList();
final Map<int, Product> products = {};

for (var i = 0; i < productIds.length; i += 5) {
  final chunk = productIds.skip(i).take(5);
  await Future.wait(
    chunk.map((id) async {
      try {
        final product = await ref.read(productDetailProvider(id).future);
        products[id] = product;
      } catch (_) {
        // 개별 상품 로드 실패 시 건너뜀
      }
    }),
  );
}
```

**Step 2: flutter analyze + test**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 3: 커밋**

```bash
git add app/lib/screens/favorites/favorites_screen.dart
git commit -m "fix(favorites): 상품 조회 최대 5개씩 청크 병렬 요청"
```

---

## Task 8: Flutter — _CentsBalanceTile 에러 표시 + GoogleSignIn dispose (H-5, H-7)

**Files:**
- Modify: `app/lib/screens/my/my_page_screen.dart`
- Modify: `app/lib/screens/auth/login_screen.dart`

**Step 1: _CentsBalanceTile 에러 처리**

`my_page_screen.dart` — `_loadPoints()` catch 블록에 에러 상태 추가:

```dart
} catch (e) {
  if (mounted) {
    setState(() => _error = true);
  }
}
```

`_error` 필드 추가 + build에서 에러 시 재시도 아이콘 표시.

`bool _error = false;` 필드 추가.

`_loadPoints()` 성공 시 `_error = false` 리셋.

build의 포인트 표시 부분에:

```dart
trailing: _error
    ? IconButton(
        icon: const Icon(Icons.refresh, size: 18),
        onPressed: _loadPoints,
      )
    : Text('$_balance¢', style: const TextStyle(fontWeight: FontWeight.bold)),
```

**Step 2: LoginScreen dispose 추가**

`login_screen.dart` — `_LoginScreenState`에 dispose 오버라이드 추가:

```dart
@override
void dispose() {
  _googleSignIn.disconnect();
  super.dispose();
}
```

(주: `disconnect()`가 실패해도 문제없음 — 이미 로그인 안 된 상태일 수 있음)

**Step 3: flutter analyze + test**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 4: 커밋**

```bash
git add app/lib/screens/my/my_page_screen.dart app/lib/screens/auth/login_screen.dart
git commit -m "fix(flutter): 센트 잔액 에러 표시 + GoogleSignIn dispose"
```

---

## Task 9: Flutter — PushNotificationTile 비기능 토글 제거 (H-4)

**Files:**
- Modify: `app/lib/screens/my/settings_screen.dart`

**Step 1: _PushNotificationTile을 비활성 상태로 변경**

TODO가 있으므로 완전 구현 대신, 토글을 비활성화하고 안내 문구 추가:

```dart
class _PushNotificationTile extends StatelessWidget {
  const _PushNotificationTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: const Text('푸시 알림'),
      subtitle: const Text('준비 중'),
      trailing: const Switch(
        value: false,
        onChanged: null,
      ),
    );
  }
}
```

`StatefulWidget` → `StatelessWidget`으로 변경. `_PushNotificationTileState` 클래스 삭제.

**Step 2: flutter analyze + test**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 3: 커밋**

```bash
git add app/lib/screens/my/settings_screen.dart
git commit -m "fix(settings): PushNotificationTile 비기능 토글 → 비활성+안내 문구"
```

---

## Task 10: CI — cargo audit + dependabot 추가 (H-8)

**Files:**
- Modify: `.github/workflows/ci.yml`
- Create: `.github/dependabot.yml`

**Step 1: CI에 cargo audit 스텝 추가**

`.github/workflows/ci.yml` — `check` job의 clippy 스텝 뒤에 추가:

```yaml
    - name: Install cargo-audit
      run: cargo install cargo-audit --locked

    - name: Security audit
      run: cargo audit
      working-directory: server
```

**Step 2: dependabot.yml 생성**

```yaml
version: 2
updates:
  - package-ecosystem: cargo
    directory: /server
    schedule:
      interval: weekly
    open-pull-requests-limit: 5

  - package-ecosystem: pub
    directory: /app
    schedule:
      interval: weekly
    open-pull-requests-limit: 5

  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    open-pull-requests-limit: 3
```

**Step 3: 커밋**

```bash
git add .github/workflows/ci.yml .github/dependabot.yml
git commit -m "ci: cargo audit 보안 스캔 + dependabot 의존성 자동 업데이트"
```

---

## Task 11: 최종 검증 + PR

**Step 1: 서버 전체 테스트**

Run: `cd /home/code/gapttuk/server && cargo test && cargo fmt --check && cargo clippy -- -D warnings`

**Step 2: Flutter 전체 테스트**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 3: PR 생성**

```bash
git push -u origin fix/phase3-quality-security
# PR 생성 (브라우저 또는 gh CLI)
```

PR 본문:

```
## Summary
- C-1: TRUSTED_PROXIES XFF 검증 — IP 스푸핑 방지
- C-2: CancelToken 전달 — 검색 결과 경쟁 조건 해결
- C-3: consent 경로 referrals 레코드 + 웰컴 보상 지급
- C-4: access_log 실제 클라이언트 IP 기록
- H-1: 카테고리/키워드 알림 UNIQUE 제약조건
- H-2: Naver 토큰 verify 이중 검증
- H-4: PushNotificationTile 비활성 + 안내 문구
- H-5: GoogleSignIn dispose 추가
- H-6: FavoritesScreen 청크 병렬 요청 (최대 5개)
- H-7: 센트 잔액 에러 표시 + 재시도
- H-8: CI cargo audit + dependabot

## Test plan
- [x] cargo test — all pass
- [x] cargo clippy — no warnings
- [x] flutter analyze — no issues
- [x] flutter test — all pass
```

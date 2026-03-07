# 보상 체계 v0.8 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** STEP 49(이미 완료)의 보안/기능/테스트 갭을 수정하고 남은 기능을 추가한다.

**Architecture:** reward_service.rs에 통합된 보상 로직(일일 룰렛 + 추천 보상 + 포인트 조회)을 보강. auth_service에 가입 웰컴 보상 추가. Flutter에 포인트 내역 화면 + 테스트 추가.

**Tech Stack:** Rust(Axum/sqlx), Flutter(Riverpod/Dio), mocktail

---

## 이미 완료된 항목 (STEP 49 — bec8585)

- Migration 013 (reward_v08)
- reward_service.rs: daily_checkin, get_points, process_referral_purchase + 4 unit tests
- API: POST /rewards/checkin, GET /rewards/points
- Flutter: RewardService, CentsBalanceTile, rewardServiceProvider
- 서버 159건 + Flutter 108건 통과

---

### Task 1: [SECURITY] reward_service OsRng 교체

**Files:**
- Modify: `server/src/services/reward_service.rs:28,52`

**Step 1: `thread_rng()` -> `OsRng` 교체**

```rust
// 변경 전 (28행, 52행 동일 패턴):
let r = rand::thread_rng().gen_range(0u32..100);

// 변경 후:
let r = rand::rngs::OsRng.gen_range(0u32..100);
```

**Step 2: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test reward_service`
Expected: 4 tests PASS

**Step 3: Commit**

```bash
git add server/src/services/reward_service.rs
git commit -m "fix(security): reward_service thread_rng -> OsRng"
```

---

### Task 2: [FEATURE] Referral 가입 웰컴 보상 1c

**Files:**
- Modify: `server/src/services/auth_service.rs:104-113`

**Step 1: upsert_user의 referral INSERT 후 웰컴 보상 1c 지급 추가**

auth_service.rs의 `if let Some(referrer_id)` 블록 안, referrals INSERT 이후에:

```rust
if let Some(referrer_id) = referred_by {
    sqlx::query(
        "INSERT INTO referrals (referrer_id, referred_id, referral_code) VALUES ($1, $2, $3)",
    )
    .bind(referrer_id)
    .bind(user.id)
    .bind(&referral_code)
    .execute(&mut *tx)
    .await?;

    // Stage 0 웰컴 보상: 피초대자 1c
    sqlx::query(
        "UPDATE user_points SET balance = balance + 1, total_earned = total_earned + 1, updated_at = NOW() WHERE user_id = $1",
    )
    .bind(user.id)
    .execute(&mut *tx)
    .await?;
    sqlx::query(
        "INSERT INTO point_transactions (user_id, amount, transaction_type, description) VALUES ($1, 1, 'referral_welcome', '추천 코드 가입 웰컴 보상')",
    )
    .bind(user.id)
    .execute(&mut *tx)
    .await?;
}
```

**Step 2: 빌드 확인**

Run: `cargo check`
Expected: success, 0 warnings

**Step 3: Commit**

```bash
git add server/src/services/auth_service.rs
git commit -m "feat: 추천 코드 가입 시 웰컴 1c 보상 지급"
```

---

### Task 3: [FEATURE] GET /rewards/history — 포인트 내역 API

**Files:**
- Modify: `server/src/services/reward_service.rs`
- Modify: `server/src/api/routes/rewards.rs`

**Step 1: reward_service에 get_history 함수 추가**

reward_service.rs 끝(#[cfg(test)] 전)에:

```rust
/// 포인트 내역 응답
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct PointHistoryItem {
    pub id: i64,
    pub amount: i32,
    pub transaction_type: String,
    pub description: Option<String>,
    pub created_at: chrono::DateTime<chrono::Utc>,
}

/// 포인트 내역 조회 (커서 페이지네이션)
pub async fn get_history(
    pool: &PgPool,
    user_id: i64,
    cursor: Option<i64>,
    limit: i64,
) -> Result<(Vec<PointHistoryItem>, bool), AppError> {
    let effective_limit = limit.clamp(1, 50);
    let fetch_limit = effective_limit + 1;

    let items: Vec<PointHistoryItem> = if let Some(cursor_id) = cursor {
        sqlx::query_as(
            "SELECT id, amount, transaction_type, description, created_at FROM point_transactions WHERE user_id = $1 AND id < $2 ORDER BY id DESC LIMIT $3",
        )
        .bind(user_id)
        .bind(cursor_id)
        .bind(fetch_limit)
        .fetch_all(pool)
        .await?
    } else {
        sqlx::query_as(
            "SELECT id, amount, transaction_type, description, created_at FROM point_transactions WHERE user_id = $1 ORDER BY id DESC LIMIT $2",
        )
        .bind(user_id)
        .bind(fetch_limit)
        .fetch_all(pool)
        .await?
    };

    let has_more = items.len() as i64 > effective_limit;
    let result: Vec<PointHistoryItem> = items.into_iter().take(effective_limit as usize).collect();
    Ok((result, has_more))
}
```

**Step 2: rewards.rs에 history 핸들러 추가**

```rust
// router에 추가:
.route("/history", get(get_history))

// 핸들러:
/// GET /api/v1/rewards/history — 포인트 내역 (커서 페이지네이션)
async fn get_history(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Query(params): Query<HistoryParams>,
) -> Result<ApiResponse<HistoryResponse>, AppError> {
    let (items, has_more) = reward_service::get_history(
        &state.pool,
        claims.sub,
        params.cursor,
        params.limit.unwrap_or(20),
    ).await?;
    Ok(ApiResponse::ok(HistoryResponse { items, has_more }))
}

#[derive(Deserialize)]
struct HistoryParams {
    cursor: Option<i64>,
    limit: Option<i64>,
}

#[derive(Serialize)]
struct HistoryResponse {
    items: Vec<reward_service::PointHistoryItem>,
    has_more: bool,
}
```

**Step 3: 빌드 확인**

Run: `cargo check`
Expected: success

**Step 4: Commit**

```bash
git add server/src/services/reward_service.rs server/src/api/routes/rewards.rs
git commit -m "feat: GET /rewards/history 포인트 내역 API 추가"
```

---

### Task 4: [TEST] reward_service Rust 테스트 보강

**Files:**
- Modify: `server/src/services/reward_service.rs` (tests 모듈)

**Step 1: 순수 함수 테스트 추가 (기존 4건 + 5건 = 9건)**

```rust
#[test]
fn assign_monthly_cap_distribution_bias() {
    // 1000회 반복 시 대부분 1c 배정 확인 (90%)
    let ones = (0..1000)
        .map(|_| assign_monthly_cap(false))
        .filter(|&c| c == 1)
        .count();
    assert!(ones > 800, "expected >80% ones, got {ones}/1000");
}

#[test]
fn assign_monthly_cap_new_user_never_above_2() {
    for _ in 0..500 {
        let cap = assign_monthly_cap(true);
        assert!(cap <= 2, "new user got cap {cap} > 2");
    }
}

#[test]
fn spin_roulette_mostly_wins() {
    // 90% 확률로 1c — 1000회 시 800+ 확인
    let wins = (0..1000).map(|_| spin_roulette()).filter(|&r| r == 1).count();
    assert!(wins > 800, "expected >80% wins, got {wins}/1000");
}

#[test]
fn points_info_zero_defaults() {
    let info = PointsInfo { balance: 0, total_earned: 0, total_spent: 0 };
    assert_eq!(info.balance, 0);
}

#[test]
fn checkin_result_reward_range() {
    for amount in [0i16, 1] {
        let r = CheckinResult { reward_amount: amount, already_checked_in: false };
        assert!((0..=1).contains(&r.reward_amount));
    }
}
```

**Step 2: 테스트 실행**

Run: `cargo test reward_service`
Expected: 9 tests PASS

**Step 3: Commit**

```bash
git add server/src/services/reward_service.rs
git commit -m "test: reward_service 유닛 테스트 4->9건 보강"
```

---

### Task 5: [FEATURE] Flutter 포인트 내역 화면 + 서비스 확장

**Files:**
- Modify: `app/lib/services/reward_service.dart`
- Create: `app/lib/screens/my/point_history_screen.dart`
- Modify: `app/lib/config/router.dart`

**Step 1: RewardService에 getHistory 추가**

```dart
// reward_service.dart에 추가:

class PointHistoryItem {
  final int id;
  final int amount;
  final String transactionType;
  final String? description;
  final String createdAt;

  const PointHistoryItem({
    required this.id,
    required this.amount,
    required this.transactionType,
    this.description,
    required this.createdAt,
  });

  factory PointHistoryItem.fromJson(Map<String, dynamic> json) => PointHistoryItem(
        id: json['id'] as int,
        amount: json['amount'] as int,
        transactionType: json['transaction_type'] as String,
        description: json['description'] as String?,
        createdAt: json['created_at'] as String,
      );
}

// RewardService 클래스 안에:
Future<({List<PointHistoryItem> items, bool hasMore})> getHistory({int? cursor, int limit = 20}) async {
  final params = <String, dynamic>{'limit': limit};
  if (cursor != null) params['cursor'] = cursor;
  final response = await _api.dio.get('/api/v1/rewards/history', queryParameters: params);
  final data = response.data['data'] as Map<String, dynamic>;
  final items = (data['items'] as List).map((e) => PointHistoryItem.fromJson(e as Map<String, dynamic>)).toList();
  return (items: items, hasMore: data['has_more'] as bool);
}
```

**Step 2: PointHistoryScreen 생성**

`app/lib/screens/my/point_history_screen.dart` — ConsumerStatefulWidget, 커서 페이지네이션, 스크롤 로드

**Step 3: router.dart에 라우트 등록**

```dart
// /my 브랜치 하위에:
GoRoute(path: 'points', builder: (_, __) => const PointHistoryScreen()),
```

**Step 4: 마이페이지 잔액 타일에 내역 보기 네비게이션 추가**

CentsBalanceTile의 title을 탭 시 `/my/points`로 이동

**Step 5: flutter analyze + test**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test --no-pub`

**Step 6: Commit**

```bash
git add app/lib/services/reward_service.dart app/lib/screens/my/point_history_screen.dart app/lib/config/router.dart app/lib/screens/my/my_page_screen.dart
git commit -m "feat: Flutter 포인트 내역 화면 + getHistory API 연결"
```

---

### Task 6: [TEST] Flutter reward_service 테스트

**Files:**
- Create: `app/test/services/reward_service_test.dart`

**Step 1: 테스트 작성 (7건)**

```dart
// checkin 성공 (reward 1c), checkin 이미 출석, checkin 0c 결과,
// getPoints 성공, getPoints 기본값,
// getHistory 성공, getHistory 빈 결과
```

패턴: MockDio + MockApiClient, mocktail when/verify, device_service_test.dart 동일 구조

**Step 2: 테스트 실행**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter test --no-pub test/services/reward_service_test.dart`
Expected: 7 tests PASS

**Step 3: Commit**

```bash
git add app/test/services/reward_service_test.dart
git commit -m "test: Flutter reward_service 테스트 7건 추가"
```

---

### Task 7: 최종 통합 커밋 + 메모리 업데이트

**Step 1: 전체 테스트 실행**

```bash
cd /home/code/gapttuk/server && cargo test
cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test --no-pub
```

**Step 2: 메모리 파일 업데이트 (progress.md, MEMORY.md)**

**Step 3: 최종 커밋**

```bash
git commit -m "STEP 50: 보상 체계 보강 — OsRng + 웰컴 1c + 포인트 내역 + 테스트"
```

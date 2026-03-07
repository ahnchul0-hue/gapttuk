//! alert_service 통합 테스트
//!
//! #[sqlx::test]는 각 테스트마다 독립 DB를 생성 + 마이그레이션 자동 적용.

use gapttuk_server::error::AppError;
use gapttuk_server::services::alert_service::{self, AlertTypeInput, CreatePriceAlertRequest};
use sqlx::PgPool;

mod common;

/// 테스트용 상품 + 사용자 생성 헬퍼
async fn seed_user_and_product(pool: &PgPool) -> (i64, i64) {
    // 쇼핑몰 생성 (id: INTEGER, code NOT NULL)
    let mall_id: i32 = sqlx::query_scalar(
        "INSERT INTO shopping_malls (name, code, base_url) VALUES ('테스트몰', 'test', 'https://test.com') ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name RETURNING id",
    )
    .fetch_one(pool)
    .await
    .unwrap();

    // 상품 생성 (external_product_id NOT NULL)
    let product_id: i64 = sqlx::query_scalar(
        "INSERT INTO products (product_name, product_url, shopping_mall_id, external_product_id) VALUES ('테스트 상품', 'https://test.com/1', $1, 'ext_test_1') RETURNING id",
    )
    .bind(mall_id)
    .fetch_one(pool)
    .await
    .unwrap();

    // 사용자 생성
    let user_id: i64 = sqlx::query_scalar(
        "INSERT INTO users (email, auth_provider, auth_provider_id, referral_code) VALUES ('test@test.com', 'kakao', 'k_1', 'GAP-TEST01') RETURNING id",
    )
    .fetch_one(pool)
    .await
    .unwrap();

    // user_points 초기화
    sqlx::query("INSERT INTO user_points (user_id) VALUES ($1)")
        .bind(user_id)
        .execute(pool)
        .await
        .unwrap();

    (user_id, product_id)
}

/// 테스트용 카테고리 생성 헬퍼
async fn seed_category(pool: &PgPool) -> i32 {
    sqlx::query_scalar(
        "INSERT INTO categories (name, slug) VALUES ('전자제품', 'electronics') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name RETURNING id",
    )
    .fetch_one(pool)
    .await
    .unwrap()
}

// ─── 가격 알림 CRUD ──────────────────────────────────────

#[sqlx::test]
async fn create_price_alert_target_price(pool: PgPool) {
    let (user_id, product_id) = seed_user_and_product(&pool).await;

    let req = CreatePriceAlertRequest {
        product_id,
        alert_type: AlertTypeInput::TargetPrice,
        target_price: Some(50_000),
    };
    let alert = alert_service::create_price_alert(&pool, user_id, &req)
        .await
        .expect("should create alert");

    assert_eq!(alert.user_id, user_id);
    assert_eq!(alert.product_id, product_id);
    assert_eq!(alert.target_price, Some(50_000));
    assert!(alert.is_active);
}

#[sqlx::test]
async fn create_price_alert_target_price_required(pool: PgPool) {
    let (user_id, product_id) = seed_user_and_product(&pool).await;

    // TargetPrice 유형에 target_price 미지정 → BadRequest
    let req = CreatePriceAlertRequest {
        product_id,
        alert_type: AlertTypeInput::TargetPrice,
        target_price: None,
    };
    let result = alert_service::create_price_alert(&pool, user_id, &req).await;
    assert!(
        matches!(result, Err(AppError::BadRequest(_))),
        "should reject missing target_price: {result:?}"
    );
}

#[sqlx::test]
async fn create_price_alert_nonexistent_product(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let req = CreatePriceAlertRequest {
        product_id: 999_999,
        alert_type: AlertTypeInput::AllTimeLow,
        target_price: None,
    };
    let result = alert_service::create_price_alert(&pool, user_id, &req).await;
    assert!(
        matches!(result, Err(AppError::NotFound(_))),
        "should reject nonexistent product: {result:?}"
    );
}

#[sqlx::test]
async fn delete_price_alert_own(pool: PgPool) {
    let (user_id, product_id) = seed_user_and_product(&pool).await;

    let req = CreatePriceAlertRequest {
        product_id,
        alert_type: AlertTypeInput::BelowAverage,
        target_price: None,
    };
    let alert = alert_service::create_price_alert(&pool, user_id, &req)
        .await
        .unwrap();

    alert_service::delete_price_alert(&pool, user_id, alert.id)
        .await
        .expect("should delete own alert");

    // 삭제 후 재삭제 → NotFound
    let result = alert_service::delete_price_alert(&pool, user_id, alert.id).await;
    assert!(matches!(result, Err(AppError::NotFound(_))));
}

#[sqlx::test]
async fn toggle_price_alert(pool: PgPool) {
    let (user_id, product_id) = seed_user_and_product(&pool).await;

    let req = CreatePriceAlertRequest {
        product_id,
        alert_type: AlertTypeInput::NearLowest,
        target_price: None,
    };
    let alert = alert_service::create_price_alert(&pool, user_id, &req)
        .await
        .unwrap();
    assert!(alert.is_active);

    // 토글 → 비활성
    let toggled = alert_service::toggle_price_alert(&pool, user_id, alert.id)
        .await
        .unwrap();
    assert!(!toggled.is_active);

    // 다시 토글 → 활성
    let toggled2 = alert_service::toggle_price_alert(&pool, user_id, toggled.id)
        .await
        .unwrap();
    assert!(toggled2.is_active);
}

#[sqlx::test]
async fn get_user_price_alerts_returns_list(pool: PgPool) {
    let (user_id, product_id) = seed_user_and_product(&pool).await;

    // 2개 알림 생성
    for alert_type in [AlertTypeInput::AllTimeLow, AlertTypeInput::BelowAverage] {
        let req = CreatePriceAlertRequest {
            product_id,
            alert_type,
            target_price: None,
        };
        alert_service::create_price_alert(&pool, user_id, &req)
            .await
            .unwrap();
    }

    let alerts = alert_service::get_user_price_alerts(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(alerts.len(), 2);
}

// ─── 카테고리 알림 ───────────────────────────────────────

#[sqlx::test]
async fn create_category_alert_success(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;
    let category_id = seed_category(&pool).await;

    let alert = alert_service::create_category_alert(&pool, user_id, category_id)
        .await
        .expect("should create category alert");

    assert_eq!(alert.user_id, user_id);
    assert_eq!(alert.category_id, category_id);
    assert!(alert.is_active);
}

#[sqlx::test]
async fn create_category_alert_nonexistent(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let result = alert_service::create_category_alert(&pool, user_id, 999_999).await;
    assert!(
        matches!(result, Err(AppError::NotFound(_))),
        "should reject nonexistent category: {result:?}"
    );
}

// ─── 키워드 알림 ─────────────────────────────────────────

#[sqlx::test]
async fn create_keyword_alert_success(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let alert = alert_service::create_keyword_alert(&pool, user_id, "맥북 프로".to_string())
        .await
        .expect("should create keyword alert");

    assert_eq!(alert.user_id, user_id);
    assert_eq!(alert.keyword, "맥북 프로");
}

#[sqlx::test]
async fn create_keyword_alert_empty_rejected(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let result = alert_service::create_keyword_alert(&pool, user_id, "   ".to_string()).await;
    assert!(
        matches!(result, Err(AppError::BadRequest(_))),
        "should reject empty keyword: {result:?}"
    );
}

#[sqlx::test]
async fn create_keyword_alert_too_long_rejected(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let long_keyword: String = "가".repeat(101);
    let result = alert_service::create_keyword_alert(&pool, user_id, long_keyword).await;
    assert!(
        matches!(result, Err(AppError::BadRequest(_))),
        "should reject keyword > 100 chars: {result:?}"
    );
}

// ─── 알림 수정 ───────────────────────────────────────────

#[sqlx::test]
async fn update_keyword_alert_success(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let alert = alert_service::create_keyword_alert(&pool, user_id, "아이패드".to_string())
        .await
        .unwrap();

    alert_service::update_keyword_alert(&pool, user_id, alert.id, "아이패드 프로")
        .await
        .expect("should update keyword");

    // 업데이트 확인
    let alerts = alert_service::get_user_keyword_alerts(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(alerts[0].keyword, "아이패드 프로");
}

#[sqlx::test]
async fn update_keyword_alert_empty_rejected(pool: PgPool) {
    let (user_id, _) = seed_user_and_product(&pool).await;

    let alert = alert_service::create_keyword_alert(&pool, user_id, "테스트".to_string())
        .await
        .unwrap();

    let result = alert_service::update_keyword_alert(&pool, user_id, alert.id, "  ").await;
    assert!(matches!(result, Err(AppError::BadRequest(_))));
}

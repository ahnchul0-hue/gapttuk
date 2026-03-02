mod common;

use axum::http::{Request, StatusCode};
use http_body_util::BodyExt;
use tower::ServiceExt;

/// GET /api/v1/products/{id} — 존재하지 않는 상품 → 404
#[sqlx::test]
async fn get_product_not_found_returns_404(pool: sqlx::PgPool) {
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri("/api/v1/products/999999")
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::NOT_FOUND);
}

/// GET /api/v1/products/{id} — DB에 상품 INSERT 후 조회 → 200
#[sqlx::test]
async fn get_product_returns_200(pool: sqlx::PgPool) {
    // 시드 데이터에 shopping_mall_id=1 (쿠팡) 존재
    let product_id: i64 = sqlx::query_scalar(
        "INSERT INTO products (shopping_mall_id, external_product_id, product_name, is_out_of_stock)
         VALUES (1, 'ext_001', '테스트 무선 이어폰', false)
         RETURNING id",
    )
    .fetch_one(&pool)
    .await
    .unwrap();

    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri(format!("/api/v1/products/{product_id}"))
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();
    assert_eq!(json["ok"], true);
    assert_eq!(json["data"]["product_name"], "테스트 무선 이어폰");
}

/// GET /api/v1/products/popular — 인기 검색어 (빈 결과) → 200
#[sqlx::test]
async fn popular_returns_200_empty(pool: sqlx::PgPool) {
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri("/api/v1/products/popular")
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();
    assert_eq!(json["ok"], true);
    assert!(json["data"].as_array().unwrap().is_empty());
}

/// GET /api/v1/products/{id}/prices — 가격 이력 (빈 결과) → 200
#[sqlx::test]
async fn prices_for_existing_product_returns_200(pool: sqlx::PgPool) {
    let product_id: i64 = sqlx::query_scalar(
        "INSERT INTO products (shopping_mall_id, external_product_id, product_name, is_out_of_stock)
         VALUES (1, 'ext_003', '가격 이력 테스트 상품', false)
         RETURNING id",
    )
    .fetch_one(&pool)
    .await
    .unwrap();

    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri(format!("/api/v1/products/{product_id}/prices"))
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();
    assert_eq!(json["ok"], true);
}

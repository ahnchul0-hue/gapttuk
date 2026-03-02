mod common;

use axum::http::{Request, StatusCode};
use http_body_util::BodyExt;
use tower::ServiceExt;

/// GET /api/v1/auth/me — 토큰 없이 접근 시 401
#[sqlx::test]
async fn me_without_token_returns_401(pool: sqlx::PgPool) {
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri("/api/v1/auth/me")
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::UNAUTHORIZED);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();
    assert_eq!(json["ok"], false);
}

/// GET /api/v1/auth/me — 유효 토큰 + DB 사용자 → 200
#[sqlx::test]
async fn me_with_valid_token_returns_user(pool: sqlx::PgPool) {
    // 테스트 사용자 직접 INSERT
    let user_id: i64 = sqlx::query_scalar(
        "INSERT INTO users (email, nickname, auth_provider, auth_provider_id, referral_code)
         VALUES ('test@example.com', '테스터', 'kakao', 'kakao_123', 'TEST0001')
         RETURNING id",
    )
    .fetch_one(&pool)
    .await
    .unwrap();

    let token = common::mint_token(user_id);
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri("/api/v1/auth/me")
                .header("Authorization", format!("Bearer {token}"))
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();
    assert_eq!(json["ok"], true);
    assert_eq!(json["data"]["email"], "test@example.com");
    assert_eq!(json["data"]["referral_code"], "TEST0001");
}

/// POST /api/v1/auth/refresh — 잘못된 refresh token → 에러
#[sqlx::test]
async fn refresh_with_invalid_token_returns_error(pool: sqlx::PgPool) {
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .method("POST")
                .uri("/api/v1/auth/refresh")
                .header("Content-Type", "application/json")
                .body(axum::body::Body::from(
                    r#"{"refresh_token":"invalid-token-12345"}"#,
                ))
                .unwrap(),
        )
        .await
        .unwrap();

    // 존재하지 않는 토큰 → 401 또는 404
    assert!(
        response.status() == StatusCode::UNAUTHORIZED || response.status() == StatusCode::NOT_FOUND
    );
}

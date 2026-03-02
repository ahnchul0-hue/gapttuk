mod common;

use axum::http::{Request, StatusCode};
use http_body_util::BodyExt;
use tower::ServiceExt;

#[sqlx::test]
async fn health_returns_200_with_status_ok(pool: sqlx::PgPool) {
    let app = common::build_test_app(pool);

    let response = app
        .oneshot(
            Request::builder()
                .uri("/health")
                .body(axum::body::Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);

    let body = response.into_body().collect().await.unwrap().to_bytes();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();

    assert_eq!(json["ok"], true);
    assert_eq!(json["data"]["status"], "ok");
    assert_eq!(json["data"]["db"], "connected");
    assert_eq!(json["data"]["cache"], "connected");
}

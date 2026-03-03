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
    assert_eq!(json["data"]["status"], "healthy");
    assert_eq!(json["data"]["db"]["status"], "connected");
    assert!(json["data"]["db"]["latency_ms"].is_number());
    assert!(json["data"]["db"]["pool_size"].is_number());
    assert!(json["data"]["db"]["pool_idle"].is_number());
    assert_eq!(json["data"]["cache"], "ok");
    assert!(json["data"]["version"].is_string());
}

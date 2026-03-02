use sqlx::postgres::{PgPool, PgPoolOptions};
use std::time::Duration;

/// PgPool 초기화 + 마이그레이션 실행.
///
/// 연결 실패 시 3회 재시도 (5초 간격).
/// 마이그레이션 실패 시 서버 종료.
pub async fn init_pool(database_url: &str) -> PgPool {
    let mut attempts = 0;
    let max_attempts = 3;

    let pool = loop {
        attempts += 1;
        match PgPoolOptions::new()
            .max_connections(5) // RAM↓: 10→5 (커넥션당 ~5-10MB 절약)
            .min_connections(1) // RAM↓: 유휴 시 최소 1개만 유지
            .acquire_timeout(Duration::from_secs(15))
            .idle_timeout(Duration::from_secs(300))
            .max_lifetime(Duration::from_secs(1800))
            .test_before_acquire(true)
            .connect(database_url)
            .await
        {
            Ok(pool) => {
                tracing::info!("Database connected successfully");
                break pool;
            }
            Err(e) => {
                if attempts >= max_attempts {
                    panic!("Failed to connect to database after {max_attempts} attempts: {e}");
                }
                tracing::warn!(
                    "Database connection attempt {attempts}/{max_attempts} failed: {e}. Retrying in 5s..."
                );
                tokio::time::sleep(Duration::from_secs(5)).await;
            }
        }
    };

    // 임베디드 마이그레이션 실행
    tracing::info!("Running database migrations...");
    sqlx::migrate!()
        .run(&pool)
        .await
        .expect("Failed to run database migrations");
    tracing::info!("Database migrations completed");

    pool
}

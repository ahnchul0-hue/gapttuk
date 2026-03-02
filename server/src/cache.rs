use moka::future::Cache;
use std::time::Duration;

/// 애플리케이션 인메모리 캐시 (moka).
/// 각 캐시는 고유 TTL과 최대 용량을 가진다.
/// M1-2에서는 String placeholder — M1-3에서 모델 타입으로 교체 예정.
#[derive(Clone)]
pub struct AppCache {
    /// 차단 IP — TTL 5분 (M1-7: bot_guard)
    pub blocked_ips: Cache<String, bool>,

    /// 카테고리 — TTL 1시간 (M1-5: 거의 불변 데이터)
    pub categories: Cache<i32, String>,

    /// 인기 검색어 — TTL 10분 (M1-5: 읽기 빈도 높음)
    pub popular_searches: Cache<String, String>,

    /// 상품 상세 — TTL 5분, 최대 10,000건 (M1-5)
    pub products: Cache<i64, String>,
}

impl AppCache {
    pub fn new() -> Self {
        Self {
            blocked_ips: Cache::builder()
                .time_to_live(Duration::from_secs(300)) // 5분
                .max_capacity(10_000)
                .build(),

            categories: Cache::builder()
                .time_to_live(Duration::from_secs(3600)) // 1시간
                .max_capacity(100)
                .build(),

            popular_searches: Cache::builder()
                .time_to_live(Duration::from_secs(600)) // 10분
                .max_capacity(10)
                .build(),

            products: Cache::builder()
                .time_to_live(Duration::from_secs(300)) // 5분
                .max_capacity(10_000)
                .build(),
        }
    }
}

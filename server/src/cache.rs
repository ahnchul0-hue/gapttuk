use moka::future::Cache;
use std::time::Duration;

use crate::models::{Category, PopularSearch, Product};

/// 애플리케이션 인메모리 캐시 (moka).
/// 각 캐시는 고유 TTL과 최대 용량을 가진다.
#[derive(Clone)]
pub struct AppCache {
    /// 차단 IP — TTL 5분 (M1-7: bot_guard)
    pub blocked_ips: Cache<String, bool>,

    /// 카테고리 — TTL 1시간 (거의 불변 데이터)
    pub categories: Cache<i32, Category>,

    /// 인기 검색어 — TTL 10분 (읽기 빈도 높음)
    pub popular_searches: Cache<String, Vec<PopularSearch>>,

    /// 상품 상세 — TTL 5분, 최대 10,000건
    pub products: Cache<i64, Product>,
}

impl AppCache {
    pub fn new() -> Self {
        Self {
            blocked_ips: Cache::builder()
                .time_to_live(Duration::from_secs(300)) // 5분
                .max_capacity(5_000) // RAM↓: 10K→5K (차단 IP는 경량 bool)
                .build(),

            categories: Cache::builder()
                .time_to_live(Duration::from_secs(3600)) // 1시간
                .max_capacity(100) // 카테고리는 고정 데이터, 유지
                .build(),

            popular_searches: Cache::builder()
                .time_to_live(Duration::from_secs(600)) // 10분
                .max_capacity(10) // 유지 (극소량)
                .build(),

            products: Cache::builder()
                .time_to_live(Duration::from_secs(300)) // 5분
                .max_capacity(3_000) // RAM↓: 10K→3K (Zipf 분포 상 히트율 90%+ 유지)
                .build(),
        }
    }

    /// 캐시 가동 여부 확인 — 비즈니스 캐시를 오염시키지 않고 검증.
    /// moka Cache는 생성 후 항상 사용 가능하므로, 객체 존재 자체가 healthy.
    pub fn is_healthy(&self) -> bool {
        // moka Cache는 내부 Arc 기반 — 생성 성공 = 사용 가능.
        // weighted_size()가 패닉 없이 반환되면 정상.
        let _ = self.products.weighted_size();
        true
    }
}

impl Default for AppCache {
    fn default() -> Self {
        Self::new()
    }
}

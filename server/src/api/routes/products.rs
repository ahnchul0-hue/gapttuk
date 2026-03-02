use axum::{
    extract::{Path, Query, State},
    routing::{get, post},
    Json, Router,
};
use chrono::{DateTime, Utc};
use serde::Deserialize;

use crate::api::pagination::PaginatedResponse;
use crate::api::{ApiResponse, Created};
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::services::product_service;
use crate::AppState;

// ── 요청 DTO ────────────────────────────────────────────

/// 검색 쿼리 — serde(flatten)은 Axum Query에서 비자기서술 포맷 이슈로 사용 불가.
/// PaginationParams 필드를 직접 인라인.
#[derive(Deserialize)]
pub struct SearchQuery {
    pub q: String,
    pub cursor: Option<String>,
    #[serde(default = "default_limit")]
    pub limit: i64,
}

#[derive(Deserialize)]
pub struct PriceHistoryQuery {
    pub from: Option<DateTime<Utc>>,
    pub to: Option<DateTime<Utc>>,
    pub cursor: Option<String>,
    #[serde(default = "default_limit")]
    pub limit: i64,
}

fn default_limit() -> i64 {
    20
}

#[derive(Deserialize)]
pub struct PopularQuery {
    #[serde(default = "default_popular_limit")]
    pub limit: i32,
}

fn default_popular_limit() -> i32 {
    10
}

#[derive(Deserialize)]
pub struct AddProductByUrlRequest {
    pub url: String,
}

// ── 라우터 ──────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    // /search에만 별도 rate limiter 적용 (10 req/min per IP)
    let search_route = Router::new()
        .route("/search", get(search))
        .layer(crate::middleware::rate_limit::search_limiter());

    Router::new()
        .merge(search_route)
        .route("/url", post(add_by_url))
        .route("/popular", get(popular))
        .route("/{id}", get(get_product))
        .route("/{id}/prices", get(prices))
        .route("/{id}/prices/daily", get(prices_daily))
}

// ── 핸들러 ──────────────────────────────────────────────

/// GET /api/v1/products/{id} — 상품 상세
async fn get_product(
    State(state): State<AppState>,
    Path(id): Path<i64>,
) -> Result<ApiResponse<crate::models::Product>, AppError> {
    let product = product_service::get_product(&state.pool, &state.cache, id).await?;
    Ok(ApiResponse::ok(product))
}

/// GET /api/v1/products/search?q=&cursor=&limit= — 키워드 검색
async fn search(
    State(state): State<AppState>,
    Query(params): Query<SearchQuery>,
) -> Result<PaginatedResponse<product_service::ProductSearchItem>, AppError> {
    let q = params.q.trim();
    if q.is_empty() {
        return Err(AppError::BadRequest("검색어를 입력해주세요".to_string()));
    }
    if q.len() > 100 {
        return Err(AppError::BadRequest(
            "검색어는 100자 이하로 입력해주세요".to_string(),
        ));
    }

    let limit = params.limit.clamp(1, 100);
    let cursor = params.cursor.as_deref().and_then(|c| c.parse::<i64>().ok());

    let items = product_service::search_products(&state.pool, q, cursor, limit).await?;

    Ok(PaginatedResponse::new(items, limit, |item| {
        item.id.to_string()
    }))
}

/// POST /api/v1/products/url — URL로 상품 추가
async fn add_by_url(
    State(state): State<AppState>,
    Auth(_claims): Auth,
    Json(body): Json<AddProductByUrlRequest>,
) -> Result<Created<product_service::AddProductResponse>, AppError> {
    let url = body.url.trim();
    if url.is_empty() {
        return Err(AppError::BadRequest("URL을 입력해주세요".to_string()));
    }

    let response = product_service::add_product_by_url(&state.pool, url).await?;
    Ok(Created(response))
}

/// GET /api/v1/products/{id}/prices — 가격 이력
async fn prices(
    State(state): State<AppState>,
    Path(id): Path<i64>,
    Query(params): Query<PriceHistoryQuery>,
) -> Result<PaginatedResponse<crate::models::PriceHistory>, AppError> {
    // 날짜 범위 검증
    if let (Some(from), Some(to)) = (params.from, params.to) {
        if from >= to {
            return Err(AppError::BadRequest(
                "from은 to보다 이전이어야 합니다".to_string(),
            ));
        }
        let span = (to - from).num_days();
        if span > 730 {
            return Err(AppError::BadRequest(
                "조회 기간은 최대 730일입니다".to_string(),
            ));
        }
    }

    let limit = params.limit.clamp(1, 100);
    let cursor = params.cursor.as_deref().and_then(|c| c.parse::<i64>().ok());

    let items =
        product_service::get_price_history(&state.pool, id, params.from, params.to, cursor, limit)
            .await?;

    Ok(PaginatedResponse::new(items, limit, |item| {
        item.id.to_string()
    }))
}

/// GET /api/v1/products/{id}/prices/daily — 요일별 집계
async fn prices_daily(
    State(state): State<AppState>,
    Path(id): Path<i64>,
) -> Result<ApiResponse<Vec<product_service::DailyPriceAggregate>>, AppError> {
    let aggregates = product_service::get_daily_price_aggregates(&state.pool, id).await?;
    Ok(ApiResponse::ok(aggregates))
}

/// GET /api/v1/products/popular — 인기 검색어
async fn popular(
    State(state): State<AppState>,
    Query(params): Query<PopularQuery>,
) -> Result<ApiResponse<Vec<crate::models::PopularSearch>>, AppError> {
    let limit = params.limit.clamp(1, 50);
    let items = product_service::get_popular_searches(&state.pool, &state.cache, limit).await?;
    Ok(ApiResponse::ok(items))
}

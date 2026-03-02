use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde::{Deserialize, Serialize};

/// 커서 기반 페이지네이션 쿼리 파라미터.
/// 핸들러에서 `Query<PaginationParams>`로 추출한다.
#[derive(Debug, Deserialize)]
pub struct PaginationParams {
    pub cursor: Option<String>,
    #[serde(default = "default_limit")]
    pub limit: i64,
}

fn default_limit() -> i64 {
    20
}

impl PaginationParams {
    /// limit을 [1, 100] 범위로 제한.
    pub fn effective_limit(&self) -> i64 {
        self.limit.clamp(1, 100)
    }
}

/// 페이지네이션 응답.
/// 리스트 엔드포인트에서 `ApiResponse<Vec<T>>` 대신 사용한다.
#[derive(Serialize)]
pub struct PaginatedResponse<T: Serialize> {
    ok: bool,
    data: Vec<T>,
    cursor: Option<String>,
    has_more: bool,
}

impl<T: Serialize> PaginatedResponse<T> {
    /// limit+1 패턴으로 페이지네이션 응답을 생성한다.
    ///
    /// DB에서 `LIMIT effective_limit + 1`개를 조회한 결과를 `items`로 전달하면,
    /// `limit`개 초과 시 `has_more = true`로 설정하고 마지막 항목을 제거한다.
    /// `cursor_fn`은 마지막 가시 항목에서 커서 값을 추출하는 클로저.
    pub fn new(mut items: Vec<T>, limit: i64, cursor_fn: impl Fn(&T) -> String) -> Self {
        let has_more = items.len() as i64 > limit;
        if has_more {
            items.pop();
        }
        let cursor = if has_more {
            items.last().map(&cursor_fn)
        } else {
            None
        };
        Self {
            ok: true,
            data: items,
            cursor,
            has_more,
        }
    }
}

impl<T: Serialize> IntoResponse for PaginatedResponse<T> {
    fn into_response(self) -> Response {
        (StatusCode::OK, Json(self)).into_response()
    }
}

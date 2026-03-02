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
    limit: i64,
}

fn default_limit() -> i64 {
    20
}

impl PaginationParams {
    /// limit을 [1, 100] 범위로 제한하여 반환.
    /// 핸들러는 반드시 이 메서드를 통해 limit에 접근해야 한다.
    pub fn effective_limit(&self) -> i64 {
        self.limit.clamp(1, 100)
    }
}

/// 페이지네이션 응답.
/// 리스트 엔드포인트에서 `ApiResponse<Vec<T>>` 대신 사용한다.
#[derive(Serialize)]
pub struct PaginatedResponse<T> {
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn effective_limit_clamps_to_range() {
        // 기본값
        let p = PaginationParams {
            cursor: None,
            limit: 20,
        };
        assert_eq!(p.effective_limit(), 20);

        // 하한 클램핑
        let p = PaginationParams {
            cursor: None,
            limit: 0,
        };
        assert_eq!(p.effective_limit(), 1);

        let p = PaginationParams {
            cursor: None,
            limit: -10,
        };
        assert_eq!(p.effective_limit(), 1);

        // 상한 클램핑
        let p = PaginationParams {
            cursor: None,
            limit: 200,
        };
        assert_eq!(p.effective_limit(), 100);

        // 경계값
        let p = PaginationParams {
            cursor: None,
            limit: 1,
        };
        assert_eq!(p.effective_limit(), 1);

        let p = PaginationParams {
            cursor: None,
            limit: 100,
        };
        assert_eq!(p.effective_limit(), 100);
    }

    #[test]
    fn paginated_response_no_more() {
        let items = vec![1, 2, 3];
        let resp = PaginatedResponse::new(items, 5, |x| x.to_string());
        assert!(!resp.has_more);
        assert!(resp.cursor.is_none());
        assert_eq!(resp.data.len(), 3);
    }

    #[test]
    fn paginated_response_has_more() {
        // limit=3이고 items=4 → has_more=true, 마지막 항목 제거
        let items = vec![10, 20, 30, 40];
        let resp = PaginatedResponse::new(items, 3, |x| x.to_string());
        assert!(resp.has_more);
        assert_eq!(resp.data.len(), 3);
        assert_eq!(resp.data, vec![10, 20, 30]);
        assert_eq!(resp.cursor, Some("30".to_string()));
    }

    #[test]
    fn paginated_response_exact_limit() {
        // limit=3이고 items=3 → has_more=false
        let items = vec![1, 2, 3];
        let resp = PaginatedResponse::new(items, 3, |x| x.to_string());
        assert!(!resp.has_more);
        assert_eq!(resp.data.len(), 3);
        assert!(resp.cursor.is_none());
    }

    #[test]
    fn paginated_response_empty() {
        let items: Vec<i32> = vec![];
        let resp = PaginatedResponse::new(items, 10, |x| x.to_string());
        assert!(!resp.has_more);
        assert!(resp.cursor.is_none());
        assert!(resp.data.is_empty());
    }
}

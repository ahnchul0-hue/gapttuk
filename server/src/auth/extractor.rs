use axum::{extract::FromRequestParts, http::request::Parts};

use super::jwt::{decode_access_token, Claims};
use crate::error::AppError;
use crate::AppState;

/// 인증된 요청에서 추출되는 사용자 정보.
/// 핸들러에서 `Auth(claims)` 패턴으로 사용.
///
/// # Example
/// ```ignore
/// async fn me(Auth(claims): Auth) -> impl IntoResponse {
///     format!("user_id = {}", claims.sub)
/// }
/// ```
pub struct Auth(pub Claims);

impl FromRequestParts<AppState> for Auth {
    type Rejection = AppError;

    async fn from_request_parts(
        parts: &mut Parts,
        state: &AppState,
    ) -> Result<Self, Self::Rejection> {
        let header = parts
            .headers
            .get("authorization")
            .and_then(|v| v.to_str().ok())
            .ok_or(AppError::Unauthorized)?;

        let token = header
            .strip_prefix("Bearer ")
            .ok_or(AppError::Unauthorized)?;

        let claims = decode_access_token(token, &state.config)?;
        Ok(Auth(claims))
    }
}

//! notification_service 통합 테스트
//!
//! 알림 CRUD + 읽음 처리 + 삭제 검증.

use gapttuk_server::error::AppError;
use gapttuk_server::services::notification_service;
use sqlx::PgPool;

/// 테스트용 사용자 생성 + 알림 삽입 헬퍼
async fn seed_user(pool: &PgPool) -> i64 {
    let user_id: i64 = sqlx::query_scalar(
        "INSERT INTO users (email, auth_provider, auth_provider_id, referral_code) VALUES ('notif@test.com', 'kakao', 'k_notif', 'GAP-NOTIF1') RETURNING id",
    )
    .fetch_one(pool)
    .await
    .unwrap();

    sqlx::query("INSERT INTO user_points (user_id) VALUES ($1)")
        .bind(user_id)
        .execute(pool)
        .await
        .unwrap();

    user_id
}

async fn insert_notification(pool: &PgPool, user_id: i64, title: &str) -> i64 {
    sqlx::query_scalar(
        r#"INSERT INTO notifications (user_id, notification_type, reference_id, reference_type, title, body)
           VALUES ($1, 'price_alert', 1, 'price_alert', $2, '테스트 본문')
           RETURNING id"#,
    )
    .bind(user_id)
    .bind(title)
    .fetch_one(pool)
    .await
    .unwrap()
}

// ─── get_user_notifications ──────────────────────────────

#[sqlx::test]
async fn get_user_notifications_empty(pool: PgPool) {
    let user_id = seed_user(&pool).await;

    let notifs = notification_service::get_user_notifications(&pool, user_id, None, 20)
        .await
        .unwrap();
    assert!(notifs.is_empty());
}

#[sqlx::test]
async fn get_user_notifications_with_cursor(pool: PgPool) {
    let user_id = seed_user(&pool).await;

    // 3개 알림 삽입
    let id1 = insert_notification(&pool, user_id, "알림1").await;
    let _id2 = insert_notification(&pool, user_id, "알림2").await;
    let id3 = insert_notification(&pool, user_id, "알림3").await;

    // 커서 없이 전체 조회
    let all = notification_service::get_user_notifications(&pool, user_id, None, 20)
        .await
        .unwrap();
    assert_eq!(all.len(), 3);

    // 커서로 id3 이전 것만 조회
    let before_3 = notification_service::get_user_notifications(&pool, user_id, Some(id3), 20)
        .await
        .unwrap();
    assert_eq!(before_3.len(), 2);
    assert!(before_3.iter().all(|n| n.id < id3));

    // 커서로 id1 이전 → 빈 결과
    let before_1 = notification_service::get_user_notifications(&pool, user_id, Some(id1), 20)
        .await
        .unwrap();
    assert!(before_1.is_empty());
}

// ─── mark_as_read ────────────────────────────────────────

#[sqlx::test]
async fn mark_as_read_success(pool: PgPool) {
    let user_id = seed_user(&pool).await;
    let notif_id = insert_notification(&pool, user_id, "읽을 알림").await;

    notification_service::mark_as_read(&pool, user_id, notif_id)
        .await
        .expect("should mark as read");

    // 읽음 확인
    let is_read: bool = sqlx::query_scalar("SELECT is_read FROM notifications WHERE id = $1")
        .bind(notif_id)
        .fetch_one(&pool)
        .await
        .unwrap();
    assert!(is_read);
}

#[sqlx::test]
async fn mark_as_read_idempotent(pool: PgPool) {
    let user_id = seed_user(&pool).await;
    let notif_id = insert_notification(&pool, user_id, "멱등 테스트").await;

    // 첫 번째 읽음 처리
    notification_service::mark_as_read(&pool, user_id, notif_id)
        .await
        .unwrap();

    // 두 번째 읽음 처리 → 에러 없음 (멱등성)
    notification_service::mark_as_read(&pool, user_id, notif_id)
        .await
        .expect("should be idempotent");
}

#[sqlx::test]
async fn mark_as_read_not_found(pool: PgPool) {
    let user_id = seed_user(&pool).await;

    let result = notification_service::mark_as_read(&pool, user_id, 999_999).await;
    assert!(
        matches!(result, Err(AppError::NotFound(_))),
        "should return NotFound: {result:?}"
    );
}

// ─── delete_notification ─────────────────────────────────

#[sqlx::test]
async fn delete_notification_success(pool: PgPool) {
    let user_id = seed_user(&pool).await;
    let notif_id = insert_notification(&pool, user_id, "삭제 대상").await;

    notification_service::delete_notification(&pool, user_id, notif_id)
        .await
        .expect("should delete");

    // 재삭제 → NotFound
    let result = notification_service::delete_notification(&pool, user_id, notif_id).await;
    assert!(matches!(result, Err(AppError::NotFound(_))));
}

#[sqlx::test]
async fn delete_notification_other_user_rejected(pool: PgPool) {
    let user_id = seed_user(&pool).await;
    let notif_id = insert_notification(&pool, user_id, "타인의 알림").await;

    // 다른 사용자로 삭제 시도
    let other_user_id: i64 = sqlx::query_scalar(
        "INSERT INTO users (email, auth_provider, auth_provider_id, referral_code) VALUES ('other@test.com', 'kakao', 'k_other', 'GAP-OTHER1') RETURNING id",
    )
    .fetch_one(&pool)
    .await
    .unwrap();

    let result = notification_service::delete_notification(&pool, other_user_id, notif_id).await;
    assert!(
        matches!(result, Err(AppError::NotFound(_))),
        "should not delete other user's notification: {result:?}"
    );
}

// ─── get_unread_count ────────────────────────────────────

#[sqlx::test]
async fn get_unread_count_tracks_reads(pool: PgPool) {
    let user_id = seed_user(&pool).await;

    // 초기: 0건
    let count = notification_service::get_unread_count(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(count, 0);

    // 2건 삽입
    let id1 = insert_notification(&pool, user_id, "미읽음1").await;
    let _id2 = insert_notification(&pool, user_id, "미읽음2").await;

    let count = notification_service::get_unread_count(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(count, 2);

    // 1건 읽음 처리
    notification_service::mark_as_read(&pool, user_id, id1)
        .await
        .unwrap();

    let count = notification_service::get_unread_count(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(count, 1);
}

// ─── mark_all_read ───────────────────────────────────────

#[sqlx::test]
async fn mark_all_read_updates_count(pool: PgPool) {
    let user_id = seed_user(&pool).await;

    insert_notification(&pool, user_id, "1").await;
    insert_notification(&pool, user_id, "2").await;
    insert_notification(&pool, user_id, "3").await;

    let affected = notification_service::mark_all_read(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(affected, 3);

    // 전체 읽음 후 미읽음 0건
    let count = notification_service::get_unread_count(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(count, 0);

    // 재호출 → 0건 업데이트 (멱등)
    let affected2 = notification_service::mark_all_read(&pool, user_id)
        .await
        .unwrap();
    assert_eq!(affected2, 0);
}

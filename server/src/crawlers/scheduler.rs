use std::sync::Arc;

use tokio_cron_scheduler::{Job, JobScheduler};

use super::CrawlerService;

/// 크롤링 스케줄러 시작 — 매 6시간 (0 0 */6 * * *).
/// `CrawlerService`를 `Arc`로 래핑하여 스케줄러 Job에 전달.
pub async fn start_scheduler(
    service: Arc<CrawlerService>,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let sched = JobScheduler::new().await?;

    // 6-field cron (sec min hour day month weekday)
    let job = Job::new_async("0 0 */6 * * *", move |_uuid, _lock| {
        let svc = service.clone();
        Box::pin(async move {
            tracing::info!("Scheduled crawl cycle starting");
            svc.run_cycle().await;
        })
    })?;

    sched.add(job).await?;
    sched.start().await?;

    tracing::info!("Crawler scheduler started (every 6 hours)");
    Ok(())
}

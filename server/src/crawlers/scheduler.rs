use std::sync::Arc;

use tokio_cron_scheduler::{Job, JobScheduler};

use super::CrawlerService;

/// 크롤링 스케줄러 시작 — 매 6시간 (0 0 */6 * * *).
/// `run_now`가 true이면 스케줄러 시작과 동시에 즉시 1회 크롤링 실행.
pub async fn start_scheduler(
    service: Arc<CrawlerService>,
    run_now: bool,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    if run_now {
        let svc = service.clone();
        tokio::spawn(async move {
            tracing::info!("Initial crawl cycle starting (CRAWL_ON_START=true)");
            svc.run_cycle().await;
        });
    }

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

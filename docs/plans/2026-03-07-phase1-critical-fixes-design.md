# Phase 1: CRITICAL + HIGH 결함 수정 설계

> 생성: 2026-03-07, PR #1 머지 후 후속 PR
> 기준 문서: `docs/REVIEW_FOLLOWUP.md`

---

## 그룹 A: Archive 로직 (CR-1, CR-2, CR-3, H-1, H-5)

**파일**: `server/src/main.rs` — `archive_old_price_history()`

| 이슈 | 현재 | 수정 |
|------|------|------|
| CR-1 파티션 이름 형식 불일치 | 이름 suffix로 사전순 비교 | `pg_get_expr(relpartbound, oid)`로 파티션 range 경계 날짜 직접 파싱 |
| CR-2 검증 쿼리 범위 오류 | 날짜 범위만으로 합산 | `product_id IN (SELECT DISTINCT product_id FROM {partition})` 조건 추가 |
| CR-3 비원자적 3단계 | aggregate/verify/DROP 별도 쿼리 | 단일 트랜잭션으로 묶기 |
| H-1 unquoted identifier | `DROP TABLE IF EXISTS {name}` | quoted identifier 사용 |
| H-5 재시도 데이터 누락 | CR-3과 동일 원인 | CR-3 트랜잭션으로 자연 해결 |

## 그룹 B: Reward 로직 (CR-4, CR-5, CR-6, CR-7, H-3, H-4)

| 이슈 | 수정 |
|------|------|
| CR-4 신규유저 7일 기준 | `created_at > NOW() - INTERVAL '7 days'` |
| CR-5 초대자 Stage 0 보상 | 초대자에게도 1c 지급 |
| CR-6 음수 amount 가드 | `if amount <= 0 { return Err }` |
| CR-7 user_points upsert | INSERT ON CONFLICT DO UPDATE |
| H-3 이중 지급 | 설계 의도 정상 — 주석 명시 |
| H-4 limit 미검증 | 핸들러 레벨 clamp(1, 50) |

## 그룹 C: Auth 로직 (H-2)

| 이슈 | 수정 |
|------|------|
| H-2 aborted tx 재사용 | pool 직접 실행으로 변경 |

# PLAN_01.md — 야간 자동화 세션 작업 계획

> **목적**: 야간 자동화 세션(`auto/night-01-*`)이 PLAN_01.md 부재 시 자율 추론하는 문제를 해결.
> 이 파일이 존재하면 세션은 여기 명시된 작업만 수행하고, 범위를 임의로 확장하지 않는다.
>
> **갱신**: 사용자가 직접 편집하거나, 세션 완료 후 아래 "다음 세션" 항목을 이번 세션으로 승격.

---

## 현재 세션 (Night-13, 2026-03-12)

> **상태**: 완료 → NIGHT_06_RESULT.md 참조

### 완료된 작업
- [x] PLAN_01.md 작성 (이 파일)
- [x] auth_service.rs 순수 함수 추출 + 단위 테스트 12건 추가
- [x] find_referrer_by_code GAP-형식 검증 강화 (M-3 수정)
- [x] 전체 테스트 실행 검증

---

## 다음 세션 (Night-14, 2026-03-13)

### 우선순위 1 — 테스트 보강 (Phase 2 로드맵)

아래 순서대로 실행. 실패 시 해당 항목만 건너뛰고 다음으로.

#### 1-A. reward_service 통합 테스트 (P1)
```
목표: daily_checkin + process_referral_purchase 통합 테스트 6건 추가
파일: server/tests/reward_service_test.rs (신규) 또는 서비스 내 통합 섹션
전제: DATABASE_URL 환경변수 + 실 DB 연결 필요
주의: CI 환경에서 통합 테스트 실행 여부 확인
```

#### 1-B. notification_service 단위 테스트 (P2)
```
목표: 기존 3건 → 8건 (notify_user, get_notifications, mark_as_read 등)
파일: server/src/services/notification_service.rs
순수 함수 추출 필요 여부 확인 후 결정
```

#### 1-C. product_service 단위 테스트 (P2)
```
목표: 기존 4건 → 10건
파일: server/src/services/product_service.rs
MonthlyPriceItem DTO 변환 로직이 순수 함수 — 우선 대상
```

---

## 미머지 브랜치 처리 계획 (사용자 결정 필요)

아래 브랜치들은 야간 세션에서 직접 머지하지 않는다.
사용자가 결정한 후 수동으로 처리 또는 PR 생성 요청.

| 브랜치 | 주요 내용 | 우선순위 |
|--------|-----------|----------|
| `fix/phase0-security-stability` | FK CASCADE(020), CD 파이프라인, 검색 필터 UI | **HIGH** |
| `feat/phase2-monthly-prices` | Monthly prices API + Flutter 차트 | MEDIUM |
| `feat/dark-mode` | 다크모드 UI + SharedPreferences | LOW |
| `auto/night-01-20260310_0100` | OpenAPI utoipa 5.x + Swagger UI | MEDIUM |

---

## 야간 세션 금지 항목 (사용자 승인 없이 불가)

- 미머지 브랜치를 main에 머지하거나 force push
- CD 파이프라인 활성화 또는 프로덕션 배포
- 외부 API 키 또는 환경변수 변경
- 마이그레이션 020 이후 번호 사용 (fix/phase0 브랜치와 충돌)

---

## 마이그레이션 번호 현황

| 번호 | 파일 | 상태 |
|------|------|------|
| 001~017 | 기본 스키마 | main에 포함 |
| 018 | alert_unique_constraints | main에 포함 (PR #3) |
| 019 | TTL 클린업 설정 | `fix/phase0-security-stability`에만 있음 |
| 020 | FK CASCADE | `fix/phase0-security-stability`에만 있음 |
| **021+** | **야간 세션 신규 마이그레이션** | **019/020 머지 후에만 사용** |

> **야간 세션은 019/020 충돌 방지를 위해 DB 마이그레이션을 추가하지 않는다.**

---

> 마지막 갱신: 2026-03-12 Night-13
> Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

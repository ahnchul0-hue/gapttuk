# 값뚝(gapttuk) 장기 품질 개선 로드맵

> 작성: 2026-03-06 | 근거: 프로젝트 전체 분석 (50 STEP, 271 테스트, 15 파일 diff)

---

## 1. 현재 상태 요약

| 지표 | 값 |
|------|-----|
| Rust 테스트 | 156 유닛 + 8 통합 = 164건 |
| Flutter 테스트 | 115건 (모델 23 + 유틸 17 + 서비스 56 + 위젯 10 + smoke 1) |
| Clippy/fmt/analyze | 0 경고 / clean / 0 이슈 |
| DB 마이그레이션 | 014 (CHECK 확장 + referral_code 인덱스) |
| API 엔드포인트 | 34개 |
| 서비스 모듈 | 9개 (auth, product, alert, notification, device, prediction, reward, push, crawler) |

---

## 2. Phase 1 완료 항목 (즉시 실행)

### 2.1 reward_service.rs 코드 중복 제거
- `add_points_and_record()` 공통 함수 추출
- daily_checkin, process_referral_purchase, auth_service 웰컴 보상에서 사용
- 포인트 조작의 단일 진실 원천 확보

### 2.2 Migration 014 — CHECK 제약 확장
- daily_checkins.reward_amount: `IN (0, 1)` → `BETWEEN 0 AND 4`
- referral_code 고유성 인덱스 추가 (WHERE deleted_at IS NULL)
- 프로덕션 데이터 마이그레이션 가이드 주석 포함

### 2.3 auth_service 탈취 감지 강화
- rotate_refresh_token에서 revoke 실패 시 최대 2회 재시도
- 각 시도에 structured logging (attempt, revoked_count)
- 최종 실패 시 SECURITY 레벨 경고 (Sentry 캡처 대상)

### 2.4 Flutter CI 워크플로우 추가
- `flutter` job: pub get → build_runner → analyze → test --coverage
- 기존 `check` (Rust) + `docker` (GHCR)와 병렬 실행

---

## 3. Phase 2 — 테스트 전략 (2~4주)

### 3.1 서버 테스트 확대 목표

| 서비스 | 현재 | 목표 | 우선순위 |
|--------|------|------|----------|
| auth_service | 0건 | 12건 | P0 |
| reward_service | 9건 | 15건 | P1 |
| notification_service | 3건 | 8건 | P2 |
| product_service | 4건 | 10건 | P2 |
| 통합 테스트 | 8건 | 20건 | P1 |

### 3.2 auth_service 테스트 우선 항목
- upsert_user: 신규 생성 + 기존 업데이트 + 동의 검증 실패
- rotate_refresh_token: 정상 순환 + 만료 + 탈취 감지
- generate_referral_code: 정상 + 충돌 재시도 + 최대 재시도 초과
- withdraw: 소프트 딜리트 + 토큰 revoke + 디바이스 비활성화

### 3.3 Flutter 통합 테스트
- Riverpod 3.0.2 패턴: `ProviderScope(overrides: [...])` + `tester.container()`
- 핵심 플로우: 로그인 → 홈 → 상품 검색 → 알림 설정 → 출석 체크인

---

## 4. Phase 3 — 관측성(Observability) 강화 (4~6주)

### 4.1 비즈니스 메트릭 추가
```
gauge: gapttuk_daily_active_users
counter: gapttuk_checkins_total{result="reward|miss|already"}
counter: gapttuk_referral_stage_transitions{from="0",to="1"}
counter: gapttuk_alert_to_purchase_conversions
gauge: gapttuk_cents_issued_monthly
histogram: gapttuk_api_response_time{endpoint="/api/v1/..."}
```

### 4.2 구조화 로깅 표준화
- 모든 서비스에 `tracing::instrument` 적용
- 표준 필드: user_id, request_id, duration_ms, outcome

### 4.3 Sentry 성능 트레이싱
- `sentry::start_transaction` + `sentry::start_span` 패턴
- 크롤러, 알림 평가, 토큰 순환 등 핵심 경로에 적용

---

## 5. Phase 4 — API 명세 및 클라이언트 정합성 (6~8주)

### 5.1 OpenAPI 재도입
- `utoipa` 또는 `aide` 크레이트로 자동 생성
- 각 핸들러에 `#[utoipa::path]` 매크로 부착
- `/api/docs` Swagger UI 엔드포인트

### 5.2 클라이언트 코드젠
- OpenAPI spec → Dart 클라이언트 자동 생성 (openapi_generator)
- Flutter 서비스 수동 작성을 자동 생성으로 전환
- API 계약 불일치 자동 감지 (STEP 47 CRITICAL 5건 재발 방지)

---

## 6. Phase 5 — 차별화 기능 고도화 (8~12주)

### 6.1 AI 가격 예측 고도화
- 현재: predict_action 순수함수 (단순 규칙)
- 목표: 시계열 분석 기반 모델
- 접근: Prophet/LightGBM 오프라인 학습 → 서버 추론
- API: GET /products/{id}/prediction → confidence_score 추가

### 6.2 패시브 인텔리전스 강화
- 카테고리 알림 UX: "원터치 설정" 위젯
- 키워드 자동 모니터링: 크롤러와 연동
- 추천 알고리즘: 유사 상품 가격 변동 패턴 매칭

### 6.3 보상 시스템 완성
- 기프티콘 교환 API 연동 (CU, 스타벅스 등)
- 보상 대시보드: 월별 적립/사용 차트
- 이벤트 룰렛 (0~2¢, 주당 상한 2¢)

---

## 7. Phase 6 — 인프라 및 배포 (지속)

### 7.1 스테이징 환경
- docker-compose.staging.yml + 별도 DB
- main 브랜치 푸시 → 자동 스테이징 배포

### 7.2 E2E 테스트 자동화
- Playwright 기반 웹 E2E (Flutter Web 빌드 후)
- 핵심 시나리오: 가입 → 상품 추가 → 알림 → 출석

### 7.3 모니터링 대시보드
- Grafana + Prometheus 스택
- 알림: 에러율 > 1%, 응답시간 P99 > 2s, DB 커넥션 > 80%

---

## 8. 우선순위 매트릭스

| Phase | 항목 | 영향도 | 난이도 | 시기 |
|-------|------|--------|--------|------|
| 1 | 코드 중복 제거 + CHECK 확장 + CI | ★★★★ | ★★ | 완료 |
| 2 | auth_service 테스트 + 통합 테스트 | ★★★★★ | ★★★ | 즉시 |
| 3 | 비즈니스 메트릭 + 구조화 로깅 | ★★★★ | ★★ | 2주 후 |
| 4 | OpenAPI + 클라이언트 코드젠 | ★★★ | ★★★ | 4주 후 |
| 5 | AI 예측 + 패시브 알림 + 보상 완성 | ★★★★★ | ★★★★ | 8주 후 |
| 6 | 스테이징 + E2E + 모니터링 | ★★★★ | ★★★ | 지속 |

---

> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

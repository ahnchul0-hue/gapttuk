# PLAN_02: 값뚝(gapttuk) 다음 단계 로드맵

> 작성: 2026-04-10 (Night-40 — Sonnet 4.6 Sub-agent)
> 베이스라인: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅
> 상태: **⏳ 방향 선택 대기 (U-42)** — PLAN_01 8-Phase 전체 완료 후 다음 방향 결정 필요
> 전제조건: `auto/night-01-20260410_0100` (64+ 커밋) → main 머지 결정 필요
>
> ### 선택지 요약
> | 코드 | 방향 | 규모 | 권장도 |
> |------|------|------|--------|
> | **A** | BREAKING 의존성 업그레이드 | 대형 | ⭐⭐⭐ |
> | **B** | 기능 확장 (미머지 PR 통합 + 신규) | 중형 | ⭐⭐⭐⭐⭐ (Opus 1순위) |
> | **C** | E2E 테스트 + CI/CD 강화 | 대형 | ⭐⭐⭐ |
> | **D** | 프로덕션 준비 | 대형 | ⭐⭐⭐⭐ |
> | **E** | 조합 (B → A → D 순서) | 대형 | ⭐⭐⭐⭐⭐ (Opus 추천) |

---

## 0. 전제: 브랜치 머지 결정 (U-3)

**현재 상태**: `auto/night-01-20260410_0100` — main 대비 **65+ 커밋** 앞

| 옵션 | 방법 | 위험도 | 추천 |
|------|------|--------|------|
| **A) Push + PR** | `git push origin auto/...` → GitHub PR 생성 | 낮음 | ✅ 권장 |
| **B) 로컬 머지** | 현재 브랜치에서 main 로컬 머지 | 중간 | |
| **C) 유지** | 브랜치 유지, main 병행 작업 | 높음 | |

> **권장**: PLAN_02 시작 전 PR 생성(Push + PR) → 코드 리뷰 후 main 머지

---

## 방향 A: BREAKING 의존성 대규모 업그레이드

> **목표**: 보류된 BREAKING 업그레이드 6건 + json 체인 충돌 해소
> **규모**: 대형 (3~5 세션)
> **전제**: 브랜치 머지 완료 후

### A-1. 업그레이드 대상 목록

| 패키지 | 현재 | 목표 | 난이도 | 이유 |
|--------|------|------|--------|------|
| `riverpod_generator` | 3.0.3 | **4.0.3** | HIGH | `analyzer <9.0.0` 충돌 해소 시작점 |
| `flutter_riverpod` | 3.0.3 | **3.3.1** | MEDIUM | riverpod_generator 4.x 동반 필요 |
| `go_router` | 16.3.0 | **17.2.0** | HIGH | ShellRoute observer 동작 변경 |
| `fl_chart` | 0.69.2 | **1.2.0** | HIGH | API 전면 변경 (MonthlyPriceChart 영향) |
| `google_sign_in` | 6.3.0 | **7.2.0** | MEDIUM | OAuth 2.0 강화 (보안 이점) |
| `flutter_secure_storage` | 9.2.4 | **10.0.0** | MEDIUM | 마이그레이션 가이드 필요 |
| `sign_in_with_apple` | 6.1.4 | **7.0.1** | LOW | API 변경 범위 소형 |
| `json_serializable` | 6.11.2 | **6.13.1** | LOW | riverpod_generator 4.x 충돌 해소 후 |
| `freezed` | 3.2.3 | **3.2.5** | LOW | patch — analyzer 충돌 해소 후 |

### A-2. 실행 순서 (의존성 그래프 기반)

```
Step 1: riverpod_generator 4.x + flutter_riverpod 3.3.x
        → analyzer 충돌 해소 확인
        → 코드젠 재실행 (dart run build_runner build)
        → 테스트 360건 통과 확인

Step 2: json_serializable 6.13.x + freezed 3.2.5
        → analyzer 충돌 재확인
        → freezed 재생성

Step 3: go_router 17.x
        → ShellRoute → StatefulShellRoute 마이그레이션
        → GoRouter observer 패턴 확인
        → 5탭 네비게이션 E2E 검증

Step 4: fl_chart 1.x
        → MonthlyPriceChart, PriceChart 위젯 API 업데이트
        → 위젯 테스트 재작성

Step 5: google_sign_in 7.x + flutter_secure_storage 10.x + sign_in_with_apple 7.x
        → 인증 플로우 수동 테스트 필요
```

### A-3. 위험 관리

| 위험 | 대응 |
|------|------|
| riverpod 코드젠 API 변경 | `@riverpod` 4개 provider 재검토 |
| go_router 탭 상태 유지 변경 | 5탭 시나리오별 수동 검증 |
| fl_chart API 전면 변경 | MonthlyPriceChart + PriceChart 전면 재작성 |
| 충돌 도미노 | Step 1 실패 시 이후 중단, 개별 PR 전략 |

### ⏸️ A 확인점
- [ ] riverpod_generator 4.x 업그레이드 후 analyze 0건 확인
- [ ] go_router 17.x 마이그레이션 후 360건 유지 확인
- [ ] fl_chart 1.x 업데이트 후 차트 위젯 동작 확인

---

## 방향 B: 기능 확장 (미머지 PR 통합 + 신규 기능)

> **목표**: 미머지 브랜치 3개 통합 + 신규 기능 개발
> **규모**: 중형 (2~4 세션)
> **Opus 1순위 권장**

### B-1. 미머지 브랜치 현황

| 브랜치 | 커밋 수 | 핵심 기능 | 충돌 위험 |
|--------|---------|-----------|----------|
| `feat/phase2-monthly-prices` | 3 | Monthly Price API + MonthlyPriceChart | MEDIUM |
| `feat/dark-mode` | 1 | 다크모드 UI + SharedPreferences 영속화 | LOW |
| `fix/phase0-security-stability` | 3 | Phase 0/1/2~E (보안 + ReferralScreen + SearchFilter + CD) | HIGH |

### B-2. 통합 순서

```
Step 1: feat/dark-mode (영향 최소 — AppTheme 확장)
        → main에 머지
        → AppColors 다크 팔레트 테스트 추가

Step 2: feat/phase2-monthly-prices (API + 차트)
        → GET /products/{id}/prices/monthly 서버 API 통합
        → MonthlyPriceChart Flutter 위젯 통합
        → 위젯 테스트 추가

Step 3: fix/phase0-security-stability (대형, 분리 머지)
        → Phase 0: health 메트릭, Cache-Control, TTL 클린업
        → Phase 1A: FK CASCADE 마이그레이션(020)
        → Phase 1B: GET /rewards/referrals API
        → Phase 1C: ReferralScreen + share_plus
        → Phase 1D: SearchScreen 필터/정렬
        → Phase 1E: CD 파이프라인
```

### B-3. 신규 기능 후보 (브랜치 통합 이후)

| 기능 | 설명 | 우선순위 |
|------|------|----------|
| AI 가격 예측 고도화 | 예측 정확도 향상, 더 많은 상품 지원 | HIGH |
| 알림 커스터마이징 | 알림 유형별 세밀한 제어 | MEDIUM |
| 소셜 공유 | 특정 상품 가격 알림 공유 | LOW |
| 배치 즐겨찾기 | 다중 상품 한 번에 알림 설정 | MEDIUM |

### ⏸️ B 확인점
- [ ] 3개 브랜치 통합 후 analyze 0건
- [ ] 통합 후 Flutter ≥360건 유지
- [ ] Phase 1E CD 파이프라인 동작 확인

---

## 방향 C: E2E 테스트 + CI/CD 강화

> **목표**: 통합 테스트 인프라 구축, playwright E2E, 배포 파이프라인 성숙
> **규모**: 대형 (4~6 세션)

### C-1. 현재 테스트 갭

| 영역 | 현재 | 목표 |
|------|------|------|
| Flutter 단위 테스트 | 360건 | 유지 |
| Rust lib 테스트 | 207건 | 유지 |
| Rust 통합 테스트 | 43건 (스킵) | **활성화** |
| E2E 테스트 | 0건 | **핵심 시나리오 20건** |
| 성능 테스트 | 없음 | 응답시간 P95 기준 수립 |

### C-2. Rust 통합 테스트 활성화

```
현재: cargo test --lib (207건) — DB 필요한 통합 43건 스킵
목표: docker-compose로 test DB 구동 → cargo test (207+43 = 250건)

구현:
1. docker-compose.test.yml (PostgreSQL 17.9 테스트 인스턴스)
2. .github/workflows/ci.yml에 DB 서비스 추가
3. sqlx::test 매크로 활용 → 트랜잭션 자동 롤백
```

### C-3. E2E 테스트 시나리오 (playwright)

| 시나리오 | 우선순위 |
|----------|----------|
| 로그인 → 상품 검색 → 알림 설정 | CRITICAL |
| 즐겨찾기 추가 → 목록 확인 | HIGH |
| 출석 체크인 → 포인트 확인 | HIGH |
| 가격 이력 차트 조회 | MEDIUM |
| 알림 수신 → 읽음 처리 | MEDIUM |

### C-4. CI/CD 강화

```
현재: ci.yml (flutter analyze + test --coverage)
추가:
1. Rust CI (cargo test + clippy + audit)
2. CD 파이프라인 (staging 자동 + production 수동)
3. PR 사이즈 제한 (500줄 이상 경고)
4. 커버리지 리포트 (codecov 연동)
```

### ⏸️ C 확인점
- [ ] 통합 테스트 250건 활성화
- [ ] E2E 핵심 시나리오 20건 작성
- [ ] CD staging 자동 배포 동작 확인

---

## 방향 D: 프로덕션 준비

> **목표**: 성능 최적화, 모니터링, 스케일링, 운영 안정성
> **규모**: 대형 (4~6 세션)

### D-1. 성능 최적화

| 대상 | 현재 | 목표 | 방법 |
|------|------|------|------|
| API 응답 P95 | 미측정 | < 200ms | Prometheus 히스토그램 추가 |
| DB 쿼리 P95 | 미측정 | < 50ms | SQLx EXPLAIN ANALYZE |
| Flutter 초기 로딩 | 미측정 | < 2s | DevTools 프로파일링 |
| 이미지 캐싱 | cached_network_image | 성능 검증 | 캐시 히트율 측정 |

### D-2. 모니터링 대시보드

```
현재: 22개 Prometheus 메트릭 (시스템 13 + 비즈니스 9)
추가:
1. Grafana 대시보드 템플릿 (Prometheus 연동)
2. 알림 규칙 (P95 > 500ms, 오류율 > 1% 등)
3. PostHog 프로덕트 분석 연동
4. Sentry 에러 추적 대시보드
```

### D-3. 스케일링 준비

| 항목 | 현재 | 목표 |
|------|------|------|
| DB 커넥션 풀 | `DATABASE_MAX_CONNECTIONS` 기본 5 | 부하 테스트 기반 최적화 |
| 캐시 히트율 | 4개 moka 캐시 | 메트릭 측정 후 TTL 조정 |
| Rate limit | 로그인 4s/burst3, 검색 별도 | 프로덕션 트래픽 기반 조정 |
| 파티션 관리 | 월별 파티션 + 2년 아카이브 | 파티션 프루닝 성능 검증 |

### D-4. 운영 안정성

```
1. 헬스체크 강화: /health → 상세 서브시스템 상태 반환
2. 그레이스풀 셧다운: SIGTERM → 진행 중인 요청 완료 후 종료
3. 시크릿 관리: 환경변수 → Vault 또는 Secret Manager 이전 검토
4. 백업 전략: pg_dump 자동화 + 복구 절차 문서화
5. SLO 정의: 가용성 99.9%, P95 < 200ms
```

### ⏸️ D 확인점
- [ ] Grafana 대시보드 핵심 패널 10개 구성
- [ ] SLO 기준 Prometheus 알림 설정
- [ ] 그레이스풀 셧다운 부하 테스트 통과

---

## 방향 E: 조합 (Opus 추천)

> **목표**: B → A → D 순서로 기능/품질/운영 순차 확장
> **규모**: 대형 (8~12 세션)
> **근거**: 기능 확장(B)로 베이스라인 강화 → BREAKING 업그레이드(A)로 기술 부채 해소 → 프로덕션 준비(D)로 완성

### E-1. 실행 로드맵

```
Phase E-1 (Night-40~42): 브랜치 머지 + B-Step1~3 (미머지 3개 통합)
Phase E-2 (Night-43~45): A-Step1~2 (riverpod/json 체인 업그레이드)
Phase E-3 (Night-46~48): A-Step3~5 (go_router/fl_chart/인증 업그레이드)
Phase E-4 (Night-49~51): D-1~2 (성능 측정 + Grafana 대시보드)
Phase E-5 (Night-52~54): C-2~3 (Rust 통합 테스트 + E2E 핵심 시나리오)
Phase E-6 (Night-55~57): D-3~4 (스케일링 + 운영 안정성)
```

### E-2. 체크포인트

| Phase | 게이트 조건 |
|-------|-----------|
| E-1 완료 | Flutter ≥360건, 3개 브랜치 통합, analyze 0건 |
| E-2 완료 | riverpod 4.x 적용, analyze 0건, 코드젠 재생성 |
| E-3 완료 | go_router 17.x + fl_chart 1.x, ≥360건 유지 |
| E-4 완료 | Grafana P95 메트릭 가시화 |
| E-5 완료 | 통합 테스트 250건 + E2E 20건 |
| E-6 완료 | SLO 정의 + 그레이스풀 셧다운 검증 |

---

## 실행 원칙 (PLAN_01 계승)

1. **단방향 결정 금지**: 모든 변수/대안 경로에 대해 명시적 확인 요청
2. **Phase 전환 시 필수 확인**: ⏸️ 마크 지점에서 반드시 사용자 승인
3. **Opus/Sonnet 역할 분리**:
   - Opus 4.6: 전략 설계, 아키텍처 결정, 트레이드오프 분석, 최종 코드 리뷰
   - Sonnet 4.6: 데이터 수집, 코드 탐색, 테스트 실행, 의존성 조회
4. **Ralph-loop 한도**: 최대 10회
5. **MCP degradation**: sonatype/context7/playwright 미연결 → WebSearch/feature-dev/code-explorer 대체

---

## 미결 사항 승계 (PLAN_01 → PLAN_02)

| 항목 | 등급 | 방향 |
|------|------|------|
| U-42: PLAN_02 방향 선택 | CRITICAL | 이 문서로 해소 예정 |
| U-3: 브랜치 머지 | CRITICAL | 전제 조건 |
| U-34: BREAKING 업그레이드 6건 | HIGH | 방향 A/E |
| U-41: riverpod_generator 4.x | HIGH | 방향 A/E |
| U-1: 중복 구현 채택 | HIGH | 방향 B |
| U-2: 미머지 브랜치 통합 순서 | HIGH | 방향 B |
| D-78: go_router 16→17 | DEFERRED | 방향 A/E |
| D-39: E2E 테스트 | DEFERRED | 방향 C/E |
| U-6: 통합 테스트 43건 활성화 | MEDIUM | 방향 C |
| U-39: SessionEnd hook 수정 | MEDIUM | PLAN_02 초반 |
| U-38: Sonatype MCP 인증 | MEDIUM | 인증 설정 or 영구 스킵 |

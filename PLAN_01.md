# PLAN_01.md — Night-14 종합 실용 최적화 계획

> **세션**: Night-14, 2026-03-13
> **목적**: 사용 가능한 MCP/플러그인/에이전트를 총동원하여 코드베이스 기술 수준을 실질적으로 끌어올리는 종합 최적화
> **실행 모델**: Opus 4.6 = Main Agent (전략/결정/최종 결과), Sonnet 4.6 = Sub-agent (데이터 수집/기술 실행/진행 추적)
> **전환 규칙**: 각 Phase 완료 후 반드시 사용자 승인을 받은 뒤 다음 Phase로 이동
> **Ralph Loop**: 최대 10회

---

## 이전 세션 기록 (Night-13, 완료)

- [x] PLAN_01.md 도입
- [x] auth_service.rs 순수 함수 추출 + 단위 테스트 17건
- [x] find_referrer_by_code GAP-형식 검증 강화

---

## MCP/플러그인 가용성 현황

| 도구 | 유형 | 상태 | 활용 계획 |
|------|------|------|-----------|
| **feature-dev** (code-explorer/architect/reviewer) | Agent | ✅ 작동 | Phase 1 심층 분석, Phase 2-3 코드 리뷰 |
| **coderabbit:code-reviewer** | Agent | ✅ 작동 | Phase 5 PR 전 최종 리뷰 |
| **pr-review-toolkit** (6종) | Agent | ✅ 작동 | Phase 2-3 silent-failure/type-design/test 분석 |
| **superpowers** (TDD/debugging/brainstorming) | Skill | ✅ 작동 | Phase 2-3 TDD 패턴 적용 |
| **frontend-design** | Skill | ✅ 작동 | Phase 3 UI 최적화 시 참조 |
| **WebSearch + WebFetch** | Tool | ✅ 작동 | 최신 프레임워크 문서 참조 |
| **sonatype-guide** | MCP | ❌ 인증 만료 | Phase 4에서 `cargo audit`로 대체 |
| **context7** | MCP | ❌ 서버 비활성 | WebSearch로 대체 |
| **playwright** | Plugin | ✅ 설치됨 | Phase 6 (E2E, 이번 세션 범위 외) |
| **serena** | Plugin | ✅ 설치됨 | 코드 분석 보조 |
| tailwind-gemini, chatgpt-mcp, shadcn | MCP | ❌ 미등록 | Flutter 네이티브 프로젝트로 해당 없음 |

---

## Phase 0: 환경 정비 + 분석 결과 통합

> **실행**: Opus Main + Sonnet Sub-agent 4대 결과 종합
> **예상 시간**: 10분
> **산출물**: 실행 우선순위 결정 매트릭스

### 0-A. 서브에이전트 4대 분석 결과 교차 검증
```
도구: feature-dev:code-explorer (4대 병렬 완료 후)
Main Agent 역할: 오탐 필터링 (기존 경험상 ~40% 오탐률)
산출물: CRITICAL/HIGH 실행 대상 확정 목록
```

### 0-B. 현재 브랜치 상태 정리
```
현재: auto/night-01-20260313_0100 (main + 1 commit)
변경: MORNING_BRIEFING.md만 수정됨
결정: 이 브랜치에서 작업 → 완료 후 PR 생성 여부 사용자 결정
```

### 🔒 GATE 0 → Phase 1 전환 시 사용자 승인 필요

---

## Phase 1: 서버(Rust) 실용 최적화

> **실행**: Opus Main (결정) + Sonnet Sub-agents (코딩)
> **범위**: server/src/ 내 CRITICAL/HIGH 이슈만 수정 (마이그레이션 추가 금지)

### 1-A. Silent Failure 제거 [CRITICAL]
```
도구: pr-review-toolkit:silent-failure-hunter
대상: error handling 패턴 전수 검사
작업:
  - unwrap_or_default / ok() / map_err(|_|) 패턴 → 적절한 에러 전파로 변환
  - 로깅 없는 에러 무시 → tracing::warn 추가
실행: Sonnet Sub-agent
검증: Opus Main이 최종 리뷰
```

### 1-B. 순수 함수 추출 + 단위 테스트 확대 [HIGH]
```
도구: superpowers:test-driven-development 패턴
대상:
  - notification_service.rs: 순수 함수 추출 → 3건 → 8건+
  - product_service.rs: MonthlyPriceItem DTO 변환 → 4건 → 10건+
  - reward_service.rs: 통합 테스트 환경 확인 후 가능하면 6건 추가
작업: DB 의존 로직에서 validation/transformation 분리 → 0ms 단위 테스트
실행: Sonnet Sub-agent (파일별 1대씩 병렬)
검증: cargo test --lib + cargo clippy -- -D warnings
```

### 1-C. 타입 설계 품질 검증 [MEDIUM]
```
도구: pr-review-toolkit:type-design-analyzer
대상: CheckinResult, ReferralStats, CrawlResult, AppError
작업: 캡슐화, 불변식 표현, 유용성 정량 평가
실행: Sonnet Sub-agent
산출물: 개선 권고 → 사용자 승인 후 적용
```

### 🔒 GATE 1 → Phase 2 전환 시 사용자 승인 필요
```
검증 조건:
  - cargo test --lib 전체 통과 (기존 176건 + 신규)
  - cargo clippy -- -D warnings 경고 0건
  - cargo fmt --check 통과
```

---

## Phase 2: Flutter(Dart) 실용 최적화

> **실행**: Opus Main (결정) + Sonnet Sub-agents (코딩)
> **범위**: app/lib/ 내 CRITICAL/HIGH 이슈만 수정

### 2-A. 메모리 누수 + dispose 점검 [CRITICAL]
```
도구: feature-dev:code-reviewer
대상: 모든 StatefulWidget의 dispose() 메서드
작업:
  - TextEditingController, ScrollController, AnimationController dispose 확인
  - StreamSubscription cancel 확인
  - CancelToken 적절한 해제 확인
실행: Sonnet Sub-agent
```

### 2-B. Riverpod 3.0 최적 패턴 적용 [HIGH]
```
참조: WebSearch 결과 — Riverpod 3.0 auto-pause/resume, Mutations, retry
대상:
  - FutureBuilder 잔존 여부 → @riverpod provider로 전환
  - select() 미사용 → 세분화된 리빌드로 성능 개선
  - autoDispose 미적용 provider → 메모리 효율 개선
실행: Sonnet Sub-agent
```

### 2-C. 접근성(a11y) 강화 [MEDIUM]
```
대상: LoginScreen, ProductCard 이외 화면에 Semantics 미적용
작업: 주요 화면 5개에 Semantics 레이블 추가
실행: Sonnet Sub-agent
```

### 🔒 GATE 2 → Phase 3 전환 시 사용자 승인 필요
```
검증 조건:
  - flutter test 전체 통과 (기존 164건 + 신규)
  - flutter analyze: 0 errors, 0 warnings, 0 infos
```

---

## Phase 3: 의존성 건강성 + CI 강화

> **실행**: Sonnet Sub-agent (데이터 수집) + Opus Main (결정)

### 3-A. 의존성 보안 스캔
```
도구: cargo audit (sonatype 대체)
작업:
  - cd server && cargo audit 실행 → 취약점 목록화
  - 취약점 발견 시 Cargo.toml 업데이트 + cargo check 검증
실행: Sonnet Sub-agent
```

### 3-B. Axum 0.8 호환성 확인
```
참조: WebSearch 결과 — 라우팅 구문, Handler trait, async trait 변경
작업:
  - 현재 Axum 버전 확인 (0.7 vs 0.8)
  - 0.8 마이그레이션 필요 시 영향 범위 분석만 수행 (실행은 사용자 승인 후)
실행: Sonnet Sub-agent (분석만)
```

### 3-C. CI 파이프라인 점검
```
대상: .github/workflows/ci.yml
작업:
  - cargo test (통합 포함 vs --lib only) 범위 확인
  - flutter test --coverage 출력물 확인
  - dependabot.yml 정상 동작 여부 확인
실행: Sonnet Sub-agent
```

### 🔒 GATE 3 → Phase 4 전환 시 사용자 승인 필요

---

## Phase 4: 종합 코드 리뷰 + PR 준비

> **실행**: Opus Main (전략) + 다중 리뷰 에이전트

### 4-A. CodeRabbit AI 코드 리뷰
```
도구: coderabbit:code-reviewer
대상: 이번 세션에서 변경된 모든 파일
작업: 자동 코드 리뷰 → CRITICAL/HIGH 피드백 반영
```

### 4-B. PR 테스트 커버리지 분석
```
도구: pr-review-toolkit:pr-test-analyzer
작업: 신규 코드의 테스트 커버리지 적절성 평가
```

### 4-C. Comment 품질 분석
```
도구: pr-review-toolkit:comment-analyzer
작업: 추가된 주석/문서의 정확성 검증
```

### 4-D. 최종 검증 + 커밋
```
도구: superpowers:verification-before-completion
검증:
  - cargo test --lib 통과
  - cargo clippy -- -D warnings 0건
  - flutter test 통과
  - flutter analyze 0 이슈
  - git diff --stat 변경 범위 확인
작업: 사용자 승인 후 커밋 + PR 생성 여부 결정
```

### 🔒 GATE 4 → 완료, 사용자에게 결과 보고

---

## Phase 5: 브랜치 통합 전략 (사용자 결정 대기)

> **실행하지 않음** — 사용자 결정 후 별도 세션에서 실행
> 이 Phase는 계획만 제시, 실행은 사용자 승인 시에만

### 5-A. 미머지 브랜치 통합 순서 (권장안)
```
순서 1: auto/night-01-20260313_0100 → main (현재 세션 결과물, 충돌 낮음)
순서 2: fix/phase0-security-stability → main (FK CASCADE + CD, 충돌 높음 — 별도 세션)
순서 3: feat/phase2-monthly-prices → main (monthly API + chart, 중복 제거 필요)
순서 4: feat/dark-mode → main (다크모드, 충돌 낮음)
순서 5: auto/night-01-20260310_0100 (OpenAPI — cherry-pick 또는 재작업)
```

### 5-B. 삭제 가능한 auto 브랜치 (5개)
```
auto/night-01-20260303_0100 ~ auto/night-01-20260307_0100
→ main에 PR #1으로 머지 완료, 삭제 안전
```

---

## 야간 세션 금지 항목 (유지)

- ❌ 미머지 브랜치를 main에 머지하거나 force push
- ❌ CD 파이프라인 활성화 또는 프로덕션 배포
- ❌ 외부 API 키 또는 환경변수 변경
- ❌ 마이그레이션 020 이후 번호 사용 (fix/phase0 브랜치와 충돌)
- ❌ 사용자 승인 없이 Phase 간 전환

---

## 마이그레이션 번호 현황 (변경 없음)

| 번호 | 파일 | 상태 |
|------|------|------|
| 001~017 | 기본 스키마 | main에 포함 |
| 018 | alert_unique_constraints | main에 포함 (PR #3) |
| 019 | TTL 클린업 설정 | `fix/phase0-security-stability`에만 있음 |
| 020 | FK CASCADE | `fix/phase0-security-stability`에만 있음 |
| **021+** | **신규 마이그레이션** | **019/020 머지 후에만 사용** |

---

## 진행 추적

| Phase | 상태 | 시작 | 완료 | 비고 |
|-------|------|------|------|------|
| 0 | ✅ 완료 | 2026-03-13 | 2026-03-13 | 브랜치 상태 확인 완료 |
| 1 | ✅ 완료 (1-B) | 2026-03-13 | 2026-03-13 | 순수 함수 추출 +15 테스트 (176→191) |
| 2 | 대기 | — | — | 사용자 승인 후 |
| 3 | 대기 | — | — | 사용자 승인 후 |
| 4 | 대기 | — | — | 사용자 승인 후 |
| 5 | 계획만 | — | — | 별도 세션 |

---

> 마지막 갱신: 2026-03-13 Night-14
> Main Agent: Claude Opus 4.6
> Sub-agents: Claude Sonnet 4.6
> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

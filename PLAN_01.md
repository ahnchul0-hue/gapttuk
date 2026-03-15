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
| 1 | ✅ 완료 | 2026-03-13 | 2026-03-14 | 1-A Silent failure 10건 + 1-B 순수함수 15테스트 + 1-C 타입 개선 |
| 2 | ✅ 완료 | 2026-03-14 | 2026-03-14 | 2-A try/finally dispose + 2-B Riverpod 확인 + 2-C Semantics 3화면 |
| 3 | ✅ 완료 | 2026-03-14 | 2026-03-14 | 3-A cargo audit.toml + 3-C CI 확인 |
| 4 | 대기 | — | — | 사용자 승인 후 (CodeRabbit/PR 분석) |
| 5 | 계획만 | — | — | 별도 세션 |

---

## Night-15 잔여 이슈 (Phase 0 분석에서 발견, 2026-03-15)

> Night-14 Phase 0~3 완료 후 미착수 항목. 사용자 U-15 갱신 요청에 따라 실행.

| # | 등급 | 작업 | 파일 | 상태 |
|---|------|------|------|------|
| F2 | HIGH | Colors.red → AppColors.error 교체 (3곳) | my_page_screen.dart, settings_screen.dart | ✅ 완료 |
| S8 | MEDIUM | main.rs assert! → if/continue 복구 패턴 | main.rs | ✅ 완료 |
| S9 | MEDIUM | build_runner pubspec 제약 업그레이드 | pubspec.yaml | ⚠️ 보류 (4.x 미존재) |
| F4 | MEDIUM | const 생성자 추가 (5곳) | onboarding_screen.dart, settings_screen.dart | ✅ 완료 |
| F5 | MEDIUM | router productId:0 → early return | router.dart | ✅ 완료 |
| F6 | MEDIUM | trailing slash 일관성 정리 | api_endpoints.dart + 테스트 3파일 | ✅ 완료 |
| F7 | MEDIUM | PointHistoryScreen 날짜 표시 추가 | point_history_screen.dart | ✅ 완료 |
| F8 | MEDIUM | LoadingSkeleton 다크모드 조건부 색상 | loading_skeleton.dart | ✅ 완료 |

> S2 (rotate_refresh_token 순수 함수 추출): DB 의존 함수로 순수 함수 추출 불가 — 영구 스킵
> S6 (process_referral_purchase): Night-14에서 compute_referral_rewards 추출로 부분 완료

---

---

## Night-16 종합 실용 최적화 (2026-03-16)

> **세션**: Night-16
> **목적**: 사용 가능한 MCP/플러그인/에이전트를 총동원하여 코드베이스 기술 수준을 실질적으로 끌어올리는 종합 최적화
> **실행 모델**: Opus 4.6 = Main Agent (전략/결정/최종 결과), Sonnet 4.6 = Sub-agent (데이터 수집/기술 실행/진행 추적)
> **전환 규칙**: 각 Phase 완료 후 반드시 사용자 승인을 받은 뒤 다음 Phase로 이동
> **Ralph Loop**: 최대 10회

---

### MCP/플러그인 가용성 현황 (Night-16 재점검)

| 도구 | 유형 | 상태 | 활용 계획 |
|------|------|------|-----------|
| **feature-dev** (code-explorer/architect/reviewer) | Agent | ✅ 작동 | Phase 1 심층 분석 (4대 병렬) |
| **coderabbit:code-reviewer** | Agent | ✅ 작동 | Phase 3 PR 전 최종 리뷰 |
| **pr-review-toolkit** (6종) | Agent | ✅ 작동 | Phase 2-3 silent-failure/type-design/test 분석 |
| **superpowers** (TDD/debugging/brainstorming/verification) | Skill | ✅ 작동 | Phase 2 TDD 패턴 + Phase 3 최종 검증 |
| **code-simplifier** | Agent | ✅ 작동 | Phase 2 코드 간결화 |
| **frontend-design** | Skill | ✅ 작동 | Phase 2-B Flutter UI 최적화 |
| **WebSearch + WebFetch** | Tool | ✅ 작동 | 최신 Axum/Flutter/Riverpod 문서 참조 |
| **sonatype-guide** | MCP | ⚠️ 인증 불확실 | Phase 1-C 의존성 버전 확인 시도 |
| **context7** | Plugin | ⚠️ 플러그인 활성/MCP 미등록 | Phase 1 문서 조회 시도 |
| **serena** | MCP | ❌ 글로벌 등록 but 세션 미기동 | Phase 0에서 활성화 시도 |
| **sequential-thinking** | MCP | ❌ pullcents에만 등록 | 마이그레이션 필요 → 결정 D-36 |
| **playwright** | Plugin+MCP | ⚠️ 플러그인 활성/MCP pullcents만 | E2E 테스트 (이번 세션 범위 판단 필요) |
| **mcp-tailwind-gemini** | MCP | ❌ Flutter 비해당 | Tailwind/React 전용 → 스킵 |
| **shadcn** | MCP | ❌ Flutter 비해당 | React UI 전용 → 스킵 |
| **chatgpt-mcp** | MCP | ❌ 미등록 | 어디에도 설정 없음 → 스킵 |

#### MCP 격차 원인
```
MCPs (context7, sequential-thinking, playwright, shadcn, mcp-tailwind-gemini)는
구 프로젝트 /home/code/pullcents에만 등록됨.
현재 프로젝트 /home/code/gapttuk에는 MCP 서버 0개.
serena만 ~/.claude.json 글로벌 등록이나 세션 미기동.
```

---

### 🔒 PRE-GATE: 사용자 결정 필요 (5건)

| # | 결정 | 설명 | 선택지 |
|---|------|------|--------|
| **D-36** | MCP 마이그레이션 | pullcents→gapttuk으로 MCP 설정 복사? | A) context7+sequential-thinking만 복사 B) 전부 복사 C) 마이그레이션 스킵 |
| **D-37** | Night-15 unstaged 커밋 | 15파일 +518줄 unstaged 변경 처리 | A) 별도 커밋 생성 B) Night-14 커밋과 squash C) 유지(unstaged) |
| **D-38** | Night-16 최적화 범위 | 어디에 집중할 것인가? | A) 서버+Flutter 균형 B) 서버 집중 C) Flutter 집중 D) Phase 4(리뷰+PR)만 |
| **D-39** | E2E 테스트 착수 여부 | playwright로 Flutter Web E2E? | A) 이번 세션 포함 B) 다음 세션으로 이연 |
| **D-40** | Ralph Loop 시작 | 자동 반복 모니터링 활성화? | A) Phase 2 시작 시 활성화 B) Phase 3 시작 시 활성화 C) 수동만 |

---

### Phase 0: 환경 정비 + 전제 조건 해결

> **실행**: Opus Main + Sonnet Sub-agent
> **예상**: 5~10분
> **전제**: D-36, D-37 결정 완료 후 시작

#### 0-A. MCP 마이그레이션 (D-36 결정에 따라)
```
IF D-36 == A or B:
  도구: Bash
  작업: ~/.claude.json projects["/home/code/gapttuk"].mcpServers에
        pullcents에서 선택된 MCP 설정 복사
  영향: 다음 Claude 세션부터 적용 (현 세션은 WebSearch/WebFetch로 대체)
ELSE:
  스킵 — 모든 외부 문서 참조는 WebSearch/WebFetch 사용
```

#### 0-B. Night-15 unstaged 변경사항 처리 (D-37 결정에 따라)
```
IF D-37 == A:
  작업: git add + git commit (별도 커밋)
  메시지: "feat(quality): Night-15 잔여 이슈 7건 수정 (F2/S8/F4/F5/F6/F7/F8)"
IF D-37 == B:
  작업: git add + git commit --amend (Night-14 마지막 커밋에 합침)
  주의: 이미 push된 경우 force push 필요 → 확인 필요
IF D-37 == C:
  유지 — unstaged 상태로 Night-16 작업 진행
```

#### 0-C. 현재 브랜치 상태 확인
```
현재: auto/night-01-20260316_0100
기반: main + Night-13~14 커밋 3건 + Night-15 unstaged 15파일
결정: 이 브랜치에서 Night-16 작업 계속
```

### 🔒 GATE 0 → Phase 1 전환 시 사용자 승인 필요

---

### Phase 1: 총동원 심층 분석

> **실행**: Opus Main (전략) + Sonnet Sub-agent 4~6대 (데이터 수집)
> **범위**: 서버(Rust) + Flutter(Dart) 전체 코드베이스
> **산출물**: CRITICAL/HIGH 실행 대상 확정 목록

#### 1-A. Sonnet Sub-agent 병렬 분석 (4대)
```
에이전트 1: feature-dev:code-explorer → 서버 코드 심층 분석
  - 신규 취약점, 미커버 에러 경로, 성능 병목
  - Night-14 수정 이후 잔존 이슈

에이전트 2: feature-dev:code-explorer → Flutter 코드 심층 분석
  - 메모리 누수, 불필요한 리빌드, 접근성 누락
  - Widget 트리 최적화 기회

에이전트 3: feature-dev:code-architect → 아키텍처 개선 기회 분석
  - 서버/클라이언트 간 API 계약 일관성
  - 모듈 결합도, 순환 의존성

에이전트 4: pr-review-toolkit:silent-failure-hunter → 잔존 silent failure 탐색
  - Night-14에서 10건 수정 후 추가 발견 가능한 패턴
```

#### 1-B. 최신 프레임워크 문서 참조 (WebSearch)
```
도구: WebSearch + WebFetch
대상:
  - Axum 0.8 migration guide (현재 0.7 vs 0.8 차이)
  - Flutter 3.41 breaking changes / deprecations
  - Riverpod 3.0 best practices 2026
  - moka cache 최신 API 변경사항
실행: Sonnet Sub-agent
```

#### 1-C. 의존성 건강성 재확인
```
도구: sonatype-guide MCP (시도) + cargo audit + WebSearch 대체
작업:
  - Rust: cargo audit 재실행 → 신규 취약점 확인
  - Flutter: pub outdated → 주요 의존성 업데이트 가능 여부
  - 이전 세션 RUSTSEC-2023-0071 예외 유지 확인
실행: Sonnet Sub-agent
```

#### 1-D. Opus Main: 오탐 필터링 + 우선순위 매트릭스
```
역할: Opus 4.6 Main Agent
입력: 1-A 분석 결과 4건 + 1-B 문서 참조 + 1-C 의존성
작업:
  - 오탐 필터링 (경험상 ~40% 오탐률)
  - CRITICAL/HIGH/MEDIUM 분류
  - Phase 2 실행 대상 확정 (사용자 승인 후)
산출물: 실행 매트릭스 (이 파일에 Phase 2 세부 항목으로 추가)
```

### 🔒 GATE 1 → Phase 2 전환 시 사용자 승인 필요
```
산출물:
  - CRITICAL/HIGH 실행 대상 목록
  - 예상 변경 파일 목록
  - 예상 신규 테스트 수
```

---

### Phase 2: 실행 — 서버 + Flutter 최적화 (D-38에 따라 범위 결정)

> **실행**: Opus Main (결정/리뷰) + Sonnet Sub-agents (코딩)
> **범위**: Phase 1-D 매트릭스 결과에 따라 확정
> **검증**: 각 작업 후 cargo test/flutter test 즉시 실행

#### 2-A. 서버(Rust) CRITICAL/HIGH 수정
```
도구: superpowers:test-driven-development 패턴
작업: Phase 1-D에서 확정된 서버 이슈 수정
  - 순수 함수 추출 + 단위 테스트 (TDD)
  - Silent failure 잔존분 수정
  - 성능 병목 해소
실행: Sonnet Sub-agent (파일별 병렬)
검증: cargo test --lib + cargo clippy -- -D warnings + cargo fmt --check
```

#### 2-B. Flutter(Dart) CRITICAL/HIGH 수정
```
도구: frontend-design 스킬 참조
작업: Phase 1-D에서 확정된 Flutter 이슈 수정
  - Widget 최적화 (const, 리빌드 최소화)
  - 접근성(a11y) 추가 강화
  - dispose/메모리 누수 수정
실행: Sonnet Sub-agent (화면별 병렬)
검증: flutter analyze + flutter test
```

#### 2-C. 코드 간결화
```
도구: code-simplifier:code-simplifier
대상: Phase 2-A/2-B에서 수정된 파일
작업: 변경 코드의 명확성, 일관성, 유지보수성 개선
실행: Sonnet Sub-agent
```

#### 2-D. Ralph Loop 모니터링 (D-40에 따라)
```
IF D-40 == A:
  도구: ralph-loop:ralph-loop
  설정: 10분 간격, 최대 10회
  감시: cargo test + flutter test + analyze 지속 통과 확인
```

### 🔒 GATE 2 → Phase 3 전환 시 사용자 승인 필요
```
검증 조건:
  - cargo test --lib 전체 통과 (기존 191건 + 신규)
  - cargo clippy -- -D warnings 경고 0건
  - cargo fmt --check 통과
  - flutter test 전체 통과 (기존 164건 + 신규)
  - flutter analyze: 0 errors, 0 warnings, 0 infos
```

---

### Phase 3: 종합 리뷰 + 커밋 + PR 준비

> **실행**: Opus Main (전략) + 다중 리뷰 에이전트
> **전제**: Phase 2 검증 조건 전체 통과

#### 3-A. CodeRabbit AI 코드 리뷰
```
도구: coderabbit:code-reviewer
대상: 이번 세션에서 변경된 모든 파일 (Night-15 + Night-16)
작업: 자동 코드 리뷰 → CRITICAL/HIGH 피드백 반영
실행: Sonnet Sub-agent
```

#### 3-B. PR 테스트 커버리지 분석
```
도구: pr-review-toolkit:pr-test-analyzer
작업: 신규 코드의 테스트 커버리지 적절성 평가
실행: Sonnet Sub-agent
```

#### 3-C. Silent Failure 최종 검사
```
도구: pr-review-toolkit:silent-failure-hunter
작업: Phase 2 변경 코드에 새로운 silent failure 미유입 확인
실행: Sonnet Sub-agent
```

#### 3-D. Comment 품질 분석
```
도구: pr-review-toolkit:comment-analyzer
작업: 추가된 주석/문서의 정확성 검증
실행: Sonnet Sub-agent
```

#### 3-E. 최종 검증 + 커밋
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

### 🔒 GATE 3 → 완료, 사용자에게 결과 보고

---

### 야간 세션 금지 항목 (유지)

- ❌ 미머지 브랜치를 main에 머지하거나 force push
- ❌ CD 파이프라인 활성화 또는 프로덕션 배포
- ❌ 외부 API 키 또는 환경변수 변경
- ❌ 마이그레이션 020 이후 번호 사용 (fix/phase0 브랜치와 충돌)
- ❌ 사용자 승인 없이 Phase 간 전환

---

### Night-16 진행 추적

| Phase | 상태 | 시작 | 완료 | 비고 |
|-------|------|------|------|------|
| PRE-GATE | ✅ 완료 | 2026-03-16 | 2026-03-16 | D-36~D-40 결정 완료 (D-36:C, D-37:A, D-38:A, D-39:B, D-40:C) |
| 0 | ✅ 완료 | 2026-03-16 | 2026-03-16 | Night-15 커밋(`5b9f5b9`) + 브랜치 상태 확인 |
| 1 | ✅ 완료 | 2026-03-16 | 2026-03-16 | 서브에이전트 4대 병렬 분석 — 30+건 발견, 13건 확정 |
| 2 | ✅ 완료 | 2026-03-16 | 2026-03-16 | 서버 7건 + Flutter 6건 수정, 191+164 테스트 통과 |
| 3 | ✅ 완료 | 2026-03-16 | 2026-03-16 | 검증 통과 + 커밋 |

---

> 마지막 갱신: 2026-03-16 Night-16
> Main Agent: Claude Opus 4.6
> Sub-agents: Claude Sonnet 4.6
> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

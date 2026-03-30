# PLAN_01: 값뚝(gapttuk) 종합 실무 최적화

> 작성: 2026-03-31 | 브랜치: `auto/night-01-20260331_0100`
> 베이스라인: Flutter 284건 ✅ | Rust 207건 ✅ | analyze 0 issues
> 역할: **Opus 4.6 (Main Agent)** = 전략/의사결정 | **Sonnet 4.6 (Sub-agent)** = 데이터 수집/실행

---

## 0. 사용 가능 도구 매트릭스

| 도구 | 유형 | 활용 Phase | 역할 |
|------|------|-----------|------|
| **context7** | MCP | 2, 5 | 최신 프레임워크 문서 쿼리 (axum, riverpod, sqlx 등) |
| **sonatype-guide** | MCP | 1 | 의존성 보안/품질 분석 (Rust crates + Dart packages) |
| **superpowers** | Plugin | 전체 | 브레인스토밍, 계획, 검증 |
| **feature-dev** | Plugin | 3, 5, 6 | code-architect, code-explorer, code-reviewer |
| **code-review** | Plugin | 4 | 코드 품질 리뷰 |
| **pr-review-toolkit** | Plugin | 4, 8 | silent-failure-hunter, type-design-analyzer, code-simplifier |
| **code-simplifier** | Plugin | 7 | 코드 간소화/리팩토링 |
| **commit-commands** | Plugin | 9 | 커밋 구조화 |
| **ralph-loop** | Plugin | 모니터링 | 반복 작업 (한도 10회) |
| **playwright** | Plugin | 6 | E2E 테스트 구조 설계 |
| **serena** | Plugin | 3 | 코드 분석 |
| **frontend-design** | Plugin | 5 | UI/UX 개선 설계 |
| **figma** | Plugin | 5 | 디자인 시스템 규칙 |

### 미설치/비해당 MCP (사유)
| MCP | 상태 | 사유 |
|-----|------|------|
| mcp-tailwind-gemini | 비해당 | Flutter 프로젝트 — Tailwind CSS 미사용 |
| shadcn | 비해당 | Flutter 프로젝트 — React/shadcn-ui 미사용 |
| chatgpt-mcp | 미설치 | 환경에 미구성 |
| sequential-thinking | 미설치 | 환경에 미구성 — superpowers:brainstorm으로 대체 |

---

## Phase 1: 의존성 보안 감사 (Sonatype MCP)

> **목표**: 전체 의존성 트리의 보안·품질·라이선스 검증
> **실행자**: Sonnet 4.6 Sub-agent (데이터 수집) → Opus 4.6 (판단/결정)

### 1-A. Rust Crates 감사
| 패키지 | 현재 버전 | 검사 항목 |
|--------|----------|----------|
| axum | 0.8 | CVE, 최신 안정 버전 |
| sqlx | 0.8 | CVE, 호환성 |
| tokio | 1.x | CVE |
| reqwest | 0.12 | CVE |
| sentry | 0.37 | CVE |
| jsonwebtoken | 9 | CVE |
| moka | 0.12 | CVE |
| tower_governor | 0.8 | CVE |
| a2 (APNs) | 0.10 | CVE, 유지보수 상태 |
| scraper | 0.25 | CVE |
| rand | 0.8 | CVE |

### 1-B. Dart Packages 감사
| 패키지 | 현재 버전 | 검사 항목 |
|--------|----------|----------|
| flutter_riverpod | 3.0.2 | 최신 안정, breaking changes |
| go_router | 16.0.0 | 최신 안정 |
| dio | 5.7.0 | CVE |
| fl_chart | 0.69.0 | 최신 안정 |
| kakao_flutter_sdk_user | 1.9.0 | 최신 안정 |
| google_sign_in | 6.2.0 | 최신 안정 |
| sign_in_with_apple | 6.1.0 | 최신 안정 |
| cached_network_image | 3.4.0 | 최신 안정 |
| flutter_secure_storage | 9.2.0 | CVE |

### 1-C. 산출물
- 업그레이드 필요 패키지 목록 + 호환성 영향 분석
- cargo audit / pub outdated 결과 대조

### ⏸️ 확인점 1: Phase 1 결과 리뷰 후 업그레이드 범위 결정

---

## Phase 2: 프레임워크 최신 패턴 검증 (Context7 MCP)

> **목표**: 현재 코드가 사용 중인 프레임워크의 최신 모범 사례와 정합하는지 검증
> **실행자**: Sonnet 4.6 Sub-agent (문서 쿼리) → Opus 4.6 (패턴 비교/판단)

### 2-A. 서버 (Rust) 패턴 검증
- **axum 0.8**: Router 구성, State 추출, 미들웨어 패턴
- **sqlx 0.8**: 쿼리 매크로, 마이그레이션, 커넥션 풀 최적화
- **tower 0.5**: 레이어 합성, ServiceBuilder 패턴

### 2-B. 프론트엔드 (Flutter) 패턴 검증
- **flutter_riverpod 3.0**: @riverpod 코드젠, Notifier 패턴, 에러 핸들링
- **go_router 16.x**: ShellRoute, StatefulNavigation, redirect 패턴
- **dio 5.x**: 인터셉터 패턴, 취소 토큰, 재시도 전략

### 2-C. 산출물
- 현행 vs 최신 패턴 GAP 분석표
- 권장 리팩토링 목록 (영향도 분류)

### ⏸️ 확인점 2: GAP 분석 결과 리뷰 후 리팩토링 범위 결정

---

## Phase 3: 아키텍처 심층 분석 (feature-dev + serena)

> **목표**: 코드베이스 구조적 개선점 식별
> **실행자**: Sonnet 4.6 Sub-agent (탐색) → Opus 4.6 (설계 결정)

### 3-A. 서버 아키텍처 탐색
- 서비스 간 의존성 매핑
- 에러 전파 경로 분석
- DB 쿼리 패턴 (N+1, 불필요 조인) 감사

### 3-B. Flutter 아키텍처 탐색
- Provider 의존성 그래프 분석
- 화면 간 상태 공유 패턴
- 서비스 레이어 일관성 검증

### 3-C. 산출물
- 아키텍처 개선 제안서 (우선순위별)
- 리팩토링 대상 파일/함수 목록

### ⏸️ 확인점 3: 아키텍처 개선안 승인

---

## Phase 4: 코드 품질 심층 리뷰 (code-review + pr-review-toolkit)

> **목표**: 버그, 보안 취약점, 사일런트 실패, 타입 설계 문제 탐지
> **실행자**: Sonnet 4.6 Sub-agent 병렬 실행 → Opus 4.6 (우선순위 결정)

### 4-A. 코드 리뷰 (병렬 Sub-agent 3개)
1. **code-reviewer**: 전체 변경 대비 버그/보안/로직 검사
2. **silent-failure-hunter**: catch 블록, 폴백 로직, 에러 억제 탐지
3. **type-design-analyzer**: 핵심 타입 (AppState, AppError, Product, User 등) 설계 품질

### 4-B. 산출물
- CRITICAL / HIGH / MEDIUM 분류 이슈 목록
- 즉시 수정 vs 후순위 분류

### ⏸️ 확인점 4: 수정 범위 승인

---

## Phase 5: Flutter UI/UX 개선 (frontend-design + context7)

> **목표**: UI 품질 향상, 접근성 강화, 사용자 경험 최적화
> **실행자**: Sonnet 4.6 Sub-agent (분석) → Opus 4.6 (설계) → 사용자 (핵심 로직 기여)

### 5-A. UI 패턴 분석
- 현재 화면별 UI 패턴 일관성 검증
- Material 3 디자인 가이드라인 준수도
- 접근성 (Semantics) 커버리지 확장

### 5-B. 테마 시스템 강화
- AppColors ThemeExtension 확장 (다크모드 일관성)
- 타이포그래피 시스템 표준화
- 간격/여백 상수화

### 5-C. 산출물
- UI 개선 목록 (스크린샷 기반)
- 테마 확장 코드

### ⏸️ 확인점 5: UI 개선안 승인

---

## Phase 6: 테스트 커버리지 확장 (feature-dev + playwright 구조)

> **목표**: 미커버 영역 테스트 추가, E2E 테스트 인프라 설계
> **실행자**: Sonnet 4.6 Sub-agent (갭 분석) → Opus 4.6 (전략) → 사용자 (핵심 검증 로직)

### 6-A. 커버리지 갭 분석
- Flutter: 미테스트 화면/프로바이더 식별
- Rust: 서비스별 커버리지 맵

### 6-B. 전략적 테스트 추가
- 경계값/에러 케이스 중심
- 비즈니스 로직 핵심 경로

### 6-C. 산출물
- 추가 테스트 목록 및 코드
- 커버리지 개선 수치

### ⏸️ 확인점 6: 테스트 결과 확인

---

## Phase 7: 코드 간소화 (code-simplifier + pr-review-toolkit)

> **목표**: 복잡도 감소, 중복 제거, 가독성 향상
> **실행자**: Sonnet 4.6 Sub-agent (분석/실행) → Opus 4.6 (판단)

### 7-A. 대상
- Phase 4에서 식별된 복잡 코드
- 중복 로직/패턴
- 과도한 중첩

### 7-B. 산출물
- 리팩토링된 코드 (기능 보존 검증 포함)

### ⏸️ 확인점 7: 리팩토링 결과 테스트 통과 확인

---

## Phase 8: 최종 검증 및 커밋 (commit-commands + verification)

> **목표**: 전체 변경 사항 통합 검증 및 구조화된 커밋
> **실행자**: Opus 4.6 (최종 판단)

### 8-A. 검증 체크리스트
- [ ] Flutter analyze: 0 issues
- [ ] Flutter test: 전체 통과 (≥284건)
- [ ] Rust test --lib: 전체 통과 (≥207건)
- [ ] cargo clippy: 0 warnings
- [ ] 기능 회귀 없음

### 8-B. 커밋 전략
- Phase별 논리적 커밋 분리
- 의미 있는 커밋 메시지 (feat/fix/refactor/perf)

### 8-C. 메모리 업데이트
- MORNING_BRIEFING.md 결과 기록
- 프로젝트 메모리 갱신

### ⏸️ 확인점 8: 최종 커밋 승인

---

## 실행 원칙

1. **단방향 결정 금지**: 모든 변수/대안 경로에 대해 명시적 확인 요청
2. **Phase 전환 시 필수 확인**: ⏸️ 마크 지점에서 반드시 사용자 승인
3. **Opus/Sonnet 역할 분리**:
   - Opus 4.6: 전략 설계, 아키텍처 결정, 트레이드오프 분석, 최종 코드 리뷰
   - Sonnet 4.6: 데이터 수집, 코드 탐색, 테스트 실행, 의존성 조회
4. **Ralph-loop 한도**: 최대 10회 (모니터링/반복 작업용)
5. **코드 기여 요청**: 비즈니스 로직 트레이드오프가 있는 5~10줄은 사용자에게 위임

---

## 예상 산출물 요약

| Phase | 핵심 산출물 | 예상 영향 |
|-------|-----------|----------|
| 1 | 의존성 보안 보고서 | 취약점 0건 목표 |
| 2 | 프레임워크 GAP 분석 | 최신 패턴 정합 |
| 3 | 아키텍처 개선 제안 | 구조적 부채 감소 |
| 4 | 코드 품질 이슈 목록 | 버그/보안 사전 차단 |
| 5 | UI/UX 개선 코드 | 사용자 경험 향상 |
| 6 | 테스트 추가 | 커버리지 ≥300건 |
| 7 | 리팩토링 결과 | 코드 복잡도 감소 |
| 8 | 구조화된 커밋 | 추적 가능한 변경 이력 |

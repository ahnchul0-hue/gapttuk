# PLAN_01.md — Night-23 종합 실용 최적화 계획

> **세션**: Night-23, 2026-03-23
> **목적**: 가용 MCP/플러그인/에이전트 총동원 — Night-22 미완료 항목 소진 + Silent Failure 수정 + 의존성 건강성 + 종합 코드 리뷰
> **실행 모델**: Opus 4.6 = Main Agent (전략/결정/최종 결과), Sonnet 4.6 = Sub-agent (데이터 수집/기술 실행/진행 추적)
> **전환 규칙**: 각 Phase 완료 후 반드시 사용자 승인을 받은 뒤 다음 Phase로 이동
> **Ralph Loop**: 최대 10회

---

## 누적 완료 기록 (Night-13~22)

- [x] auth_service 순수 함수 추출 + 단위 테스트 17건 (Night-13)
- [x] notification_service 순수 함수 추출 + 8건 (Night-14)
- [x] product_service DTO 변환 추출 + 12건 (Night-14)
- [x] Flutter 접근성 강화 5개 화면 (Night-15)
- [x] Riverpod select() 최적화 (Night-15)
- [x] CI 점검 + cargo audit 정상 (Night-16)
- [x] Phase 2-A/B/C 14건 결함 수정 (Night-17~18)
- [x] serde rename_all 적용 4+3개 enum (Night-19~21)
- [x] PriceTrend 직렬화 버그 수정 (Night-20)
- [x] showErrorSnackBar 통합 9개 화면 (Night-20)
- [x] parse_cursor 헬퍼 추출 (Night-20)
- [x] serde 직렬화 단위 테스트 14건 (Night-21)
- [x] confidence String/num 방어 파싱 (Night-21)
- [x] context.mounted 체크 + switch 현대화 (Night-21)
- [x] referral_code TOCTOU → retry loop 3회 (Night-22)
- [x] alert 한도 TOCTOU → SELECT FOR UPDATE + 트랜잭션 (Night-22)
- [x] serde CI 자동검증 스크립트 + ci.yml 통합 (Night-22)
- [x] HomeScreen 테스트 7건 + SearchScreen 테스트 4건 (Night-22)
- [x] Provider 테스트 5건 (productDetail/dailyPrices/popularSearches) (Night-22)
- [x] alertTypeBadge 공통 위젯 추출 (Night-22)

**Night-23 시작 기준**: Rust lib 207건 ✅, clippy clean ✅, Flutter 180건 ✅, analyze 0 ✅
**미커밋**: Night-22 변경 8 modified + 5 untracked (unstaged)

---

## MCP/플러그인 가용성 현황 (Night-23 재확인)

| 도구 | 유형 | 상태 | Night-23 활용 |
|------|------|------|---------------|
| **sonatype-guide** (3 tools) | MCP | ✅ 작동 | Phase 1 의존성 보안/품질 분석 |
| **LSP** (rust-analyzer) | Tool | ✅ 작동 | Phase 2 호출 체인 추적 |
| **feature-dev** (3종) | Agent | ✅ 작동 | Phase 2 서버→클라이언트 데이터 흐름 분석 |
| **coderabbit** | Agent | ✅ 작동 | Phase 4 종합 코드 리뷰 |
| **pr-review-toolkit** (6종) | Agent | ✅ 작동 | Phase 2/4 silent-failure/type-design/test 분석 |
| **superpowers** (검증 등) | Skill | ✅ 작동 | Phase 4 최종 검증 |
| **WebSearch + WebFetch** | Tool | ✅ 작동 | 최신 보안 권고/문서 참조 |
| **playwright** | Plugin | ✅ 설치 | 해당 Phase 없음 (E2E는 별도 세션) |
| **serena** | Plugin | ✅ 설치 | 필요 시 코드 심볼 분석 보조 |
| mcp-tailwind-gemini | MCP | ❌ | Flutter 프로젝트 — 해당 없음 |
| sequential-thinking | MCP | ❌ | Opus 자체 추론으로 대체 |
| chatgpt-mcp | MCP | ❌ | WebSearch로 대체 |
| shadcn | MCP | ❌ | Flutter 프로젝트 — 해당 없음 |

---

## Phase 0: Night-22 미커밋 변경 커밋 + 환경 확인

> **실행**: Opus Main (직접)
> **목적**: Night-22 작업물을 안전하게 커밋하여 Night-23 기반 확보

### 0-A. Night-22 변경 커밋
```
작업:
  - git add (8 modified + 5 untracked)
  - 커밋 메시지: "feat(quality): Night-22 TOCTOU 해결 + serde CI + Flutter 테스트 +16건"
  - 커밋 후 cargo test --lib / flutter test / check_serde_enums.py 재검증
산출물: 안정적 커밋 기반
사용자 결정: 커밋 허용 여부
```

### 0-B. 현재 브랜치명 갱신
```
현재: auto/night-01-20260323_0100 (이미 갱신됨)
또는: auto/night-01-20260322_0100에서 계속 작업
→ 사용자 결정 필요
```

### 🔒 GATE 0 → Phase 1 전환 시 사용자 승인 필요
```
보고: Night-22 커밋 완료 여부 + 테스트 기준선 확인
```

---

## Phase 1: 의존성 건강성 분석 (Night-22 Phase 3 이어받기)

> **실행**: Sonnet Sub-agents (병렬 데이터 수집) → Opus Main (판단)
> **범위**: sonatype 의존성 스캔 + cargo audit + flutter pub outdated

### 1-A. sonatype-guide 핵심 의존성 분석
```
도구: sonatype-guide (getRecommendedComponentVersions + getLatestComponentVersion)
대상 (Rust):
  - pkg:cargo/axum@0.8.1
  - pkg:cargo/sqlx@0.8.3
  - pkg:cargo/jsonwebtoken@9.3.1
  - pkg:cargo/reqwest@0.12.15
  - pkg:cargo/rand@0.8.5
  - pkg:cargo/sentry@0.37.0
  - pkg:cargo/scraper@0.25.0
대상 (Dart):
  - pkg:pub/dio@5.7.0
  - pkg:pub/go_router@16.0.0
  - pkg:pub/flutter_riverpod@3.0.2
산출물: 보안/품질/라이선스 점수 비교 + 업그레이드 권고
실행: Sonnet Sub-agent 2대 (Rust/Dart 병렬)
```

### 1-B. cargo audit 보안 취약점 스캔
```
도구: cargo audit (Bash)
산출물: 취약점 목록 (0건 목표)
실행: Sonnet Sub-agent (1-A와 병렬)
```

### 1-C. flutter pub outdated
```
도구: flutter pub outdated (Bash)
산출물: 업그레이드 가능 패키지 목록
실행: Sonnet Sub-agent (1-A와 병렬)
```

### 🔒 GATE 1 → Phase 2 전환 시 사용자 승인 필요
```
보고:
  - sonatype 분석 결과 테이블 (보안/품질/라이선스 점수)
  - cargo audit 결과 요약
  - flutter pub outdated 주요 항목
  - 업그레이드 권고 (실행은 사용자 승인 후에만)
```

---

## Phase 2: Night-22 미완료 항목 실행

> **실행**: Opus Main (설계/결정) + Sonnet Sub-agents (코딩)
> **범위**: Silent Failure 수정 + rust_decimal API 계약 검증 + formatPrice 정리

### 2-A. Silent Failure HIGH 항목 수정 [HIGH]
```
Night-22 발견 HIGH 항목 (4건):
  1. auth_service.rs:230 — let _ = tx.rollback() → warn! 로깅 추가
  2. main.rs:275,301,328 — let _ = tx.rollback() 3건 → warn! 로깅 추가
  3. alert_service.rs:557 — .unwrap_or_default() → warn! + 빈 디바이스 로그
수정: 각 위치에 warn! 또는 error! 트레이싱 추가 (동작 변경 없이 관측성만 확보)
실행: Sonnet Sub-agent
```

### 2-B. rust_decimal serde-with-str API 계약 검증 [HIGH]
```
문제: Cargo.toml serde-with-str → Decimal이 JSON String으로 직렬화
      Flutter Product 모델에 unit_price/rating/sales_velocity 3필드 없음
분석:
  - 서버 ProductResponse 구조체에서 이 3필드의 직렬화 여부 확인
  - Flutter Product.fromJson에 영향 여부 확인
  - 불일치 발견 시 → 수정 방향 사용자 결정 (skip_serializing or Flutter 방어 파싱)
도구: feature-dev:code-explorer (서버→클라이언트 데이터 흐름 추적)
실행: Sonnet Sub-agent (2-A와 병렬)
→ 사용자 결정 필요: 불일치 발견 시 수정 방향
```

### 2-C. formatPrice 유틸리티 레이어 정리 [MEDIUM]
```
문제: UI 포맷 함수가 widget 레이어에 분산
확인: formatPrice 함수 사용처 전수 조사 → 추출 가치 판단
  - 중복이 3곳 이상이면 utils/format_utils.dart로 이동
  - 중복이 적으면 현 상태 유지 (과도한 추상화 방지)
실행: Sonnet Sub-agent (2-A/2-B와 병렬)
→ 사용자 결정 필요: 추출 여부
```

### 🔒 GATE 2 → Phase 3 전환 시 사용자 승인 필요
```
검증:
  - cargo test --lib 전체 통과
  - cargo clippy -- -D warnings 0건
  - flutter test 전체 통과
  - flutter analyze 0 이슈
보고:
  - Silent Failure 수정 결과
  - rust_decimal API 계약 분석 결과 + 수정 방향 제안
  - formatPrice 분석 결과 + 추출 여부 권고
```

---

## Phase 3: 추가 테스트 확대 + 코드 품질

> **실행**: Opus Main (설계) + Sonnet Sub-agents (코딩)
> **범위**: 핵심 비즈니스 화면 테스트 + Silent Failure 단위 테스트

### 3-A. ProductDetailScreen 테스트 [HIGH]
```
문제: 핵심 비즈니스 화면 테스트 0건
작업: 기본 렌더링 + 가격 표시 + 알림 설정 + 에러 상태 (4-6건)
제약: AppTheme.light 주입 필수, mock ProductService 필요
실행: Sonnet Sub-agent
```

### 3-B. AlertScreen/FavoritesScreen 테스트 [MEDIUM]
```
문제: Night-22에서 alertTypeBadge 추출 후 연결 검증 필요
작업: 알림 목록 렌더링 + 알림 타입 배지 표시 + 필터링 (각 3-4건)
실행: Sonnet Sub-agent (3-A와 병렬)
```

### 3-C. Night-22 Silent Failure 수정 단위 테스트 [MEDIUM]
```
문제: Phase 2-A에서 추가한 warn! 로깅이 실제 동작하는지 검증
작업: 롤백 실패 시나리오 모킹 → warn! 로깅 확인 (가능한 범위 내)
실행: Sonnet Sub-agent (3-A와 병렬)
→ 사용자 결정 필요: 통합 테스트 범위 vs lib 테스트 범위
```

### 🔒 GATE 3 → Phase 4 전환 시 사용자 승인 필요
```
검증:
  - flutter test 전체 통과 (180건 + 신규)
  - flutter analyze 0 이슈
  - cargo test --lib 통과 (207건 + 신규)
보고:
  - 신규 테스트 건수 + 커버리지 개선 요약
```

---

## Phase 4: 종합 코드 리뷰 + 최종 커밋

> **실행**: Opus Main (전략) + 다중 리뷰 에이전트 병렬
> **목적**: Night-22+23 전체 변경에 대한 다각도 자동 리뷰 → CRITICAL/HIGH 반영

### 4-A. CodeRabbit AI 코드 리뷰
```
도구: coderabbit:code-reviewer
대상: Night-22+23 전체 변경 파일
작업: 자동 리뷰 → CRITICAL/HIGH 피드백 반영
```

### 4-B. Silent Failure 재검증
```
도구: pr-review-toolkit:silent-failure-hunter
대상: Phase 2-A 수정 후 잔존 silent failure 확인
```

### 4-C. Type Design 품질 검증
```
도구: pr-review-toolkit:type-design-analyzer
대상: Night-22+23에서 추가/변경된 타입들
```

### 4-D. 코드 간결화 리뷰
```
도구: pr-review-toolkit:code-simplifier
대상: Night-23 변경 파일
작업: 불필요한 복잡성, 중복, 비효율 식별
```

### 4-E. 최종 검증 + 커밋
```
도구: superpowers:verification-before-completion
검증:
  - cargo test --lib 전체 통과
  - cargo clippy -- -D warnings 0건
  - cargo fmt --check 통과
  - flutter test 전체 통과
  - flutter analyze 0 이슈
  - serde CI 체크 통과
작업: 사용자 승인 후 커밋 + NIGHT_06_RESULT.md 업데이트
```

### 🔒 GATE 4 → Phase 5 전환 시 사용자 승인 필요
```
보고:
  - 4-A~D 리뷰 결과 요약 (CRITICAL/HIGH 피드백 + 반영 여부)
  - 최종 테스트 결과
  - 커밋 완료 확인
```

---

## Phase 5: 문서 업데이트 + 브랜치 전략

> **실행**: Opus Main (직접)
> **목적**: NIGHT_06_RESULT.md + MORNING_BRIEFING.md 업데이트, 브랜치 전략 제안

### 5-A. NIGHT_06_RESULT.md 업데이트
```
Night-23 결과 기록:
  - Phase별 완료 항목 + 변경 파일 + 테스트 증감
  - sonatype 분석 결과 요약
  - 코드 리뷰 주요 발견/반영 사항
```

### 5-B. MORNING_BRIEFING.md 업데이트
```
Night-23 전략 분석 추가:
  - 전략 성숙도 곡선 업데이트
  - 핵심 결정(Decision) 기록
  - 미해결 과제 목록
```

### 5-C. 브랜치 통합 전략 (계획만, 실행은 사용자 승인 시에만)
```
권장 순서:
  1. auto/night-01 → main (현 브랜치, Night-13~23 전체, 충돌 낮음)
  2. feat/dark-mode → main (독립적, 충돌 낮음)
  3. fix/phase0-security-stability → main (FK CASCADE + CD, 충돌 중간~높음)
  4. feat/phase2-monthly-prices → main (API + Chart, 중복 확인 필요)
삭제 후보: auto/night-01-2026030X 16개 (현 브랜치에 통합 완료)
```

### 🔒 GATE 5 → 세션 완료

---

## 야간 세션 금지 항목 (유지)

- ❌ 미머지 브랜치를 main에 머지하거나 force push
- ❌ CD 파이프라인 활성화 또는 프로덕션 배포
- ❌ 외부 API 키 또는 환경변수 변경
- ❌ 마이그레이션 020 이후 번호 사용 (fix/phase0 브랜치와 충돌)
- ❌ 사용자 승인 없이 Phase 간 전환
- ❌ firebase_messaging 패키지 추가 (FCM 완성은 별도 세션)

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

## 실행 예산 요약

| Phase | 예상 Sonnet Sub-agent 수 | 주요 도구 |
|-------|--------------------------|-----------|
| 0 | 0 (Opus 직접) | git commit |
| 1 | 3 (병렬) | sonatype-guide, cargo audit, flutter pub |
| 2 | 3 (병렬) | feature-dev:code-explorer, Grep/Read, LSP |
| 3 | 3 (병렬) | 직접 코딩 (테스트 작성) |
| 4 | 4 (병렬) | coderabbit, pr-review-toolkit (3종) |
| 5 | 0 (Opus 직접) | 문서 작성 |
| **계** | **~13회** | — |

# PLAN_01: 값뚝(gapttuk) 종합 실무 최적화

> 작성: 2026-03-31 | **실행: 2026-04-01 ~ 진행 중** | 브랜치: `auto/night-01-20260516_0100`
> 베이스라인: Flutter 296건 ✅ | Rust 207건 ✅ | analyze 0 issues
> **Night-70 현재**: Flutter **380건** ✅ | Rust **221건** ✅ | analyze 0건 ✅ | **Phase 1~23 완료(Phase 23: 6대 병렬 에이전트 → 즉시 수정 9건(F-01~F-09) + D-126~D-130 신규), Phase 24-25 대기**
> 역할: **Opus 4.6 (Main Agent)** = 전략/의사결정 | **Sonnet 4.6 (Sub-agent)** = 데이터 수집/실행
> Ralph-loop 한도: **10회**
>
> ### Phase 진행 현황
> | Phase | 상태 | 완료 Night | 핵심 성과 |
> |-------|------|-----------|----------|
> | 1 | ✅ 완료 | Night-31 | Rust CVE 0건, Dart CVE 0건, Skia CVE 2건(Flutter팀 대기) |
> | 2 | ✅ 완료 | Night-31 | axum/riverpod/sqlx/go_router 패턴 정합 확인 |
> | 3 | ✅ 완료 | Night-31 | 아키텍처 개선 제안 도출 |
> | 4 | ✅ 완료 | Night-35 | 37건 발견 → 오탐 6건 제외 → 5건 수정 |
> | 5 | ✅ 완료 | Night-36 | PD-62 AlertType Enum + AppSpacing/TextStyles 테마 상수 |
> | 6 | ✅ 완료 | Night-34 | 테스트 296→358건 (+62건) |
> | 7 | ✅ 완료 | Night-37 | 코드 간소화 + 의존성 3건 업그레이드 |
> | 8 | ✅ 완료 | Night-37 | 최종 검증 + 구조화된 커밋 |
> | 9 | ✅ 완료 | Night-47 | Rust 11개 + Dart 9개 의존성 분석, CVE 0건 |
> | 10 | ✅ 완료 | Night-48 | 17건 발견 → 9건 확정 (HIGH 2 + MEDIUM 3 + LOW 4) |
> | 11 | ✅ 완료 | Night-49 | Rust 5건 + Flutter 8건 GAP 분석, D-88~D-92 도출 |
> | 12 | ✅ 완료 | Night-50 | 9건 발견(HIGH 1 + MEDIUM 3 + LOW 5), D-93~D-96 도출 |
> | 13 | ✅ 완료 | Night-52 | 8건 수정(I-01/I-02/F-08/U-02/D-91/D-89/D-94/D-90) |
> | 14 | ✅ 완료 | Night-53 | 3중 검증 통과(Flutter 361건/Rust 207건/analyze 0건) |
> | 15 | ✅ 완료 | Night-58 | NaverSearch 파이프라인(Rust 2서비스+Flutter 5파일+migration 019) |
> | 16 | ✅ 완료 | Night-58 | 의존성 분석, BREAKING 이연(D-101~D-103 확정) |
> | 17 | ✅ 완료 | Night-60 | 아키텍처 고도화(moka 캐시+1h 배치+OnceLock 제거) |
> | 18 | ✅ 완료 | Night-61 | 코드 품질 점검 5건 수정(I-03/I-04/I-05/F-09/F-10) |
> | **19** | **✅ 완료** | **Night-62** | **3중 검증 통과(370건/216건/0건) + PLAN_01 전체 종결 선언** |
> | **20** | **✅ 완료** | **Night-68** | **MCP 전수 실측: 0 불일치, CoinInfo/OpenDart 비해당** |
> | **21** | **✅ 완료** | **Night-68** | **인구통계 파이프라인: Rust 1서비스+Flutter 4파일, 테스트 380/221건** |
> | **22** | ✅ 완료 | Night-69 | 트랜지티브 24개↑ + BREAKING 분석 완료 (D-101/D-102 사용자 결정 대기, D-119/D-120 신규) |
> | **23** | **✅ 완료** | **Night-70** | **6대 병렬 에이전트 감사 → 즉시 수정 9건(F-01~F-09) + D-126~D-130 신규** |
> | **24** | ⏳ 대기 | — | 프론트엔드 UX + 디자인 시스템 강화 (D-95/D-96 해소) |
> | **25** | ⏳ 대기 | — | 최종 검증 + 구조화 커밋 + 베이스라인 갱신 |

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

### 미설치/비해당 MCP (Night-37 실측)
| MCP | 상태 | 사유 |
|-----|------|------|
| mcp-tailwind-gemini | 비해당 | Flutter 프로젝트 — Tailwind CSS 미사용 |
| shadcn | 비해당 | Flutter 프로젝트 — React/shadcn-ui 미사용 |
| chatgpt-mcp | 미설치 | 환경에 미구성 |
| sequential-thinking | 미설치 | 환경에 미구성 — superpowers:brainstorm으로 대체 |
| context7 | 설치됨/미연결 | `.mcp.json` 존재하나 세션 미연결 — **WebSearch로 대체** |
| playwright | 설치됨/미연결 | `.mcp.json` 존재하나 세션 미연결 — **feature-dev:code-architect로 대체** |
| serena | 설치됨/미연결 | `.mcp.json` 존재하나 세션 미연결 — **feature-dev:code-explorer로 대체** |
| sonatype-guide | 설치됨/인증필요 | 3개 도구 활성이나 **인증 미구성** — WebSearch 대체 유지 |

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

### 1-C. 산출물 (2026-04-01 실행 결과)

> **도구**: Sonatype MCP (인증 미구성 → WebSearch + pub outdated 대체)
> **실행자**: Sonnet 4.6 Sub-agent ×3 (병렬) → Opus 4.6 종합

#### 🔴 CRITICAL / HIGH 발견 사항

| # | 대상 | CVE/Advisory | 심각도 | 상태 | 조치 |
|---|------|-------------|--------|------|------|
| C-1 | **tokio** (Rust) | RUSTSEC-2025-0023 | Medium (Unsound) | ✅ **이미 해결** — 현재 1.50.0 ≥ 패치(1.44.2) | 추가 조치 불필요 |
| C-2 | **Cargo toolchain** | CVE-2026-33056 (tar-rs) | Medium | ⚠️ 빌드타임 — Rust ≥1.94.1 필요 | 서버 빌드 환경에서 rustup update |
| C-3 | **Flutter/Skia** | CVE-2025-27363 (FreeType OOB) | HIGH (CISA KEV) | ⚠️ 불확실 — Flutter 3.41.x Skia 번들 확인 필요 | Flutter 최신 패치 모니터링 |
| C-4 | **Flutter/Skia** | CVE-2026-3909 (Skia zero-day) | HIGH (8.8) | ⚠️ 불확실 — 엔진 패치 대기 | Flutter stable 업데이트 시 즉시 적용 |
| C-5 | **Dart SDK** | CVE-2026-27704 (pub path traversal) | HIGH | ✅ **이미 해결** — SDK ^3.11.1 / Flutter 3.41.3 | 추가 조치 불필요 |

#### ✅ Rust Crates — 보안 청정 (30개 직접 의존성)

| 크레이트 | 현재 버전 | 상태 |
|----------|----------|------|
| axum | 0.8.8 | ✅ CVE 없음 |
| sqlx | 0.8.6 | ✅ CVE 없음 |
| reqwest | 0.12.28 | ✅ CVE 없음 |
| jsonwebtoken | 9.3.1 | ✅ CVE 없음 |
| sentry | 0.37.0 | ✅ CVE 없음 |
| moka | 0.12.15 | ✅ CVE 없음 |
| a2 | 0.10.0 | ✅ CVE 없음 (APNs 인증서 호환성 확인 권장) |
| scraper | 0.25.0 | ✅ CVE 없음 |
| 기타 (tokio, tower, chrono, rand, etc.) | 최신 | ✅ 전부 청정 |

#### 📦 Dart Packages — 업그레이드 후보 (pub outdated)

| 패키지 | 현재 | Resolvable | Latest | 유형 | 권장 |
|--------|------|-----------|--------|------|------|
| **flutter_riverpod** | 3.0.3 | 3.0.3 | **3.3.1** | minor | ⬆️ 업그레이드 (API 호환) |
| **go_router** | 16.3.0 | 16.3.0 | **17.1.0** | **BREAKING** | ⏸️ 영향 분석 후 결정 |
| **fl_chart** | 0.69.2 | 0.69.2 | **1.2.0** | **BREAKING** | ⏸️ API 변경 범위 확인 필요 |
| **flutter_secure_storage** | 9.2.4 | 9.2.4 | **10.0.0** | **BREAKING** | ⏸️ 마이그레이션 가이드 확인 |
| **google_sign_in** | 6.3.0 | 6.3.0 | **7.2.0** | **BREAKING** | ⏸️ OAuth 2.0 강화 — 보안 이점 |
| **sign_in_with_apple** | 6.1.4 | 6.1.4 | **7.0.1** | **BREAKING** | ⏸️ 영향 분석 후 결정 |
| **intl** | 0.19.0 | 0.19.0 | **0.20.2** | minor | ⬆️ 업그레이드 (API 호환) |
| **json_annotation** | 4.9.0 | 4.9.0 | **4.11.0** | minor | ⬆️ 업그레이드 |
| cupertino_icons | 1.0.8 | 1.0.9 | 1.0.9 | patch | ⬆️ 즉시 |
| build_runner (dev) | 2.12.1 | 2.13.1 | 2.13.1 | minor | ⬆️ 업그레이드 |
| freezed (dev) | 3.2.3 | 3.2.3 | **3.2.5** | patch | ⬆️ 즉시 |
| json_serializable (dev) | 6.11.2 | 6.13.0 | **6.13.1** | minor | ⬆️ 업그레이드 |
| riverpod_generator (dev) | 3.0.3 | 3.0.3 | **4.0.3** | **BREAKING** | ⏸️ riverpod 3.3.1과 함께 결정 |

#### 📊 Phase 1 종합 판정

| 항목 | 결과 |
|------|------|
| **Rust 보안** | ✅ 취약점 0건 (tokio 이미 패치, cargo audit.toml RUSTSEC-2026-0049 ignore 유지) |
| **Dart 보안** | ✅ 직접 패키지 CVE 0건 / ⚠️ 엔진 레벨 Skia CVE 2건 (Flutter 팀 패치 대기) |
| **즉시 가능 업그레이드** | 6건 (minor/patch — cupertino_icons, intl, json_annotation, build_runner, freezed, json_serializable) |
| **BREAKING 업그레이드** | 6건 (go_router, fl_chart, flutter_secure_storage, google_sign_in, sign_in_with_apple, riverpod_generator) |

### ⏸️ 확인점 1: Phase 1 결과 리뷰 후 업그레이드 범위 결정

**사용자 결정 필요 사항:**

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-58** | minor/patch 6건 즉시 업그레이드? | A) 전체 적용 / B) 선택적 / C) 보류 |
| **D-59** | BREAKING 6건 중 이번에 시도할 범위? | A) 전체 / B) 보안 이점 있는 것만 (google_sign_in) / C) 전부 보류 |
| **D-60** | flutter_riverpod 3.0→3.3 업그레이드? | A) 예 (riverpod_generator 4.x 동반) / B) 3.0 유지 |
| **D-61** | Sonatype MCP 인증 설정 진행? | A) 예 (API 키 제공) / B) WebSearch 대체 유지 |

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

## Phase 7: 코드 간소화 + 프레임워크 정합 보완 (Night-37)

> **목표**: 복잡도 감소, 중복 제거, 프레임워크 최신 패턴 정합, 의존성 minor 업그레이드
> **실행자**: Sonnet 4.6 Sub-agent (분석/실행) → Opus 4.6 (판단/리뷰)
> **도구**: code-simplifier, pr-review-toolkit:code-simplifier, feature-dev:code-reviewer, WebSearch

### 7-A. 프레임워크 최신 패턴 정합 보완 (Night-37 WebSearch 결과 기반)

> Night-37에서 WebSearch로 조회한 프레임워크 최신 패턴 GAP 분석 결과:

| # | 대상 | 현재 | 최신 패턴 | 조치 | 영향도 |
|---|------|------|----------|------|--------|
| 7-A1 | **go_router** | 16.3.0 | 17.2.0 (Dart 3.9 필요) | ⏸️ pubspec `^16.0.0` → `^17.0.0` 업그레이드 검토 | MEDIUM |
| 7-A2 | **Riverpod auto-retry** | 3.0.3 (기본 활성) | auto-retry 동작 확인 | ✅ 4개 `@riverpod` FutureProvider는 데이터 패칭 → 유익. 조치 불필요 | LOW |
| 7-A3 | **Riverpod legacy 패턴** | 미사용 | StateProvider 등 제거 | ✅ 이미 `@riverpod` 코드젠 전용 → 조치 불필요 | — |
| 7-A4 | **Axum `#[async_trait]`** | 미사용 | native async trait | ✅ 이미 정합 → 조치 불필요 | — |
| 7-A5 | **SQLx 0.8.6** | 0.8.6 | 0.8.6 (최신) | ✅ RUSTSEC-2024-0363 이미 해결 → 조치 불필요 | — |
| 7-A6 | **minor 의존성** | 현재 | 최신 patch/minor | cupertino_icons, intl, json_annotation, build_runner, freezed, json_serializable 업그레이드 | LOW |

**사용자 결정 필요:**

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-78** | go_router 16→17 업그레이드? (ShellRoute observer 동작 변경) | A) 예 (테스트 후) / B) 보류 |
| **D-79** | minor/patch 6건 즉시 업그레이드? | A) 전체 / B) 선택적 / C) 보류 |

### 7-B. Rust 서버 코드 간소화 (Night-37 Explore Sub-agent 결과 기반)

> **실행**: Sonnet Sub-agent (code-simplifier) → Opus (리뷰)

| # | 파일 | 설명 | 예상 감소 | 영향도 |
|---|------|------|----------|--------|
| 7-B1 | `alert_service.rs:90-379` | `create_*_alert` 3함수 트랜잭션 보일러플레이트 → 공통 헬퍼 `begin_alert_tx_checked()` 추출 | ~60줄 | HIGH |
| 7-B2 | `main.rs:202-363` | `archive_old_price_history` 162줄 → `build_aggregate_sql`/`build_verify_sql` 분리 | ~80줄 | HIGH |
| 7-B3 | `alert_service.rs:504-640` | `evaluate_price_alerts` 5관심사 → 푸시 디스패치 `dispatch_push_for_claimed_alerts()` 추출 | ~35줄 | HIGH |
| 7-B4 | `auth_service.rs:207,316` | `refresh_token_expiry` TTL 계산 중복 → 공통 함수 추출 | ~10줄 | MEDIUM |
| 7-B5 | `main.rs:79-185` | `ensure_partitions` 파티션 접미사 검증 중복 → `is_safe_partition_suffix()` 추출 | ~15줄 | MEDIUM |
| 7-B6 | `alert_service.rs:703-713` | `format_price` → `utils` 모듈로 이동 (재사용 대비) | ~5줄 | LOW |

### 7-C. Flutter 코드 간소화 (Night-37 Explore Sub-agent 결과 기반)

> **실행**: Sonnet Sub-agent (code-simplifier) → Opus (리뷰)

| # | 파일 | 설명 | 예상 감소 | 영향도 |
|---|------|------|----------|--------|
| 7-C1 | `alert/favorites/notification` | 에러 상태 위젯 3화면 동일 → `ScreenErrorWidget` 공통 위젯 추출 | ~75줄 | HIGH |
| 7-C2 | `alert_screen.dart:75-160` | `_toggle*Alert`/`_delete*Alert` 9메서드 → 제네릭 1-2메서드 통합 | ~60줄 | HIGH |
| 7-C3 | `point_history/notification_list` | 무한스크롤 스켈레톤 (cursor+_hasMore+_isLoading+ScrollController) → 공통 mixin 검토 | ~50줄 | MEDIUM |
| 7-C4 | `onboarding_screen.dart:175-253` | `_buildBottomButtons` 3 case 반복 ElevatedButton → `_primaryButton` 추출 | ~30줄 | LOW |

### 7-D. 코드 리뷰 (Opus Main Agent)

> Phase 7-B/C 완료 후 pr-review-toolkit 병렬 리뷰

| # | 도구 | 검사 대상 |
|---|------|----------|
| 7-D1 | pr-review-toolkit:code-reviewer | 간소화 결과 전체 diff |
| 7-D2 | pr-review-toolkit:silent-failure-hunter | 간소화 과정의 에러 억제 도입 여부 |

### ⏸️ 확인점 7: 간소화 결과 + 테스트 통과 확인

**검증 기준:**
- [ ] Flutter analyze: 0 issues
- [ ] Flutter test: ≥358건 통과
- [ ] Rust test --lib: ≥207건 통과
- [ ] 기능 회귀 없음 (diff 리뷰)

---

## Phase 8: 최종 검증 및 커밋 (Night-37)

> **목표**: 전체 변경 사항 통합 검증 및 구조화된 커밋
> **실행자**: Opus 4.6 (최종 판단)
> **도구**: Bash(flutter test/analyze, cargo test/clippy), pr-review-toolkit:code-reviewer, commit-commands

### 8-A. 검증 체크리스트
- [ ] Flutter analyze: 0 issues
- [ ] Flutter test: 전체 통과 (≥358건)
- [ ] Rust test --lib: 전체 통과 (≥207건)
- [ ] cargo clippy: 0 warnings
- [ ] 기능 회귀 없음 (전체 diff 리뷰)

### 8-B. 커밋 전략
- Phase 7 간소화: `refactor(quality): Night-37 Phase 7 코드 간소화 + 프레임워크 정합`
- Phase 8 문서: `docs: MORNING_BRIEFING.md Night-37 커밋 해시 업데이트`

### 8-C. 메모리 업데이트
- MORNING_BRIEFING.md Night-37 결과 기록
- 프로젝트 메모리 갱신 (테스트 수, Phase 완료 상태)
- PLAN_01.md Phase 7/8 완료 마킹

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

| Phase | 핵심 산출물 | 예상 영향 | 상태 |
|-------|-----------|----------|------|
| 1 | 의존성 보안 보고서 | 취약점 0건 달성 | ✅ Night-31 |
| 2 | 프레임워크 GAP 분석 | 최신 패턴 정합 확인 | ✅ Night-31 |
| 3 | 아키텍처 개선 제안 | 구조적 부채 식별 | ✅ Night-31 |
| 4 | 코드 품질 이슈 목록 | 37건→5건 수정 | ✅ Night-35 |
| 5 | UI/UX 개선 코드 | AlertType Enum + 테마 상수 | ✅ Night-36 |
| 6 | 테스트 추가 | 296→358건 (+62건) | ✅ Night-34 |
| 7 | 코드 간소화 + 정합 보완 | 복잡도 감소 + minor 업데이트 | ✅ Night-37 |
| 8 | 구조화된 커밋 + 문서 | 추적 가능한 변경 이력 | ✅ Night-37 |

---

# PLAN_01 확장: Phase 9-14 종합 실무 최적화 (Night-47~)

> 작성: 2026-04-27 | **실행: Night-47 시작** | 브랜치: `auto/night-01-20260427_0100`
> 베이스라인: Flutter **360건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (2026-04-27 실측)
> main 대비: **75 커밋** ahead
> 역할: **Opus 4.6 (Main Agent)** = 전략/의사결정/최종 코드 리뷰 | **Sonnet 4.6 (Sub-agent)** = 데이터 수집/탐색/실행
> Ralph-loop 한도: **10회**
> **U-42 해소**: 사용자가 종합 실무 최적화를 지시 → PLAN_02 방향 E(조합) 기반 실행
>
> ### Phase 9-14 진행 현황
> | Phase | 상태 | 핵심 목표 | 주요 도구 |
> |-------|------|-----------|----------|
> | 9 | ✅ **완료 (Night-47)** | 의존성 보안/품질 심층 분석 | **WebSearch+pub outdated** (Sonatype 인증 미구성 → 대체) |
> | 10 | ✅ **완료 (Night-48)** | 코드 품질 심층 리뷰 | **coderabbit** + **pr-review-toolkit** (4종) — 17건 발견 → 9건 확정 |
> | 11 | ✅ **완료 (Night-49)** | 아키텍처 분석 + 프레임워크 최신화 | **feature-dev** (3종) + **WebSearch** — Rust 5건+Flutter 8건 신규 GAP, Axum GAP 없음 |
> | 12 | ⏳ 대기 | 프론트엔드 UI/UX 감사 | **frontend-design** + **figma** |
> | 13 | ✅ **완료 (Night-51/52)** | 발견 사항 기반 코드 수정 실행 (8건) | Opus 직접 실행 + Sonnet 병렬 |
> | 14 | ✅ **완료 (Night-53)** | 최종 검증 + 베이스라인 보존 확인 | Flutter 361건 / Rust 207건 / analyze 0건 |

---

## 0-E. 도구 가용성 실측 매트릭스 (2026-04-27 실측)

### 즉시 사용 가능 (활성)
| 도구 | 유형 | API 수 | 활용 Phase |
|------|------|--------|-----------|
| **Sonatype Guide** | MCP | 3 | 9 (의존성 분석) |
| **Hugging Face** | MCP | 8 | 11 (문서 검색) |
| **superpowers** | Plugin | 12 스킬 | 전체 (계획/검증) |
| **feature-dev** | Plugin | 3 에이전트 | 10-11 (코드 탐색/리뷰/설계) |
| **pr-review-toolkit** | Plugin | 6 에이전트 | 10, 13 (품질/타입/간소화) |
| **coderabbit** | Plugin | 2 스킬 | 10 (코드 리뷰) |
| **frontend-design** | Plugin | 1 스킬 | 12 (UI/UX) |
| **figma** | Plugin | 6 스킬 | 12 (디자인 시스템) |
| **commit-commands** | Plugin | 3 스킬 | 14 (커밋) |
| **ralph-loop** | Plugin | 3 스킬 | 모니터링 |
| **code-simplifier** | Plugin | 1 스킬 | 13 (간소화) |
| **WebSearch/WebFetch** | 내장 | - | 11 (최신 문서) |

### 비해당 / 미설치 (대체 도구 명시)
| 도구 | 상태 | 사유 | 대체 |
|------|------|------|------|
| mcp-tailwind-gemini | 비해당 | Flutter — Tailwind 미사용 | **frontend-design** 스킬 |
| shadcn | 비해당 | Flutter — React/shadcn 미사용 | **figma** 디자인 시스템 |
| chatgpt-mcp | 미설치 | 환경 미구성 | **Opus 4.6 직접 분석** |
| sequential-thinking | 미설치 | 환경 미구성 | **superpowers:brainstorm** |
| context7 | 미연결 | `.mcp.json` 존재, 세션 미활성 | **WebSearch + HuggingFace MCP** |
| playwright | 미연결 | `.mcp.json` 존재, 세션 미활성 | **feature-dev:code-architect** |
| serena | 미연결 | `.mcp.json` 존재, 세션 미활성 | **feature-dev:code-explorer** |
| cargo | 미설치 | 런타임 환경 제한 | **Sonatype MCP** (PURL 분석) |

### OAuth 대기 (인증 시 추가 활용 가능)
| 도구 | API 수 | 잠재 활용 |
|------|--------|----------|
| PostHog | 20+ | 프로덕트 분석 연동 |
| Sentry | 3 | 에러 추적 워크플로 |
| Slack | 5+ | 상태 공유 |
| Vercel | 10+ | 배포/성능 최적화 |

---

## Phase 9: 의존성 보안/품질 심층 분석 (Sonatype MCP)

> **목표**: Sonatype MCP 3개 API로 Rust 15+개 crate + Dart 15+개 package의 보안·품질·라이선스 심층 분석
> **실행자**: Sonnet 4.6 Sub-agent (PURL 조회) → Opus 4.6 (분석/판단)
> **예상 시간**: 1 단위 작업

### 9-A. Rust Crates PURL 분석 (Sonnet 실행)

| 패키지 | 현재 | PURL |
|--------|------|------|
| axum | 0.8 | `pkg:cargo/axum@0.8` |
| tokio | 1 | `pkg:cargo/tokio@1` |
| sqlx | 0.8 | `pkg:cargo/sqlx@0.8` |
| reqwest | 0.12 | `pkg:cargo/reqwest@0.12` |
| jsonwebtoken | 9 | `pkg:cargo/jsonwebtoken@9` |
| tower_governor | 0.8 | `pkg:cargo/tower_governor@0.8` |
| a2 | 0.10 | `pkg:cargo/a2@0.10` |
| scraper | 0.25 | `pkg:cargo/scraper@0.25` |
| governor | 0.10 | `pkg:cargo/governor@0.10` |
| moka | 0.12 | `pkg:cargo/moka@0.12` |
| sentry | 0.37 | `pkg:cargo/sentry@0.37` |
| tower-http | 0.6 | `pkg:cargo/tower-http@0.6` |

**조회 항목**: `getLatestComponentVersion` → 최신 안정 버전 확인
**조회 항목**: `getRecommendedComponentVersions` → 보안/품질 기반 권장 버전
**조회 항목**: `getComponentVersion` → 현재 사용 버전의 CVE/라이선스/품질 점수

### 9-B. Dart Packages PURL 분석 (Sonnet 실행)

| 패키지 | 현재 | PURL |
|--------|------|------|
| flutter_riverpod | 3.0.2 | `pkg:pub/flutter_riverpod@3.0.2` |
| go_router | 16.0.0 | `pkg:pub/go_router@16.0.0` |
| dio | 5.7.0 | `pkg:pub/dio@5.7.0` |
| fl_chart | 0.69.0 | `pkg:pub/fl_chart@0.69.0` |
| google_sign_in | 6.2.0 | `pkg:pub/google_sign_in@6.2.0` |
| sign_in_with_apple | 6.1.0 | `pkg:pub/sign_in_with_apple@6.1.0` |
| flutter_secure_storage | 9.2.0 | `pkg:pub/flutter_secure_storage@9.2.0` |
| kakao_flutter_sdk_user | 1.9.0 | `pkg:pub/kakao_flutter_sdk_user@1.9.0` |
| freezed | 3.0.0 | `pkg:pub/freezed@3.0.0` |
| json_serializable | 6.8.0 | `pkg:pub/json_serializable@6.8.0` |
| riverpod_generator | 3.0.0 | `pkg:pub/riverpod_generator@3.0.0` |

### 9-C. 산출물
- 의존성별 보안 등급 (CVE 존재 여부)
- 권장 업그레이드 경로 (BREAKING vs MINOR)
- 업그레이드 우선순위 매트릭스

### ✅ Phase 9 확인점 (Night-47 완료)
- [x] 의존성 분석 완료 — WebSearch+pub outdated 대체 실행 (Sonatype 인증 미구성)
- [x] Rust CVE 없음 ✅ / Dart CVE 없음 ✅
- [x] BREAKING 업그레이드 목록 도출: Rust 3건(reqwest/jsonwebtoken/sentry) + Dart 8건
- [ ] **D-82**: Rust BREAKING 업그레이드 범위 — ⏳ 사용자 결정 필요
- [ ] **D-83**: Dart BREAKING 업그레이드 범위 — ⏳ 사용자 결정 필요
- [ ] **D-84**: Dart non-BREAKING 4건 즉시 적용 — ⏳ 사용자 결정 필요

---

## Phase 10: 코드 품질 심층 리뷰 (병렬 4대 에이전트)

> **목표**: 병렬 에이전트 4대로 코드 품질 전면 감사
> **실행자**: Sonnet 4.6 Sub-agent 4대 동시 (병렬) → Opus 4.6 (결과 종합/판단)
> **전제**: Phase 9 승인 후

### 10-A. 에이전트 배치표

| # | 에이전트 | 대상 | 탐색 범위 |
|---|---------|------|----------|
| 1 | **coderabbit:code-reviewer** | 전체 코드베이스 | server/ + app/ 주요 변경 |
| 2 | **pr-review-toolkit:silent-failure-hunter** | server/src/ | 에러 핸들링 누락, catch 무시 |
| 3 | **pr-review-toolkit:type-design-analyzer** | server/src/ + app/lib/ | 타입 설계 품질 |
| 4 | **feature-dev:code-reviewer** | app/lib/ | Flutter 코드 품질 |

### 10-B. 판정 기준 (Opus 적용)
- **CRITICAL**: 데이터 손실, 보안 취약, 비즈니스 로직 오류 → 즉시 수정
- **HIGH**: 성능 저하, 미흡한 에러 핸들링 → Phase 13에서 수정
- **MEDIUM**: 코드 스타일, 타입 설계 개선 → 선별 수정
- **LOW/오탐**: Night-35 경험 기반 오탐 필터링 → 건너뜀

### 10-C. 산출물
- 이슈 목록 (등급별 분류)
- 오탐 필터링 결과
- Phase 13 수정 대상 확정 목록

### ✅ Phase 10 확인점 (Night-48 완료)
- [x] 발견 이슈 목록 사용자 검토 — 17건 발견 → 9건 확정, 4건 오탐 제외
- [ ] **D-85**: HIGH 2건 수정 범위 (I-01 rollback warn + I-02 ALLOWED_ORIGINS) — ⏳ 사용자 결정 필요
- [ ] **D-86**: MEDIUM 3건 수정 범위 (I-03 current_price + I-04 NULL UNIQUE + PD-67 priceTrend Enum) — ⏳ 사용자 결정 필요
- [ ] **D-87**: LOW 4건 포함 여부 — ⏳ 사용자 결정 필요

---

## Phase 11: 아키텍처 분석 + 프레임워크 최신화 (feature-dev + WebSearch)

> **목표**: 현재 아키텍처 구조 심층 분석 + 최신 프레임워크 패턴 GAP 식별
> **실행자**: Sonnet 4.6 Sub-agent 3대 (병렬) → Opus 4.6 (전략 종합)
> **전제**: Phase 10 승인 후

### 11-A. 에이전트 배치표

| # | 에이전트 | 임무 |
|---|---------|------|
| 1 | **feature-dev:code-explorer** | Rust 서버 실행 경로 추적 (요청→응답 전체 흐름) |
| 2 | **feature-dev:code-architect** | Flutter 앱 아키텍처 개선 설계안 |
| 3 | **WebSearch** (Opus 직접) | axum 0.8/riverpod 3.x/go_router 16.x 최신 모범사례 |

### 11-B. HuggingFace MCP 활용
- `hf_doc_search`: Rust/Flutter 관련 기술 문서 검색
- `hub_repo_search`: 유사 프로젝트 참조 아키텍처 탐색

### 11-C. 산출물
- 서버 아키텍처 흐름도 (요청→미들웨어→핸들러→DB→응답)
- Flutter 아키텍처 개선안 (Riverpod 패턴, GoRouter 최적화)
- 프레임워크 GAP 목록 (최신 패턴과의 차이점)

### ✅ Phase 11 확인점 (Night-49 완료)
- [x] 아키텍처 분석 결과 검토 — Rust 5건 + Flutter 8건 신규 GAP 발견
- [x] 프레임워크 GAP 분석 — Axum 0.8 GAP 없음 ✅ / Riverpod 3.x AsyncNotifier GAP 확인 ⚠️
- [ ] **D-88**: F-08(HIGH 401 미리다이렉트) + I-01/I-02 Phase 13 즉시 수정 — ⏳ 사용자 결정 필요
- [ ] **D-89**: F-04 AppSpacing/AppTextStyles 적용 범위 — ⏳ 사용자 결정 필요
- [ ] **D-90**: F-06 productPredictionProvider 타입 안전화 — ⏳ 사용자 결정 필요
- [ ] **D-91**: PD-67 priceTrend String→Enum 전환 — ⏳ 사용자 결정 필요
- [ ] **D-92**: Phase 12/13 실행 순서 결정 — ⏳ 사용자 결정 필요

---

## Phase 12: 프론트엔드 UI/UX 감사 (frontend-design + figma)

> **목표**: Flutter 앱 UI/UX 패턴 감사 + 디자인 시스템 규칙 정합
> **실행자**: Sonnet 4.6 Sub-agent → Opus 4.6 (UX 판단)
> **전제**: Phase 11 승인 후

### 12-A. 실행 항목

| # | 스킬 | 임무 |
|---|------|------|
| 1 | **frontend-design** | 10개 화면 UI 패턴 감사 (일관성, 접근성, 반응성) |
| 2 | **figma:figma-create-design-system-rules** | AppColors/AppSpacing/AppTextStyles 기반 디자인 시스템 규칙 도출 |
| 3 | **pr-review-toolkit:code-simplifier** | Flutter 위젯 코드 간소화 기회 식별 |

### 12-B. 감사 대상 화면
| 화면 | 파일 | 핵심 검사 항목 |
|------|------|---------------|
| HomeScreen | `home_screen.dart` | 상품 목록 성능, 무한스크롤 |
| ProductDetailScreen | `product_detail_screen.dart` | 차트 렌더링, 정보 레이아웃 |
| SearchScreen | `search_screen.dart` | 필터/정렬 UX, 자동완성 |
| AlertScreen | `alert_screen.dart` | 탭 UX, 알림 설정 흐름 |
| LoginScreen | `login_screen.dart` | 소셜 로그인 UX, 접근성 |

### 12-C. 산출물
- UI/UX 이슈 목록 (일관성/접근성/성능)
- 디자인 시스템 규칙 문서
- 위젯 간소화 제안

### ⏸️ Phase 12 확인점
- [ ] UI/UX 이슈 목록 검토
- [ ] 디자인 시스템 규칙 승인
- [ ] 수정 우선순위 결정

---

## Phase 13: 발견 사항 기반 코드 수정 실행

> **목표**: Phase 9-12에서 승인된 모든 변경 사항 실행
> **실행자**: Opus 4.6 (전략적 수정) + Sonnet 4.6 (병렬 실행)
> **전제**: Phase 12 승인 후 — 수정 대상 확정 목록 필수

### 13-A. 수정 카테고리

| 카테고리 | 출처 Phase | 예상 범위 |
|----------|-----------|----------|
| 의존성 업그레이드 (MINOR) | 9 | pubspec.yaml + Cargo.toml |
| 코드 품질 수정 (CRITICAL/HIGH) | 10 | server/src/ + app/lib/ |
| 아키텍처 개선 (승인분) | 11 | 구조적 리팩토링 |
| UI/UX 개선 (승인분) | 12 | Flutter 위젯 수정 |
| 코드 간소화 | 10, 12 | 중복 제거, 헬퍼 추출 |

### 13-B. 실행 원칙
1. MINOR 업그레이드 우선 (위험 최소)
2. CRITICAL 수정 다음 (안전성 확보)
3. 각 수정 후 `flutter test` + `flutter analyze` 즉시 검증
4. **사용자 코드 기여 요청**: 비즈니스 로직 트레이드오프가 있는 부분은 5-10줄 코드 요청

### 13-C. 산출물
- 수정된 파일 목록 + diff
- 테스트 결과 (≥360건 보존)
- analyze 결과 (0건 유지)

### ⏸️ Phase 13 확인점
- [ ] 각 카테고리 수정 완료 후 개별 확인
- [ ] 테스트 ≥360건 보존 확인
- [ ] analyze 0건 유지 확인

---

## Phase 14: 최종 검증 + 구조화된 커밋

> **목표**: 전체 변경 사항 최종 검증 + 의미 있는 커밋 단위로 구조화
> **실행자**: Opus 4.6 (최종 리뷰) + Sonnet 4.6 (검증 실행)

### 14-A. 검증 항목
| 항목 | 기준 | 도구 |
|------|------|------|
| Flutter 테스트 | ≥360건 | `flutter test` |
| Flutter analyze | 0건 | `flutter analyze` |
| 의존성 보안 | CVE 0건 (신규) | Sonatype 재확인 |
| 코드 품질 | CRITICAL 0건 | coderabbit 재검토 |

### 14-B. 커밋 전략
- 카테고리별 분리 커밋 (의존성 / 코드품질 / 아키텍처 / UI)
- 각 커밋 메시지에 Phase 참조 포함
- `commit-commands:commit` 스킬 활용

### ⏸️ Phase 14 확인점
- [ ] 최종 테스트 전원 통과
- [ ] 커밋 목록 사용자 최종 승인
- [ ] main 머지 PR 생성 여부 결정

---

## 실행 원칙 (Phase 9-14 공통)

1. **단방향 결정 금지**: 모든 변수/대안 경로에 대해 명시적 확인 요청
2. **Phase 전환 시 필수 확인**: ⏸️ 마크 지점에서 반드시 사용자 승인
3. **Opus/Sonnet 역할 분리**:
   - Opus 4.6: 전략 설계, 아키텍처 결정, 트레이드오프 분석, 오탐 필터링, 최종 리뷰
   - Sonnet 4.6: Sonatype PURL 조회, 코드 탐색, 테스트 실행, 병렬 리뷰 에이전트 운용
4. **Ralph-loop 한도**: 최대 10회
5. **코드 기여 요청**: 비즈니스 로직 트레이드오프가 있는 5~10줄은 사용자에게 위임
6. **MCP degradation**: context7→WebSearch+HF, playwright→feature-dev, serena→code-explorer 대체
7. **베이스라인 보존**: Flutter ≥360건, analyze 0건 — 매 Phase 종료 시 검증

---

# PLAN_01 확장: Phase 15-19 MCP 총동원 실무 최적화 (Night-56~)

> 작성: 2026-05-04 | **실행: Night-56 시작** | 브랜치: `auto/night-01-20260504_0100`
> 베이스라인: Flutter **365건** ✅ | Rust **207건** ✅ | analyze 0건 ✅ (2026-05-04 실측)
> 역할: **Opus 4.6 (Main Agent)** = 전략/의사결정/최종 코드 리뷰 | **Sonnet 4.6 (Sub-agent)** = 데이터 수집/기술 실행/진행 추적
> Ralph-loop 한도: **10회**
> **목적**: MCP 전체 동원 + 플러그인 전체 활용 → 실행 가능한 코드 생성 → 기술 수준 실질적 상향

---

## 0-F. MCP/플러그인 가용성 실측 (2026-05-04 세션)

### 즉시 사용 가능 MCP (인증 불필요, 5종)

| MCP | API 수 | 핵심 활용 | Phase |
|-----|--------|----------|-------|
| **PlayMCP NaverSearch** | 18+ | search_shop(상품검색), datalab_shopping_category(카테고리트렌드), datalab_shopping_keywords(키워드분석), find_category(카테고리코드) | 15 |
| **PlayMCP CoinInfo** | 6 | get_coin_price(실시간가격), get_market_overview(시장요약), get_kimchi_premium(김프) | 15 |
| **PlayMCP OpenDart** | 12+ | find_company(기업검색), get_company_info(기업정보), get_financial_index(재무지표) | 15 |
| **Sonatype Guide** | 3 | getLatestComponentVersion(최신버전), getRecommendedComponentVersions(권장버전) | 16 |
| **Hugging Face** | 8 | hf_doc_search(문서검색), hub_repo_search(레포검색), paper_search(논문검색) | 17 |

### 즉시 사용 가능 Plugin/Skill (12종)

| 플러그인 | 스킬/에이전트 | Phase |
|----------|-------------|-------|
| **superpowers** | brainstorm, write-plan, execute-plan, verification-before-completion | 전체 |
| **feature-dev** | code-architect, code-explorer, code-reviewer | 17, 18 |
| **pr-review-toolkit** | code-reviewer, silent-failure-hunter, type-design-analyzer, code-simplifier, pr-test-analyzer | 18, 19 |
| **coderabbit** | code-review, autofix | 18 |
| **frontend-design** | frontend-design | 18 |
| **figma** | figma-create-design-system-rules, figma-generate-design | 18 |
| **commit-commands** | commit, commit-push-pr | 19 |
| **ralph-loop** | ralph-loop (모니터링 루프) | 전체 |
| **code-simplifier** | code-simplifier | 18 |
| **claude-md-management** | revise-claude-md | 19 |

### 비해당/미연결 (대체 도구 확정)

| 도구 | 상태 | 대체 |
|------|------|------|
| mcp-tailwind-gemini | 비해당 (Flutter) | frontend-design 스킬 |
| shadcn | 비해당 (Flutter) | figma 디자인 시스템 |
| chatgpt-mcp | 미설치 | Opus 4.6 직접 분석 |
| sequential-thinking | 미설치 | superpowers:brainstorm |
| context7 | 세션 미연결 | WebSearch + HuggingFace MCP |
| playwright | 세션 미연결 | feature-dev:code-architect |
| serena | 세션 미연결 | feature-dev:code-explorer |

---

## Phase 15: NaverSearch MCP 기반 실시간 데이터 파이프라인 구축

> **목표**: NaverSearch MCP의 search_shop + datalab API를 활용하여 값뚝 핵심 기능(가격 추적)의 실시간 데이터 소스 확보 및 검증 코드 생성
> **실행자**: Sonnet 4.6 (MCP 호출/데이터 수집) → Opus 4.6 (아키텍처 설계/코드 생성)
> **산출물**: 직접 실행 가능한 Rust + Flutter 코드

### 15-A. NaverSearch 데이터 수집 (Sonnet 실행)

| # | API | 목적 | 파라미터 |
|---|-----|------|---------|
| 15-A1 | `find_category` | 값뚝 카테고리 체계와 네이버 카테고리 매핑 | keyword: "생활용품", "식품", "가전" 등 |
| 15-A2 | `search_shop` | 실시간 상품 가격 데이터 확보 | query: 앱 인기 검색어 기반, sort: sim/date |
| 15-A3 | `datalab_shopping_category` | 카테고리별 검색 트렌드 시계열 | 15-A1 카테고리 코드, 최근 6개월 |
| 15-A4 | `datalab_shopping_keywords` | 핵심 키워드 검색량 트렌드 | 카테고리+키워드 조합 |

### 15-B. 데이터 기반 코드 생성 (Opus 설계)

| # | 생성 대상 | 설명 | 파일 위치 |
|---|----------|------|----------|
| 15-B1 | **NaverPriceService (Rust)** | search_shop 응답 구조체 + 가격 파싱 로직 | `server/src/services/naver_price_service.rs` |
| 15-B2 | **CategoryMapping 테이블** | 값뚝 카테고리↔네이버 카테고리 매핑 | `server/migrations/021_naver_category_mapping.sql` |
| 15-B3 | **TrendDataService (Rust)** | datalab 응답 파싱 + 트렌드 점수 계산 | `server/src/services/trend_data_service.rs` |
| 15-B4 | **NaverDataProvider (Flutter)** | 트렌드 데이터 표시용 Riverpod provider | `app/lib/providers/naver_trend_provider.dart` |
| 15-B5 | **TrendChartWidget (Flutter)** | fl_chart 기반 트렌드 시각화 위젯 | `app/lib/widgets/trend_chart.dart` |

### 15-C. CoinInfo/OpenDart 확장 탐색 (선택적)

| # | API | 잠재 활용 | 사용자 결정 필요 |
|---|-----|----------|---------------|
| 15-C1 | CoinInfo `get_coin_price` | 암호화폐 가격 추적 확장 | **D-97**: 값뚝에 암호화폐 카테고리 추가? |
| 15-C2 | OpenDart `get_financial_index` | 쇼핑 관련 기업 재무 참조 데이터 | **D-98**: OpenDart 활용 범위? |

### ⏸️ Phase 15 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-97** | CoinInfo 암호화폐 가격 추적 확장? | A) 포함 / B) 미포함 (쇼핑 전용) |
| **D-98** | OpenDart 기업 재무 데이터 연동? | A) 포함 / B) 미포함 |
| **D-99** | NaverSearch 데이터 수집 대상 카테고리? | A) 생활용품+식품+가전 (3종) / B) 전체 (10종+) / C) 사용자 지정 |
| **D-100** | 15-B 코드 생성 범위? | A) 전체 (B1-B5) / B) 서버만 (B1-B3) / C) Flutter만 (B4-B5) / D) 선택적 |

---

## Phase 16: 의존성 최신화 실행 (Sonatype MCP)

> **목표**: Sonatype MCP로 전체 의존성 최신 권장 버전 확인 → BREAKING + MINOR 업그레이드 실행
> **실행자**: Sonnet 4.6 (Sonatype 조회) → Opus 4.6 (영향 분석/결정)
> **전제**: Phase 15 승인 후

### 16-A. Sonatype 심층 분석 (Sonnet 실행)

| # | 대상 | PURL 배치 | 조회 API |
|---|------|----------|---------|
| 16-A1 | Rust crates 12개 | `pkg:cargo/axum@0.8`, `pkg:cargo/tokio@1`, ... | getLatestComponentVersion + getRecommendedComponentVersions |
| 16-A2 | Dart packages 11개 | `pkg:pub/flutter_riverpod@3.0.2`, ... | getLatestComponentVersion + getRecommendedComponentVersions |

### 16-B. 업그레이드 실행 계획

| 우선순위 | 유형 | 대상 | 위험도 |
|---------|------|------|--------|
| 1 | MINOR/PATCH | 즉시 적용 가능 (D-84 잔여) | LOW |
| 2 | 보안 BREAKING | google_sign_in 7.x (OAuth 강화) | MEDIUM |
| 3 | 기능 BREAKING | flutter_riverpod 3.3.x + riverpod_generator 4.x | HIGH |
| 4 | 전체 BREAKING | go_router 17.x, fl_chart 1.x, flutter_secure_storage 10.x | HIGH |

### 16-C. 산출물
- Sonatype 분석 보고서 (버전별 보안/품질 점수)
- 업그레이드 실행 diff (pubspec.yaml + Cargo.toml)
- 호환성 테스트 결과

### ⏸️ Phase 16 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-101** | MINOR/PATCH 즉시 적용? | A) 전체 / B) 선택적 / C) 보류 |
| **D-102** | BREAKING 업그레이드 범위? | A) 보안만 (google_sign_in) / B) 핵심 (riverpod+google) / C) 전체 / D) 보류 |
| **D-103** | Rust BREAKING (reqwest 1.x/sentry 0.38) 포함? | A) 예 / B) 보류 |

---

## Phase 17: 아키텍처 고도화 + 문서 품질 (feature-dev + HuggingFace)

> **목표**: Phase 15 신규 서비스 통합에 따른 아키텍처 리팩토링 + HuggingFace MCP로 최신 패턴 문서 조회
> **실행자**: Sonnet 4.6 (탐색/문서 조회) → Opus 4.6 (설계/코드 생성)
> **전제**: Phase 16 승인 후

### 17-A. 아키텍처 분석 (feature-dev 3대 병렬)

| # | 에이전트 | 임무 |
|---|---------|------|
| 17-A1 | **code-explorer** | Phase 15 신규 서비스의 기존 서비스 의존성 매핑 |
| 17-A2 | **code-architect** | NaverSearch 통합 아키텍처 청사진 (서비스 계층, 캐시 전략, 에러 폴백) |
| 17-A3 | **code-reviewer** | Phase 15-16 코드의 품질 검증 |

### 17-B. HuggingFace MCP 문서 조회

| # | API | 검색 쿼리 | 목적 |
|---|-----|----------|------|
| 17-B1 | `hf_doc_search` | "axum service layer pattern" | 서비스 계층 모범사례 |
| 17-B2 | `hf_doc_search` | "riverpod async notifier caching" | 캐시 전략 최신 패턴 |
| 17-B3 | `hub_repo_search` | "price tracking flutter rust" | 유사 프로젝트 참조 |
| 17-B4 | `paper_search` | "e-commerce price prediction" | 가격 예측 알고리즘 참조 |

### 17-C. 산출물
- 통합 아키텍처 다이어그램 (텍스트 기반)
- 서비스 간 의존성 맵 갱신
- 캐시 전략 설계서 (moka 확장 vs Redis 도입)
- 코드 생성: 아키텍처 리팩토링 diff

### ⏸️ Phase 17 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-104** | 캐시 전략? | A) moka 확장 (현행) / B) Redis 도입 / C) 하이브리드 |
| **D-105** | NaverSearch 호출 빈도? | A) 실시간 (요청당) / B) 배치 (1시간마다) / C) 이벤트 기반 |
| **D-106** | 서비스 계층 리팩토링 범위? | A) 신규만 / B) 기존 포함 (product_service 통합) |

---

## Phase 18: 프론트엔드 UX 최적화 + 코드 품질 (frontend-design + coderabbit + pr-review-toolkit)

> **목표**: 실시간 데이터 기반 UI 최적화 + 전체 코드 품질 최종 점검
> **실행자**: Sonnet 4.6 (병렬 에이전트 6대) → Opus 4.6 (UX 결정/최종 리뷰)
> **전제**: Phase 17 승인 후

### 18-A. 프론트엔드 감사 (병렬 3대)

| # | 도구 | 임무 |
|---|------|------|
| 18-A1 | **frontend-design** | NaverSearch 트렌드 데이터 시각화 UX 설계 |
| 18-A2 | **figma:figma-create-design-system-rules** | 트렌드 차트/배지/카드 디자인 규칙 도출 |
| 18-A3 | **code-simplifier** | Phase 15-17 Flutter 코드 간소화 |

### 18-B. 코드 품질 최종 점검 (병렬 3대)

| # | 에이전트 | 대상 |
|---|---------|------|
| 18-B1 | **coderabbit:code-review** | Phase 15-17 전체 diff |
| 18-B2 | **pr-review-toolkit:silent-failure-hunter** | 신규 서비스 에러 핸들링 |
| 18-B3 | **pr-review-toolkit:type-design-analyzer** | 신규 타입 (NaverSearchResult, TrendData 등) 설계 |

### 18-C. 산출물
- UI/UX 설계서 (트렌드 데이터 표시 방식)
- 디자인 시스템 규칙 갱신
- 코드 품질 이슈 목록 + 수정
- Flutter 코드 간소화 결과

### ⏸️ Phase 18 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-107** | 트렌드 데이터 표시 위치? | A) 상품 상세 내 / B) 별도 탭 / C) 홈 대시보드 |
| **D-108** | 디자인 시스템 규칙 범위? | A) 신규 위젯만 / B) 기존 위젯 포함 전면 적용 |

---

## Phase 19: 최종 검증 + 구조화 커밋 + 베이스라인 갱신

> **목표**: 전체 Phase 15-18 결과물 통합 검증 → 의미 있는 커밋 단위 구조화
> **실행자**: Opus 4.6 (최종 판단) + Sonnet 4.6 (테스트 실행)
> **전제**: Phase 18 승인 후

### 19-A. 검증 항목

| 항목 | 기준 | 도구 |
|------|------|------|
| Flutter 테스트 | ≥365건 (증가 기대) | `flutter test` |
| Flutter analyze | 0건 | `flutter analyze` |
| Rust 테스트 | ≥207건 (증가 기대) | `cargo test --lib` |
| 의존성 보안 | CVE 0건 | Sonatype MCP 재확인 |
| 코드 품질 | CRITICAL 0건 | coderabbit 최종 |

### 19-B. 커밋 전략

| # | 커밋 범위 | 메시지 패턴 |
|---|----------|------------|
| 1 | Phase 15 NaverSearch 통합 | `feat(naver): NaverSearch 실시간 가격 파이프라인 + 트렌드 시각화` |
| 2 | Phase 16 의존성 최신화 | `deps: BREAKING/MINOR 의존성 업그레이드 (Phase 16)` |
| 3 | Phase 17 아키텍처 | `refactor(arch): 서비스 계층 통합 + 캐시 전략 고도화` |
| 4 | Phase 18 UX+품질 | `feat(ui): 트렌드 UX + 코드 품질 최종 점검` |

### 19-C. 메모리/문서 갱신
- MORNING_BRIEFING.md 갱신
- 프로젝트 메모리 갱신 (테스트 수, Phase 완료 상태)
- PLAN_01.md Phase 15-19 완료 마킹

### ✅ Phase 19 완료 (Night-62, 2026-05-10)

**검증 결과:**
| 항목 | 결과 | 기준 |
|------|------|------|
| Flutter 테스트 | **370건** ✅ | ≥365건 |
| Flutter analyze | **0건** ✅ | 0건 |
| Rust 테스트 | **216건** ✅ | ≥207건 |
| 코드 품질 CRITICAL | **0건** ✅ | Phase 18 수정 5건 완료 |

**확인점 결정:**
| 결정 ID | 결과 |
|---------|------|
| D-109 | ✅ **Phase별 분리 커밋(A)** — Night-56~61에서 이미 Phase별 커밋 완료 |
| D-110 | ⏸️ **main 머지 PR** — 사용자 결정 대기 |
| D-111 | ⏸️ **다음 PLAN_02 방향** — 사용자 결정 대기 |

---

## 실행 원칙 (Phase 15-19 공통)

1. **단방향 결정 금지**: 모든 변수/대안 경로에 대해 명시적 확인 요청
2. **Phase 전환 시 필수 확인**: ⏸️ 마크 지점에서 반드시 사용자 승인
3. **Opus/Sonnet 역할 분리**:
   - Opus 4.6: 전략 설계, MCP 데이터 해석, 아키텍처 결정, 최종 코드 리뷰
   - Sonnet 4.6: MCP API 호출, 데이터 수집, 코드 탐색, 테스트 실행, 병렬 에이전트 운용
4. **Ralph-loop 한도**: 최대 10회 (모니터링/테스트 반복용)
5. **코드 기여 요청**: 비즈니스 로직 트레이드오프가 있는 5~10줄은 사용자에게 위임
6. **MCP 활용 원칙**: 실시간 데이터로 코드 생성 → 가상 데이터 절대 사용 금지
7. **베이스라인 보존**: Flutter ≥365건, Rust ≥207건, analyze 0건 — 매 Phase 종료 시 검증
8. **직접 실행 가능 코드**: 모든 생성 코드는 컴파일/테스트 즉시 가능해야 함

---

## 예상 산출물 요약 (Phase 15-19)

| Phase | 핵심 산출물 | 예상 영향 | MCP 활용 |
|-------|-----------|----------|---------|
| 15 | NaverSearch 가격 파이프라인 코드 | 실시간 가격 검증 + 트렌드 기능 | NaverSearch (4 API) |
| 16 | 의존성 최신화 | 보안 강화 + 최신 API | Sonatype (2 API) |
| 17 | 아키텍처 리팩토링 | 서비스 통합 + 캐시 최적화 | HuggingFace (4 API) |
| 18 | UX 최적화 + 품질 점검 | UI 일관성 + 코드 품질 | feature-dev + coderabbit |
| 19 | 구조화 커밋 + 검증 | 추적 가능한 이력 | commit-commands |

---

# PLAN_01 확장: Phase 20-25 MCP 전수 동원 종합 실무 최적화 (Night-68~)

> 작성: 2026-05-16 | **실행: Night-68 시작** | 브랜치: `auto/night-01-20260516_0100`
> 베이스라인: Flutter **370건** ✅ | Rust **216건** ✅ (Night-67 기준) | analyze 0건 ✅
> 역할: **Opus 4.6 (Main Agent)** = 전략/의사결정/최종 코드 리뷰 | **Sonnet 4.6 (Sub-agent)** = 데이터 수집/기술 실행/진행 추적
> Ralph-loop 한도: **10회**
> **목적**: 사용 가능한 MCP 49+ API + 플러그인 12종 전수 동원 → 실시간 데이터 기반 코드 검증 + 직접 실행 가능 코드 생성 → 기술 수준 실질 상향

---

## 0-G. MCP/플러그인 가용성 실측 매트릭스 (2026-05-16 세션)

### 즉시 사용 가능 MCP (6종, 49+ API)

| MCP | API 수 | 핵심 API | Phase |
|-----|--------|---------|-------|
| **PlayMCP NaverSearch** | 18+ | search_shop, find_category, datalab_shopping_category, datalab_shopping_keywords, datalab_shopping_by_age/gender/device, datalab_shopping_keyword_by_age/gender/device, datalab_search, search_blog/news/webkr/kin/encyc/academic/book/cafearticle/image/local | 20, 21 |
| **PlayMCP CoinInfo** | 7 | get_coin_price, get_market_overview, get_kimchi_premium, get_coin_dominance, get_fear_greed_index, get_top_gainers/losers | 20 (탐색) |
| **PlayMCP OpenDart** | 12+ | find_company, get_company_info, get_financial_account/index/statement, get_dividend_info, get_employees, get_executive_stock, search_disclosures | 20 (탐색) |
| **PlayMCP UsStockInfo** | 8+ | get_stock_info, get_financial_statement, get_historical_stock_prices, get_recommendations, get_finance_news, get_holder_info | 20 (탐색) |
| **PlayMCP KakaoMap** | 4 | SearchPlaceByKeywordOpen, GetPublicTransitDirections, GetWalkDirections, GetBikeDirections | 20 (탐색) |
| **PlayMCP KakaotalkChat** | 1 | MemoChat (나에게 메시지) | 25 (알림) |

### 즉시 사용 가능 Plugin/Skill (12종)

| 플러그인 | 스킬/에이전트 | Phase |
|----------|-------------|-------|
| **superpowers** | brainstorm, write-plan, execute-plan, verification-before-completion, systematic-debugging | 전체 |
| **feature-dev** | code-architect, code-explorer, code-reviewer | 23 |
| **pr-review-toolkit** | code-reviewer, silent-failure-hunter, type-design-analyzer, code-simplifier, pr-test-analyzer, comment-analyzer | 23, 24 |
| **coderabbit** | code-review, autofix | 23 |
| **frontend-design** | frontend-design | 24 |
| **figma** | figma-create-design-system-rules, figma-generate-design | 24 |
| **commit-commands** | commit, commit-push-pr, clean_gone | 25 |
| **ralph-loop** | ralph-loop (모니터링 루프, 한도 10) | 전체 |
| **code-simplifier** | code-simplifier (간소화) | 23 |
| **claude-md-management** | revise-claude-md, claude-md-improver | 25 |
| **hookify** | hookify, configure, list | 25 |
| **Sonatype Guide** | getLatestComponentVersion, getRecommendedComponentVersions, getComponentVersion | 22 |
| **HuggingFace** | hf_doc_search, hub_repo_search, paper_search | 23 |

### 비해당/미연결 (대체 도구 확정)

| 도구 | 상태 | 사유 | 대체 |
|------|------|------|------|
| **mcp-tailwind-gemini** | 비해당 | Flutter 프로젝트 — Tailwind CSS 미사용 | frontend-design 스킬 |
| **shadcn** | 비해당 | Flutter 프로젝트 — React/shadcn-ui 미사용 | figma 디자인 시스템 |
| **chatgpt-mcp** | 미설치 | 환경 미구성 | Opus 4.6 직접 분석 |
| **sequential-thinking** | 미설치 | 환경 미구성 | superpowers:brainstorm |
| **context7** | 미연결 | `.mcp.json` 존재, 세션 미활성 | WebSearch + HuggingFace MCP |
| **playwright** | 미연결 | `.mcp.json` 존재, 세션 미활성 | feature-dev:code-architect |
| **serena** | 미연결 | `.mcp.json` 존재, 세션 미활성 | feature-dev:code-explorer |

### 미결 결정 현황 (Phase 20-25에서 해소 대상)

| 결정 ID | 출처 | 내용 | 해소 Phase |
|---------|------|------|-----------|
| **D-82** | Phase 9 | Rust BREAKING 업그레이드 범위 | 22 |
| **D-83** | Phase 9 | Dart BREAKING 업그레이드 범위 | 22 |
| **D-84** | Phase 9 | Dart non-BREAKING 4건 즉시 적용 | 22 |
| **D-95** | Phase 12 | discountRate 다크모드 대응 | 24 |
| **D-96** | Phase 12 | SearchScreen 필터 재연결 | 24 |
| **D-101** | Phase 16 | flutter_riverpod 3.0→3.3 minor | 22 |
| **D-102** | Phase 16 | BREAKING 5종 (go_router/fl_chart/google_sign_in/flutter_secure_storage/sign_in_with_apple) | 22 |
| **D-103** | Phase 16 | Rust BREAKING (reqwest 1.x/sentry 0.38) | 22 |
| **D-110** | Phase 19 | main 머지 PR | 25 |
| **D-111** | Phase 19 | 다음 PLAN_02 방향 | 25 |

---

## Phase 20: MCP 전수 실측 + 실시간 데이터 기반 코드 검증

> **목표**: 49+ MCP API를 실시간 호출하여 기존 코드(Phase 15 NaverSearch 파이프라인)의 데이터 정합성 검증 + 신규 MCP 활용 기회 발굴
> **실행자**: Sonnet 4.6 Sub-agent (MCP 호출/데이터 수집) → Opus 4.6 (정합성 분석/코드 수정 결정)

### 20-A. NaverSearch 실시간 데이터 vs 기존 코드 검증 (Sonnet 실행)

| # | API 호출 | 검증 대상 | 파일 |
|---|---------|----------|------|
| 20-A1 | `search_shop("세탁세제")` | NaverShopItem 구조체 필드 정합성 | `server/src/services/naver_price_service.rs` |
| 20-A2 | `find_category("생활용품")` | naver_category_mapping 테이블 코드 정합성 | `server/migrations/019_naver_category_mapping.sql` |
| 20-A3 | `find_category("식품")` + `find_category("가전")` | 카테고리 코드 3종 검증 | migration 019 |
| 20-A4 | `datalab_shopping_category` | TrendResult/TrendPeriodData 구조체 검증 | `server/src/services/trend_data_service.rs` |
| 20-A5 | `datalab_shopping_by_age` | 연령별 데이터 구조 파악 (신규) | — |
| 20-A6 | `datalab_shopping_by_gender` | 성별 데이터 구조 파악 (신규) | — |
| 20-A7 | `datalab_shopping_by_device` | 기기별 데이터 구조 파악 (신규) | — |

### 20-B. CoinInfo/OpenDart/UsStockInfo 탐색 (Sonnet 실행)

| # | API 호출 | 목적 |
|---|---------|------|
| 20-B1 | `CoinInfo.get_coin_price("BTC")` | 응답 구조 파악 — 향후 암호화폐 가격 추적 확장 가능성 |
| 20-B2 | `OpenDart.find_company("네이버")` | 응답 구조 파악 — 가격 제공 기업 재무 데이터 활용 |
| 20-B3 | `UsStockInfo.get_stock_info("AMZN")` | 응답 구조 파악 — 글로벌 가격 비교 기능 참조 |

### 20-C. 산출물
- NaverSearch 응답 vs 기존 Rust 구조체 정합성 보고서
- 필드 불일치/누락 목록 (있다면 즉시 수정 대상)
- 신규 MCP 활용 기회 목록 (연령/성별/기기 데이터)
- CoinInfo/OpenDart/UsStockInfo 확장 가능성 평가

### ⏸️ Phase 20 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-112** | 필드 불일치 발견 시 즉시 수정? | A) 즉시 수정 / B) Phase 23에서 일괄 |
| **D-113** | CoinInfo 암호화폐 추적 확장? | A) Phase 21에 포함 / B) 보류 (가격 추적 전용 유지) |
| **D-114** | OpenDart/UsStockInfo 연동? | A) 향후 Phase / B) 비해당 (쇼핑 전용 유지) |

---

## Phase 21: NaverSearch 인구통계 분석 파이프라인 확장

> **목표**: Phase 20에서 파악한 연령/성별/기기별 데이터 구조를 기반으로 인구통계 분석 파이프라인 구축 → Rust 서비스 + Flutter UI 코드 생성
> **실행자**: Sonnet 4.6 (MCP 데이터 수집/코드 탐색) → Opus 4.6 (아키텍처 설계/코드 생성)
> **전제**: Phase 20 승인 후

### 21-A. 실시간 데이터 수집 (Sonnet MCP 호출)

| # | API | 파라미터 | 목적 |
|---|-----|---------|------|
| 21-A1 | `datalab_shopping_by_age` | category: Phase 20 검증 코드, ages: ["10","20","30","40","50","60"] | 연령대별 쇼핑 관심도 시계열 |
| 21-A2 | `datalab_shopping_by_gender` | 동일 카테고리, gender: "f"/"m" | 성별 쇼핑 관심도 시계열 |
| 21-A3 | `datalab_shopping_by_device` | 동일 카테고리, device: "pc"/"mo" | PC vs 모바일 비율 시계열 |
| 21-A4 | `datalab_shopping_keyword_by_age` | 인기 키워드 + 카테고리 | 키워드별 연령 반응 |
| 21-A5 | `datalab_shopping_keyword_by_gender` | 인기 키워드 + 카테고리 | 키워드별 성별 반응 |
| 21-A6 | `datalab_search` | keywordGroups: 인기 검색어 3~5개, 최근 6개월 | 일반 검색 트렌드 비교 |

### 21-B. 코드 생성 (Opus 설계)

| # | 생성 대상 | 설명 | 파일 위치 |
|---|----------|------|----------|
| 21-B1 | **DemographicTrendService (Rust)** | 연령/성별/기기별 API 응답 파싱 + 인구통계 트렌드 점수 | `server/src/services/demographic_trend_service.rs` |
| 21-B2 | **DemographicTrend 모델 (Flutter)** | freezed 모델 — AgeTrend, GenderTrend, DeviceTrend | `app/lib/models/demographic_trend.dart` |
| 21-B3 | **DemographicTrendProvider (Flutter)** | @riverpod 프로바이더 — 인구통계 데이터 fetch | `app/lib/providers/demographic_trend_provider.dart` |
| 21-B4 | **DemographicChartWidget (Flutter)** | fl_chart 기반 연령/성별 시각화 (막대+파이) | `app/lib/widgets/demographic_chart.dart` |
| 21-B5 | **API 핸들러 (Rust)** | GET /trends/demographic/:category | `server/src/handlers/trends.rs` 확장 |
| 21-B6 | **테스트 (Rust + Flutter)** | 서비스 + 위젯 테스트 | 각 테스트 파일 |

### 21-C. 산출물
- Rust: DemographicTrendService + 핸들러 + 테스트
- Flutter: 모델 + 프로바이더 + 위젯 + 테스트
- MCP 실시간 데이터 기반 검증 완료

### ⏸️ Phase 21 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-115** | 인구통계 데이터 표시 위치? | A) ProductDetailScreen 내 탭 / B) 별도 DemographicScreen / C) HomeScreen 카드 |
| **D-116** | 인구통계 API 캐시 전략? | A) moka 확장 (1h TTL, 현행 패턴) / B) DB 저장 + 배치 갱신 |
| **D-117** | 코드 생성 범위? | A) 전체 (B1-B6) / B) 서버만 (B1+B5+B6) / C) Flutter만 (B2-B4+B6) |

---

## Phase 22: 의존성 최신화 + 미결 결정 해소 (Sonatype + WebSearch)

> **목표**: Sonatype MCP + WebSearch로 D-82~D-84, D-101~D-103 데이터 확보 → 업그레이드 실행
> **실행자**: Sonnet 4.6 (Sonatype PURL 조회 + WebSearch) → Opus 4.6 (영향 분석/결정)
> **전제**: Phase 21 승인 후

### 22-A. Sonatype 심층 조회 (Sonnet 실행)

| # | 대상 | PURL | 조회 항목 |
|---|------|------|----------|
| 22-A1 | flutter_riverpod | `pkg:pub/flutter_riverpod@3.0.3` | 최신 3.3.x 보안/품질 점수 |
| 22-A2 | go_router | `pkg:pub/go_router@16.3.0` | 17.x 호환성/보안 |
| 22-A3 | fl_chart | `pkg:pub/fl_chart@0.69.2` | 1.x BREAKING 범위 |
| 22-A4 | google_sign_in | `pkg:pub/google_sign_in@6.3.0` | 7.x OAuth 강화 |
| 22-A5 | flutter_secure_storage | `pkg:pub/flutter_secure_storage@9.2.4` | 10.x 마이그레이션 |
| 22-A6 | sign_in_with_apple | `pkg:pub/sign_in_with_apple@6.1.4` | 7.x 변경 범위 |
| 22-A7 | riverpod_generator | `pkg:pub/riverpod_generator@3.0.3` | 4.x BREAKING 호환 |
| 22-A8 | reqwest (Rust) | `pkg:cargo/reqwest@0.12.28` | 1.x 변경 범위 |
| 22-A9 | sentry (Rust) | `pkg:cargo/sentry@0.37.0` | 0.38.x 변경 범위 |

### 22-B. WebSearch 영향 분석 (Sonnet 실행)

| # | 검색 주제 | 목적 |
|---|----------|------|
| 22-B1 | "go_router 17 migration guide" | ShellRoute 변경점 확인 |
| 22-B2 | "fl_chart 1.0 breaking changes" | API 변경 범위 확인 |
| 22-B3 | "riverpod_generator 4.0 migration" | 코드젠 변경점 확인 |
| 22-B4 | "flutter_secure_storage 10 migration" | 스토리지 마이그레이션 확인 |

### 22-C. 업그레이드 실행 계획 (Opus 결정)

| 우선순위 | 유형 | 대상 | 위험도 | 미결 결정 |
|---------|------|------|--------|----------|
| 1 | MINOR/PATCH | D-84 잔여 (json_annotation, freezed 등) | LOW | D-84 |
| 2 | MINOR | flutter_riverpod 3.0→3.3 | LOW-MEDIUM | D-101 |
| 3 | BREAKING (보안) | google_sign_in 7.x | MEDIUM | D-102 일부 |
| 4 | BREAKING (기능) | go_router 17.x, fl_chart 1.x | HIGH | D-102 |
| 5 | BREAKING (Rust) | reqwest 1.x, sentry 0.38 | MEDIUM | D-82, D-103 |

### ⏸️ Phase 22 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-84** (재확인) | Dart non-BREAKING 잔여 즉시 적용? | A) 전체 / B) 선택적 / C) 보류 |
| **D-101** (재확인) | flutter_riverpod 3.0→3.3? | A) 예 / B) 보류 |
| **D-102** (재확인) | BREAKING 5종 범위? | A) 보안만 / B) 핵심 / C) 전체 / D) 보류 |
| **D-103** (재확인) | Rust BREAKING? | A) 예 / B) 보류 |
| **D-118** | 업그레이드 후 regression 발생 시? | A) 롤백 / B) 수정 시도 (1시간 내) |

---

## Phase 23: 코드 품질 + 아키텍처 종합 감사 (병렬 에이전트 6대)

> **목표**: Phase 20-22 신규 코드 포함 전체 코드베이스 품질 종합 감사 + HuggingFace 기술 문서 참조
> **실행자**: Sonnet 4.6 Sub-agent 6대 동시 (병렬) → Opus 4.6 (결과 종합/우선순위 결정)
> **전제**: Phase 22 승인 후

### 23-A. 병렬 에이전트 배치 (Sonnet 6대)

| # | 에이전트 | 대상 | 검사 항목 |
|---|---------|------|----------|
| 1 | **coderabbit:code-reviewer** | Phase 20-22 전체 diff | 버그, 보안, 로직 |
| 2 | **pr-review-toolkit:silent-failure-hunter** | server/src/ 전체 | 에러 억제, catch 누락 |
| 3 | **pr-review-toolkit:type-design-analyzer** | 신규 타입 (DemographicTrend 등) | 타입 설계 품질 |
| 4 | **feature-dev:code-reviewer** | app/lib/ 전체 | Flutter 코드 품질 |
| 5 | **feature-dev:code-explorer** | server/src/ 서비스 간 의존성 | 아키텍처 결합도 |
| 6 | **pr-review-toolkit:code-simplifier** | 전체 | 코드 간소화 기회 |

### 23-B. HuggingFace MCP 기술 문서 조회 (Sonnet 실행)

| # | API | 검색 쿼리 | 목적 |
|---|-----|----------|------|
| 23-B1 | `hf_doc_search` | "rust axum service layer caching pattern" | 캐시 전략 최적화 참조 |
| 23-B2 | `hf_doc_search` | "flutter riverpod async notifier error handling" | 에러 핸들링 최신 패턴 |
| 23-B3 | `hub_repo_search` | "naver shopping price tracker" | 유사 프로젝트 참조 |
| 23-B4 | `paper_search` | "e-commerce price prediction machine learning" | 가격 예측 알고리즘 |

### 23-C. 판정 기준 (Opus 적용)
- **CRITICAL**: 데이터 손실, 보안 취약, 비즈니스 로직 오류 → 즉시 수정
- **HIGH**: 성능 저하, 에러 핸들링 미흡 → Phase 24에서 수정
- **MEDIUM**: 코드 스타일, 타입 설계 → 선별 수정
- **LOW/오탐**: 건너뜀

### 23-D. 산출물
- 이슈 목록 (등급별)
- 아키텍처 개선 권고
- 기술 문서 기반 최적화 제안
- 코드 간소화 목록

### ⏸️ Phase 23 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-119** | CRITICAL/HIGH 수정 범위? | A) 전체 즉시 / B) CRITICAL만 / C) 선별 |
| **D-120** | 아키텍처 리팩토링 범위? | A) 권고 전체 / B) 신규 서비스만 / C) 보류 |
| **D-121** | HuggingFace 참조 기반 최적화? | A) 적용 / B) 참고만 |

---

## Phase 24: 프론트엔드 UX + 디자인 시스템 강화 (frontend-design + figma)

> **목표**: Flutter 앱 전체 UI/UX 감사 + 디자인 시스템 규칙 도출 + D-95/D-96 미결 해소
> **실행자**: Sonnet 4.6 Sub-agent (감사/분석) → Opus 4.6 (UX 결정/코드 생성)
> **전제**: Phase 23 승인 후

### 24-A. 프론트엔드 감사 (Sonnet 병렬 3대)

| # | 스킬/에이전트 | 임무 |
|---|-------------|------|
| 24-A1 | **frontend-design** | 10개 화면 UI 패턴 감사 (일관성/접근성/반응성) |
| 24-A2 | **figma:figma-create-design-system-rules** | AppColors/AppSpacing/AppTextStyles 기반 디자인 시스템 규칙 |
| 24-A3 | **pr-review-toolkit:comment-analyzer** | Flutter 위젯 문서/주석 품질 |

### 24-B. 미결 결정 해소

| # | 결정 ID | 내용 | 실행 내용 |
|---|---------|------|----------|
| 24-B1 | **D-95** | discountRate 다크모드 대응 | AppColors.discountRate 다크모드 색상 추가 |
| 24-B2 | **D-96** | SearchScreen 필터 재연결 | 백엔드 기존 4필터+4정렬 → Flutter UI 완전 연결 검증 |

### 24-C. NaverSearch 기반 UX 검증 (Sonnet MCP 호출)

| # | API | 목적 |
|---|-----|------|
| 24-C1 | `search_shop` | 실제 상품 데이터로 ProductCard 렌더링 검증 |
| 24-C2 | `search_blog` + `search_news` | 상품 관련 리뷰/뉴스 UI 표시 가능성 평가 |
| 24-C3 | `datalab_search` | 검색 트렌드 데이터로 SearchScreen 개선점 도출 |

### 24-D. 산출물
- UI/UX 이슈 목록 + 수정 코드
- 디자인 시스템 규칙 문서
- D-95/D-96 해소 코드
- 접근성 강화 코드 (Semantics 확장)

### ⏸️ Phase 24 확인점

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-122** | 디자인 시스템 규칙 적용 범위? | A) 전체 화면 / B) 신규 위젯만 / C) 참고만 |
| **D-123** | 접근성 강화 범위? | A) 전체 10화면 / B) 미적용 화면만 / C) 보류 |
| **D-124** | 블로그/뉴스 리뷰 UI 기능 추가? | A) Phase 21 확장 / B) 향후 PLAN_02 / C) 비해당 |

---

## Phase 25: 최종 검증 + 구조화 커밋 + 베이스라인 갱신

> **목표**: Phase 20-24 전체 결과물 통합 검증 → 구조화 커밋 → 베이스라인 갱신 → PLAN_01 최종 종결
> **실행자**: Opus 4.6 (최종 판단) + Sonnet 4.6 (검증 실행)
> **전제**: Phase 24 승인 후

### 25-A. 검증 항목

| 항목 | 기준 | 도구 |
|------|------|------|
| Flutter 테스트 | ≥370건 (증가 기대) | `flutter test` |
| Flutter analyze | 0건 | `flutter analyze` |
| Rust 테스트 | ≥216건 (증가 기대) | Sonatype 재확인 |
| 의존성 보안 | CVE 0건 | Sonatype + `cargo audit` |
| 코드 품질 | CRITICAL 0건 | coderabbit 최종 |

### 25-B. 커밋 전략

| # | 커밋 범위 | 메시지 패턴 |
|---|----------|------------|
| 1 | Phase 20 데이터 검증 수정 | `fix(naver): MCP 실측 기반 NaverSearch 응답 구조 정합 수정` |
| 2 | Phase 21 인구통계 파이프라인 | `feat(demographic): 연령/성별/기기별 트렌드 분석 파이프라인` |
| 3 | Phase 22 의존성 최신화 | `deps: BREAKING/MINOR 의존성 업그레이드 (Phase 22)` |
| 4 | Phase 23 품질 수정 | `fix(quality): 코드 품질 + 아키텍처 개선 (Phase 23)` |
| 5 | Phase 24 UX + 디자인 | `feat(ui): UX 감사 + 디자인 시스템 강화 + D-95/D-96 해소` |

### 25-C. 최종 결정

| 결정 ID | 질문 | 선택지 |
|---------|------|--------|
| **D-110** (재확인) | main 머지 PR 생성? | A) 예 / B) 보류 |
| **D-111** (재확인) | PLAN_02 방향? | A) 프로덕션 준비 / B) 기능 확장 / C) E2E 테스트 / D) 조합 |
| **D-125** | KakaotalkChat 완료 알림? | A) 예 (MemoChat으로 결과 요약 전송) / B) 불필요 |

### 25-D. 메모리/문서 갱신
- MORNING_BRIEFING.md Night-68 결과 기록
- 프로젝트 메모리 갱신 (테스트 수, Phase 완료 상태, 신규 서비스)
- PLAN_01.md Phase 20-25 완료 마킹

---

## 실행 원칙 (Phase 20-25 공통)

1. **단방향 결정 금지**: 모든 변수/대안 경로에 대해 ⏸️ 확인점에서 명시적 사용자 승인
2. **Phase 전환 시 필수 확인**: ⏸️ 마크 지점에서 반드시 사용자 승인 획득 후 다음 Phase 진입
3. **Opus/Sonnet 역할 분리**:
   - Opus 4.6 (Main Agent): 전략 설계, MCP 데이터 해석, 아키텍처 결정, 트레이드오프 분석, 오탐 필터링, 최종 코드 리뷰
   - Sonnet 4.6 (Sub-agent): MCP API 호출, 데이터 수집, 코드 탐색, 테스트 실행, 병렬 에이전트 운용
4. **Ralph-loop 한도**: 최대 **10회** (모니터링/반복 작업용)
5. **코드 기여 요청**: 비즈니스 로직 트레이드오프가 있는 5~10줄은 사용자에게 위임
6. **MCP 활용 원칙**:
   - 실시간 데이터로 코드 생성/검증 → 가상 데이터 절대 사용 금지
   - NaverSearch/CoinInfo/OpenDart: 실시간 API 호출로 데이터 정합성 보장
   - Sonatype: 의존성 보안/품질 점수 기반 업그레이드 결정
   - HuggingFace: 기술 문서 참조 기반 최적화
7. **MCP 대체 원칙**:
   - context7 → WebSearch + HuggingFace MCP
   - playwright → feature-dev:code-architect
   - serena → feature-dev:code-explorer
   - sequential-thinking → superpowers:brainstorm
   - mcp-tailwind-gemini/shadcn → frontend-design + figma (Flutter 프로젝트)
   - chatgpt-mcp → Opus 4.6 직접 분석
8. **베이스라인 보존**: Flutter ≥370건, Rust ≥216건, analyze 0건 — 매 Phase 종료 시 검증
9. **직접 실행 가능 코드**: 모든 생성 코드는 컴파일/테스트 즉시 가능해야 함

---

## 예상 산출물 요약 (Phase 20-25)

| Phase | 핵심 산출물 | 예상 영향 | MCP 활용 |
|-------|-----------|----------|---------|
| 20 | 실시간 데이터 검증 보고서 + 코드 수정 | 데이터 정합성 보장 | NaverSearch(7)+CoinInfo(1)+OpenDart(1)+UsStockInfo(1) |
| 21 | 인구통계 분석 파이프라인 (Rust+Flutter) | 사용자 분석 기능 추가 | NaverSearch(6) |
| 22 | 의존성 최신화 (BREAKING+MINOR) | 보안 강화 + 최신 API | Sonatype(3)+WebSearch |
| 23 | 코드 품질 감사 + 아키텍처 개선 | 기술 부채 해소 | HuggingFace(4)+병렬 에이전트 6대 |
| 24 | UX 감사 + 디자인 시스템 + D-95/D-96 | UI 일관성 + 미결 해소 | NaverSearch(3)+frontend-design+figma |
| 25 | 구조화 커밋 + 최종 검증 | 추적 가능한 이력 | KakaotalkChat(1)+commit-commands |

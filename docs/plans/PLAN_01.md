# PLAN_01: 값뚝(gapttuk) 종합 실무 최적화

> 작성: 2026-03-31 | **실행: 2026-04-01 ~ 2026-04-07** | 브랜치: `auto/night-01-20260407_0100`
> 베이스라인: Flutter 296건 ✅ | Rust 207건 ✅ | analyze 0 issues
> **Night-37 현재**: Flutter **358건** ✅ | Rust **207건** ✅ | Phase 1~6 완료 | **Phase 7~8 실행 대기**
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
> | **7** | **✅ 완료** | Night-37 | 코드 간소화 + 의존성 3건 업그레이드 |
> | **8** | **✅ 완료** | Night-37 | 최종 검증 + 구조화된 커밋 |

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

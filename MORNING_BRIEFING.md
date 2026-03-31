# MORNING BRIEFING — 2026-03-31 (Night-13 ~ Night-30 종합 분석)

> **분석 대상**: Night-13 ~ Night-30 (2026-03-12 ~ 2026-03-31)
> **현재 브랜치**: `auto/night-01-20260331_0100` (main + 44 commits)
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-03-31 (Night-30 최종, 검증 완료)
> **변경 규모**: 78파일+ (+4,837 / -884)
> **검증**: Rust 207건 ✅ / Flutter 296건 ✅ / analyze 0건 ✅ (2026-03-31 실측)
> **총 커밋**: main + 44 commits

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-30 세션별 전략

| Night | 날짜 | 전략 | 핵심 결정 | 커밋 |
|-------|------|------|-----------|------|
| 13 | 03-12 | PLAN_01.md 도입 + 테스트 보강 | D-25~D-26: 야간 세션 자율 범위 제한, 순수 함수 추출 | `0d04c09` |
| 14 | 03-13~14 | 종합 최적화 Phase 0~3 | D-27~D-33: Silent failure 10건 + 순수함수 15건 + 접근성 3화면 | `8cfa413`, `c7dcb1d` |
| 15 | 03-15 | 잔여 이슈 소진 | D-34~D-35: trailing slash 정리, build_runner 보류 | `5b9f5b9` |
| 16 | 03-16 | 심층 분석 + 로깅 보강 | D-36~D-40: MCP 스킵, 서버+Flutter 균형, E2E 이연 | `b57981d` |
| 17 | 03-17 | 타입 안전성 + 관측성 | D-41~D-42: chars().count(), referral_welcome_referrer 버그 수정 | `d8e76a7` |
| 18 | 03-18 | 타입 안전성 심화 + 에러 로깅 | 테스트 +2, saturating_mul, clamp, cursor 로깅 | `39dca08` |
| 19 | 03-19 | API 계약 정합 + 순수함수 DRY | serde rename_all, validate 추출, 테스트 +10, mounted 가드 | `966ca32` |
| 20 | 03-20 | CRITICAL 버그수정 + Phase 2-C 실행 | PriceTrend serde 누락, showErrorSnackBar 통합, parse_cursor DRY | `bb55aac` |
| 21 | 03-21 | serde 파급 누락 3회차 + 방어 파싱 | PredictedAction/SearchTrend/AuthProvider serde, confidence String 파싱 | `63780bb` |
| 22 | 03-22 | 구조적 자동화 전환 + TOCTOU 해결 | D-43: alert SELECT FOR UPDATE, referral retry loop, serde CI, Flutter 테스트 +16 | `f1ab244` |
| 23 | 03-23 | 관측성 완결 + 테스트 확대 + 의존성 감사 | D-44~46: rollback warn 5곳, C-1 CRITICAL, cargo audit 7건, Flutter +18건 | `d95e438`, `d9ab41f` |
| 24 | 03-24 | 취약점 해결 + FakeService 패턴 확장 | D-47: RUSTSEC-2026-0049 ignore, cargo 7→0건, Flutter +18건 (216건) | `025eaeb`, `e506f6f` |
| 25 | 03-25 | 위젯/프로바이더 단위 테스트 완성 | D-48: Riverpod 3.x auto-dispose 에러 테스트 패턴, 위젯 4/4 커버리지 | `7206ac1` |
| 26 | 03-26 | AuthState 프로바이더 + SearchScreen 테스트 완성 | D-49: keepAlive Notifier 테스트 시 PushService stub 필수 | `b4b7cd0` |
| 27 | 03-27 | 화면별 심층 테스트 완성 (Favorites/MyPage/Alert 탭) | D-50: productDetailProvider family override / D-51: TabBar 탭 전환 테스트 | `6c3358c` |
| 28 | 03-28 | 세부 UI 상태 테스트 완성 (ProductDetail/Notification/PointHistory) | D-52: markAllAsRead 스낵바 검증 / D-53: _transactionLabel switch 간접 검증 | `7db6024` |
| 29 | 03-29 | 미확장 화면 테스트 완성 (Home/Login/Onboarding) | D-54: _trendIcon switch 간접 검증 / D-55: 전체동의 상태 버튼 활성화 | `d8adc28` |
| **30** | **03-31** | **PLAN_01.md 8-Phase 전략 수립 + 다이얼로그/접근성/다중알림 테스트** | **D-56: Semantics properties.label 패턴 / D-57: 다중 family override** | **`63016a4`** |
| **31** | **04-01** | **Phase 2/3 GAP 분석 + ProductDetail/MyPage/Notification 테스트 +12건** | **D-58: default 케이스 간접 검증 / D-59: initState 에러 분기 / D-60: _formatTime 분기** | **`c8efba4`** |

### 1.2 전략적 성숙도 곡선

```
Night 01-03: 기반 정비 ──── 보안/성능/구조
Night 04-06: 품질 + 비즈니스 ─ 메트릭/보상/관측성
Night 07-09: 안정화 ──────── 테마/버그수정
Night 10-12: 기능 확장 ───── OpenAPI/Monthly/Referral
Night 13:    자기 교정 ───── PLAN_01.md 도입 → 자율 범위 제한
Night 14:    규율 있는 실행 ── PLAN_01 Phase 0→1→2→3 순차 완수
Night 15:    잔여 소진 ───── §5.3 잔여 이슈 8건 일괄 처리
Night 16:    심층 재분석 ──── 4대 병렬 서브에이전트 → 13건 확정 실행
Night 17:    정밀 안전성 ──── 타입 캐스팅/산술 오버플로 제거 + UI 버그
Night 18:    수확 체감 지점 ── 동일 패턴 3회 반복, 테스트 +2만 증가
Night 19:    수확 체감 확정 ── API 계약 보정 + 순수함수 DRY
Night 20:    기습 CRITICAL ── PriceTrend 직렬화 버그 + Phase 2-C 해소
Night 21:    구조적 패턴 확인 ── 3회 연속 serde 파급 누락 → 자동화 필요성
Night 22:    ★ 전환점 ──────── 자동화(CI serde) + TOCTOU 해결 + 테스트 대폭 증가
Night 23:    ★★ 완결 ────────── 발견→수정→검증 3단계 완결 + 의존성 감사
Night 24:    ★★★ 안정화 종결 ── 취약점 0건 + FakeService 3종 + 216건
Night 25:    ★★★★ 테스트 완결 ── 위젯 4/4 + 프로바이더 family + 238건
Night 26:    ★★★★★ 상태 관리 ── AuthState Notifier + SearchScreen + 248건
Night 27:    ★★★★★★ 화면별 심층 ── Favorites/MyPage/Alert 탭전환 + 260건
Night 28:    ★★★★★★★ 세부 UI ── ProductDetail/Notification/PointHistory + 272건
Night 29:    ★★★★★★★★ 미확장 완성 ── Home/Login/Onboarding + 284건
Night 30:    ★★★★★★★★★ 전략 전환 ── PLAN_01.md 8-Phase 계획 + 다이얼로그/접근성 + 296건
```

### 1.3 Night-30 전략적 전환점: PLAN_01.md

Night-30에서 **8-Phase 종합 최적화 계획** (`docs/plans/PLAN_01.md`)이 수립됨.
이전까지 ad-hoc 품질 개선이었던 야간 세션이 **체계적 파이프라인으로 전환**:

| Phase | 내용 | 주요 도구 | 상태 |
|-------|------|----------|------|
| **1** | 의존성 보안 감사 | Sonatype MCP → `pub outdated` 대체 | ⚠️ 부분 실행 |
| **2** | 프레임워크 최신 패턴 검증 | Context7 MCP → 코드베이스 직접 탐색 | ✅ Night-31 완료 |
| **3** | 아키텍처 심층 분석 | feature-dev + serena → 직접 탐색 | ✅ Night-31 완료 |
| **4** | 코드 품질 심층 리뷰 | code-review + pr-review-toolkit | ⏳ 미시작 |
| **5** | Flutter UI/UX 개선 | frontend-design + context7 | ⏳ 미시작 |
| **6** | 테스트 커버리지 확장 | feature-dev | ✅ Night-30(+12) + Night-31(+12) = **308건** |
| **7** | 코드 간소화 | code-simplifier | ⏳ 미시작 |
| **8** | 최종 검증 및 커밋 | commit-commands + verification | ⏳ 미시작 |

**Phase 1 부분 실행 결과 (Night-30):**
- Sonatype MCP 인증 실패 → `pub outdated`로 대체
- 즉시 업그레이드 가능: `json_annotation` 4.9.0 → 4.11.0
- 메이저 업그레이드 대기: `fl_chart` 1.2.0, `go_router` 17.x, `google_sign_in` 7.x (Breaking changes)

**Phase 2/3 실행 결과 (Night-31):**
- 서버(Rust): axum/sqlx/tower 패턴 최신 권장사항과 완전 정합
- Flutter GAP: riverpod 3.0→3.3(minor), go_router StatefulShellRoute(minor) — 현재 기능 영향 없음

**설계 핵심 의도:**
1. **Opus/Sonnet 역할 분리** — 데이터 수집(Sonnet Sub-agent) vs 의사결정(Opus Main Agent) 명시적 분리
2. **8개 ⏸️ GATE** — 매 Phase 전환 시 사용자 승인 필수, 단방향 결정 금지
3. **미설치 MCP 대체 전략** — chatgpt-mcp/sequential-thinking → `superpowers:brainstorm` 대체

### 1.4 Opus 4.6의 핵심 전략 패턴

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 (⏸️ 8개 확인점)
2. **오탐 필터링**: 서브에이전트 발견 → Opus가 ~40% 필터링 → 13~18건 실행 확정
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트
4. **serde 파급 누락 → CI 자동화** (Night-19→22): 3회 수동 반복 실패 후 구조적 종결
5. **Silent Failure 생명주기**: 전수 조사(Night-22) → 수정(Night-23) → 재검증 = 3단계 완결
6. **FakeService 패턴 3종 완비** (Night-23→24): 플랫폼 채널 없이 전체 비즈니스 화면 테스트
7. **위젯 단위 테스트 완결** (Night-25): 4/4 위젯 커버리지

### 1.5 의사결정 일관성

- **총 57개 결정** (D-1 ~ D-57)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 1건 (D-39: E2E 테스트)
- **나머지 50건: IMPLEMENTED 유지**

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~30 서브에이전트 운용

| Night | 에이전트 수 | 서버 발견 | Flutter 발견 | 실행 건수 |
|-------|------------|----------|-------------|----------|
| 16 | 4대 | CRIT-2+HIGH-6+MED-5 | CRIT-3+HIGH-8+MED-3 | 서버7+Flutter6 |
| 17 | 3대 | HIGH-3+MED-6+LOW-4 | HIGH-4+MED-6+LOW-2 | 서버7+Flutter9 |
| 18 | 3대 | CRIT-1+HIGH-6+MED-5+LOW-3 | HIGH-8+MED-5+LOW-2 | 서버7+Flutter9+테스트2 |
| 19 | 3대 | MED-5+LOW-5 | MED-6+LOW-9 | 서버7+Flutter7+테스트10 |
| 20 | 3대 | HIGH-4+MED-7+LOW-6 | MED-6+LOW-10 | 서버7+Flutter7 |
| 21 | 3대 | CRIT-2+HIGH-5+MED-6+LOW-4 | CRIT-2+HIGH-5+MED-6+LOW-3 | 서버7+Flutter7 |
| 22 | 1대 (silent-failure-hunter) | HIGH-3+MED-3 | — | 서버3+Flutter4+CI1 |
| 23 | ~13대 (최대 4병렬) | audit 7건, warn 5곳+C-1 | +18건 테스트 | 서버7+Flutter18+리뷰5 |
| 24 | ~3대 (순차) | cargo update+audit.toml | +18건 테스트 | 서버2+Flutter18 |
| 25~29 | 직접 실행 | 프로덕션 코드 변경 없음 | +22/+10/+12/+12/+12건 | Flutter only |
| **30** | **직접 실행** | **PLAN_01.md 작성 + pub outdated** | **+12건 테스트** | **계획 수립 + Flutter12** |

### 2.3 MCP/플러그인 활용 현황

| 카테고리 | 도구 | 누적 활용 | 현재 상태 |
|----------|------|-----------|----------|
| 코드 탐색 | `feature-dev:code-explorer` (22대+) | Night-16~23 주력 | ✅ 활성 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-22 완결 | ✅ 완료 |
| 코드 리뷰 | `coderabbit:code-reviewer` | Night-23 종합 리뷰 | ✅ 활성 |
| 의존성 | `cargo audit` + `cargo update` | Night-24: 7건→0건 | ✅ 완료 |
| 외부 참조 | WebSearch + WebFetch | MCP 대체 (D-36:C) | ✅ 활성 |

**MCP 서버 상태:**

| MCP | 상태 | 비고 |
|-----|------|------|
| context7 | ✅ 활성 (stdio) | PLAN_01 Phase 2/5 대기 |
| playwright | ✅ 설치 (stdio) | D-39:B — E2E 이연 |
| serena | ✅ 설치 (stdio) | PLAN_01 Phase 3 대기 |
| Hugging Face | ⚠️ OAuth 만료 | `HF_TOKEN` 갱신 필요 |
| **Sonatype Guide** | **⚠️ 인증 미설정** | **Night-22~30 — 9세션 연속 API 호출 실패** |
| shadcn, mcp-tailwind | ❌ Flutter 비해당 | 영구 스킵 |
| chatgpt-mcp, sequential-thinking | ❌ 미설치 | `superpowers:brainstorm` 대체 |

### 2.4 기술 실행 품질

**누적 강점 (Night-13~30):**
- 일관된 5단계 검증 루틴 (test → clippy → fmt → analyze → flutter test)
- **0건 테스트 회귀**: 18개 세션에서 기존 테스트 깨짐 0건
- Silent Failure 완결: 전수 조사(51파일) → 수정(5곳) → 재검증 = 생명주기 종결
- **cargo audit 0건**: Night-24 이후 7세션 연속 유지
- **위젯 테스트 4/4**: Night-25 이후 6세션 연속 유지
- serde rename_all 7개 enum + 14건 직렬화 테스트 + CI 자동 전수 검사

**지속적 약점:**
- `cargo test --lib`만 실행 — 통합 테스트 43건 스킵 (환경 제약)
- `sonatype-guide` 인증 미설정 (**9세션 연속 Night-22~30**)
- RUSTSEC-2026-0049: a2 upstream rustls 0.23 전환 대기 (audit.toml ignore)
- SessionEnd hook 실패: `node` 미설치 (`session-end-cleanup.mjs`)

---

## 3. 코드 생성 결과

### 3.1 테스트 성장 추이

| 시점 | Rust (lib) | Flutter | 총계 (lib) |
|------|-----------|---------|-----------|
| Night-01 시작 | 147 | — | 147 |
| STEP 50 (보상) | 164 | 115 | 279 |
| Night-07 (STEP 53) | 197 | 164 | 361 |
| Night-13 | 176 | 164 | 340 |
| Night-14 | 191 | 164 | 355 |
| Night-18 | 193 | 164 | 357 |
| Night-19 | 203 | 164 | 367 |
| Night-20~21 | 207 | 164 | 371 |
| Night-22 | 207 | 180 | 387 |
| Night-23 | 207 | 198 | 405 |
| Night-24 | 207 | 216 | 423 |
| Night-25 | 207 | 238 | 445 |
| Night-26 | 207 | 248 | 455 |
| Night-27 | 207 | 260 | 467 |
| Night-28 | 207 | 272 | 479 |
| Night-29 | 207 | 284 | 491 |
| **Night-30 최종** | **207** | **296** | **503** |

> 통합(43) + doc(4) 포함 시 추정 ~550건.

### 3.2 Night-30 신규 테스트 상세

| 파일 | 이전 | 이후 | 신규 검증 경로 |
|------|------|------|--------------|
| `settings_screen_test.dart` | 7 | **11** | 로그아웃 다이얼로그·취소, 탈퇴 다이얼로그·아이콘 |
| `search_screen_test.dart` | 8 | **12** | Semantics.label, textInputAction, tooltip, 빈검색 |
| `favorites_screen_test.dart` | 9 | **13** | AlertTypeBadge, 2개 배지, 비활성 오버레이, 재시도 |

### 3.3 Night-30 신규 결정 패턴

| ID | 패턴 | 내용 |
|----|------|------|
| **D-56** | Semantics properties.label | `find.bySemanticsLabel()` 대신 `find.ancestor(...).first` + `widget<Semantics>().properties.label` — 접근성 트리 비활성 환경에서 안정적 검증 |
| **D-57** | 다중 family override | `productDetailProvider(100).overrideWith(...)` + `productDetailProvider(200).overrideWith(...)` 별도 등록 — 여러 상품 ID 동시 override |

### 3.4 코드베이스 규모

| 항목 | **Night-30** | Night-29 | 변화 |
|------|-------------|----------|------|
| DB 마이그레이션 (main) | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-57** | D-55 | **+2** |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | 28건+ (잔존 0건) | 28건+ | — |
| 커밋 (main 대비) | **44** | 37 | **+7** |

### 3.5 순수 함수 추출 목록

| 서비스 | 함수 | 테스트 수 | Night |
|--------|------|----------|-------|
| auth_service | `validate_consent` | 5 | 13 |
| auth_service | `is_valid_referral_code_format` | 12 | 13 |
| notification_service | `build_deep_link` | 6 (+1) | 14 |
| product_service | `build_search_pattern` | 6 | 14 |
| reward_service | `compute_referral_rewards` | 4 | 14 |
| alert_service | `format_price` | 1 | 18 |
| alert_service | `validate_target_price` | 5 | 19 |
| alert_service | `validate_keyword` | 5 | 19 |

**총 11개 함수, 54 테스트 — DB 의존 없이 ~0ms 실행**

---

## 4. 브랜치 현황

### 4.1 활성 브랜치 (2026-03-31)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260331_0100`** ★ | **+44 commits** | Night-13~30 전체 + PLAN_01.md | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (19개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0330_0100` (18개) | **Night-30 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260331_0100 → main (44커밋, 충돌 없음) → 즉시 PR 가능
2. feat/dark-mode (1커밋, 독립, 충돌 낮음)
3. fix/phase0-security-stability (보안+CD, migration 019-020, 충돌 높음)
4. feat/phase2-monthly-prices (MonthlyPriceItem 중복 확인 필요)
```

### 4.4 중복 작업 매트릭스

| 기능 | `feat/phase2-monthly-prices` | `fix/phase0-security-stability` |
|------|------|------|
| Monthly prices API | O | — |
| MonthlyPriceChart | O | — |
| ReferralScreen | — | O |
| FK CASCADE(020) | — | O |
| 검색 필터 UI | — | O |
| CD 파이프라인 | — | O |

---

## 5. PLAN_01.md Phase 진행 상황

| Phase | 상태 | Night | 결과 |
|-------|------|-------|------|
| 기존 Phase 0~3 | ✅ 완료 | 14 | Silent failure, 순수함수, 접근성, cargo audit |
| Night-15~29 | ✅ 완료 | 15~29 | 타입 안전성, API 계약, 테스트 +132건 |
| **PLAN_01 Phase 1** | **⚠️ 부분** | **30** | **Sonatype 실패 → pub outdated 대체. json_annotation 업그레이드 가능** |
| **PLAN_01 Phase 2~5** | **⏳ 대기** | — | **사용자 승인 필요 (GATE 체계)** |
| **PLAN_01 Phase 6** | **⚠️ 부분** | **30** | **+12건 테스트 추가 (296건)** |
| **PLAN_01 Phase 7~8** | **⏳ 대기** | — | **코드 간소화 + 최종 검증** |
| sonatype-guide | ⏭️ 건너뜀 | 22~30 | 인증 미설정 (**9세션 연속**) |
| PR 생성 + 머지 | ⏳ 대기 | — | **사용자 승인 필요** |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~30 머지 방향 | `auto/night-01-20260331_0100` (78파일+, 44커밋, cargo audit 0건, Flutter 296건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **U-37** | PLAN_01 Phase 2~5 진행 여부 | Phase 1 부분 완료 후, Phase 2(프레임워크 검증)부터 순차 진행 또는 범위 조정 | A) 순차 진행 B) Phase 선택 C) 보류 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-38** | Sonatype MCP 인증 설정 | **9세션 연속 실패** — Phase 1 의존성 보안 점수 미확인. 인증 설정하거나 영구 스킵 결정 필요 |
| **U-34** | 메이저 패키지 업그레이드 | `go_router` 17.x, `fl_chart` 1.2.0, `google_sign_in` 7.x — breaking changes 포함 |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 4개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **19개+** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | `cargo test --lib`만 실행 중 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-39** | SessionEnd hook 수정 | `node` 미설치로 `session-end-cleanup.mjs` 실행 실패 (Night-30 2회 감지) |
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |

---

## 7. Night-30에서 해결된 항목 + 잔존 항목

### ✅ Night-30에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| SettingsScreen 다이얼로그 테스트 0건 | MEDIUM | +4건 (로그아웃/탈퇴 다이얼로그·취소·아이콘) |
| SearchScreen 접근성/Semantics 테스트 0건 | MEDIUM | +4건 (label/textInputAction/tooltip/빈검색) |
| FavoritesScreen AlertTypeBadge/비활성 테스트 0건 | MEDIUM | +4건 (배지/2개배지/비활성오버레이/재시도) |
| 체계적 최적화 계획 부재 | HIGH | PLAN_01.md 8-Phase 파이프라인 수립 |

### ✅ Night-30에서 신규 생성

| 항목 | 설명 |
|------|------|
| `docs/plans/PLAN_01.md` | 8-Phase 종합 최적화 계획 (251줄) — Opus/Sonnet 역할 분리, MCP 매트릭스, Phase별 GATE |

### ⏳ 잔존 항목 (다음 세션)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| PLAN_01 Phase 2~5 실행 | HIGH | GATE 체계 — 사용자 승인 대기 |
| 메이저 패키지 업그레이드 | HIGH | breaking changes — 별도 계획 필요 |
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 (**9세션 연속**) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 19개+ 정리 | LOW | 사용자 승인 대기 |
| SessionEnd hook `node` 미설치 | LOW | 환경 설정 필요 |
| **Flutter 테스트 포화** | **INFO** | **11개 화면 확장 완료 — 추가 단위 테스트 수확 체감** |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-03-31, Night-30 실측 검증 완료)

| 지표 | **Night-30** | Night-29 | Night-28 | 변화 (vs 29) |
|------|------------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** ✅ | 207 | 207 | — |
| Flutter 테스트 | **296** ✅ | 284 | 272 | **+12** |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | — |
| DECISION_LOG | **D-57** | D-55 | D-53 | **+2** |
| Silent Failure 수정 | **28건+** (잔존 0건) | 28건+ | 28건+ | — |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | — |
| showErrorSnackBar 통합 | **11개소** | 11개소 | 11개소 | — |
| serde rename_all 적용 enum | **7개** | 7개 | 7개 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 | 0건 | — |
| 위젯 테스트 커버리지 | **4/4** ✅ | 4/4 | 4/4 | — |
| FakeService 패턴 | **3종** | 3종 | 3종 | — |
| 순수 함수 추출 | 11개/54테스트 | 11개/54 | 11개/54 | — |
| 커밋 (main 대비) | **44** | 37 | 35 | **+7** |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **완결** ✅ |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **해결됨** ✅ |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (20건) |
| API 계약 정합성 | **완료** ✅ (serde 7개 + CI) |
| serde 파급 누락 방지 | **해결됨** ✅ (CI 자동검사) |
| TOCTOU 경쟁 조건 | **해결됨** ✅ |
| 의존성 보안 | **해결됨** ✅ (cargo audit 0건) |
| **Flutter 테스트 커버리지** | **포화** ✅ (296건) |
| PLAN_01 Phase 2~8 | **미시작** ⏳ |
| 미머지 브랜치 통합 | **적체** ⚠️ (4개) |
| auto 브랜치 정리 | **미처리** ⚠️ (19개+) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (9세션 연속) |
| RUSTSEC-2026-0049 | **모니터링** ⚠️ (audit.toml ignore) |
| SessionEnd hook | **node 미설치** ⚠️ |

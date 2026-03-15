# MORNING BRIEFING — 2026-03-15 (Night-01 ~ Night-15 종합 분석)

> **분석 대상**: 13일간 야간 자동화 세션 (2026-03-03 ~ 2026-03-15)
> **현재 브랜치**: `auto/night-01-20260315_0100` (main + 3 commits + unstaged 15파일)
> **생성**: Opus 4.6 종합 분석
> **이전 브리핑**: 2026-03-14 (Night-14 기준)
> **신규 변경**: Night-15 잔여 이슈 8건 처리 (F2/S8/S9보류/F4/F5/F6/F7/F8)

---

## 1. Opus 4.6 전략 분석

### 1.1 세션별 전략 패턴

| Night | 날짜 | 브랜치 | 전략 | 핵심 결정 |
|-------|------|--------|------|-----------|
| 01 | 03-03 | auto/...0303 | 서비스 레이어 정비 | D-1: device_service 추출, D-3: 배경 태스크 메트릭 |
| 02 | 03-04 | auto/...0304 | 보안 핫픽스 집중 | D-6~8: JWT aud/iss, Kakao app_id, chars().count() |
| 03 | 03-05 | auto/...0305 | 성능 CRITICAL 해결 | D-11~14: 동적 세마포어, 파티션 프루닝, single-query upsert |
| 04-06 | 03-06 | auto/...0306 | 풀스택 품질 + 보상 체계 | 메트릭 22개, reward_service v0.8, reward_stage |
| 07 | 03-07 | auto/...0307 | 테마 중앙화 + 보존 정책 | STEP 53: AppColors ThemeExtension, Migration 017 |
| 08 | 03-08 | auto/...0308 | 버그 수정 2건 | M-3: GAP- 형식 검증, M-4: checkin caps race condition |
| 09 | 03-09 | auto/...0309 | Medium 결함 2건 | M-5: null-safe fromJson, M-7: 결정론적 재시도 방지 |
| 10 | 03-10 | auto/...0310 | OpenAPI Phase 4 | utoipa 5.x + Swagger UI (CDN HTML 방식) |
| 12 | 03-11 | auto/...0311 | Phase 2 기능 구현 | Monthly prices API + ReferralScreen |
| 13 | 03-12 | auto/...0312 | 테스트 보강 + 계획 도입 | D-25: PLAN_01.md 도입, D-26: 순수 함수 추출 +17 테스트 |
| 14 | 03-13~14 | auto/...0314 | 종합 최적화 3-Phase | D-27~D-33: Silent failure 10건 + Flutter a11y 3화면 |
| **15** | **03-15** | **auto/...0315** | **잔여 이슈 소진** | **D-34~D-35: trailing slash 정리, build_runner 보류** |

### 1.2 전략적 특징

**점진적 성숙도 곡선**
```
Night 01-03: 기반 정비 ──── 보안/성능/구조
Night 04-06: 품질 + 비즈니스 ─ 메트릭/보상/관측성
Night 07-09: 안정화 ──────── 테마/버그수정
Night 10-12: 기능 확장 ───── OpenAPI/Monthly/Referral
Night 13:    자기 교정 ───── PLAN_01.md 도입
Night 14:    규율 있는 실행 ── PLAN_01.md Phase 1→2→3 순차 완수
Night 15:    잔여 소진 ───── PLAN_01 §5.3 잔여 이슈 8건 일괄 처리
```

**Night-15의 핵심 전략 전환:**
- Night-14에서 PLAN_01.md Phase 0~3을 완수한 뒤, **§5.3 잔여 이슈 목록**이 자연스럽게 Night-15의 작업 범위가 됨
- 서버 4건 + Flutter 6건 중 **7건 완료, 1건 보류(S9: build_runner 4.x 미존재)**
- **커밋 없이 unstaged 상태로 종료** — 사용자의 커밋/PR 방향 결정 대기

**의사결정 일관성**: 35개 결정(D-1~D-35) 중 1건만 REVERSED (D-2: utoipa), 2건 보류(D-32: CheckinResult 열거형, D-33: productDetailProvider keepAlive), 1건 보류(D-35: build_runner 4.x). 나머지 31건 IMPLEMENTED 유지.

### 1.3 Opus 4.6의 핵심 전략 패턴

1. **순수 함수 추출 패턴** (9개 함수, 42 테스트):
   - DB 의존 로직에서 validation/transformation 순수 함수를 분리 → 0ms 단위 테스트 가능
   - Night-14에서 3개 추가: `build_deep_link`, `build_search_pattern`, `compute_referral_rewards`
   - S2(rotate_refresh_token)는 "DB 의존 함수로 순수 함수 추출 불가" 판정 → 영구 스킵

2. **Silent Failure 제거** (Night-14, D-28):
   - `unwrap_or(default)` → `unwrap_or_else` + `tracing::warn!`
   - `map_err(|_|)` → 원본 에러 보존 + `tracing::debug!`
   - `.and_then(|c| c.parse().ok())` → `.transpose()?` 로 클라이언트에 400 반환
   - 총 10건 수정 (crawlers/mod.rs 4건, reward_service 3건, product_service 1건, routes 2건)

3. **잔여 이슈 소진** (Night-15):
   - F2: `Colors.red` → `AppColors.error` (테마 일관성)
   - S8: `assert!` → `if/continue` (프로덕션 안정성)
   - F4: `const` 생성자 5곳 (위젯 리빌드 최적화)
   - F5: router `productId:0` early return guard (잘못된 라우팅 방지)
   - F6: trailing slash 3곳 제거 + 테스트 3파일 동기화 (Axum 호환성)
   - F7: `PointHistoryScreen` 날짜 표시 `_formatDate` 헬퍼 (UX)
   - F8: `LoadingSkeleton` 다크모드 shimmer 색상 (다크모드 준비)

4. **GATE 기반 Phase 전환**: 사용자 승인 없이 자율 진행 불가 → Night-14에서 Phase 4 앞에서 정지 (효과 검증 성공)

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 야간 세션 실행 모델

- **Opus 4.6** = Main Agent: 전략 수립, 오탐 필터링, 최종 결정, GATE 승인 요청
- **Sonnet 4.6** = Sub-agent: 데이터 수집, 기술 실행, 코드 생성, 진행 추적

| 실행 특성 | 상세 |
|-----------|------|
| 주요 도구 | 내장 도구(Read/Write/Edit/Bash/Grep/Glob) 위주 |
| Night-14 서브에이전트 | feature-dev:code-explorer 4대 병렬 (Phase 0) + silent-failure-hunter 참조 (Phase 1-A) |
| Night-15 실행 | 단일 에이전트 순차 실행 — 잔여 이슈 8건 처리 |
| 커밋 패턴 | Night-14: 2커밋 (`8cfa413` + `c7dcb1d`), Night-15: **커밋 없음 (unstaged)** |
| 문서 갱신 | NIGHT_06_RESULT.md + PLAN_01.md + DECISION_LOG.md 매 세션 업데이트 |
| 검증 루틴 | `cargo test --lib` + `cargo clippy` + `cargo fmt` + `flutter analyze` + `flutter test` |

### 2.2 MCP/플러그인 활용 현황

**Night-14에서 활용된 도구:**

| 카테고리 | 도구 | 활용 내용 |
|----------|------|----------|
| 코드 탐색 | `feature-dev:code-explorer` | **4대 병렬** — 서버/Flutter/의존성/브랜치 전수 분석 |
| Silent Failure | `pr-review-toolkit:silent-failure-hunter` | Phase 1-A — 10건 에러 핸들링 패턴 수정 |
| 타입 분석 | `pr-review-toolkit:type-design-analyzer` | Phase 1-C — CrawlError/AppError 개선 |
| 검증 | `superpowers:verification-before-completion` | 최종 4단계 검증 루틴 |
| TDD | `superpowers:test-driven-development` | Phase 1-B 순수 함수 추출 패턴 |

**미활용 (Phase 4 대기):**

| 도구 | 용도 | 보류 이유 |
|------|------|-----------|
| `coderabbit:code-reviewer` | PR 전 AI 코드 리뷰 | Phase 4 — 사용자 승인 대기 |
| `pr-review-toolkit:pr-test-analyzer` | 테스트 커버리지 분석 | Phase 4 — PR 생성 시 |
| `pr-review-toolkit:comment-analyzer` | 주석 정확성 검증 | Phase 4 — PR 생성 시 |

**MCP 서버 상태:**

| MCP | 상태 | 비고 |
|-----|------|------|
| Hugging Face | ⚠️ OAuth 만료 | `HF_TOKEN` 갱신 필요 (https://hf.co/settings/mcp/) |
| Sonatype Guide | ⚠️ 인증 만료 | `cargo audit`로 대체 완료 |
| context7, playwright, serena | 설치됨, 세션 미활성 | 향후 세션에서 활성화 가능 |

### 2.3 기술 실행 품질

**Night-15 실행 결과:**

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | ✅ **191/191 passed** |
| `cargo clippy` | ✅ 0 warnings |
| `cargo fmt --check` | ✅ No diff |
| `flutter analyze` | ✅ **0 issues** |
| `flutter test` | ✅ **164/164 passed** |

**강점:**
- 일관된 5단계 검증 루틴 유지
- trailing slash 수정 시 **소스 코드 + 테스트 mock URL 동시 동기화** (6곳 한 번에 처리)
- `build_runner ^4.0.0` 미존재를 즉시 판단하여 원복 + DECISION_LOG 문서화 (D-35)
- `WidgetsBinding.instance.addPostFrameCallback`으로 빌드 중 네비게이션 안전하게 지연 (F5)
- `_formatDate` 헬퍼 로컬 시간 변환 (UTC → 사용자 시간대)

**약점:**
- `cargo test --lib`만 실행 (통합 테스트 41건 스킵) — 환경 제약 지속
- Night-15 **커밋 미생성** — working tree에만 변경사항 존재
- Phase 2-B(Riverpod 3.0 최적 패턴) 실질적 개선 기회 미발굴

---

## 3. 코드 생성 결과

### 3.1 테스트 성장 추이

| 시점 | Rust 테스트 (lib) | Flutter 테스트 | 총계 (lib) |
|------|-------------------|---------------|------------|
| Night-01 시작 | 147 | — | 147 |
| STEP 44 (Flutter 기반) | 155 | 65 | 220 |
| STEP 50 (보상 완성) | 164 | 115 | 279 |
| Night-06 (Phase 3) | 175 | 122 | 297 |
| STEP 51 (품질 최적화) | 197 | 135 | 332 |
| Night-07 (STEP 53) | 197 | 164 | 361 |
| Night-13 | 176 | 164 | 340 |
| Night-14 최종 | 191 | 164 | 355 |
| **Night-15 최종** | **191** | **164** | **355** |

> Night-15: 코드 품질/UX 수정이므로 테스트 수 변경 없음. 통합 테스트(41건) + doc 테스트(4건) 포함 시 추정 ~236건.

### 3.2 코드베이스 규모

| 항목 | Night-06 | Night-14 | **Night-15** | 변화 |
|------|----------|----------|-------------|------|
| DB 마이그레이션 (main) | 014 | 018 | 018 | 유지 |
| DB 마이그레이션 (전체) | 014 | 020 | 020 | 유지 |
| 서버 API 핸들러 | 34 | 37+ | 37+ | 유지 |
| Flutter 화면 | 12 | 15+ | 15+ | 유지 |
| Prometheus 메트릭 | 22 | 22 | 22 | 유지 |
| DECISION_LOG 항목 | D-18 | D-33 | **D-35** | **+2** |
| Dart 모델 (freezed) | 15+ | 18+ | 18+ | 유지 |
| 순수 함수 추출 누계 | 2 | 9 | 9 | 유지 |
| PR 머지 | 1 | 3 | 3 | 유지 |

### 3.3 Night-15 변경 상세 (unstaged, 커밋 미생성)

| 파일 | 작업 | 핵심 |
|------|------|------|
| `app/lib/screens/my/my_page_screen.dart` | F2 | `Colors.red` → `AppColors.error` (1곳) |
| `app/lib/screens/my/settings_screen.dart` | F2+F4 | `Colors.red` → `AppColors.error` (2곳), const 4곳 |
| `server/src/main.rs` | S8 | `assert!` → `if/continue` 복구 패턴 |
| `app/lib/screens/onboarding/onboarding_screen.dart` | F4 | const `_WelcomePage` + `_CompletePage` |
| `app/lib/config/router.dart` | F5 | `productId` early return guard + `addPostFrameCallback` |
| `app/lib/config/api_endpoints.dart` | F6 | trailing slash 3곳 제거 |
| `app/test/services/alert_service_test.dart` | F6 | 테스트 URL 동기화 |
| `app/test/services/notification_service_test.dart` | F6 | 테스트 URL 동기화 |
| `app/test/services/device_service_test.dart` | F6 | 테스트 URL 동기화 |
| `app/lib/screens/my/point_history_screen.dart` | F7 | `_formatDate` 헬퍼 + 날짜 표시 |
| `app/lib/widgets/loading_skeleton.dart` | F8 | 다크모드 조건부 shimmer 색상 |
| `DECISION_LOG.md` | — | D-34, D-35 추가 |
| `NIGHT_06_RESULT.md` | — | Night-15 결과 기록 |
| `PLAN_01.md` | — | §5.3 완료 상태 업데이트 |
| `MORNING_BRIEFING.md` | — | 종합 분석 갱신 |

**누적 변경 (main 대비, committed + unstaged):**
- Committed: 19 files, +1,428/-176 lines (Night-13~14)
- Unstaged: 15 files, +511/-187 lines (Night-15)
- **합산 추정: ~30+ files, ~1,900+ insertions**

### 3.4 순수 함수 추출 현황 (전체)

| 서비스 | 함수 | 목적 | 테스트 수 | 추출 시점 |
|--------|------|------|----------|-----------|
| reward_service | `assign_monthly_cap` | 신규/기존 유저 월한도 배정 | 2 | Night-06 |
| reward_service | `spin_roulette` | 출석 룰렛 확률 분배 | 2 | Night-06 |
| device_service | `validate_device_token` | 토큰 형식 검증 | 6 | Night-01 |
| auth_service | `validate_consent` | 약관 동의 검증 | 5 | Night-13 |
| auth_service | `is_valid_referral_code_format` | GAP-코드 형식 검증 | 12 | Night-13 |
| notification_service | `build_deep_link` | NotificationType → 딥링크 URL | 5 | Night-14 |
| product_service | `build_search_pattern` | ILIKE 이스케이프 + 패턴 래핑 | 6 | Night-14 |
| reward_service | `compute_referral_rewards` | Stage → 보상금액 계산 | 4 | Night-14 |

**총 순수 함수 9개, 테스트 42건** — DB 의존 없이 ~0ms에 실행

### 3.5 Night-15 코드 품질 평가

**서버 (Rust/Axum):**

| 작업 | 수정 전 | 수정 후 | 영향 |
|------|--------|--------|------|
| S8: assert! 제거 | `assert!(suffix.chars().all(...))` → panic | `if !suffix... { tracing::warn!; continue; }` | 프로덕션 서버 crash 방지 |

**Flutter (Dart):**

| 작업 | 수정 내용 | 영향 |
|------|-----------|------|
| F2: 테마 일관성 | 하드코딩 `Colors.red` → `AppColors.error` | 다크모드 전환 시 올바른 색상 표시 |
| F4: const 최적화 | 5곳 const 생성자 | 위젯 트리 리빌드 시 불필요한 재생성 방지 |
| F5: 라우팅 가드 | `productId:0` → early return + `addPostFrameCallback` | 잘못된 상품 ID 접근 시 홈으로 안전하게 리다이렉트 |
| F6: trailing slash | 3 엔드포인트 + 3 테스트 동기화 | Axum 서버 404 방지 (trailing slash redirect 미지원) |
| F7: 날짜 표시 | `_formatDate` UTC→로컬 변환 | 포인트 내역에서 거래 시점 확인 가능 |
| F8: 다크모드 shimmer | 밝기 기반 조건부 색상 | 다크모드에서 스켈레톤 로딩 가시성 확보 |

---

## 4. 브랜치 현황

### 4.1 활성 브랜치 상태 (2026-03-15)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260315_0100`** ★ | **+3 commits + unstaged** | Night-13~15 전체 (순수함수+silent failure+잔여이슈) | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색 필터, CD | **높음** | PR 미생성 |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** (중복) | origin에 push됨 |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |
| `auto/night-01-20260310_0100` | +5 commits | OpenAPI + M-5/M-7 + reward 수정 | **높음** | 로컬만 |
| `auto/night-01-20260311_0100` | +2 commits | Monthly API + Referral (중복) | **중간** | 로컬만 |
| `fix/phase1-critical-high` | — | Phase 1 수정 | **불명** | 확인 필요 |
| `fix/phase3-quality-security` | — | Phase 3 품질/보안 | **불명** | PR #3 머지 완료? |

### 4.2 삭제 안전한 auto 브랜치 (10개)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303_0100` | main에 PR #1으로 머지됨 |
| `auto/night-01-20260304_0100` | main에 PR #1으로 머지됨 |
| `auto/night-01-20260305_0100` | main과 동일 |
| `auto/night-01-20260306_0100` | main에 PR #1으로 머지됨 |
| `auto/night-01-20260307_0100` | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 auth 코드 재구현됨 |
| `auto/night-01-20260309_0100` | Night-10에 포함된 변경 |
| `auto/night-01-20260312_0100` | Night-14(0313)에 완전 포함됨 |
| `auto/night-01-20260313_0100` | Night-14(0314)에 완전 포함됨 |
| `auto/night-01-20260314_0100` | Night-15(0315)에 완전 포함됨 |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260315_0100 → main (현재, 충돌 없음) → 커밋 후 즉시 PR
2. feat/dark-mode (1커밋, 독립)
3. auto/night-01-20260310_0100 (OpenAPI)
4. fix/phase0-security-stability (보안, migration 019-020)
5. feat/phase2-monthly-prices 또는 auto/0311 중 **택일** (MonthlyPriceItem 7필드 vs 2필드)
```

### 4.4 중복 작업 매트릭스

| 기능 | `feat/phase2-monthly-prices` | `auto/...0311` (Night-12) | `fix/phase0-security-stability` |
|------|-------|-------|-------|
| Monthly prices API | ✅ | ✅ | — |
| MonthlyPriceChart | ✅ | ✅ | — |
| ReferralScreen | — | ✅ | ✅ |
| Referrals API | — | — | ✅ |
| FK CASCADE(020) | — | — | ✅ |
| 검색 필터 UI | — | — | ✅ |
| CD 파이프라인 | — | — | ✅ |

---

## 5. PLAN_01.md Phase 진행 상황 (Night-15 최종)

### 5.1 전체 Phase 진행 현황

| Phase | 상태 | Night | 결과 |
|-------|------|-------|------|
| 0 | ✅ 완료 | 14 | 오탐 필터링 + 우선순위 매트릭스 |
| 1 | ✅ 완료 | 14 | Silent failure 10건 + 순수함수 15테스트 + 타입 개선 |
| 2 | ✅ 완료 | 14 | try/finally dispose + Riverpod 확인 + Semantics 3화면 |
| 3 | ✅ 완료 | 14 | cargo audit.toml + CI 확인 |
| §5.3 잔여 | ✅ 완료 | **15** | **8건 처리 (7완료 + 1보류)** |
| 4 | ⏳ 대기 | — | 사용자 승인 후 (CodeRabbit/PR 분석) |
| 5 | 📋 계획만 | — | 별도 세션 |

### 5.2 잔여 이슈 최종 상태 (Night-15)

**서버 (Rust):**

| # | 등급 | 작업 | 상태 |
|---|------|------|------|
| S2 | CRITICAL | rotate_refresh_token 순수 함수 추출 | ❌ 영구 스킵 (DB 의존) |
| S6 | HIGH | process_referral_purchase 순수 함수 추출 | ✅ 부분 완료 (`compute_referral_rewards` 추출) |
| S8 | MEDIUM | assert! → if/continue 복구 패턴 | ✅ **Night-15 완료** |
| S9 | MEDIUM | build_runner ^4.0.0 | ⚠️ **보류 (4.x 미존재)** |

**Flutter (Dart):**

| # | 등급 | 작업 | 상태 |
|---|------|------|------|
| F2 | HIGH | Colors.red → AppColors.error (3곳) | ✅ **Night-15 완료** |
| F4 | MEDIUM | const 생성자 추가 (5곳) | ✅ **Night-15 완료** |
| F5 | MEDIUM | router productId:0 → early return | ✅ **Night-15 완료** |
| F6 | MEDIUM | trailing slash 일관성 정리 (6곳) | ✅ **Night-15 완료** |
| F7 | MEDIUM | PointHistoryScreen 날짜 표시 | ✅ **Night-15 완료** |
| F8 | MEDIUM | LoadingSkeleton 다크모드 색상 | ✅ **Night-15 완료** |

> PLAN_01 §5.3 잔여 이슈: **10건 중 8건 완료, 1건 보류(S9), 1건 영구 스킵(S2)**

### 5.3 GATE 4 대기 중 (Phase 4 — 사용자 승인 필요)

| 항목 | 설명 | 도구 |
|------|------|------|
| 4-A | CodeRabbit AI 코드 리뷰 | `coderabbit:code-reviewer` |
| 4-B | PR 테스트 커버리지 분석 | `pr-review-toolkit:pr-test-analyzer` |
| 4-C | Comment 품질 분석 | `pr-review-toolkit:comment-analyzer` |
| 4-D | 최종 검증 + 커밋/PR 생성 | `superpowers:verification-before-completion` |

---

## 6. 사용자 확인 필요 항목

### CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-17** | **Night-15 커밋 방향** | 15파일 +511줄 unstaged — Night-14 커밋에 합치거나 별도 커밋 생성? | A) Night-14 브랜치에 별도 커밋 추가 B) Night-14 커밋과 squash C) 유지(unstaged) D) 폐기 |
| **U-3** | Night-13~15 머지 방향 | `auto/night-01-20260315_0100` (전체 ~30파일, ~1,900줄) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **U-13** | Phase 4 실행 승인 | CodeRabbit 리뷰 + PR 테스트 분석 + 커밋/PR 생성 진행? | A) 승인 B) 항목 조정 C) 스킵 |
| **U-1** | 중복 구현 채택 | Monthly prices API + ReferralScreen이 여러 브랜치에서 이중 구현 | A) `feat/phase2-monthly-prices` B) Night-12 C) cherry-pick |
| **U-2** | 미머지 브랜치 통합 순서 | 5개 미머지 브랜치 + auto 브랜치 충돌 해결 순서 | A) §4.3 권장 순서 B) 사용자 지정 C) 전부 폐기+재작업 |

### HIGH (금일 중 결정 권장)

| # | 항목 | 설명 | 상태 |
|---|------|------|------|
| **U-5** | auto 브랜치 정리 | **10개** 삭제 안전 (§4.2 참조) | 삭제 권장 |
| **U-6** | 통합 테스트 실행 | Night-15도 `cargo test --lib`만 실행 (통합 41건 스킵) | 환경 제약 |
| **U-7** | OpenAPI (Night-10) 채택 | `auto/...0310`의 utoipa 5.x + Swagger UI 변경 | PLAN_01에 미포함 → 결정 대기 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) | 다음 세션 실행 또는 영구 보류 |
| **U-15** | PLAN_01 Phase 5 진행 | §5.3 잔여 이슈 거의 소진 → Phase 5(브랜치 통합) 진행 여부 | PLAN_01 갱신 필요 |

### MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-9** | CD 파이프라인 활성화 | `fix/phase0-security-stability`의 `cd.yml` (staging 자동 + production 수동) |
| **U-10** | dependabot 검증 | PR #3에서 추가된 `dependabot.yml` — cargo/pub/github-actions weekly 동작 확인 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 토큰 만료 (401) |
| **U-12** | MEDIUM 잔여 결함 | M-1(access_log 배치 INSERT), M-8(신규유저 확률 근거 문서화) |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |

---

## 7. 프로젝트 대시보드

### 7.1 현재 지표 (2026-03-15)

| 지표 | 값 | Night-14 | Night-06 | Night-15 변화 |
|------|-----|----------|----------|--------------|
| Rust 테스트 (lib) | **191** | 191 | 175 | 유지 |
| Flutter 테스트 | **164** | 164 | 122 | 유지 |
| DB 마이그레이션 (main) | 018 | 018 | 014 | 유지 |
| Prometheus 메트릭 | 22 | 22 | 22 | 유지 |
| DECISION_LOG | **D-35** | D-33 | D-18 | **+2** (D-34~D-35) |
| 미머지 브랜치 | 5 | 5 | 1 | 유지 |
| auto 브랜치 | **15** | 12 | — | **+3** |
| PR 머지 | 3 | 3 | 1 | 유지 |
| 순수 함수 추출 | 9개/42테스트 | 9개/42테스트 | 2개/4테스트 | 유지 |
| Silent Failure 수정 | 10건 | 10건 | — | 유지 |
| Flutter 접근성 화면 | 5개 | 5개 | 0 | 유지 |
| 잔여 이슈 (서버+Flutter) | **1건** | 10건 | — | **-9** (Night-15) |
| 커밋 (main 대비) | 3 + unstaged | 3 | — | **+unstaged** |

### 7.2 기술 부채 현황

| 항목 | 상태 | Night-15 변화 |
|------|------|---------------|
| PLAN_01 §5.3 잔여 이슈 | **거의 해결** ✅ | 10건 → 1건 보류 |
| Silent Failure | **해결됨** ✅ | 유지 |
| Flutter 접근성 | **개선됨** ✅ | 유지 |
| Flutter 테마 일관성 | **개선됨** ✅ | Colors.red → AppColors.error 완료 |
| Flutter 다크모드 준비 | **개선됨** ✅ | LoadingSkeleton 조건부 색상 |
| 서버 안정성 | **개선됨** ✅ | assert! → if/continue (crash 방지) |
| 라우팅 안전성 | **개선됨** ✅ | productId early return guard |
| API 엔드포인트 일관성 | **해결됨** ✅ | trailing slash 정리 완료 |
| 미머지 브랜치 통합 | **적체** ⚠️ | 5개 유지 — U-1~U-3 결정 대기 |
| auto 브랜치 정리 | **미처리** ⚠️ | 15개 (10개 삭제 가능) |
| 통합 테스트 검증 | **미실행** ⚠️ | Night-15도 --lib만 |
| E2E 테스트 | 미구축 | Phase 6 예정 |
| 크롤러 프로덕션 검증 | 미완 | 쿠팡 파트너스 API 미연동 |
| M0 사전 준비 | 미착수 | 카카오/Google/Apple 개발자 등록 미완 |
| HF_TOKEN 만료 | **지속** 🔴 | OAuth 401 — 갱신 필요 |

---

## 8. 권장 다음 행동

### 즉시 (오늘)
1. **U-17 Night-15 커밋**: unstaged 15파일 → 커밋 생성 여부 결정
2. **U-3 머지 방향**: Night-13~15 결과물 main 반영 여부 (충돌 없음)
3. **U-13 Phase 4 승인**: CodeRabbit 리뷰 + PR 생성 진행 여부
4. **U-5 auto 브랜치 정리**: 10개 삭제 (§4.2)

### 이번 주
5. **U-1~U-2 브랜치 통합 결정**: 중복 구현 채택 + 머지 순서 확정
6. **U-6 전체 테스트 실행**: `cargo test` (통합 포함) 확인
7. **U-11 HF_TOKEN 갱신**: https://hf.co/settings/mcp/
8. **U-14 보류 결정 3건**: D-32, D-33, D-35

### 다음 주
9. **Phase 5/6 방향 결정** (U-8)
10. **M0 사전 준비 시작**: 쿠팡파트너스 API 키 신청 (2~4주 리드타임)

---

> **생성**: 2026-03-15 Morning Briefing — Night-01~15 종합 분석 (Night-15 잔여 이슈 소진 반영)
> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

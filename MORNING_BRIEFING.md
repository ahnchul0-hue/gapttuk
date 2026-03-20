# MORNING BRIEFING — 2026-03-20 (Night-13 ~ Night-20 종합 분석)

> **분석 대상**: Night-13 ~ Night-20 (2026-03-12 ~ 2026-03-20)
> **현재 브랜치**: `auto/night-01-20260320_0100` (main + 15 commits, clean)
> **생성**: Opus 4.6 종합 분석
> **이전 브리핑**: 2026-03-19 (Night-19 기준)
> **신규 변경**: Night-20 PriceTrend CRITICAL 버그수정 + Phase 2-C 코드간결화 (14건, -66줄)

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-20 세션별 전략

| Night | 날짜 | 전략 | 핵심 결정 | 커밋 |
|-------|------|------|-----------|------|
| 13 | 03-12 | PLAN_01.md 도입 + 테스트 보강 | D-25~D-26: 야간 세션 자율 범위 제한, 순수 함수 추출 | `0d04c09` |
| 14 | 03-13~14 | 종합 최적화 Phase 0~3 | D-27~D-33: Silent failure 10건 + 순수함수 15건 + 접근성 3화면 | `8cfa413`, `c7dcb1d` |
| 15 | 03-15 | 잔여 이슈 소진 | D-34~D-35: trailing slash 정리, build_runner 보류 | `5b9f5b9` |
| 16 | 03-16 | 심층 분석 + 로깅 보강 | D-36~D-40: MCP 스킵, 서버+Flutter 균형, E2E 이연 | `b57981d` |
| 17 | 03-17 | 타입 안전성 + 관측성 | D-41~D-42: chars().count(), referral_welcome_referrer 버그 수정 | `d8e76a7` |
| 18 | 03-18 | 타입 안전성 심화 + 에러 로깅 | 테스트 +2, saturating_mul, clamp, cursor 로깅 | `39dca08` |
| 19 | 03-19 | API 계약 정합 + 순수함수 DRY | serde rename_all, validate 추출, 테스트 +10, mounted 가드 | `966ca32` |
| **20** | **03-20** | **CRITICAL 버그수정 + Phase 2-C 실행** | **PriceTrend serde 누락, showErrorSnackBar 통합, parse_cursor DRY** | **`bb55aac`** |

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
Night 19:    수확 체감 확정 ── API 계약 보정 + 순수함수 DRY, 신규 DECISION 0건 4연속
Night 20:    기습 CRITICAL ── PriceTrend 직렬화 버그 + Phase 2-C 4회 미착수 해소
```

### 1.3 Opus 4.6의 핵심 전략 패턴

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 → Night-14에서 Phase 4 앞에서 정지 (효과 검증 완료)
2. **오탐 필터링**: 서브에이전트 3~4대가 30+건 발견 → Opus가 ~40% 필터링 → 13~18건 실행 확정 (Night-16~20 일관)
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트 (0ms 실행)
4. **PRE-GATE 결정 패턴**: Night-16에서 5건(D-36~D-40) 선결정 요청 → 이후 세션에서 동일 결정 재활용
5. **타입 안전성 계층화** (Night-17~20): `as` 캐스트 → `try_from`/`saturating_mul`/`.clamp()` + 정수 연산으로 산술 오버플로/부동소수점 오차 제거
6. **수확 체감 재평가** (Night-20): Night-19에서 서버 HIGH 0건 → 고갈 판정했으나, Night-20에서 **CRITICAL 1건 발견** — 완전한 E2E 테스트 없이는 JSON 직렬화 불일치 같은 통합 버그는 단위 테스트로 잡기 어려움

### 1.4 Night-20 전략 특이점: "수확 체감" 판정 번복

Night-19에서 "서버 HIGH 이상 고갈"로 Phase 4 전환을 권고했으나, Night-20에서 **CRITICAL 1건**(PriceTrend serde rename_all 누락)이 새로 발견됨.

**근본 원인**: Night-19에서 `AlertType`/`NotificationType`에 `serde(rename_all)` 추가 시, 동일 패턴의 `PriceTrend` enum을 누락. 이는 **파급 누락(cascade omission)** — 한 enum 수정이 유사 enum으로 전파되지 않는 패턴.

**교훈**:
- 수확 체감 판정은 "같은 분석 프레임워크로 같은 코드를 분석한 결과"에 기반하므로, 이전 세션의 변경이 만든 **새로운 결함**은 탐지하지 못함
- Night-20의 CRITICAL은 Night-19 변경의 부산물
- `#[sqlx]`와 `#[serde]`가 독립적으로 동작하는 Rust derive 특성상, 하나의 enum에 적용한 속성이 동류 enum에 자동 전파되지 않음

### 1.5 의사결정 일관성

- **총 42개 결정** (D-1 ~ D-42) — Night-17 이후 **4세션 연속 신규 의사결정 0건** (기존 프레임워크 재활용)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 1건 (D-39: E2E 테스트)
- **나머지 35건: IMPLEMENTED 유지**

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~20 서브에이전트 운용 비교

| Night | 에이전트 수 | 서버 발견 | Flutter 발견 | 오탐 필터링 후 | 실행 건수 |
|-------|------------|----------|-------------|--------------|----------|
| 16 | 4대 | CRIT-2+HIGH-6+MED-5 | CRIT-3+HIGH-8+MED-3 | **13건** | 서버7+Flutter6 |
| 17 | 3대 | HIGH-3+MED-6+LOW-4 | HIGH-4+MED-6+LOW-2 | **16건** | 서버7+Flutter9 |
| 18 | 3대 | CRIT-1+HIGH-6+MED-5+LOW-3 | HIGH-8+MED-5+LOW-2 | **18건** | 서버7+Flutter9+테스트2 |
| 19 | 3대 | MED-5+LOW-5 | MED-6+LOW-9 | **14건** | 서버7+Flutter7+테스트10 |
| **20** | **3대** | **HIGH-4+MED-7+LOW-6** | **MED-6+LOW-10** | **14건** | **서버7+Flutter7** |

**Night-20 서브에이전트 상세:**

| 에이전트 | 역할 | 발견 |
|----------|------|------|
| `feature-dev:code-explorer` #1 | 서버 코드 분석 | HIGH-4 + MED-7 + LOW-6 |
| `feature-dev:code-explorer` #2 | Flutter 코드 분석 | MED-6 + LOW-10 |
| `feature-dev:code-architect` | 아키텍처/API/코드간결화 | **CRITICAL-1** + HIGH-3 + MED-5 |

**주목**: Night-19에서 서버 HIGH 0건이었으나 Night-20에서 HIGH-4 + CRITICAL-1 부활. CRITICAL은 Night-19 변경이 만든 파급 누락.

### 2.3 MCP/플러그인 활용 현황 (Night-16~20 통합)

**활성 전투력:**

| 카테고리 | 도구 | 활용 |
|----------|------|------|
| 코드 탐색 | `feature-dev:code-explorer` (누적 16대) | Phase 1 심층 분석 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Phase 1 에러 패턴 탐색 |
| 아키텍처 | `feature-dev:code-architect` (5회) | API 계약 + 코드 간결화 분석 |
| 검증 | `superpowers:verification-before-completion` | 최종 4단계 검증 |
| 외부 참조 | WebSearch + WebFetch | MCP 대체 (D-36:C 결정) |

**미활용 (Phase 4 대기):**

| 도구 | 용도 | 보류 이유 |
|------|------|-----------|
| `coderabbit:code-reviewer` | AI 코드 리뷰 | Phase 4 사용자 승인 대기 |
| `pr-review-toolkit:pr-test-analyzer` | 테스트 커버리지 | PR 생성 시 |
| `pr-review-toolkit:comment-analyzer` | 주석 검증 | PR 생성 시 |

**MCP 서버 상태:**

| MCP | 상태 | 비고 |
|-----|------|------|
| context7, sequential-thinking | ❌ `pullcents`에만 등록 | D-36:C — 스킵, WebSearch 대체 |
| playwright | ⚠️ 플러그인만 활성 | D-39:B — E2E 다음 세션 이연 |
| serena | ❌ 글로벌 등록, 세션 미기동 | 향후 활성화 가능 |
| shadcn, mcp-tailwind-gemini | ❌ Flutter 비해당 | React/Tailwind 전용 → 영구 스킵 |
| Hugging Face | ⚠️ OAuth 만료 | `HF_TOKEN` 갱신 필요 |
| Sonatype Guide | ⚠️ 인증 만료 | `cargo audit`로 대체 완료 |

### 2.4 기술 실행 품질

**Night-20 최종 검증:**

| 항목 | 결과 |
|------|------|
| `cargo test --lib` | **203/203 passed** (변화 없음) |
| `cargo clippy -- -D warnings` | 0 warnings |
| `cargo fmt --check` | No diff |
| `flutter analyze` | **0 issues** |
| `flutter test` | **164/164 passed** |

**Night-16~20 누적 강점:**
- 일관된 5단계 검증 루틴 (test → clippy → fmt → analyze → flutter test)
- **0건 테스트 회귀**: 8개 세션(Night-13~20)에서 기존 테스트 깨짐 0건
- `map_err(|_|)` → `tracing::warn!/debug!` 에러 정보 보존 패턴 완성
- `catch(_)` → `catch(e,st)` + debugPrint 관측성 패턴 코드베이스 전반 확산
- `as i64`/`as f64` → `try_from`/`saturating_mul`/`.clamp()` 산술 안전성 체계화
- `showErrorSnackBar` 헬퍼로 에러 표시 9개 화면 통합 (Night-20)

**지속적 약점:**
- `cargo test --lib`만 실행 — 통합 테스트 41건 스킵 (환경 제약 지속)
- Phase 4(CodeRabbit 리뷰 + PR) 미진입 — 사용자 승인 대기
- Night-20 세션 종료 시 **529 Overloaded 에러** 발생 (API 부하)

---

## 3. 코드 생성 결과

### 3.1 테스트 성장 추이

| 시점 | Rust (lib) | Flutter | 총계 (lib) |
|------|-----------|---------|-----------|
| Night-01 시작 | 147 | — | 147 |
| STEP 50 (보상) | 164 | 115 | 279 |
| Night-07 (STEP 53) | 197 | 164 | 361 |
| Night-13 | 176 | 164 | 340 |
| Night-14 최종 | 191 | 164 | 355 |
| Night-15~17 | 191 | 164 | 355 |
| Night-18 | 193 | 164 | 357 |
| Night-19 | 203 | 164 | 367 |
| **Night-20 최종** | **203** | **164** | **367** |

> Night-20: 코드 간결화 중심 — 테스트 수 변화 없음 (기능 변경 없이 리팩토링).
> 통합(41) + doc(4) 포함 시 추정 ~412건.

### 3.2 코드베이스 규모

| 항목 | Night-19 | **Night-20** | 변화 |
|------|----------|-------------|------|
| DB 마이그레이션 (main) | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | — |
| DECISION_LOG 항목 | D-42 | D-42 | — |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | 23건+ | 23건+ | — |
| Flutter 접근성 화면 | 7개 | 7개 | — |
| Flutter catch(e,st) 적용 | 27건 | **28건** | **+1** |
| 타입 안전 캐스트 수정 | 14건 | **19건** | **+5** |
| showErrorSnackBar 통합 | 0개 | **11개소** | **+11 (신규)** |
| PR 머지 | 3 | 3 | — |
| auto 브랜치 | 19 | **20** | **+1** |
| main 대비 커밋 | 13 | **15** | **+2** |
| main 대비 파일 변경 | 49 | **53** | **+4** |
| main 대비 줄 변경 | +2,996/-381 | **+3,126/-463** | **+130/-82** |

### 3.3 Night-20 변경 상세

**브랜치: `auto/night-01-20260320_0100` — main + 15 commits, clean (53 files, +3,126/-463)**

#### Night-20 커밋 (`bb55aac`) — 서버 7건 + Flutter 7건 = 14건, **순 -66줄**

**서버 API 정합성 + 타입 안전성 + DRY (7건):**

| 파일 | 수정 | 핵심 |
|------|------|------|
| `models/product.rs` | `PriceTrend`에 `#[serde(rename_all = "snake_case")]` | **CRITICAL** — 가격 트렌드 UI 무동작 수정 |
| `models/user.rs` | `Platform`에 `#[serde(rename_all = "snake_case")]` | API 계약 정합 |
| `api/pagination.rs` | `parse_cursor` 헬퍼 추출 + 라우터 3곳 적용 | DRY — -18줄 |
| `services/alert_service.rs` | `i32::MAX as f64 as i32` → `i32::try_from()` | 안전 변환 |
| `services/ai_prediction_service.rs` | `i16 as i32` → `i32::from()` | 명시적 widening |
| `crawlers/mod.rs` | `usize as u64` 3곳 → `u64::try_from()` | 안전 변환 |
| `lib.rs` | `as_millis() as u64` → `u64::try_from()` | u128→u64 안전 |

**Flutter Phase 2-C 코드간결화 + 버그수정 (7건):**

| 파일 | 수정 | 핵심 |
|------|------|------|
| 9개 화면 11개소 | `showErrorSnackBar` 헬퍼 통합 | 3줄→1줄 기계적 치환, **-34줄** |
| `alert_screen.dart` | switch 표현식 변환 | -8줄 |
| `search_screen.dart` | DioException+catch 두 블록 통합 | -7줄 |
| `api_client.dart` | `catch(e)` → `catch(e, st)` | stacktrace 보존 |
| `reward_service.dart` | `PointHistoryItem.createdAt` String→DateTime | 타입 안전성 |
| `point_history_screen.dart` | `_formatDate` static + DateTime 직접 수신 | -7줄 |

### 3.4 Night-13~20 세션별 변경 요약

| Night | 커밋 | 수정 건수 | 핵심 변경 |
|-------|------|----------|-----------|
| 13 | `0d04c09` | 17건 | auth_service 순수 함수 추출 + 단위 테스트 17건 |
| 14 | `8cfa413`, `c7dcb1d` | 25건 | Silent failure 10건 + 순수함수 15테스트 + 접근성 3화면 |
| 15 | `5b9f5b9` | 8건 | Colors.red→AppColors.error, assert→if, trailing slash 등 |
| 16 | `b57981d` | 13건 | Silent failure 로깅 보강 (map_err→warn, catch(_)→catch(e,st)) |
| 17 | `d8e76a7` | 16건 | 타입 안전 캐스트 8건 + Flutter catch(e,st) 6건 + 버그 1건 |
| 18 | `39dca08` | 18건 | 타입 안전성 5건 + 에러 로깅 3건 + Flutter catch(e,st) 13건 + 테스트 2건 |
| 19 | `966ca32` | 14건 | API 계약 정합 2건 + 순수함수 DRY 2건 + 관측성 5건 + 테스트 10건 |
| **20** | **`bb55aac`** | **14건** | **CRITICAL PriceTrend + showErrorSnackBar 11개소 + parse_cursor DRY + 캐스트 5건** |

### 3.5 순수 함수 추출 현황 (전체, Night-20 변화 없음)

| 서비스 | 함수 | 테스트 | 추출 시점 |
|--------|------|--------|-----------|
| reward_service | `assign_monthly_cap` | 2 | Night-06 |
| reward_service | `spin_roulette` | 2 | Night-06 |
| device_service | `validate_device_token` | 6 | Night-01 |
| auth_service | `validate_consent` | 5 | Night-13 |
| auth_service | `is_valid_referral_code_format` | 12 | Night-13 |
| notification_service | `build_deep_link` | 6 (+1 Night-18) | Night-14 |
| product_service | `build_search_pattern` | 6 | Night-14 |
| reward_service | `compute_referral_rewards` | 4 | Night-14 |
| alert_service | `format_price` | 1 | Night-18 |
| alert_service | `validate_target_price` | 5 | Night-19 |
| alert_service | `validate_keyword` | 5 | Night-19 |

**총 11개 함수, 54 테스트 — DB 의존 없이 ~0ms 실행**

---

## 4. 브랜치 현황

### 4.1 활성 브랜치 (2026-03-20)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260320_0100`** ★ | **+15 commits, clean** | Night-13~20 전체 | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin에 push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin에 push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |
| `auto/night-01-20260310_0100` | +5 commits | OpenAPI + M-5/M-7 | **높음** | 로컬만 |
| `auto/night-01-20260311_0100` | +2 commits | Monthly + Referral (중복) | **중간** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (15개)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 auth 코드 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312_0100` | Night-14에 완전 포함 |
| `auto/night-01-20260313_0100` | Night-14에 완전 포함 |
| `auto/night-01-20260314_0100` | Night-15에 완전 포함 |
| `auto/night-01-20260315_0100` | Night-16에 완전 포함 |
| `auto/night-01-20260316_0100` | Night-17에 완전 포함 |
| `auto/night-01-20260317_0100` | Night-18에 완전 포함 |
| `auto/night-01-20260318_0100` | Night-19에 완전 포함 |
| **`auto/night-01-20260319_0100`** | **Night-20에 완전 포함 (신규)** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260320_0100 → main (현재, 충돌 없음, 15커밋) → 즉시 PR 가능
2. feat/dark-mode (1커밋, 독립, 충돌 낮음)
3. auto/night-01-20260310_0100 (OpenAPI, 충돌 가능)
4. fix/phase0-security-stability (보안+CD, migration 019-020, 충돌 높음)
5. feat/phase2-monthly-prices 또는 auto/0311 중 택일 (MonthlyPriceItem 중복)
```

### 4.4 중복 작업 매트릭스

| 기능 | `feat/phase2-monthly-prices` | `auto/...0311` | `fix/phase0-security-stability` |
|------|------|------|------|
| Monthly prices API | O | O | — |
| MonthlyPriceChart | O | O | — |
| ReferralScreen | — | O | O |
| FK CASCADE(020) | — | — | O |
| 검색 필터 UI | — | — | O |
| CD 파이프라인 | — | — | O |

---

## 5. PLAN_01.md Phase 진행 상황 (Night-20 최종)

| Phase | 상태 | Night | 결과 |
|-------|------|-------|------|
| 0 | ✅ 완료 | 14 | 오탐 필터링 + 우선순위 매트릭스 |
| 1 | ✅ 완료 | 14 | Silent failure 10건 + 순수함수 15테스트 + 타입 개선 |
| 2 | ✅ 완료 | 14 | try/finally dispose + Riverpod 확인 + Semantics 3화면 |
| 3 | ✅ 완료 | 14 | cargo audit.toml + CI 확인 |
| §5.3 잔여 | ✅ 완료 | 15 | 8건 처리 (7완료 + 1보류) |
| Night-16 Phase 0~3 | ✅ 완료 | 16 | Silent failure 13건 로깅 보강 |
| Night-17 Phase 0~3 | ✅ 완료 | 17 | 타입 안전성 7건 + Flutter 9건 |
| Night-18 Phase 0~3 | ✅ 완료 | 18 | 타입 안전성 5건 + 에러 로깅 3건 + Flutter 9건 + 테스트 2건 |
| Night-19 Phase 0~3 | ✅ 완료 | 19 | API 계약 2건 + 순수함수 DRY 2건 + 관측성 5건 + 테스트 10건 |
| **Night-20 Phase 0~3** | **✅ 완료** | **20** | **CRITICAL 1건 + 코드간결화 11개소 + DRY 3개소 + 캐스트 5건** |
| 4 (CodeRabbit/PR) | ⏳ 대기 | — | **사용자 승인 필요** |
| 5 (브랜치 통합) | 📋 계획만 | — | 별도 세션 |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~20 머지 방향 | `auto/night-01-20260320_0100` (53파일, +3,126줄, **15커밋**, PriceTrend CRITICAL 포함) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **U-13** | Phase 4 실행 승인 | CodeRabbit 리뷰 + PR 테스트 분석 + 커밋/PR 생성 | A) 승인 B) 항목 조정 C) 스킵 |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 | A) `feat/phase2` B) Night-12 C) cherry-pick |
| **U-2** | 미머지 브랜치 통합 순서 | 5개 미머지 브랜치 충돌 해결 | A) §4.3 권장 순서 B) 사용자 지정 C) 전부 폐기+재작업 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-25** | **PriceTrend serde 변경 확인** | `PriceTrend`이 이제 `"falling"`(snake_case)으로 직렬화됨 — Flutter는 이미 `'falling'`을 기대하므로 호환, 외부 소비자 확인 필요 |
| **U-23** | serde rename_all 영향 (Night-19+20 누적) | `NotificationType`/`AlertType`/`PriceTrend`/`Platform` 4개 enum JSON 직렬화 형식 변경 |
| **U-5** | auto 브랜치 정리 | **15개** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | Night-20도 `cargo test --lib`만 (통합 41건 스킵) — **PriceTrend류 통합 버그 재발 방지 핵심** |
| **U-7** | OpenAPI 채택 | `auto/...0310`의 utoipa 5.x + Swagger UI |
| **U-18** | CRIT-2: upsert_user referral_code TOCTOU | retry 루프 설계 필요 — 아키텍처 결정 |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-26** | Night-20 스킵 항목 6건 | count_all_user_alerts TOCTOU, refresh_product_stats 중복, AdvisoryLockGuard, 로그아웃 다이얼로그, ErrorStateView 추출 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-9** | CD 파이프라인 활성화 | `fix/phase0-security-stability`의 cd.yml |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |

---

## 7. Night-20에서 스킵된 항목 (사용자 결정 대기)

| 항목 | 등급 | 설명 | 보류 이유 |
|------|------|------|-----------|
| CRIT-2 | CRITICAL | `upsert_user` referral_code TOCTOU 경쟁 조건 | DB retry 루프 설계 필요 — 아키텍처 결정 |
| `count_all_user_alerts` TOCTOU | HIGH | 50개 알림 한도 검사 경쟁 조건 | DB 트랜잭션 잠금 설계 필요 |
| `refresh_product_stats` 중복 | MEDIUM | 구현 중복 제거 | 통합 테스트 환경 없이 위험 |
| `AdvisoryLockGuard` block_in_place | MEDIUM | 런타임 문제 가능성 | 테스트 환경에만 영향 |
| 로그아웃 다이얼로그 중복 | MEDIUM | my_page + settings 두 곳 동일 | 새 위젯 파일 생성 필요 |
| ErrorStateView 추출 | MEDIUM | 3개 화면 에러 UI 통합 | 새 파일 생성 + 3개 화면 변경 |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-03-20)

| 지표 | **Night-20** | Night-19 | Night-18 | Night-17 | Night-16 | 변화 (vs 19) |
|------|------------|----------|----------|----------|----------|-------------|
| Rust 테스트 (lib) | **203** | 203 | 193 | 191 | 191 | — |
| Flutter 테스트 | **164** | 164 | 164 | 164 | 164 | — |
| DECISION_LOG | D-42 | D-42 | D-42 | D-42 | D-40 | — |
| Silent Failure 수정 누계 | **23건+** | 23건+ | 23건+ | 23건+ | 23건 | — |
| catch(e,st) 적용 | **28건** | 27건 | 24건 | 11건 | 5건 | **+1** |
| 타입 안전 캐스트 수정 | **19건** | 14건 | 13건 | 8건 | — | **+5** |
| showErrorSnackBar 통합 | **11개소** | — | — | — | — | **+11 (신규)** |
| 순수 함수 추출 | 11개/54테스트 | 11개/54테스트 | 9개/44테스트 | — | — | — |
| 커밋 (main 대비) | **15** | 13 | 10 | 7 | 5 | **+2** |
| 코드 순감소 (Night-20) | **-66줄** | — | — | — | — | 간결화 효과 |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **완료** ✅ (23건 수정 + 에러 관측성 전면 보강) |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **해결됨** ✅ |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (Night-17~20: 19건 적용, 잔존 최소) |
| Flutter 에러 관측성 | **완료** ✅ (catch(e,st) 28건 — 코드베이스 전반 확산) |
| API 계약 정합성 | **완료** ✅ (serde rename_all 4개 enum — Night-19+20) |
| 순수 함수 / DRY | **개선됨** ✅ (11개 함수, 54테스트 + parse_cursor DRY) |
| Flutter 에러 표시 일관성 | **완료** ✅ (showErrorSnackBar 11개소 통합 — Night-20) |
| TOCTOU 경쟁 조건 | **미해결** ⚠️ (CRIT-2 + count_all_user_alerts) |
| 미머지 브랜치 통합 | **적체** ⚠️ (5개) |
| auto 브랜치 정리 | **미처리** ⚠️ (15개 삭제 가능) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (D-39:B 이연) |

### 8.3 Night-13→20 누적 성과 요약

```
+44 테스트 (Night-13 auth 17 + Night-14 서비스 15 + Night-18 +2 + Night-19 +10)
+23 silent failure 수정
+3  사용자 대면 버그 수정 (D-42 라벨 누락 + 센트 에러 표시 + PriceTrend CRITICAL)
+19 타입 안전 캐스트 변환
+28 Flutter catch(e,st) 관측성 보강
+11 showErrorSnackBar 에러 표시 통합
+7  접근성 적용 화면
+11 순수 함수 추출 (54 테스트)
+7  의사결정 (D-36~D-42)
 53 파일, +3,126줄, -463줄 (main 대비)
-66줄 순감소 (Night-20 코드 간결화)
```

### 8.4 수확 체감 분석 (Night-20 업데이트)

Night-16~20에서 동일한 Phase 0→3 파이프라인을 5회 반복한 결과:

| 지표 | Night-16 | Night-17 | Night-18 | Night-19 | **Night-20** | 추세 |
|------|----------|----------|----------|----------|-------------|------|
| 서브에이전트 | 4대 | 3대 | 3대 | 3대 | **3대** | 안정 |
| 실행 확정 건수 | 13건 | 16건 | 18건 | 14건 | **14건** | 안정~감소 |
| 신규 테스트 | 0 | 0 | +2 | +10 | **0** | 불규칙 |
| 신규 DECISION | 5건 | 2건 | 0건 | 0건 | **0건** | **0 고착 (5연속)** |
| 변경 줄 수 | +114/-53 | ~+150/-80 | +126/-70 | +123/-48 | **+64/-130** | **순감소 전환** |
| 서버 최고 등급 | CRIT-2 | HIGH-3 | CRIT-1 | HIGH-0 | **CRIT-1** | 불규칙 (파급 누락) |

**결론 (Night-20 수정)**:
- Night-19의 "서버 HIGH 완전 고갈" 판정은 **번복됨**. 이전 세션의 변경이 새로운 CRITICAL을 생성할 수 있음
- 그러나 Night-20의 순 -66줄은 이 파이프라인이 **간결화 모드**에 진입했음을 시사
- **Phase 4(종합 리뷰 + PR)** 전환 권고는 유지. Night-16~20의 5회 반복으로 Phase 0~3에서 추출 가능한 가치가 대부분 소진됨
- 다만 **E2E 통합 테스트 없이는 PriceTrend류 CRITICAL이 재발할 수 있음** — U-6 통합 테스트 실행이 더욱 중요

---

## 9. 권장 다음 행동

### 즉시 (오늘)
1. **U-3**: Night-13~20 결과물 main 반영 여부 결정 (충돌 없음, 15커밋 clean, **PriceTrend CRITICAL 포함**)
2. **U-25/U-23**: serde rename_all 영향 확인 — 4개 enum 직렬화 형식 변경 (Flutter는 호환, 외부 소비자?)
3. **U-13**: Phase 4 CodeRabbit 리뷰 + PR 생성 승인 여부
4. **U-5**: auto 브랜치 15개 정리

### 이번 주
5. **U-6**: `cargo test` 전체 실행 (통합 테스트 포함) — **PriceTrend류 통합 버그 재발 방지 핵심**
6. **U-1~U-2**: 중복 구현 채택 + 미머지 브랜치 통합 순서 확정
7. **U-18**: CRIT-2 referral_code TOCTOU + count_all_user_alerts TOCTOU 해결 방향

### 다음 주
8. **U-8**: Phase 5/6 로드맵 방향 결정 (새 기능 vs 인프라)
9. M0 사전 준비: 쿠팡파트너스 API 키 신청 (2~4주 리드타임)
10. **U-11**: HF_TOKEN 갱신 (https://hf.co/settings/mcp/)

---

> **생성**: 2026-03-20 Morning Briefing — Night-13~20 종합 분석
> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

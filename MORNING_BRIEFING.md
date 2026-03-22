# MORNING BRIEFING — 2026-03-23 (Night-13 ~ Night-23 종합 분석)

> **분석 대상**: Night-13 ~ Night-23 (2026-03-12 ~ 2026-03-23)
> **현재 브랜치**: `auto/night-01-20260323_0100` (main + 21 commits)
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **이전 브리핑**: 2026-03-22 (Night-22 기준)
> **신규 변경 (Night-23)**: Silent Failure 관측성 강화 + cargo audit 7건 발견 + Flutter 테스트 +18건

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-22 세션별 전략

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
| **23** | **03-23** | **Silent Failure 관측성 + 테스트 확대** | **D-44~46: rollback warn 5곳, C-1 count/verify 명시적 rollback, Flutter +18건** | **`d95e438`** |

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
Night 21:    구조적 패턴 확인 ── 3회 연속 serde 파급 누락 → 자동화 필요성 증명
Night 22:    ★ 전환점 ──────── 자동화(CI serde 검증) + TOCTOU 해결 + 테스트 대폭 증가
Night 23:    관측성 심화 ────── Silent Failure rollback warn + cargo audit 발견 + Flutter 테스트 198건 돌파
```

### 1.3 Opus 4.6의 핵심 전략 패턴

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 → Night-14에서 Phase 4 앞에서 정지 (효과 검증 완료)
2. **오탐 필터링**: 서브에이전트 3~4대가 30+건 발견 → Opus가 ~40% 필터링 → 13~18건 실행 확정 (Night-16~22 일관)
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트 (0ms 실행)
4. **PRE-GATE 결정 패턴**: Night-16에서 5건(D-36~D-40) 선결정 요청 → 이후 세션에서 동일 결정 재활용
5. **타입 안전성 계층화** (Night-17~21): `as` 캐스트 → `try_from`/`saturating_mul`/`.clamp()` + 정수 연산으로 산술 오버플로/부동소수점 오차 제거
6. **serde 파급 누락 → CI 자동화** (Night-19→20→21→22): 3회 수동 반복 실패 후 Night-22에서 `check_serde_enums.py` CI step 도입으로 **구조적 종결**

### 1.4 Night-22 전략 특이점: "반복 파이프라인에서 구조적 해결로 전환"

**Night-22의 핵심 전략 전환:**

Night-16~21은 동일한 Phase 0→3 파이프라인을 6회 반복하며 **14건/세션** 수렴에 도달. Night-22는 이 패턴을 깨고:

1. **PLAN_01.md 전면 개편**: 기존 누적 기록 정리 + MCP/플러그인 가용성 매핑 + 5 Phase 실행 계획 수립
2. **Phase 0 Silent Failure 전수 조사**: `pr-review-toolkit:silent-failure-hunter` 활용 → 51개 .rs 파일 스캔 → HIGH 3건 + MEDIUM 3건 발견
3. **Phase 1 CRITICAL 해결**: Night-21까지 "사용자 결정 대기"로 보류된 TOCTOU 2건을 즉시 수정
4. **Phase 2 Flutter 테스트 대폭 증가**: +16건 (164→180) — 7개 세션 동안 Flutter 테스트 0건이었던 정체 해소
5. **CI 자동화 도입**: `check_serde_enums.py` + ci.yml step — serde 파급 누락 3회 반복의 근본 원인 해결

**MCP/플러그인 활용 현황 (Night-22 확인):**
- **sonatype-guide**: 인증 자격증명 미설정 → API 호출 불가 (Phase 3-A 건너뜀)
- **silent-failure-hunter**: 51개 파일 전수 스캔 성공 → HIGH 3건 식별
- context7, playwright, serena, coderabbit: 확인됨 (Phase 4 대기)
- mcp-tailwind-gemini, shadcn: Flutter 프로젝트 해당 없음 (영구 스킵)

### 1.5 의사결정 일관성

- **총 43개 결정** (D-1 ~ D-43) — Night-17~21 **6세션 연속 신규 의사결정 0건** 후 Night-22에서 **D-43 신규**
- D-43: alert TOCTOU에 `SELECT FOR UPDATE` on users row 선택 (Advisory lock 대비 낮은 오버헤드)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 1건 (D-39: E2E 테스트)
- **나머지 36건: IMPLEMENTED 유지**

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~22 서브에이전트 운용 비교

| Night | 에이전트 수 | 서버 발견 | Flutter 발견 | 오탐 필터링 후 | 실행 건수 |
|-------|------------|----------|-------------|--------------|----------|
| 16 | 4대 | CRIT-2+HIGH-6+MED-5 | CRIT-3+HIGH-8+MED-3 | **13건** | 서버7+Flutter6 |
| 17 | 3대 | HIGH-3+MED-6+LOW-4 | HIGH-4+MED-6+LOW-2 | **16건** | 서버7+Flutter9 |
| 18 | 3대 | CRIT-1+HIGH-6+MED-5+LOW-3 | HIGH-8+MED-5+LOW-2 | **18건** | 서버7+Flutter9+테스트2 |
| 19 | 3대 | MED-5+LOW-5 | MED-6+LOW-9 | **14건** | 서버7+Flutter7+테스트10 |
| 20 | 3대 | HIGH-4+MED-7+LOW-6 | MED-6+LOW-10 | **14건** | 서버7+Flutter7 |
| 21 | 3대 | CRIT-2+HIGH-5+MED-6+LOW-4 | CRIT-2+HIGH-5+MED-6+LOW-3 | **14건** | 서버7+Flutter7 |
| **22** | **silent-failure-hunter 1대** | **HIGH-3+MED-3** | **(Flutter 테스트 작성으로 전환)** | **— (전수 조사)** | **서버3+Flutter4+CI1** |

**Night-22 주목**: 기존 3대 병렬 서브에이전트 패턴 대신, **silent-failure-hunter 단독 전수 조사** + **PLAN_01.md 기반 Phase별 직접 실행**으로 전환. 반복적 발견→필터링→실행 루프에서 벗어나 **구조적 해결(TOCTOU, CI 자동화)에 집중**.

### 2.3 MCP/플러그인 활용 현황 (Night-22 업데이트)

**활성 전투력:**

| 카테고리 | 도구 | Night-22 활용 |
|----------|------|------|
| 코드 탐색 | `feature-dev:code-explorer` (누적 19대) | Phase 1 심층 분석 (Night-22에서 직접 실행으로 대체) |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | **Night-22: 51파일 전수 조사** → HIGH 3건 식별 |
| 아키텍처 | `feature-dev:code-architect` (6회) | API 계약 + 코드 간결화 분석 |
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
| **Sonatype Guide** | **⚠️ 인증 미설정** | **Night-22에서 API 호출 실패 확인** |

### 2.4 기술 실행 품질

**Night-22 Silent Failure 전수 조사 결과 (51개 .rs 파일):**

| 등급 | 위치 | 패턴 | 문제 |
|------|------|------|------|
| **HIGH** | `auth_service.rs:230` | `let _ = tx.rollback()` | 토큰 탈취 감지 후 롤백 실패 → 로그 없음 |
| **HIGH** | `main.rs:275,301,328` | `let _ = tx.rollback()` (3건) | 아카이빙 트랜잭션 롤백 실패 3곳 무시 |
| **HIGH** | `alert_service.rs:557` | `.unwrap_or_default()` | 디바이스 없는 사용자 push silent skip |
| MEDIUM | `main.rs:197` | `.ok()` | 파티션 날짜 파싱 실패 원인 미기록 |
| MEDIUM | `access_log.rs:86` | `.ok()` | 만료/조작 JWT가 user_id=None으로만 기록 |
| MEDIUM | `coupang.rs:226` | `.ok()` | 가격 파싱 실패 무음 |

**`.unwrap()` 프로덕션 코드: 0건** ✅ — 타입 안전성 작업의 누적 효과.

**Night-22 검증 상태 (unstaged — 커밋 전 최종 검증 필요):**

| 항목 | 결과 |
|------|------|
| `cargo check` | ✅ |
| `cargo test --lib` | ✅ 207/207 passed |
| `cargo clippy -D warnings` | ✅ 0 warnings |
| `check_serde_enums.py` | ✅ 0건 |
| `flutter analyze` | ✅ 0 issues |
| `flutter test` | ✅ **180/180 passed** (+16 vs Night-21) |

**Night-16~22 누적 강점:**
- 일관된 5단계 검증 루틴 (test → clippy → fmt → analyze → flutter test)
- **0건 테스트 회귀**: 10개 세션(Night-13~22)에서 기존 테스트 깨짐 0건
- `map_err(|_|)` → `tracing::warn!/debug!` 에러 정보 보존 패턴 완성
- `catch(_)` → `catch(e,st)` + debugPrint 관측성 패턴 코드베이스 전반 확산
- `as i64`/`as f64` → `try_from`/`saturating_mul`/`.clamp()` 산술 안전성 체계화
- serde rename_all 7개 enum + 14건 직렬화 테스트 + **CI 자동 전수 검사**
- **Night-22: TOCTOU 2건 해결** (referral_code retry + alert SELECT FOR UPDATE)

**지속적 약점:**
- `cargo test --lib`만 실행 — 통합 테스트 41건 스킵 (환경 제약 지속)
- Phase 4(CodeRabbit 리뷰 + PR) 미진입 — 사용자 승인 대기
- Silent Failure HIGH 3건 발견 → **Night-22에서 미수정** (다음 세션 우선 수정 권고)

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
| Night-20~21 | 207 | 164 | 371 |
| **Night-22 최종** | **207** | **180** | **387** |

> Night-22: Flutter 테스트 +16건 (HomeScreen 7 + SearchScreen 4 + Provider 5). 7개 세션 정체 해소.
> 통합(43) + doc(4) 포함 시 추정 ~434건.

### 3.2 코드베이스 규모

| 항목 | Night-21 | **Night-22** | 변화 |
|------|----------|-------------|------|
| DB 마이그레이션 (main) | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | — |
| DECISION_LOG 항목 | D-42 | **D-43** | **+1** |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | 23건+ | 23건+ | — (HIGH 3건 미수정 잔존) |
| Flutter 접근성 화면 | 7개 | 7개 | — |
| Flutter catch(e,st) 적용 | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | 20건 | 20건 | — |
| showErrorSnackBar 통합 | 11개소 | 11개소 | — |
| serde rename_all 적용 enum | 7개 | 7개 | — |
| serde 직렬화 단위 테스트 | 14건 | 14건 | — |
| **TOCTOU 해결** | **0건** | **2건** | **+2 (신규)** |
| **serde CI 자동검증** | **미구축** | **구축 완료** | **신규** |
| **Flutter 테스트** | **164건** | **180건** | **+16** |
| **공통 위젯 추출** | **—** | **alertTypeBadge** | **+1** |
| PR 머지 | 3 | 3 | — |
| auto 브랜치 | 21 | **22** | **+1** |
| main 대비 커밋 | 18 | **19** (unstaged 포함 시) | **+1** |
| main 대비 파일 변경 | 55 | **60+** (신규 5파일 포함) | **+5** |

### 3.3 Night-22 변경 상세

**브랜치: `auto/night-01-20260322_0100` — main + 19 commits + unstaged 8파일**

#### Night-22 (unstaged) — Phase 1~2, 8파일 + 신규 5파일

**Phase 1: 서버(Rust) CRITICAL/HIGH 수정 (3건):**

| 파일 | 수정 | 핵심 |
|------|------|------|
| `auth_service.rs` | referral_code TOCTOU: DB UNIQUE 충돌 시 최대 3회 retry loop + `is_referral_code_collision()` 헬퍼 | **CRITICAL** 해결 — 동시 가입 시 중복 코드 방지 |
| `alert_service.rs` | `create_price/category/keyword_alert` 3함수: `SELECT FOR UPDATE` + 트랜잭션화, `count_all_user_alerts_in_tx()` 분리 | **CRITICAL** 해결 — 50개 한도 동시 초과 방지 |
| `ci.yml` + `check_serde_enums.py` | Serialize enum에 rename_all 누락 시 CI 실패 | **구조적** — 3회 파급 누락 재발 방지 |

**Phase 2: Flutter 품질 확대 (4건):**

| 파일 | 수정 | 핵심 |
|------|------|------|
| `test/screens/home_screen_test.dart` (신규 99줄) | 7건 (AppBar/검색바/URL카드/인기검색어/데이터/에러/다이얼로그) | 앱 첫 진입점 테스트 |
| `test/screens/search_screen_test.dart` (신규 54줄) | 4건 (AppBar/TextField/초기상태/입력) | 검색 화면 기본 동작 |
| `test/providers/product_provider_test.dart` (신규 113줄) | 5건 (productDetail/dailyPrices/popularSearches) | **첫 Provider 테스트** |
| `widgets/alert_type_badge.dart` (신규 55줄) | `alertTypeLabel()`, `alertTypeColor()`, `AlertTypeBadge` 위젯 추출 | `favorites_screen` + `alert_screen` 중복 제거 (-37줄) |

### 3.4 Night-13~22 세션별 변경 요약

| Night | 커밋 | 수정 건수 | 핵심 변경 |
|-------|------|----------|-----------|
| 13 | `0d04c09` | 17건 | auth_service 순수 함수 추출 + 단위 테스트 17건 |
| 14 | `8cfa413`, `c7dcb1d` | 25건 | Silent failure 10건 + 순수함수 15테스트 + 접근성 3화면 |
| 15 | `5b9f5b9` | 8건 | Colors.red→AppColors.error, assert→if, trailing slash 등 |
| 16 | `b57981d` | 13건 | Silent failure 로깅 보강 (map_err→warn, catch(_)→catch(e,st)) |
| 17 | `d8e76a7` | 16건 | 타입 안전 캐스트 8건 + Flutter catch(e,st) 6건 + 버그 1건 |
| 18 | `39dca08` | 18건 | 타입 안전성 5건 + 에러 로깅 3건 + Flutter catch(e,st) 13건 + 테스트 2건 |
| 19 | `966ca32` | 14건 | API 계약 정합 2건 + 순수함수 DRY 2건 + 관측성 5건 + 테스트 10건 |
| 20 | `bb55aac` | 14건 | CRITICAL PriceTrend + showErrorSnackBar 11개소 + parse_cursor DRY + 캐스트 5건 |
| 21 | `63780bb` | 14건 | serde 3회차(PredictedAction/SearchTrend/AuthProvider) + confidence 방어 파싱 + switch 현대화 |
| **22** | **(unstaged)** | **~8건** | **TOCTOU 2건 + serde CI + Flutter 테스트 +16 + alertTypeBadge 추출** |

### 3.5 순수 함수 추출 현황 (전체, Night-22 변화 없음)

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

### 3.6 serde rename_all 적용 현황 (Night-22 최종 — CI 자동 검증 추가)

| enum | 직렬화 형식 | 적용 시점 | 테스트 |
|------|------------|-----------|--------|
| `AlertType` | snake_case | Night-19 | — |
| `NotificationType` | snake_case | Night-19 | — |
| `PriceTrend` | snake_case | Night-20 | — |
| `Platform` | snake_case | Night-20 | — |
| `PredictedAction` | snake_case | Night-21 | 3건 |
| `SearchTrend` | snake_case | Night-21 | 4건 |
| `AuthProvider` | snake_case | Night-21 | 4건 + Platform 3건 |

> **Night-22 완결**: `check_serde_enums.py` CI step이 모든 Serialize enum을 자동 전수 검사 → 현재 0건 미적용. 4세션에 걸친 파급 누락 연쇄 **구조적 종결**.

---

## 4. 브랜치 현황

### 4.1 활성 브랜치 (2026-03-22)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260322_0100`** ★ | **+19 commits + unstaged** | Night-13~22 전체 | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin에 push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin에 push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |
| `auto/night-01-20260310_0100` | +5 commits | OpenAPI + M-5/M-7 | **높음** | 로컬만 |
| `auto/night-01-20260311_0100` | +2 commits | Monthly + Referral (중복) | **중간** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (17개)

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
| `auto/night-01-20260319_0100` | Night-20에 완전 포함 |
| `auto/night-01-20260320_0100` | Night-21에 완전 포함 |
| **`auto/night-01-20260321_0100`** | **Night-22에 완전 포함 (신규)** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260322_0100 → main (현재, 충돌 없음, 19+커밋) → 즉시 PR 가능
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

## 5. PLAN_01.md Phase 진행 상황 (Night-22 업데이트)

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
| Night-20 Phase 0~3 | ✅ 완료 | 20 | CRITICAL 1건 + 코드간결화 11개소 + DRY 3개소 + 캐스트 5건 |
| Night-21 Phase 0~3 | ✅ 완료 | 21 | serde 3회차 + confidence 파싱 + switch 현대화 + 테스트 14건 |
| **Night-22 Phase 0** | **✅ 완료** | **22** | **Silent Failure 전수 조사 51파일 → HIGH 3건 + MEDIUM 3건** |
| **Night-22 Phase 1** | **✅ 완료** | **22** | **TOCTOU 2건 해결 + serde CI 자동검증** |
| **Night-22 Phase 2** | **✅ 완료** | **22** | **Flutter 테스트 +16 + alertTypeBadge 추출** |
| **Night-22 Phase 3-B** | **✅ 완료** | **22** | **ci.yml에 serde 검증 step 통합** |
| Night-22 Phase 3-A | ⏭️ 건너뜀 | 22 | sonatype 인증 미설정 |
| 4 (CodeRabbit/PR) | ⏳ 대기 | — | **사용자 승인 필요** |
| 5 (브랜치 통합) | 📋 계획만 | — | 별도 세션 |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~22 머지 방향 | `auto/night-01-20260322_0100` (60+파일, TOCTOU 2건 해결 + serde CI + 테스트 +16 포함, **unstaged — 커밋 필요**) | A) 커밋 + main 로컬 머지 B) 커밋 + Push + PR C) 유지 D) 폐기 |
| **U-13** | Phase 4 실행 승인 | CodeRabbit 리뷰 + PR 테스트 분석 + 커밋/PR 생성 | A) 승인 B) 항목 조정 C) 스킵 |
| **U-30** | **Night-22 unstaged 변경 커밋** | 8파일 수정 + 5파일 신규 — TOCTOU 해결 + CI 자동화 + Flutter 테스트가 아직 커밋되지 않음 | A) 즉시 커밋 B) 추가 수정 후 커밋 C) 검토 후 결정 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-31** | **Silent Failure HIGH 3건 수정** | `let _ = tx.rollback()` 4곳 + push silent skip 1곳 — Night-22에서 발견, 미수정 |
| **U-28** | rust_decimal serde-with-str 전수 확인 | `confidence` 외 다른 Decimal 필드도 Flutter에서 String으로 전달될 수 있음 |
| **U-32** | **sonatype-guide 인증 설정** | Night-22에서 API 호출 실패 — 의존성 보안 스캔 불가. 인증 자격증명 필요 |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 5개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **17개** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | Night-22도 `cargo test --lib`만 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-9** | CD 파이프라인 활성화 | `fix/phase0-security-stability`의 cd.yml |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |

---

## 7. Night-22에서 해결된 항목 + 잔존 항목

### ✅ Night-22에서 해결됨

| 항목 | 등급 | Night-22 해결 방법 |
|------|------|-------------------|
| `upsert_user` referral_code TOCTOU | **CRITICAL** | DB UNIQUE 충돌 시 최대 3회 retry loop + `is_referral_code_collision()` |
| `count_all_user_alerts` TOCTOU | **CRITICAL** | `SELECT FOR UPDATE` on users row + 트랜잭션화 (D-43) |
| serde rename_all CI 자동 검증 | **HIGH** | `check_serde_enums.py` + ci.yml step |
| `_alertTypeBadge` 3파일 중복 | LOW | `widgets/alert_type_badge.dart`로 추출 |
| Flutter 테스트 정체 (164→180) | HIGH | HomeScreen 7 + SearchScreen 4 + Provider 5 = +16건 |

### ⏳ 잔존 항목 (다음 세션)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| Silent Failure HIGH 3건 (`let _ = tx.rollback()` 등) | HIGH | Night-22 전수 조사에서 발견, 미수정 |
| `SearchScreen` 필터/정렬 미연결 | MEDIUM | fix/phase0 브랜치와 충돌 위험 |
| `formatPrice` 레이어 이동 | LOW | 영향 범위 넓음 |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-03-22)

| 지표 | **Night-22** | Night-21 | Night-20 | Night-19 | Night-18 | 변화 (vs 21) |
|------|------------|----------|----------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** | 207 | 203 | 203 | 193 | — |
| Flutter 테스트 | **180** | 164 | 164 | 164 | 164 | **+16** |
| DECISION_LOG | **D-43** | D-42 | D-42 | D-42 | D-42 | **+1** |
| Silent Failure 수정 누계 | **23건+** | 23건+ | 23건+ | 23건+ | 23건+ | — |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | 27건 | 24건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 19건 | 14건 | 13건 | — |
| showErrorSnackBar 통합 | **11개소** | 11개소 | 11개소 | — | — | — |
| serde rename_all 적용 enum | **7개** | 7개 | 4개 | 2개 | — | — |
| serde 직렬화 테스트 | **14건** | 14건 | 0건 | 0건 | — | — |
| **serde CI 자동검증** | **✅** | ❌ | ❌ | ❌ | ❌ | **신규** |
| **TOCTOU 해결** | **2건** | 0건 | 0건 | 0건 | 0건 | **+2** |
| **공통 위젯 추출** | **1개** | 0개 | 0개 | 0개 | 0개 | **+1** |
| 순수 함수 추출 | 11개/54테스트 | 11개/54테스트 | 11개/54테스트 | 11개/54테스트 | 9개/44테스트 | — |
| 커밋 (main 대비) | **19+** | 18 | 15 | 13 | 10 | **+1+** |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **개선됨** ✅ (23건 수정 + 에러 관측성 전면 보강) — ⚠️ HIGH 3건 잔존 |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **해결됨** ✅ |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (Night-17~21: 20건 적용, 잔존 최소) |
| Flutter 에러 관측성 | **완료** ✅ (catch(e,st) 28건 — 코드베이스 전반 확산) |
| API 계약 정합성 | **완료** ✅ (serde rename_all **7개** enum + **14건** 직렬화 테스트) |
| **serde 파급 누락 방지** | **해결됨** ✅ (CI 자동 전수 검사 구축 — Night-22) |
| **TOCTOU 경쟁 조건** | **해결됨** ✅ (referral_code retry + alert SELECT FOR UPDATE — Night-22) |
| 순수 함수 / DRY | **개선됨** ✅ (11개 함수, 54테스트 + parse_cursor DRY + alertTypeBadge 추출) |
| Flutter 에러 표시 일관성 | **완료** ✅ (showErrorSnackBar 11개소 통합 — Night-20) |
| **Flutter 테스트 커버리지** | **개선됨** ✅ (180건 — Night-22에서 +16건, Provider 테스트 시작) |
| 미머지 브랜치 통합 | **적체** ⚠️ (5개) |
| auto 브랜치 정리 | **미처리** ⚠️ (17개 삭제 가능) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (D-39:B 이연) |

### 8.3 Night-13→22 누적 성과 요약

```
+64 테스트 (Night-13 auth 17 + Night-14 서비스 15 + Night-18 +2 + Night-19 +10 + Night-21 +4 + Night-22 Flutter +16)
+23 silent failure 수정
+5  사용자 대면 버그 수정 (D-42 라벨 누락 + 센트 에러 + PriceTrend CRITICAL + confidence 0% + 트렌드 아이콘)
+2  TOCTOU 경쟁 조건 해결 (Night-22: referral_code + alert 한도)
+20 타입 안전 캐스트 변환
+28 Flutter catch(e,st) 관측성 보강
+11 showErrorSnackBar 에러 표시 통합
+7  serde rename_all enum 적용 (3회 세션에 걸쳐) + CI 자동검증
+14 serde 직렬화 단위 테스트
+7  접근성 적용 화면
+11 순수 함수 추출 (54 테스트)
+1  공통 위젯 추출 (alertTypeBadge)
+8  의사결정 (D-36~D-43)
 60+ 파일, +3,500줄+ (main 대비)
```

### 8.4 수확 체감 분석 (Night-22 업데이트)

Night-16~22에서 Phase 0→3 파이프라인을 7회 반복한 결과:

| 지표 | Night-16 | Night-17 | Night-18 | Night-19 | Night-20 | Night-21 | **Night-22** | 추세 |
|------|----------|----------|----------|----------|----------|----------|-------------|------|
| 서브에이전트 | 4대 | 3대 | 3대 | 3대 | 3대 | 3대 | **1대 (전환)** | ★ 전환 |
| 실행 확정 건수 | 13건 | 16건 | 18건 | 14건 | 14건 | 14건 | **~8건** | 구조적 해결 우선 |
| 신규 테스트 | 0 | 0 | +2 | +10 | 0 | +4 | **+16** | **★ 돌파** |
| 신규 DECISION | 5건 | 2건 | 0건 | 0건 | 0건 | 0건 | **+1건** | 7연속 0 후 재개 |
| 서버 최고 등급 | CRIT-2 | HIGH-3 | CRIT-1 | HIGH-0 | CRIT-1 | CRIT-2 | **— (전수 조사)** | 패턴 변화 |

**결론 (Night-22 업데이트)**:
- **Night-22는 전환점**: 반복적 발견→필터링→실행 루프에서 **구조적 해결(자동화, 동시성 방어)로 전환**
- 14건/세션 수렴 → ~8건/세션이지만, 개별 건의 **영향력 대폭 상승** (TOCTOU CRITICAL 2건 해결)
- **Flutter 테스트 +16건**: 7개 세션(Night-15~21) 동안 164건 정체 → Night-22에서 180건으로 10% 증가
- **serde CI 자동검증**: 4세션에 걸친 파급 누락 연쇄를 구조적으로 종결
- **Phase 4(종합 리뷰 + PR) 전환 강력 권고** — 기술 부채 대부분 해결됨, 남은 것은 리뷰/머지

---

## 9. 권장 다음 행동

### 즉시 (오늘)
1. **U-30**: Night-22 unstaged 변경 커밋 — TOCTOU 해결 + CI 자동화 + Flutter 테스트가 아직 커밋되지 않음
2. **U-3**: Night-13~22 결과물 main 반영 여부 결정 (충돌 없음, 20커밋 clean)
3. **U-13**: Phase 4 CodeRabbit 리뷰 + PR 생성 승인 여부
4. **U-31**: Silent Failure HIGH 3건 수정 (`let _ = tx.rollback()` → `if let Err(e) = tx.rollback()`)

### 이번 주
5. **U-5**: auto 브랜치 17개 정리
6. **U-6**: `cargo test` 전체 실행 (통합 테스트 포함)
7. **U-1~U-2**: 중복 구현 채택 + 미머지 브랜치 통합 순서 확정
8. **U-28**: rust_decimal serde-with-str 전수 영향 확인
9. **U-32**: sonatype-guide 인증 설정

### 다음 주
10. **U-8**: Phase 5/6 로드맵 방향 결정 (새 기능 vs 인프라)
11. M0 사전 준비: 쿠팡파트너스 API 키 신청 (2~4주 리드타임)
12. **U-11**: HF_TOKEN 갱신 (https://hf.co/settings/mcp/)

---

> **생성**: 2026-03-22 Morning Briefing — Night-13~22 종합 분석
> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>

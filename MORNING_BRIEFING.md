# MORNING BRIEFING — 2026-03-26 (Night-13 ~ Night-26 종합 분석)

> **분석 대상**: Night-13 ~ Night-26 (2026-03-12 ~ 2026-03-26)
> **현재 브랜치**: `auto/night-01-20260326_0100` (main + 30 commits)
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-03-26 (Night-26 최종, 검증 완료)
> **변경 규모**: 74파일, +3,888줄, -893줄
> **검증**: Rust 207건 ✅ / Flutter 248건 ✅ / analyze 0건 ✅ (2026-03-26 실측)

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-26 세션별 전략

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
| 25 | 03-25 | 위젯/프로바이더 단위 테스트 완성 | D-48: Riverpod 3.x auto-dispose 에러 테스트 패턴, 위젯 4/4 커버리지 | `7206ac1`, `d6364ac` |
| **26** | **03-26** | **AuthState 프로바이더 + SearchScreen 테스트 완성** | **D-49: keepAlive Notifier 테스트 시 PushService stub 필수** | **`b4b7cd0`** |

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
Night 23:    ★★ 완결 ────────── 발견→수정→검증 3단계 완결 + 의존성 감사 + 테스트 198건
Night 24:    ★★★ 안정화 종결 ── 취약점 0건 달성 + FakeService 패턴 3종 + 사용자 화면 216건
Night 25:    ★★★★ 테스트 완결 ── 미테스트 위젯 0개 + 프로바이더 family 검증 + 238건
Night 26:    ★★★★★ 상태 관리 테스트 ── AuthState Notifier 검증 + SearchScreen 확장 + 248건
```

### 1.3 Opus 4.6의 핵심 전략 패턴 (Night-26까지)

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 → Night-23에서 6 Phase 전체 순차 완수
2. **오탐 필터링**: 서브에이전트 발견 → Opus가 ~40% 필터링 → 13~18건 실행 확정 (Night-16~23 일관)
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트 (0ms 실행)
4. **serde 파급 누락 → CI 자동화** (Night-19→22): 3회 수동 반복 실패 후 Night-22에서 CI step 도입으로 **구조적 종결**
5. **Silent Failure 생명주기**: 전수 조사(Night-22) → 수정(Night-23) → 재검증 + C-1 추가 — **3단계 완결**
6. **FakeService 패턴 3종 완비** (Night-23→24): 플랫폼 채널 없이 전체 비즈니스 화면 테스트 가능
7. **audit.toml 전략** (Night-24): upstream 미업그레이드 간접 의존성은 `ignore` + 명시적 근거 주석
8. **위젯 단위 테스트 완결** (Night-25): 순수 함수 switch 전 분기 + ConsumerWidget ProviderScope override → **4/4 위젯 커버리지**

### 1.4 의사결정 일관성

- **총 48개 결정** (D-1 ~ D-48)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 1건 (D-39: E2E 테스트)
- **나머지 41건: IMPLEMENTED 유지**

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~25 서브에이전트 운용 비교

| Night | 에이전트 수 | 서버 발견 | Flutter 발견 | 오탐 필터링 후 | 실행 건수 |
|-------|------------|----------|-------------|--------------|----------|
| 16 | 4대 | CRIT-2+HIGH-6+MED-5 | CRIT-3+HIGH-8+MED-3 | **13건** | 서버7+Flutter6 |
| 17 | 3대 | HIGH-3+MED-6+LOW-4 | HIGH-4+MED-6+LOW-2 | **16건** | 서버7+Flutter9 |
| 18 | 3대 | CRIT-1+HIGH-6+MED-5+LOW-3 | HIGH-8+MED-5+LOW-2 | **18건** | 서버7+Flutter9+테스트2 |
| 19 | 3대 | MED-5+LOW-5 | MED-6+LOW-9 | **14건** | 서버7+Flutter7+테스트10 |
| 20 | 3대 | HIGH-4+MED-7+LOW-6 | MED-6+LOW-10 | **14건** | 서버7+Flutter7 |
| 21 | 3대 | CRIT-2+HIGH-5+MED-6+LOW-4 | CRIT-2+HIGH-5+MED-6+LOW-3 | **14건** | 서버7+Flutter7 |
| 22 | silent-failure-hunter 1대 | HIGH-3+MED-3 | (Flutter 테스트 전환) | — (전수 조사) | 서버3+Flutter4+CI1 |
| 23 | ~13대 (최대 4병렬) | Phase 1: audit 7건, Phase 2: warn 5곳+C-1 | Phase 3: +18건 테스트 | Phase 4: C-1+H-1+M-3 | 서버7+Flutter18+리뷰5 |
| 24 | ~3대 (순차) | Phase 1: cargo update+audit.toml | Phase 2: +18건 테스트 (3 FakeService) | — (수정 완결) | 서버2+Flutter18 |
| **25** | **직접 실행** | **— (프로덕션 코드 변경 없음)** | **Phase 1-2: +22건 테스트** | **—** | **Flutter22** |
| **26** | **직접 실행** | **— (프로덕션 코드 변경 없음)** | **Phase 1-2: +10건 테스트** | **—** | **Flutter10** |

### 2.3 MCP/플러그인 활용 현황

**활성 전투력:**

| 카테고리 | 도구 | 누적 활용 |
|----------|------|-----------|
| 코드 탐색 | `feature-dev:code-explorer` (누적 22대+) | Night-16~23 주력 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-22에서 완결 |
| 코드 리뷰 | `coderabbit:code-reviewer` | Night-23 종합 리뷰 |
| 의존성 | `cargo audit` + `cargo update` (Bash) | Night-24: 7건 → 0건 |
| 외부 참조 | WebSearch + WebFetch | MCP 대체 (D-36:C 결정) |

**MCP 서버 상태:**

| MCP | 상태 | 비고 |
|-----|------|------|
| context7 | ✅ 활성 (stdio) | `npx @upstash/context7-mcp` — 미활용 (라이브러리 문서 필요 시) |
| playwright | ✅ 설치 (stdio) | D-39:B — E2E 다음 세션 이연 |
| serena | ✅ 설치 (stdio) | 코드 심볼 분석 — 향후 활성화 가능 |
| shadcn, mcp-tailwind-gemini | ❌ Flutter 비해당 | React/Tailwind 전용 → 영구 스킵 |
| Hugging Face | ⚠️ OAuth 만료 | `HF_TOKEN` 갱신 필요 |
| **Sonatype Guide** | **⚠️ 인증 미설정** | **Night-22~26 5세션 연속 API 호출 실패** |

### 2.4 기술 실행 품질

**Night-16~25 누적 강점:**
- 일관된 5단계 검증 루틴 (test → clippy → fmt → analyze → flutter test)
- **0건 테스트 회귀**: 14개 세션(Night-13~26)에서 기존 테스트 깨짐 0건
- `map_err(|_|)` → `tracing::warn!/debug!` 에러 정보 보존 패턴 완성
- `catch(_)` → `catch(e,st)` + debugPrint 관측성 패턴 코드베이스 전반 확산
- `as i64`/`as f64` → `try_from`/`saturating_mul`/`.clamp()` 산술 안전성 체계화
- serde rename_all 7개 enum + 14건 직렬화 테스트 + CI 자동 전수 검사
- TOCTOU 2건 해결 (Night-22: referral_code retry + alert SELECT FOR UPDATE)
- Silent Failure 완결: Night-22 전수 조사(51파일) → Night-23 수정(5곳) + 재검증(C-1) = 생명주기 종결
- **cargo audit 0건**: Night-24에서 7건 취약점 완전 해결
- **위젯 테스트 4/4**: Night-25에서 AlertTypeBadge + PriceChart 추가 → 미테스트 위젯 0개

**지속적 약점:**
- `cargo test --lib`만 실행 — 통합 테스트 43건 스킵 (환경 제약 지속)
- `sonatype-guide` 인증 미설정 — 의존성 보안 점수 미확인 (**5세션 연속**)
- RUSTSEC-2026-0049: a2 upstream rustls 0.23 전환 대기 (audit.toml ignore 중)

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
| Night-22 최종 | 207 | 180 | 387 |
| Night-23 최종 | 207 | 198 | 405 |
| Night-24 최종 | 207 | 216 | 423 |
| Night-25 최종 | 207 | 238 | 445 |
| **Night-26 최종** | **207** | **248** | **455** |

> Night-25: Flutter 테스트 +22건 (AlertTypeBadge 13 + PriceChart 5 + Provider 4). 위젯 테스트 4/4 완전 커버리지.
> Night-26: Flutter 테스트 +10건 (AuthState provider 6 + SearchScreen 확장 4). keepAlive Notifier 테스트 패턴 완성.
> 통합(43) + doc(4) 포함 시 추정 ~502건.

### 3.2 코드베이스 규모

| 항목 | **Night-26** | Night-25 | Night-24 | 변화 (vs 25) |
|------|-------------|----------|----------|-------------|
| DB 마이그레이션 (main) | 018 | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-49** | D-48 | D-47 | **+1** |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | 28건+ (잔존 0건) | 28건+ | 28건+ | — |
| Flutter 접근성 화면 | 7개 | 7개 | 7개 | — |
| Flutter catch(e,st) 적용 | 28건 | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | 20건 | 20건 | 20건 | — |
| showErrorSnackBar 통합 | 11개소 | 11개소 | 11개소 | — |
| serde rename_all 적용 enum | 7개 | 7개 | 7개 | — |
| serde 직렬화 단위 테스트 | 14건 | 14건 | 14건 | — |
| serde CI 자동검증 | ✅ | ✅ | ✅ | — |
| TOCTOU 해결 | 2건 | 2건 | 2건 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 ✅ | 0건 ✅ | — |
| **Flutter 테스트** | **248건** | 238건 | 216건 | **+10** |
| **위젯 테스트 커버리지** | **4/4** ✅ | 4/4 ✅ | 2/4 | — |
| **AuthState 프로바이더 테스트** | **✅ (6건)** | ❌ | ❌ | **신규** |
| FakeService 패턴 | 3종 | 3종 | 3종 | — |
| 공통 헬퍼 | 4개 | 4개 | 4개 | — |
| PR 머지 | 3 | 3 | 3 | — |
| main 대비 커밋 | **30** | 28 | 25 | **+2** |
| main 대비 파일 변경 | **74파일, +3,888줄, -893줄** | 73파일 | 70+파일 | **+1파일** |

### 3.3 Night-26 변경 상세

**브랜치: `auto/night-01-20260326_0100` — main + 30 commits (2개 Night-26 신규)**

#### 커밋 `b4b7cd0` — Night-26 코드 변경

**Flutter 테스트 (1파일 신규, 1파일 확장):**

| 파일 | 건수 | 핵심 테스트 |
|------|------|-------------|
| `test/providers/auth_provider_test.dart` (신규) | 6건 | AuthState 초기null/login/logout/refresh성공/refreshDio에러/withdraw |
| `test/screens/search_screen_test.dart` (확장) | +4건 | 힌트텍스트/검색아이콘/로딩없음/ListView없음 |

**핵심 테스트 패턴 (Night-26 신규):**
- `keepAlive: true` Notifier(`AuthState`) → ProviderContainer + `pushServiceProvider` stub 필수
- `authServiceProvider.overrideWith` + `pushServiceProvider.overrideWith` 동시 override
- DioException 분기: `refresh()` 내부 `on DioException catch` → state = null 검증
- SearchScreen `buildScreen()` 헬퍼 AppTheme.light 통일 + 4가지 UI 검증 추가

### 3.4 Night-25 변경 상세 (이전)

**브랜치: `auto/night-01-20260325_0100` — main + 28 commits (3개 Night-25 신규)**

#### 커밋 `3cdd40c` — MORNING_BRIEFING.md Night-24 종합 분석 업데이트 (Phase 0)

#### 커밋 `7206ac1` — Night-25 코드 변경 (Phase 1~2)

**프로덕션 코드 변경: 없음** — 순수 테스트 추가만.

**Flutter 테스트 (2파일 신규, 1파일 확장):**

| 파일 | 건수 | 핵심 테스트 |
|------|------|-------------|
| `test/widgets/alert_type_badge_test.dart` (신규) | 13건 | alertTypeLabel(5) + alertTypeColor(5) + AlertTypeBadge위젯(3) |
| `test/widgets/price_chart_test.dart` (신규) | 5건 | 로딩/빈목록/avgPrice-null/에러/정상 |
| `test/providers/product_provider_test.dart` (확장) | +4건 | productPrediction(성공/빈Map/family독립) + popularSearches(랭크순서) |

#### 커밋 `d6364ac` — 문서 업데이트 (Phase 3)
NIGHT_06_RESULT.md + MORNING_BRIEFING.md Night-25 결과 기록.

**핵심 테스트 패턴 (Night-25 신규):**
- `alertTypeLabel`/`alertTypeColor` 순수 함수 switch expression 전 분기 검증 — `test()` 단순 단언
- `PriceChart` ConsumerWidget → `ProviderScope(overrides: [dailyPricesProvider(1).overrideWith(...)])` family override 패턴
- `Future(() async { throw ... })` — zone 전파 없는 에러 상태 테스트
- `MockPredictionService` + `buildContainerWithPrediction` 헬퍼
- family 프로바이더 독립성 검증: ID 10 vs 20 → 각각 1회 호출 확인

### 3.4 Night-13~25 세션별 변경 요약

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
| 22 | `f1ab244` | ~8건 | TOCTOU 2건 + serde CI + Flutter 테스트 +16 + alertTypeBadge 추출 |
| 23 | `d95e438` | ~12건 | Silent Failure 수정 5곳 + C-1 CRITICAL + Flutter 테스트 +18 + FakeAlertService |
| 24 | `025eaeb` | ~5건 | cargo 취약점 7→0 + audit.toml + FakeRewardService/NotificationService + Flutter +18 |
| **25** | **`7206ac1`** | **+22건 테스트** | **AlertTypeBadge 13 + PriceChart 5 + Provider 4 — 프로덕션 코드 변경 없음** |
| **26** | **`b4b7cd0`** | **+10건 테스트** | **AuthState Notifier 6건 + SearchScreen +4건 — 프로덕션 코드 변경 없음** |

### 3.5 FakeService 패턴 현황 (Night-24~25 안정)

| 헬퍼 | 인터페이스 | 모드 | 추출 시점 |
|------|-----------|------|-----------|
| `FakeAlertService` | `implements AlertService` | slow/error/response | Night-23 |
| `FakeRewardService` | `implements RewardService` | slow/error/response | Night-24 |
| `FakeNotificationService` | `implements NotificationService` | slow/error/response | Night-24 |

> 3종 FakeService로 플랫폼 채널 없이 MyPage, PointHistory, NotificationList, ProductDetail, Alert, Favorites, PriceChart 화면 모두 테스트 가능.

### 3.6 순수 함수 추출 현황 (전체, Night-25 변화 없음)

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

### 4.1 활성 브랜치 (2026-03-26)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260326_0100`** ★ | **+30 commits** | Night-13~26 전체 | **낮음** | 현재 HEAD, **커밋 완료** |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin에 push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin에 push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |
| `auto/night-01-20260310_0100` | +5 commits | OpenAPI + M-5/M-7 | **높음** | 로컬만 |
| `auto/night-01-20260311_0100` | +2 commits | Monthly + Referral (중복) | **중간** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (18개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 auth 코드 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0325_0100` (14개) | **Night-26 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260326_0100 → main (현재, 충돌 없음, 30커밋) → 즉시 PR 가능
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

## 5. PLAN_01.md Phase 진행 상황 (Night-25 최종)

| Phase | 상태 | Night | 결과 |
|-------|------|-------|------|
| 0 | ✅ 완료 | 14 | 오탐 필터링 + 우선순위 매트릭스 |
| 1 | ✅ 완료 | 14 | Silent failure 10건 + 순수함수 15테스트 + 타입 개선 |
| 2 | ✅ 완료 | 14 | try/finally dispose + Riverpod 확인 + Semantics 3화면 |
| 3 | ✅ 완료 | 14 | cargo audit.toml + CI 확인 |
| §5.3 잔여 | ✅ 완료 | 15 | 8건 처리 (7완료 + 1보류) |
| Night-16~21 | ✅ 완료 | 16~21 | 타입 안전성 + API 계약 + 관측성 |
| Night-22 | ✅ 완료 | 22 | Silent Failure 전수 + TOCTOU + Flutter +16 + serde CI |
| Night-23 | ✅ 완료 | 23 | Silent Failure 수정 + C-1 + 의존성 감사 + Flutter +18 |
| Night-24 | ✅ 완료 | 24 | cargo 7→0건 + FakeService 3종 + Flutter +18 |
| **Night-25** | **✅ 완료** | **25** | **위젯 4/4 + Provider family + Flutter +22 (238건)** |
| **Night-26** | **✅ 완료** | **26** | **AuthState Notifier 6건 + SearchScreen +4건 = 248건** |
| sonatype-guide | ⏭️ 건너뜀 | 22~26 | 인증 미설정 (5세션 연속) |
| PR 생성 + 머지 | ⏳ 대기 | — | **사용자 승인 필요** |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~26 머지 방향 | `auto/night-01-20260326_0100` (74파일, 30커밋, cargo audit 0건, Flutter 248건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-34** | go_router/flutter_riverpod/fl_chart 메이저 업그레이드 | breaking changes 포함 — 별도 세션 계획 필요 |
| **U-32** | sonatype-guide 인증 설정 | Night-22~26 **5세션 연속** API 호출 실패 — 의존성 보안 점수 미확인 |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 5개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **18개+** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | Night-25도 `cargo test --lib`만 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-9** | CD 파이프라인 활성화 | `fix/phase0-security-stability`의 cd.yml |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |

---

## 7. Night-26에서 해결된 항목 + 잔존 항목

### ✅ Night-26에서 해결됨

| 항목 | 등급 | Night-26 해결 방법 |
|------|------|-------------------|
| AuthState 프로바이더 테스트 0건 | MEDIUM | auth_provider_test.dart 신규 (6건 — 초기상태/login/logout/refresh성공/DioException/withdraw) |
| SearchScreen 테스트 부실 (4건) | LOW | +4건 추가 → 8건 (힌트텍스트/검색아이콘/로딩없음/ListView없음) |

### ⏳ 잔존 항목 (다음 세션)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| go_router/riverpod/fl_chart 메이저 업그레이드 | HIGH | breaking changes — 별도 계획 필요 |
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 — 사용자 설정 대기 (**5세션 연속**) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 (audit.toml ignore 중) |
| `SearchScreen` 필터/정렬 미연결 | MEDIUM | fix/phase0 브랜치와 충돌 위험 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 18개+ 정리 | LOW | 사용자 승인 대기 |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-03-26, 실측 검증 완료)

| 지표 | **Night-26** | Night-25 | Night-24 | Night-23 | 변화 (vs 25) |
|------|------------|----------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** ✅ | 207 | 207 | 207 | — |
| Flutter 테스트 | **248** ✅ | 238 | 216 | 198 | **+10** |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | 0건 | — |
| DECISION_LOG | **D-49** | D-48 | D-47 | D-46 | **+1** |
| Silent Failure 수정 누계 | **28건+** | 28건+ | 28건+ | 28건+ | — |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | 20건 | — |
| showErrorSnackBar 통합 | **11개소** | 11개소 | 11개소 | 11개소 | — |
| serde rename_all 적용 enum | **7개** | 7개 | 7개 | 7개 | — |
| serde 직렬화 테스트 | **14건** | 14건 | 14건 | 14건 | — |
| serde CI 자동검증 | **✅** | ✅ | ✅ | ✅ | — |
| TOCTOU 해결 | **2건** | 2건 | 2건 | 2건 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 ✅ | 0건 ✅ | 7건 | — |
| **위젯 테스트 커버리지** | **4/4** ✅ | 4/4 ✅ | 2/4 | 2/4 | — |
| **AuthState 프로바이더 테스트** | **✅ 6건** | ❌ | ❌ | ❌ | **신규** |
| FakeService 패턴 | **3종** | 3종 | 3종 | 1종 | — |
| 공통 헬퍼 | **4개** | 4개 | 4개 | 2개 | — |
| 순수 함수 추출 | 11개/54테스트 | 11개/54테스트 | 11개/54테스트 | 11개/54테스트 | — |
| 커밋 (main 대비) | **30** | 28 | 25 | 22 | **+2** |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **완결** ✅ (28건 수정, HIGH 0건 잔존) |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **해결됨** ✅ |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (Night-17~21: 20건) |
| Flutter 에러 관측성 | **완료** ✅ (catch(e,st) 28건) |
| API 계약 정합성 | **완료** ✅ (serde 7개 enum + 14건 테스트 + CI) |
| serde 파급 누락 방지 | **해결됨** ✅ (CI 자동 전수 검사) |
| TOCTOU 경쟁 조건 | **해결됨** ✅ (referral_code retry + alert SELECT FOR UPDATE) |
| 순수 함수 / DRY | **개선됨** ✅ (11개 함수, 54테스트 + 헬퍼 4개) |
| Flutter 에러 표시 일관성 | **완료** ✅ (showErrorSnackBar 11개소) |
| 의존성 보안 | **해결됨** ✅ (cargo audit 0건) |
| **Flutter 테스트 커버리지** | **Notifier 포함 완결** ✅ (248건 — 위젯 4/4 + AuthState 6건 + SearchScreen 8건 + FakeService 3종) |
| 미머지 브랜치 통합 | **적체** ⚠️ (5개) |
| auto 브랜치 정리 | **미처리** ⚠️ (18개+ 삭제 가능) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (D-39:B 이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (5세션 연속) |
| RUSTSEC-2026-0049 | **모니터링 필요** ⚠️ (audit.toml ignore 중) |

# MORNING BRIEFING — 2026-04-29 (Night-13 ~ Night-49 종합 분석)

> **분석 대상**: Night-13 ~ Night-49 (2026-03-12 ~ 2026-04-29)
> **현재 브랜치**: `auto/night-01-20260429_0100`
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-04-29 (Night-49 결과 통합 — **PLAN_01 Phase 11 아키텍처 분석 완료 + D-88~D-92 사용자 결정 대기**)
> **검증**: Rust 207건 ✅ / Flutter **360건** ✅ / analyze 0건 ✅ (2026-04-29 실측, Night-49 코드 변경 없음)
> **Night-37 커밋**: `044da3f` (Phase 7 간소화) + `a971acc` (문서) + `9b530f5` (NIGHT_06_RESULT)
> **Night-38 커밋**: `2dd797f` (MORNING_BRIEFING 종합) + `22a115e` (NIGHT_06_RESULT Night-38)
> **Night-39 커밋**: `aebf3d5` (MORNING_BRIEFING Night-38) + `8811c00` (D-63 해소 + NIGHT_06_RESULT Night-39)
> **Night-40 커밋**: `222f935` (MORNING_BRIEFING Night-39) + `26394e3` (PLAN_02 초안 + Night-40 결과) + `73ad4c5` (MORNING_BRIEFING Night-40 해시)
> **Night-41 커밋**: `e051bb5` (MORNING_BRIEFING Night-40 반영) + `d655baf` (U-39 분석 + D-81 + 베이스라인 재검증)
> **Night-42 커밋**: `ed1b2b8` (MORNING_BRIEFING Night-41 반영) + `579b0e8` (Night-42 결과)
> **Night-43 커밋**: `4f07c41` (MORNING_BRIEFING Night-42 반영 + Night-43 결과) + `c79dad5` (해시 갱신)
> **Night-44 커밋**: N/A (코드 변경 없음 — 종합 분석 세션)
> **Night-45 커밋**: `b1786bf` (MORNING_BRIEFING Night-44 반영 + Night-45 결과) + `0157f99` (해시 갱신)
> **Night-46 커밋**: TBD (Night-13~45 종합 분석 + MORNING_BRIEFING Night-46 반영)
> **Night-47 커밋**: `f605793` (Phase 9 의존성 분석 + MORNING_BRIEFING Night-47 반영) + `e84089b` (해시 갱신)
> **Night-48 커밋**: `f2319d5` (Phase 10 코드 품질 심층 리뷰 + MORNING_BRIEFING Night-48 반영) + `0315310` (해시 갱신)
> **Night-49 커밋**: `090dc8d` (Phase 11 아키텍처 분석 + MORNING_BRIEFING Night-49 반영)

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-41 세션별 전략

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
| 30 | 03-31 | PLAN_01.md 8-Phase 전략 수립 + 다이얼로그/접근성/다중알림 테스트 | D-56: Semantics properties.label 패턴 / D-57: 다중 family override | `63016a4` |
| **31** | **04-01** | **Phase 1 보안감사 + Phase 2/3 GAP 분석 + 테스트 +12건** | **D-58~D-60: default 간접검증, initState 에러, _formatTime 분기** | **`c8efba4`** |
| **32** | **04-02** | **Phase 6 테스트 커버리지 확대 +12건 (308→320건)** | **D-61~D-63: 탭Badge/Semantics label/transactionLabel 분기 완성** | **`1f36f3c`** |
| **33** | **04-03** | **Phase 6 테스트 커버리지 확대 +12건 (320→332건)** | **D-64~D-66: 출석완료/다이얼로그/formatTime전분기/탈퇴경고** | **`ecfd5e6`** |
| **34** | **04-04** | **Phase 6 테스트 커버리지 확대 +12건 (332→344건)** | **D-67~D-69: Home default분기/ProductDetail neutral/Onboarding완료페이지** | **`6f5c0b2`** |
| **35** | **04-05** | **PLAN_01 Phase 4: 코드 품질 심층 리뷰 + 5건 수정** | **D-70~D-75: 오탐필터, alert rollback 3곳, checkin rollback warn, TTL안전화, SearchQuery serde** | **`68bfd6e`** |
| **36** | **04-06** | **PLAN_01 Phase 5: PD-62 AlertType Enum 전환 + AppSpacing/TextStyles + 테스트 +14건** | **D-76~D-77: AlertType String→Enum(PD-62 해소), AppSpacing/AppTextStyles 테마 상수** | **`aab5540`** |
| **37** | **04-07** | **PLAN_01 Phase 7: 코드 간소화 + 의존성 3건 업그레이드** | **D-78~D-79: go_router 보류, minor 3건 적용(cupertino_icons/intl/build_runner)** | **`044da3f`** |
| **38** | **04-08** | **문서 완결 + PLAN_02 방향 제시** | **MORNING_BRIEFING 종합 업데이트, 기준선 재검증, PLAN_02 선택지(A~E) 질의** | **`22a115e`** |
| **39** | **04-09** | **D-63 완전 해소 + 잔존 항목 소진** | **D-80: _transactionLabel default 폴백 테스트, +2건 (360건)** | **`8811c00`** |
| **40** | **04-10** | **PLAN_02 초안 작성 + U-42 해소 준비** | **docs/plans/PLAN_02.md 생성 — A/B/C/D/E 5가지 방향 구체화, 브랜치 머지 전제 조건 명시** | **`222f935`, `26394e3`, `73ad4c5`** |
| **41** | **04-11** | **U-39 원인 규명 + 베이스라인 재검증** | **D-81: Vercel SessionEnd hook → node 미설치 원인 확인 + 3가지 수정 옵션 문서화** | **`e051bb5`, `d655baf`** |
| **42** | **04-12** | **PLAN_02 U-42 5세션 대기 + 베이스라인 재검증** | **코드 변경 0건 — PLAN_01 완전 완료 확인, PLAN_02 방향 결정 대기 지속** | **`ed1b2b8`, `579b0e8`** |
| **43** | **04-13** | **PLAN_02 U-42 6세션 대기 + 베이스라인 재검증** | **코드 변경 0건 — MORNING_BRIEFING Night-42 커밋 해시 반영, PLAN_02 방향 결정 대기 지속** | **`4f07c41`** |
| **44** | **04-13** | **종합 분석 + PLAN_02 U-42 7세션 대기** | **코드 변경 0건 — Night-13~44 종합 분석, MCP 도구 매트릭스 정밀 점검, 사용자 방향 결정 대기** | **N/A** |
| **45** | **04-14** | **PLAN_02 U-42 8세션 대기 + 베이스라인 재검증** | **코드 변경 0건 — MORNING_BRIEFING Night-44 커밋 해시 반영, PLAN_02 방향 결정 대기 지속** | **`b1786bf`, `0157f99`** |
| **46** | **04-14** | **Night-13~45 종합 분석 + PLAN_02 U-42 9세션 대기** | **코드 변경 0건 — Opus 전략/Sonnet 기술/코드 결과 종합 + MCP 가용성 재점검 + 사용자 확인 항목 정리** | **TBD** |
| **47** | **04-27** | **PLAN_01 Phase 9: 의존성 보안/품질 심층 분석 (U-42 해소 첫 실행)** | **코드 변경 0건 — Sonatype MCP 대체(WebSearch+pub outdated), Rust 11 crates + Dart 9 packages 분석, CVE 없음, BREAKING 업그레이드 3+8건 식별, D-82~D-84 결정 항목 도출** | **`f605793`, `e84089b`** |
| **48** | **04-28** | **PLAN_01 Phase 10: 코드 품질 심층 리뷰 (병렬 4대 에이전트)** | **코드 변경 0건 — 17건 발견 → 오탐 4건 제외 → 9건 확정 (HIGH 2 + MEDIUM 3 + LOW 4), D-85~D-87 결정 항목 도출** | **`f2319d5`** |

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
Night 31:    ★★★★★★★★★★ 체계적 실행 ── PLAN_01 Phase 1/2/3 완료 + 308건
Night 32:    ★★★★★★★★★★★ 분기 완성 ── Alert/Login/PointHistory 분기 전량 + 320건
Night 33:    ★★★★★★★★★★★★ 포화 도달 ── MyPage/Notification/Settings 다이얼로그+시간 전량 + 332건
Night 34:    ★★★★★★★★★★★★★ 포화 확정 ── Home/ProductDetail/Onboarding default+null분기 + 344건
Night 35:    ★★★★★★★★★★★★★★ Phase 4 완결 ── 병렬 3에이전트 37건→5건 수정 + 오탐 필터링
Night 36:    ★★★★★★★★★★★★★★★ Phase 5 진입 ── PD-62 AlertType Enum 전환 + 테마 상수 + 358건
Night 37:    ★★★★★★★★★★★★★★★★ Phase 7 완결 ── 코드 간소화 (Rust 4헬퍼 + Flutter ScreenErrorWidget) + 의존성 3건
Night 38:    ★★★★★★★★★★★★★★★★★ 문서 완결 ── PLAN_01 종합 문서화 + PLAN_02 방향 제시 (코드 변경 0건)
Night 39:    ★★★★★★★★★★★★★★★★★★ 잔존 소진 ── D-63 완전 해소 (360건) + PLAN_02 방향 대기 지속
Night 40:    ★★★★★★★★★★★★★★★★★★★ PLAN_02 초안 ── A~E 5방향 구체화 + 브랜치 머지 전제 명시 (코드 변경 0건)
Night 41:    ★★★★★★★★★★★★★★★★★★★★ 분석 심화 ── U-39 원인 규명(Vercel hook) + 베이스라인 재검증 + D-81 문서화
Night 42:    ★★★★★★★★★★★★★★★★★★★★★ 정체 세션 ── PLAN_02 U-42 5세션 대기, 코드 변경 0건, 베이스라인 재확인
Night 43:    ★★★★★★★★★★★★★★★★★★★★★★ 정체 지속 ── PLAN_02 U-42 6세션 대기, 코드 변경 0건, 해시 갱신+재검증
Night 44:    ★★★★★★★★★★★★★★★★★★★★★★★ 종합 분석 ── PLAN_02 U-42 7세션 대기, 종합 분석+MCP 도구 매트릭스, 코드 변경 0건
Night 45:    ★★★★★★★★★★★★★★★★★★★★★★★★ 정체 지속 ── PLAN_02 U-42 8세션 대기, 코드 변경 0건, 해시 갱신+재검증
Night 46:    ★★★★★★★★★★★★★★★★★★★★★★★★★ 종합 분석 ── PLAN_02 U-42 9세션 대기, Night-13~45 종합 분석+MCP 재점검, 코드 변경 0건
Night 47:    ★★★★★★★★★★★★★★★★★★★★★★★★★★ 재기동 ── U-42 해소, Phase 9 실행, Rust 11개+Dart 9개 의존성 분석, CVE 0건 ✅, BREAKING 업그레이드 식별
Night 48:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★ 품질 감사 ── Phase 10 병렬 4대 에이전트, 17건 발견 → 9건 확정 (HIGH 2 + MEDIUM 3 + LOW 4), D-85~D-87 도출
```

### 1.3 Night-48 전략적 의의: Phase 10 코드 품질 심층 리뷰 완료

Night-47 Phase 9 (의존성 분석) 완료 후, **Night-48은 PLAN_01 Phase 10 코드 품질 심층 리뷰를 병렬 4대 에이전트로 실행**.

**실행 전략:**
- 베이스라인 검증 (Flutter 360건 / Rust 207건 / analyze 0건) — 변동 없음 확인
- 병렬 4대 에이전트 동시 배치: silent-failure-hunter + type-design-analyzer + feature-dev:code-reviewer + coderabbit:code-reviewer
- Night-35 경험 기반 오탐 필터링: 17건 발견 → 오탐 4건 제외 → 9건 확정

**Night-48 핵심 성과:**
1. **Phase 10 완료**: 4대 에이전트 병렬 감사, 9건 확정 이슈 도출
2. **HIGH 2건 발견**: I-01 (rollback warn 패턴 불일치 2곳), I-02 (ALLOWED_ORIGINS 조용한 실패)
3. **신규 PD-67**: `Product.priceTrend` Dart `String?` → `PriceTrend` Enum 전환 필요 (AlertType PD-62 선례 존재)
4. **오탐 4건 필터링**: RadioGroup(Flutter 표준 위젯), new_balance(서버 정상 반환), TOCTOU(Night-22 완료), is_new 리터럴(의도적 설계)

**Night-48 결정 항목:**
- D-85: I-01+I-02 HIGH 수정 범위
- D-86: I-03+I-04+PD-67 MEDIUM 수정 범위
- D-87: LOW 4건 포함 여부

**다음 세션 최우선 항목:**
- D-85~D-87 (Phase 10 확인점): Phase 11 또는 Phase 13 진입 조건
- D-82~D-84 (Phase 9 업그레이드 범위): 지속 대기

### 1.3a Night-47 전략적 의의: U-42 해소 + Phase 9 의존성 심층 분석 실행

Night-46까지 **9세션 연속 코드 변경 0건**(Night-38~46) 정체 후, **사용자가 종합 실무 최적화를 지시**하여 U-42가 해소됨. Night-47은 **PLAN_01 Phase 9(의존성 보안/품질 심층 분석)** 을 실행한 재기동 세션.

**실행 전략:**
- Night-46까지의 MORNING_BRIEFING/PLAN_01 상태에서 시작
- PLAN_01.md에 Phase 9-14 확장 계획 작성 (6개 Phase, 도구 가용성 매트릭스 포함)
- Sonatype MCP 3개 API 시도 → **인증 실패 25세션째** → WebSearch+pub outdated+cargo metadata 조합으로 대체
- Rust 11개 crate + Dart 9개 package 보안/버전/BREAKING 분석 완료
- D-82~D-84 사용자 결정 항목 도출 → Phase 10 전환 조건 설정

**Night-47 핵심 성과:**
1. **U-42 해소**: 9세션 연속 대기 → 사용자 지시로 즉시 실행 재개. "단방향 결정 금지" 원칙의 올바른 해제 사례
2. **Phase 9 완료**: Rust CVE 0건 / Dart CVE 0건 — BREAKING 업그레이드 Rust 3건(reqwest 0.13/jwt 10/sentry 0.47) + Dart 8건(kakao 2.0 포함) 식별
3. **PLAN_01 Phase 9-14 확장 계획 수립**: 기존 8-Phase 위에 6개 Phase 추가, GATE 체계 계승
4. **MCP degradation 전략 25세션 안정성**: Sonatype 인증 실패에도 WebSearch 조합으로 동등한 분석 달성

**Opus 4.6 전략 요약 (Night-47):**
- **Phase 9 실행**: Sonnet Sub-agent가 Sonatype MCP PURL 조회 시도 → 인증 실패 → WebSearch+pub outdated 대체
- **Opus 판단**: Rust BREAKING 3건의 영향 범위 분석 + Dart BREAKING 8건의 우선순위 매트릭스 구성
- **결정 항목 도출**: D-82(Rust BREAKING), D-83(Dart BREAKING), D-84(Dart non-BREAKING) — Phase 10 전환 조건

**Sonnet 4.6 기술 실행:**
- **도구**: WebSearch(CVE 조회) + WebFetch(changelog 확인) + pub outdated(Dart 버전) + cargo metadata(Rust 버전)
- **PLAN_01 Phase 9-14 문서화**: PLAN_01.md 하단에 확장 계획 387줄 추가
- **MORNING_BRIEFING Night-47 반영**: 커밋 `f605793` + `e84089b`

**전략적 의의:**
1. **재기동 패턴 확립**: 사용자 방향 결정 → 즉시 실행 재개. Autonomy Ceiling에서의 올바른 탈출 패턴 실증
2. **Phase 9-14 GATE 체계 유지**: Phase 전환마다 ⏸️ 확인점 — 기존 PLAN_01의 규율을 확장 계획에도 적용
3. **신규 결정 항목 3건**: D-82~D-84 — Rust/Dart BREAKING 업그레이드 범위가 이후 Phase 10~13의 실행 범위를 결정

**다음 세션 최우선 항목**:
- **D-82~D-84** (업그레이드 범위 결정): Phase 10 진입 조건
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260427_0100` (75+ commits) → main PR 생성

### 1.3a Night-46 전략적 의의: Night-13~45 종합 분석 + PLAN_02 방향 결정 대기 9세션째

Night-45 커밋 해시 갱신 이후, **Night-46은 사용자 요청으로 Night-13~45 전체 종합 분석**을 수행한 세션.

**실행 전략:**
- Night-45 커밋(`b1786bf`, `0157f99`) 반영 상태에서 시작
- Flutter 360건 / Rust 207건 / analyze 0건 베이스라인 재검증 — **Night-45 대비 변동 없음**
- Opus 4.6 전략(33세션 분석), Sonnet 4.6 기술 실행(MCP 활용 이력), 생성 코드 결과 종합 리뷰
- MCP/플러그인 가용성 재점검 — 사용 가능 도구와 미연결/비해당 도구 분류

**Night-46 핵심 성과:**
1. **베이스라인 검증 완료**: Flutter 360건 / Rust 207건 / analyze 0건 — Night-45 대비 변동 없음
2. **종합 분석 작성**: MORNING_BRIEFING.md에 Night-46 전략/기술/코드 결과 반영
3. **MCP 가용성 재점검**: 활성 도구(feature-dev 3종, pr-review-toolkit 6종, superpowers 12종 등) vs 미연결(context7/playwright/serena) vs 비해당(tailwind/shadcn)

**Opus 4.6 전략 요약 (Night-13~45 전체):**
- **Phase 1 (Night-13~22)**: 보안/성능/구조 기반 정비 → API 계약 정합 → TOCTOU 해결 → 자동화(CI serde)
- **Phase 2 (Night-23~29)**: 취약점 해결 → FakeService 확립 → 위젯/프로바이더 테스트 포화
- **Phase 3 (Night-30~37)**: PLAN_01 8-Phase 체계적 실행 → 보안감사/코드품질/UI·UX/간소화 순차 완결
- **Phase 4 (Night-38~45)**: PLAN_01 문서 완결 → PLAN_02 초안 → U-42 대기 (8세션, 코드 변경 0건)

**Sonnet 4.6 기술 실행 요약:**
- **병렬 서브에이전트**: Night-16~24 주력 (최대 13대 동시 운용, Night-23)
- **Opus 직접 실행**: Night-25~34 (10세션 연속 테스트 코딩)
- **병렬 복귀**: Night-35~37 (Phase 4/5/7 — 3대 병렬 탐색 + Opus 실행)
- **문서/분석 전용**: Night-38~45 (MCP 미사용, 코드 변경 0건)
- **MCP 활용 누적**: feature-dev:code-explorer 22대+, code-reviewer 14건+15건, type-design-analyzer 8타입, cargo audit 7→0건

**전략적 의의:**
1. **U-42 9세션 연속 대기**: Night-38~46 — 사용자 방향 결정이 프로젝트 진행의 최대 병목 **확정**
2. **코드 변경 0건 8세션 연속**: Night-39(+2건) 이후 Night-40~46 모두 문서/분석 전용
3. **자율 실행 한계(Autonomy Ceiling) 패턴 안정화**: "단방향 결정 금지" 원칙이 8세션 연속 정상 작동

**다음 세션 최우선 항목**:
- **U-42** (PLAN_02 방향 선택): A)BREAKING 업그레이드 / B)기능 확장 / C)E2E+CI/CD / D)프로덕션 준비 / E)조합(Opus 추천)
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260414_0100` (75 commits) → main PR 생성

### 1.3a Night-44 전략적 의의: 종합 분석 + PLAN_02 방향 결정 대기 7세션째

Night-43 베이스라인 검증 이후, **Night-44는 Opus 4.6 직접 실행으로 Night-13~44 전체 종합 분석**을 수행한 세션.

**실행 전략:**
- Night-43까지의 Night-43 커밋 해시 반영 상태에서 시작
- Flutter 360건 / Rust 207건 / analyze 0건 베이스라인 재검증 — **Night-43 대비 변동 없음**
- Night-13~44 전체 전략/기술/코드 결과 종합 분석 (사용자 요청)
- MCP 도구 활용 가능성 정밀 매트릭스 작성

**Night-44 핵심 성과:**
1. **베이스라인 검증 완료**: Flutter 360건 / Rust 207건 / analyze 0건 — Night-43 대비 변동 없음
2. **종합 분석**: Opus 전략(31세션), Sonnet 기술 실행(MCP 23세션), 생성 코드(360+207 테스트) 통합 리뷰
3. **MCP 도구 가용성 정밀 점검**: 즉시 활용 가능(7종) vs OAuth 대기(14종) vs 미연결(3종) vs 비해당(2종) 4단계 분류

**전략적 의의:**
1. **U-42 7세션 연속 대기**: Night-38~44 — 사용자 방향 결정이 프로젝트 진행의 최대 병목 **확정**
2. **코드 변경 0건 6세션 연속**: Night-39(+2건) 이후 Night-40~44 모두 문서/분석 전용
3. **자율 실행 한계(Autonomy Ceiling) 패턴 안정화**: "단방향 결정 금지" 원칙이 6세션 연속 정상 작동 — 설계 방향 결정 없이는 자율적으로 변경 멈춤

**다음 세션 최우선 항목**:
- **U-42** (PLAN_02 방향 선택): A)BREAKING 업그레이드 / B)기능 확장 / C)E2E+CI/CD / D)프로덕션 준비 / E)조합(Opus 추천)
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260413_0100` (75+ commits) → main PR 생성

### 1.3a Night-43 전략적 의의: PLAN_02 방향 결정 대기 — 자율 실행 한계 지속

Night-42 베이스라인 검증 이후, **Night-43도 코드 변경 없는 베이스라인 검증 세션**으로 실행됨.

**실행 전략:**
- Night-42의 미커밋 MORNING_BRIEFING.md 업데이트 먼저 커밋 (Night-42 해시 `ed1b2b8`, `579b0e8` 반영)
- Flutter 360건 / Rust 207건 / analyze 0건 베이스라인 재검증
- PLAN_02 U-42 방향 미결정 상태 → 주요 코드 변경 없음

**Night-43 핵심 성과:**
1. **베이스라인 검증 완료**: Flutter 360건 / Rust 207건 / analyze 0건 — Night-42 대비 변동 없음
2. **PLAN_01 완전 완료 재확인**: 8-Phase 모두 ✅, 추가 실행 항목 없음
3. **자율 실행 한계 지속**: U-42(PLAN_02 방향) 6세션 연속 미결 — 사용자 방향 결정 없이는 코드 진전 불가

**전략적 의의:**
1. **U-42 6세션 연속 대기**: Night-38~43 — 사용자 방향 결정이 프로젝트 진행의 최대 병목 지속
2. **코드 변경 0건 5세션 연속**: Night-39(+2건) 이후 Night-40/41/42/43 모두 문서/분석 전용
3. **PLAN_02 E-2 진입 지연**: E-1(Night-40~42) 기간 초과, E-2 진입하려면 U-42 결정 필수

**다음 세션 최우선 항목**:
- **U-42** (PLAN_02 방향 선택): A)BREAKING 업그레이드 / B)기능 확장 / C)E2E+CI/CD / D)프로덕션 준비 / E)조합(Opus 추천)
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260413_0100` → main PR 생성

### 1.4 Night-42 전략적 의의: PLAN_02 방향 결정 대기 — 자율 실행 한계

Night-41 U-39 분석 이후, **Night-42는 코드 변경 없는 베이스라인 검증 세션**으로 실행됨.

**실행 전략:**
- Night-41의 미커밋 MORNING_BRIEFING.md 업데이트 먼저 커밋 (`ed1b2b8`)
- Flutter 360건 / Rust 207건 / analyze 0건 베이스라인 재검증
- PLAN_02 U-42 방향 미결정 상태 → 주요 코드 변경 없음

**Night-42 핵심 성과:**
1. **베이스라인 검증 완료**: Flutter 360건 / Rust 207건 / analyze 0건 — Night-41 대비 변동 없음
2. **PLAN_01 완전 완료 재확인**: 8-Phase 모두 ✅, 추가 실행 항목 없음
3. **자율 실행 한계 도달**: U-42(PLAN_02 방향) 5세션 연속 미결 — 사용자 방향 결정 없이는 코드 진전 불가

**전략적 의의:**
1. **U-42 5세션 연속 대기**: Night-38~42 — 사용자 방향 결정이 프로젝트 진행의 최대 병목 지속
2. **코드 변경 0건 4세션 연속**: Night-39(+2건) 이후 Night-40/41/42 모두 문서/분석 전용
3. **PLAN_02 E-1 기간 만료**: E-1(Night-40~42) 범위 종료 → E-2로 진행하려면 U-42 결정 필수

**다음 세션 최우선 항목**:
- **U-42** (PLAN_02 방향 선택): A)BREAKING 업그레이드 / B)기능 확장 / C)E2E+CI/CD / D)프로덕션 준비 / E)조합(Opus 추천)
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260412_0100` → main PR 생성

### 1.4 Night-41 전략적 의의: U-39 원인 규명 + 베이스라인 재검증

Night-40 PLAN_02 초안 작성 이후, **Night-41은 독립적 운영 이슈(U-39) 원인 분석 세션**으로 실행됨.

**실행 전략:**
- Night-40의 미커밋 MORNING_BRIEFING.md 업데이트 먼저 커밋 (`e051bb5`)
- U-39(SessionEnd hook 22회 실패) 원인 체계적 분석 — Vercel 플러그인 + node 미설치 조합 규명
- D-81 DECISION_LOG에 3가지 수정 옵션 문서화 (사용자 결정 대기)
- Flutter 360건 / Rust 207건 / analyze 0건 베이스라인 재검증

**Night-41 핵심 성과:**
1. **U-39 원인 규명 완료 (D-81)**: `vercel@claude-plugins-official` 플러그인의 `SessionEnd` 훅이 `node` 실행 필요 → 미설치 환경에서 24회 실패 — 비차단(non-blocking)이나 불필요한 에러 로그 발생
2. **진단 근거 체계화**: `python3` ✅ / `jq` ✅ / `node` ❌ — 다른 훅은 정상, Vercel 전용 문제 확인
3. **3가지 수정 옵션**: A)Vercel 플러그인 비활성화(권장) B)Node.js 설치 C)현 상태 유지 — 전역 설정 변경이므로 사용자 승인 필요

**전략적 의의:**
1. **운영 이슈 독립 해소 패턴**: PLAN_02 대기(U-42) 중에도 독립적 운영 이슈를 분석하여 대기 시간 활용
2. **U-42 5세션 연속 대기**: Night-38~41 + 현재 세션 — 사용자 방향 결정이 프로젝트 진행의 최대 병목
3. **코드 변경 0건 3세션 연속**: Night-39(+2 테스트) 이후 Night-40/41 모두 문서/분석 전용 — 새 계획 없이는 코드 진전 한계

### 1.4 Night-40 전략적 의의: PLAN_02 초안 작성 + 방향 결정 준비

Night-39에서 2세션 연속 U-42(PLAN_02 방향) 대기가 지속됨.
Night-40은 **PLAN_02 초안 문서화 세션** — Sonnet 4.6 Sub-agent가 직접 실행.

**실행 전략:**
- Night-39 미커밋 MORNING_BRIEFING.md 업데이트 먼저 커밋 (`222f935`)
- `docs/plans/PLAN_02.md` 신규 생성 — A~E 5가지 방향 각각의 구체적 실행 계획 포함
- NIGHT_06_RESULT.md Night-40 섹션 추가

**Night-40 핵심 성과:**
1. **PLAN_02.md 초안 완성**: 5가지 방향 × 세부 실행 단계 — 사용자 방향 결정 즉시 실행 가능한 blueprint
2. **U-42 해소 준비**: 구체적 선택지 명시로 의사결정 비용 최소화
3. **Opus 추천 E-방향(B→A→D)**: 기능 확장 → BREAKING 업그레이드 → 프로덕션 준비 순서 근거 문서화

**전략적 의의:**
1. **방향 결정 병목 해소**: U-42 3세션 연속 대기 → 구체적 실행 계획으로 사용자 결정 지원
2. **브랜치 머지 전제 명시**: PLAN_02 어떤 방향이든 `auto/night-01-20260410_0100` → main 머지가 선행 필요
3. **기술 부채 vs 기능 확장 트레이드오프**: PLAN_02.md §방향 A/B 비교 — B 먼저가 충돌 최소화

### 1.5 Night-39 전략적 의의: D-63 완전 해소 + 잔존 항목 소진

Night-38 문서 완결 후, **Night-39는 PLAN_01 이후 첫 소규모 코드 개선 세션**으로 실행됨.

**실행 전략:**
- Night-38에서 미커밋 상태의 MORNING_BRIEFING.md Night-38 업데이트를 먼저 커밋 (`aebf3d5`)
- D-63 잔존 2건(`referral_purchase_referred` + default 폴백) 완전 해소 → `_transactionLabel` 8/8 + default 전량 커버
- D-80 신규 패턴 수립: 미정의 타입 폴백 원문 반환 테스트 — 서버-클라이언트 계약 방어

**Night-39 핵심 성과:**
1. **D-63 완전 해소**: Night-32에서 7/8로 남았던 `_transactionLabel` 케이스를 Night-39에서 9/9(8명시+1default)로 완전 해소 — 3세션에 걸친 점진적 완성
2. **D-80 패턴**: `'unknown_future_type'` 주입 → `_ => type` 폴백 → 원문 그대로 렌더링 확인 — 서버에 새 transactionType 추가 시 UI 크래시 없는 graceful degradation 보장
3. **Flutter 360건 달성**: 358 → 360 (+2건) — PLAN_01 이후 첫 테스트 추가

**전략적 의의:**
1. **잔존 항목 소진 패턴**: PLAN_01 완결 후 미해결 D-항목을 체계적으로 정리 — PLAN_02 시작 전 깨끗한 상태 확보
2. **수확 체감 심화**: Night-38(+0건) → Night-39(+2건) — 새로운 계획(PLAN_02) 없이는 의미 있는 진전이 어려운 구간
3. **PLAN_02 방향 대기 지속 (U-42)**: 2세션 연속 사용자 결정 대기 — 방향 결정이 프로젝트 진행의 최대 병목

### 1.6 Night-38 전략적 의의: PLAN_01 문서 완결 + PLAN_02 방향 제시

Night-37에서 PLAN_01 8-Phase 전체 완료 후, **Night-38은 순수 문서 세션**으로 실행됨.

**실행 전략:**
- MORNING_BRIEFING.md의 Night-37 종합 업데이트(§1.3, §3.7-8, §8.2, §9 등) 커밋 완결
- Flutter 358건 / Rust 207건 / analyze 0건 기준선 재검증 — **변동 없음** 확인
- PLAN_02 방향 선택지 5가지(A~E) 제시 + MCP/플러그인 실측 상태 점검

**Night-38 핵심 발견 — MCP/플러그인 실측 현황:**
| 도구 | 실측 상태 | 비고 |
|------|----------|------|
| mcp-tailwind-gemini / shadcn | **비해당** | Flutter 프로젝트 (Tailwind/React 미사용) |
| chatgpt-mcp / sequential-thinking | **미설치** | superpowers:brainstorm + WebSearch로 대체 |
| context7 | 설치됨 / **미연결** | WebSearch로 11세션 연속 대체 |
| playwright / serena | 설치됨 / **미연결** | feature-dev:code-architect/explorer로 대체 |
| sonatype-guide | 설치됨 / **인증 미구성** | WebSearch + cargo audit으로 17세션 연속 대체 |

**PLAN_02 방향 선택지 (사용자 응답 대기):**
| 선택지 | 설명 |
|--------|------|
| **A)** | BREAKING 의존성 대규모 업그레이드 (riverpod 4.x, go_router 17 등) |
| **B)** | 기능 확장 — 미머지 PR 3개 통합 + 신규 기능 |
| **C)** | E2E 테스트 + CI/CD 강화 |
| **D)** | 프로덕션 준비 — 성능/모니터링/스케일링 |
| **E)** | 위 항목의 조합 (우선순위 지정) |

**전략적 의의:**
1. **PLAN_01 ↔ PLAN_02 전환점**: 8-Phase 완결 → 다음 방향 결정이 필요한 '교차점' 세션
2. **62커밋 브랜치**: Night-38 기준 main 대비 62 commits — 머지 결정이 PLAN_02 전제 조건
3. **코드 변경 0건**: 문서 품질에 집중 — 기술 부채 추가 없이 지식 자산만 증가

### 1.7 Night-37 전략적 의의: PLAN_01 전체 완결 (Phase 7 + Phase 8)

Night-36 Phase 5(UI/UX) 완료 후, **Phase 7(코드 간소화) + Phase 8(최종 검증)** 을 단일 세션에 완결. PLAN_01 8개 Phase 전체 완료.

**실행 전략:**
- 사용자 제시 실행 계획(D-78/D-79 결정 + Phase 7-B/C 우선순위표) → Opus 자율 판단으로 **HIGH + MEDIUM 범위** 실행
- **Phase 7-B(Rust)**: 4개 헬퍼 함수 추출 — `refresh_token_expiry`, `is_safe_partition_suffix`, `begin_alert_tx_checked`, `build_aggregate_sql`/`build_verify_sql`
- **Phase 7-C(Flutter)**: 2개 위젯 추출 — `ScreenErrorWidget` (3화면 공통 에러), `_primaryButton` (onboarding 반복 버튼)
- **Phase 7-A(의존성)**: 3건 적용 (cupertino_icons/intl/build_runner), 3건 보류 (json 체인 — analyzer 충돌)
- **Phase 8**: Flutter 358건 + Rust 207건 + analyze 0 + clippy 통과 → 구조화된 커밋

**PLAN_01 완결의 전략적 의의:**
1. **8-Phase 체계적 실행**: Night-30 계획 수립 → Night-37 완결 (8세션, 7일)
2. **Phase 간 연속성**: PD-62 발견(Phase 4, Night-35) → 해소(Phase 5, Night-36) → 간소화(Phase 7, Night-37) 크로스-Phase 추적
3. **코드베이스 총 감소 ~230줄**: Rust ~125줄 + Flutter ~105줄 (기능 변경 없이 구조 개선)
4. **의존성 충돌 명확화**: `riverpod_generator ^3.0.0` ↔ `analyzer <9.0.0` — 해결 경로 문서화 (4.x 동반 업그레이드)
5. **MCP degradation 패턴 일관성**: context7 미연결 → WebSearch 대체 (Night-31부터 7세션 연속)

**D-78/D-79 결정:**
- **D-78**: go_router 16→17 **보류** — ShellRoute observer 변경 리스크, Dart 3.9 요구
- **D-79**: minor 6건 중 **3건 적용** (cupertino_icons/intl/build_runner), **3건 보류** (json 체인 analyzer 충돌)

### 1.8 Night-36 전략적 의의: Phase 5 진입 + PD-62 해소

Night-35 Phase 4 완결 후, **Phase 5(UI/UX) 진입** 첫 세션. Sonnet 병렬 서브에이전트 3대로 코드베이스 탐색 후, Opus가 **PD-62(AlertType enum 전환)** 실행 결정.

**실행 전략:**
- Sonnet ×3 병렬 탐색: Phase 5(UI/UX) + Phase 7(간소화) 대상 식별
- 사용자에게 A/B/C 범위 선택 제시 → **사용자 미응답 → Opus 자율 판단으로 Phase 5 집중**
- **PD-62 DEFERRED → RESOLVED**: Night-35 type-design-analyzer 발견 16/40점 → Night-36에서 완전 해소
- Phase 5-B(테마 시스템 강화): AppSpacing + AppTextStyles 상수 추가

**PD-62 AlertType Enum 전환의 기술적 의의:**
1. **String → Dart Enum**: 컴파일타임 타입 안전성 — `unknown_type` 런타임 버그 원천 차단
2. **`@JsonValue` 어노테이션**: JSON 역직렬화 자동 처리 (snake_case ↔ camelCase)
3. **`AlertTypeX.value` extension**: API 전송용 snake_case 변환 — 서버/클라이언트 계약 보존
4. **exhaustive switch**: `_` 폴백 케이스 제거 → 새 AlertType 추가 시 컴파일 에러 강제
5. **6개 테스트 파일 업데이트**: String 리터럴 → `AlertType.targetPrice` 등 enum 리터럴

**Phase 5-B 테마 상수:**
- `AppSpacing`: `xs(4) / sm(8) / md(16) / lg(24) / xl(32) / xxl(48)` — Material 8pt 그리드
- `AppTextStyles`: `priceLabel / discountRate / sectionHeader / caption` — 디자인 토큰
- `abstract final class + static const` — ThemeExtension 불필요, const 컨텍스트 사용 가능

**Sonnet 탐색 결과 (Phase 5/7 대상 식별):**
- **Phase 5 UI/UX**: 11개 화면 3,488줄, AppColors 7색 시맨틱, 접근성 7파일 14곳
- **Phase 7 Flutter 간소화 대상**: ErrorStateView 공통 추출(3파일 ~60줄), 로그아웃 다이얼로그 중복, `_priceFormat` 중복
- **Phase 7 서버 간소화 대상**: `alert_service.rs` 한도체크/delete/toggle 3종 중복(~100줄), sqlx Transaction 자동 롤백 미활용(6곳)

### 1.9 Night-35 전략적 의의: Phase 4 코드 품질 리뷰 완결

Night-25~34 **10세션 연속** Opus 직접 테스트 코딩 후, Night-35에서 **Sonnet 병렬 서브에이전트 3대** 모델로 복귀. Phase 전환(테스트 포화 → 코드 품질 리뷰)에 따른 적응적 실행 모델 변화.

**실행 전략 (접근 C: Phase 4 Deep Dive 선택)**:
- 사용자 미응답 → Opus 자율 판단으로 **Phase 4 집중 심층 실행** 채택
- 3개 병렬 서브에이전트 동시 실행 (Night-31 이후 4세션 만에 병렬 복귀)
- **37건 발견 → 오탐 6건 제외 → 5건 수정** — 오탐률 ~16% (Night-22의 ~40%보다 개선)

**5건 수정의 보안/안정성 임팩트**:
1. **alert_service.rs 3곳**: `SELECT FOR UPDATE` 잠금 후 명시적 rollback — 잠금 해제 지연 방지
2. **reward_service.rs**: rollback `?` 연산자 → warn 패턴 — 500 오류 노출 차단
3. **auth_service.rs 2곳**: TTL `i64::MAX` 폴백 → `AppError::Internal` — 292년 영구 토큰 발행 보안 결함 방지
4. **products.rs**: `SearchQuery.q` serde(default) — 422 비표준 응답 → 일관된 400 BadRequest
5. **notification_list_screen.dart**: markAsRead catch에 `showErrorSnackBar` — 에러 피드백 일관성

**MCP/플러그인 실제 활용**:
- `feature-dev:code-reviewer` (14건 발견) + `pr-review-toolkit:silent-failure-hunter` (15건) + `pr-review-toolkit:type-design-analyzer` (8개 타입)
- **context7/playwright/serena**: 설치 확인됨, Phase 4에서는 미사용 (코드 리뷰 전용)
- **mcp-tailwind-gemini/shadcn**: 비해당 (Flutter 프로젝트)
- **sequential-thinking/chatgpt-mcp**: 미설치, `superpowers:brainstorm` + WebSearch로 대체

**type-design-analyzer 핵심 발견 → Night-36에서 해소**:
- `AlertType` String→Dart Enum 전환 필요 — 점수 16/40 (최저, PD-62)
- ✅ **Night-36에서 완전 해소**: freezed 재생성 + 6개 테스트 파일 업데이트 완료

### 1.10 Night-34 전략적 의의: 단위 테스트 포화 확정

Night-25~34 **10세션 연속** 테스트 전용 실행. 핵심 수치:
- **Phase 6 누적**: +168건 (Night-22~34), +60건 (Night-30~34 PLAN_01 기준)
- **11개 화면 전체** 확장 완료 — 미커버 분기 체계적 소진
- **`_formatTime` 5개 분기 전량 커버** (D-65) — Night-31~33 누적 완성
- **다이얼로그 패턴 2종 완비** (로그아웃 + 회원탈퇴) — MyPage, Settings 양쪽 모두
- **null 조건부 렌더링 완결** (D-67~D-68) — `trend null`, `buyTimingScore null` 부재 검증
- **OnboardingScreen Page 3 도달** (D-69) — `_finish()` 호출 없이 렌더링만 검증하는 경량 패턴
- **Opus 직접 실행 10세션** (Sonnet sub-agent 불필요) — 테스트 코딩 패턴 안정화

**수확 체감 분석**: Night-27~34 매 세션 +12건 균일 (8세션 × 12건 = 96건). 신규 분기 발견 난이도 최대 → **Phase 6 포화 확정 (344건)**.

### 1.11 Night-31~32 전략적 의의: PLAN_01.md 본격 실행

Night-30에서 수립된 **8-Phase 종합 최적화 계획**이 Night-31에서 본격 실행됨.
핵심 성과: **Phase 1(보안감사) + Phase 2/3(GAP 분석) + Phase 6(테스트) 동시 진행**.

#### Phase 1: 의존성 보안 감사 결과

| 영역 | 결과 | 세부 |
|------|------|------|
| **Rust 30개 크레이트** | ✅ CVE 0건 | tokio 1.50.0 이미 패치 완료 |
| **Dart 17개 패키지** | ✅ 직접 CVE 0건 | pub outdated로 대체 검증 |
| **Flutter 엔진** | ⚠️ Skia CVE 2건 | CVE-2025-27363(CISA KEV) + CVE-2026-3909 — Flutter 팀 패치 대기 |
| **Sonatype MCP** | ❌ 인증 실패 | WebSearch + RustSec DB + NVD로 대체 (10세션 연속) |

#### Phase 2/3: 프레임워크 GAP 분석 결과

| 영역 | GAP | 판정 |
|------|-----|------|
| 서버 (axum 0.8/sqlx 0.8/tower) | 없음 | 완전 정합 — 리팩토링 불필요 |
| Flutter riverpod 3.0→3.3 | 🟡 Minor | `ref.keepAlive()` 새 API, `family` 타입 안전성 |
| Flutter go_router 16→StatefulShellRoute | 🟡 Minor | 탭 상태 유지 개선 가능 |
| Flutter dio 5.x | 🟢 Low | Retry interceptor 검토 가능 |

**설계 핵심:**
1. **Opus/Sonnet 역할 분리** — Sonnet이 데이터 수집(병렬 sub-agent), Opus가 오탐 필터링 + 의사결정
2. **8개 ⏸️ GATE** — Phase 전환마다 사용자 승인 필수, 단방향 결정 금지
3. **MCP 불가 시 degradation** — Sonatype 인증 실패 → WebSearch/RustSec/NVD 직접 조회로 대체

### 1.12 Opus 4.6의 핵심 전략 패턴 (Night-13~41 누적)

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 (⏸️ 8개 확인점)
2. **오탐 필터링**: 서브에이전트 발견 → Opus가 ~40% 필터링 → 실행 확정
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트
4. **serde 파급 누락 → CI 자동화** (Night-19→22): 3회 수동 반복 실패 후 구조적 종결
5. **Silent Failure 생명주기**: 전수 조사(Night-22) → 수정(Night-23) → 재검증 = 3단계 완결
6. **FakeService 패턴 3종 완비** (Night-23→24): 플랫폼 채널 없이 전체 비즈니스 화면 테스트
7. **테스트 포화 관리** (Night-25~34): 매 세션 +12건 균일 패턴 → 미커버 분기 체계적 소진 → Night-34 포화 확정 (344건)
8. **MCP degradation 전략** (Night-31): Sonatype 실패 시 WebSearch 대체 내재화
9. **누적 패턴 완성** (Night-31~33): `_formatTime` 5분기를 3세션에 걸쳐 점진적 완성 — 장기 일관성 유지
10. **null 부재 검증 패턴** (Night-34): `findsNothing`으로 조건부 렌더링 부재 확인 — 존재 확인보다 강력한 테스트
11. **적응적 실행 모델 전환** (Night-35): 10세션 직접 코딩 → 병렬 서브에이전트 복귀 — Phase 특성에 맞춤
12. **rollback warn 표준 패턴 누적** (Night-23→35): 8곳 적용 — `if let Err(rb_err) = tx.rollback().await { warn!() }` 코드베이스 표준
13. **DEFERRED→RESOLVED 교차 세션 추적** (Night-35→36): PD-62 발견(type-design-analyzer) → 다음 세션에서 완전 해소 — Phase 간 연속성 유지
14. **테마 상수 설계**: `abstract final class + static const` — ThemeExtension 불필요한 값에 대해 경량 패턴 선택 (const 컨텍스트 호환)
15. **헬퍼 추출 전략** (Night-37): `begin_alert_tx_checked`(~60줄 절감) 등 반복 보일러플레이트를 단일 함수로 — 기능 변경 없이 구조 개선
16. **의존성 충돌 문서화** (Night-37): `riverpod_generator ^3.0.0` ↔ `analyzer <9.0.0` 충돌 → 해결 경로(4.x 동반 업그레이드) 명시 — 미래 세션 삽질 방지
17. **PLAN_01 8-Phase 전체 완결** (Night-30→37): 계획 수립(Night-30) → 체계적 실행(Night-31~37) → 완결 — 7일 8세션 내 완수
18. **문서 전용 세션 패턴** (Night-38): 코드 변경 0건으로 문서 품질에만 집중 — PLAN_01↔PLAN_02 전환점에서 지식 자산 정리
19. **MCP 실측 점검 루틴** (Night-38): 설치됨≠사용가능 구분 — 미연결/비해당/미설치 3단계 분류로 다음 계획의 도구 가용성 사전 확인
20. **잔존 항목 소진 패턴** (Night-39): PLAN 완결 후 미해결 D-항목 체계적 정리 — 다음 PLAN 시작 전 깨끗한 상태 확보
21. **default 폴백 방어 테스트** (Night-39, D-80): 미정의 타입 주입 → `_ => type` 폴백 원문 반환 검증 — 서버-클라이언트 계약의 forward compatibility 보장
22. **운영 이슈 독립 해소** (Night-41, D-81): PLAN_02 대기 중 독립적 운영 이슈(SessionEnd hook) 분석 — 대기 시간을 진단에 활용하여 기술 부채 식별
23. **전역 설정 변경 사전 승인 원칙** (Night-41): Vercel 플러그인 비활성화가 모든 프로젝트에 영향 → 단방향 결정 금지 원칙 준수, 옵션 제시 후 사용자 결정 대기
24. **자율 실행 한계(Autonomy Ceiling) 확정** (Night-44→46): 9세션 연속(Night-38~46) 코드 변경 0건으로 수렴 — PLAN 완결 후 사용자 방향 미결정 시 자율적으로 멈추는 올바른 에이전트 동작 실증
25. **재기동(Restart) 패턴** (Night-47): Autonomy Ceiling 9세션 후 사용자 지시로 Phase 9 즉시 실행 — 정체 세션의 축적된 분석(도구 매트릭스, PLAN_02 초안)이 재기동 즉시 활용됨
26. **Phase 확장(9-14) 계획 수립** (Night-47): 기존 PLAN_01 8-Phase 구조를 계승하되, Phase 9-14로 신규 6개 Phase 추가 — 도구 가용성 실측 기반 현실적 계획
27. **Sonatype MCP 25세션 대체 패턴 안정화** (Night-47): 인증 미구성 상태로도 WebSearch+pub outdated+cargo metadata 조합이 보안/버전 분석에 충분 — MCP 의존도를 낮추는 전략적 유연성
28. **4대 병렬 에이전트 코드 품질 감사** (Night-48): Phase 4(3대, Night-35) → Phase 10(4대, Night-48) — 동일 코드베이스에 대한 2차 감사로 잔존 이슈 발굴. Night-35 오탐률 ~16% → Night-48 ~24% (코드베이스 성숙에 따른 오탐 비율 자연 상승)
29. **Phase 간 연계 발견 추적** (Night-48): PD-67(priceTrend Enum)은 Night-36 PD-62(AlertType Enum) 선례 존재 — Phase 4→5에서 발견→해소된 패턴을 Phase 10→13에서 반복 적용 가능
30. **10세션 연속 코드 변경 0건** (Night-40~48): 분석/문서/리뷰 세션이 코드 변경 세션과 분리 — Phase 13(수정 실행)까지 축적된 분석이 한꺼번에 실행되는 "축적→폭발" 패턴

### 1.13 의사결정 일관성

- **총 87개 결정** (D-1 ~ D-87) — Night-48에서 D-85(Phase 10 HIGH 수정), D-86(MEDIUM 수정 범위), D-87(LOW 포함 여부) 추가
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 2건 (D-39: E2E 테스트, D-78: go_router 16→17 보류) — ~~PD-62: Night-36에서 해소~~
- DIAGNOSED: 1건 (D-81: SessionEnd hook — 사용자 방향 결정 대기)
- **PENDING (사용자 결정 대기)**: 6건 (D-82~D-84: 업그레이드 범위, D-85~D-87: Phase 10 수정 범위)
- **나머지 71건: IMPLEMENTED 유지** (Night-37에서 D-78~D-79 추가)

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~41 서브에이전트 운용

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
| 30 | 직접 실행 | PLAN_01.md 작성 + pub outdated | +12건 테스트 | 계획 수립 + Flutter12 |
| **31** | **Sonnet ×3 (병렬)** | **Rust 30개 CVE 청정** | **Dart 17개 CVE 청정** | **Phase 1/2/3 + Flutter12** |
| **32** | **직접 실행** | **프로덕션 코드 변경 없음** | **+12건 테스트** | **Phase 6 Flutter only** |
| **33** | **직접 실행** | **프로덕션 코드 변경 없음** | **+12건 테스트** | **Phase 6 Flutter only** |
| **34** | **직접 실행** | **프로덕션 코드 변경 없음** | **+12건 테스트** | **Phase 6 Flutter only — 포화 확정** |
| **35** | **Sonnet ×3 (병렬)** | **37건 발견 → 5건 수정** | **344건 유지** | **Phase 4: code-reviewer + silent-failure-hunter + type-design-analyzer** |
| **36** | **Sonnet ×3 (병렬 탐색) + Opus 실행** | **PD-62 enum 전환** | **+14건 (358건)** | **Phase 5: 코드베이스 탐색 → AlertType enum + AppSpacing/TextStyles** |
| **37** | **Sonnet ×3 (병렬 탐색) + Opus 실행** | **4헬퍼 + 2위젯 추출 + 의존성 3건** | **358건 유지** | **Phase 7: 간소화 (~230줄 감소) + Phase 8: 검증/커밋 — PLAN_01 전체 완료** |
| **38** | **Opus 직접 실행 (문서)** | **프로덕션 코드 변경 0건** | **358건 유지** | **문서 완결: MORNING_BRIEFING §전체 + PLAN_02 방향 제시 + MCP 실측 점검** |
| **39** | **Opus 직접 실행 (테스트)** | **프로덕션 코드 변경 0건** | **+2건 (360건)** | **D-63 완전 해소: _transactionLabel 8/8+default — PLAN_02 대기 지속** |
| **40** | **Sonnet 4.6 Sub-agent (문서)** | **프로덕션 코드 변경 0건** | **360건 유지** | **PLAN_02 초안: docs/plans/PLAN_02.md 생성 — A~E 5방향 + 브랜치 머지 전제 명시** |
| **41** | **Sonnet 4.6 Sub-agent (분석)** | **프로덕션 코드 변경 0건** | **360건 유지** | **U-39 원인 규명: Vercel SessionEnd hook + node 미설치 → D-81 3옵션 문서화 + 베이스라인 재검증** |
| **42** | **Sonnet 4.6 Sub-agent (문서)** | **프로덕션 코드 변경 0건** | **360건 유지** | **PLAN_02 U-42 5세션 대기 + 베이스라인 재검증 — 코드 변경 0건, Night-41 커밋 해시 갱신** |
| **43** | **Sonnet 4.6 Sub-agent (문서)** | **프로덕션 코드 변경 0건** | **360건 유지** | **PLAN_02 U-42 6세션 대기 + 베이스라인 재검증 — 코드 변경 0건, Night-42 커밋 해시 갱신** |
| **44** | **Opus 4.6 직접 실행 (종합 분석)** | **프로덕션 코드 변경 0건** | **360건 유지** | **Night-13~44 종합 분석 + MCP 도구 매트릭스 + 베이스라인 재검증 — PLAN_02 U-42 7세션 대기** |
| **45** | **Sonnet 4.6 Sub-agent (문서)** | **프로덕션 코드 변경 0건** | **360건 유지** | **PLAN_02 U-42 8세션 대기 + 베이스라인 재검증 — Night-44 커밋 해시 갱신** |
| **46** | **Opus 4.6 직접 실행 (종합 분석)** | **프로덕션 코드 변경 0건** | **360건 유지** | **Night-13~45 종합 분석 + MCP 가용성 재점검 + 베이스라인 재검증 — PLAN_02 U-42 9세션 대기** |
| **47** | **Opus 4.6 (Phase 9 실행) + Sonnet 대체 분석** | **프로덕션 코드 변경 0건** | **360건 유지** | **U-42 해소 → Phase 9 실행: Sonatype MCP 인증 실패(25세션) → WebSearch+pub outdated 대체, Rust 11 crates + Dart 9 packages 분석, CVE 0건, BREAKING Rust 3+Dart 8건, D-82~D-84 도출** |
| **48** | **Opus 4.6 (Phase 10 실행) + Sonnet ×4 병렬** | **프로덕션 코드 변경 0건** | **360건 유지** | **Phase 10: silent-failure-hunter + type-design-analyzer + feature-dev:code-reviewer + coderabbit:code-reviewer 4대 병렬 → 17건 발견 → 오탐 4건 제외 → 9건 확정 (HIGH 2 + MEDIUM 3 + LOW 4), D-85~D-87 도출** |

### 2.3 MCP/플러그인 활용 현황

| 카테고리 | 도구 | 누적 활용 | 현재 상태 |
|----------|------|-----------|----------|
| 코드 탐색 | `feature-dev:code-explorer` (22대+) | Night-16~23 주력 | ✅ 활성 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-22 완결 | ✅ 완료 |
| 코드 리뷰 | `coderabbit:code-reviewer` | Night-23 종합 리뷰 | ✅ 활성 |
| 코드 리뷰 | `feature-dev:code-reviewer` | Night-35 Phase 4 (14건 발견) | ✅ 활성 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-35 Phase 4 (15건 발견) | ✅ 완료 (Night-22+35) |
| 타입 설계 | `pr-review-toolkit:type-design-analyzer` | Night-35 Phase 4 (8개 타입) | ✅ 활성 |
| 의존성 감사 | `cargo audit` + `cargo update` | Night-24: 7→0건 | ✅ 완료 |
| 코드 리뷰 | `coderabbit:code-reviewer` | Night-48 Phase 10 (4대 병렬 1번째) | ✅ 활성 |
| 코드 리뷰 | `feature-dev:code-reviewer` | Night-48 Phase 10 (4대 병렬 2번째) | ✅ 활성 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-48 Phase 10 (4대 병렬 3번째) | ✅ 완료 (Night-22+35+48) |
| 타입 설계 | `pr-review-toolkit:type-design-analyzer` | Night-48 Phase 10 (4대 병렬 4번째) | ✅ 활성 |
| 의존성 보안 | Sonatype MCP | Night-31~48: 인증 실패 | ❌ **26세션** 연속 실패 |
| 코드 간소화 | `pr-review-toolkit:code-reviewer` + `pr-review-toolkit:silent-failure-hunter` | Night-37 Phase 7-D 리뷰 | ✅ 활성 |
| 대체 전략 | WebSearch + RustSec DB + NVD | Night-31~37: 대체 성공 | ✅ 활성 |
| 외부 참조 | WebSearch + WebFetch | MCP 대체 (D-36:C) | ✅ 활성 |

### 2.4 Night-31 MCP 실행 상세

**Sonatype MCP 인증 실패 → WebSearch 대체 전략:**

```
시도: sonatype-guide:getLatestComponentVersion (Rust crates + Dart packages)
결과: 인증 요구 → 400 에러
대체: WebSearch("CVE {package_name} 2025 2026") × 47건
      + RustSec Advisory DB 직접 조회
      + NVD(National Vulnerability Database) 크로스체크
      + pub.dev 버전 정보 + changelog 확인
판정: Rust 30개 CVE 0건, Dart 17개 직접 CVE 0건, Flutter 엔진 Skia CVE 2건(코드 변경 불가)
```

이 패턴은 MCP 의존 없이 동등한 보안 감사 결과를 도출. Sonatype의 부가 가치(보안 점수, 라이선스 분석)는 미확인.

---

## 3. 생성 코드 결과

### 3.1 Night-31 코드 변경 (커밋 `c8efba4`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `test/screens/product_detail_screen_test.dart` | +4건 | rising/stable 트렌드, 최고가, wait 예측 |
| `test/screens/my_page_screen_test.dart` | +4건 | 잔액타이틀, 출석버튼, 출석스낵바, 에러분기 |
| `test/screens/notification_list_screen_test.dart` | +4건 | 에러텍스트, 읽음알림, 방금, 1시간전 |

**프로덕션 코드 변경: 0건** — 테스트 전용 세션

---

### 3.2 Night-32 코드 변경 (커밋 `1f36f3c`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `test/screens/alert_screen_test.dart` | +4건 | AppBar add 버튼, 에러 다시시도, 탭 Badge, CategoryAlert threshold |
| `test/screens/login_screen_test.dart` | +4건 | Google 아이콘, Semantics 로고 레이블, TextButton, SafeArea |
| `test/screens/point_history_screen_test.dart` | +4건 | referral_welcome_referrer, referral_purchase_referrer, admin_adjustment, description |

**프로덕션 코드 변경: 0건** — 테스트 전용 세션 (Night-31과 동일 패턴)

---

### 3.3 Night-33 코드 변경 (커밋 `ecfd5e6`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `test/screens/my_page_screen_test.dart` | +4건 | 출석완료 버튼, 복사 tooltip, 로그아웃 AlertDialog, 다이얼로그 취소 |
| `test/screens/notification_list_screen_test.dart` | +4건 | 5분전, 2일전, M/D 날짜, system 아이콘 |
| `test/screens/settings_screen_test.dart` | +4건 | 탈퇴 버튼, 탈퇴 취소, 로그아웃 확인, 탈퇴 경고 문구 |

**프로덕션 코드 변경: 0건** — 테스트 전용 세션 (Night-31~32와 동일 패턴, 3세션 연속)

---

### 3.4 Night-34 코드 변경 (커밋 `6f5c0b2`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `test/screens/home_screen_test.dart` | +4건 | stable→`trending_flat`, trend null→trailing 없음, rank 번호, URL 다이얼로그 취소 |
| `test/screens/product_detail_screen_test.dart` | +4건 | 평균가 ₩30,000, neutral→"보합", "요일별 평균 가격" 타이틀, buyTimingScore null |
| `test/screens/onboarding_screen_test.dart` | +4건 | "가격 히스토리" 설명, "센트(¢) 보상" 설명, 이용약관 개별 탭, 완료 페이지 "준비 완료!" |

**프로덕션 코드 변경: 0건** — 테스트 전용 세션 (Night-31~33과 동일 패턴, **4세션 연속**)

**Night-34 실행 특성:**
- **Opus 4.6 직접 실행** — Sonnet 서브에이전트 미사용 (Night-25~34, **10세션 연속**)
- **MCP/플러그인 미사용** — 순수 테스트 코딩 세션
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~34, **10회** 누적 감지)

### 3.5 Night-35 코드 변경 (커밋 `68bfd6e`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `server/src/services/alert_service.rs` | +9줄 (3곳) | FOR UPDATE 잠금 후 명시적 `warn!` 패턴 rollback 추가 |
| `server/src/services/reward_service.rs` | +3줄 | daily_checkin rollback `?` → warn 패턴 (500 노출 방지) |
| `server/src/services/auth_service.rs` | +8줄 (2곳) | TTL `i64::MAX` 폴백 → `AppError::Internal` 명시 |
| `server/src/api/routes/products.rs` | +1줄 | `SearchQuery.q`에 `#[serde(default)]` 추가 |
| `app/lib/screens/notification/notification_list_screen.dart` | +1줄 | markAsRead catch에 `showErrorSnackBar` 추가 |

**프로덕션 코드 변경: 5건 (Rust 4 + Flutter 1)** — Night-25~34 10세션 테스트 전용 후 **첫 프로덕션 수정**

**Night-35 실행 특성:**
- **Sonnet 4.6 병렬 서브에이전트 ×3** — Night-31 이후 4세션 만에 병렬 복귀
- **MCP/플러그인 활용**: `feature-dev:code-reviewer` + `pr-review-toolkit:silent-failure-hunter` + `pr-review-toolkit:type-design-analyzer`
- **오탐 필터링**: 37건 발견 → 6건 제외 (오탐률 ~16%) → 5건 실제 수정
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~35, **12회** 누적 감지)

### 3.6 Night-36 코드 변경 (커밋 `aab5540`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `app/lib/models/price_alert.dart` | enum 추가 | `AlertType` enum 4값 (`targetPrice/belowAverage/nearLowest/allTimeLow`) + `@JsonValue` |
| `app/lib/models/price_alert.g.dart` | 재생성 | `build_runner` — `AlertType` JSON 역직렬화 코드 자동 생성 |
| `app/lib/models/price_alert.freezed.dart` | 재생성 | freezed — `AlertType` 타입 반영 |
| `app/lib/widgets/alert_type_badge.dart` | 수정 | `String alertType` → `AlertType alertType` + exhaustive switch (`_` 제거) |
| `app/lib/screens/product/product_detail_screen.dart` | 수정 | `alertTypeLabel()` String→AlertType 파라미터 |
| `app/lib/config/theme.dart` | 추가 | `AppSpacing` 6단계 + `AppTextStyles` 4종 상수 |
| `test/widgets/alert_type_badge_test.dart` | +3건 | `AlertType.value` extension 검증 4건 (기존 13→16) |
| `test/config/theme_test.dart` | +11건 | AppSpacing 7건 + AppTextStyles 4건 (기존 8→19) |
| 6개 테스트 파일 | 수정 | String 리터럴 → `AlertType.xxx` enum 리터럴 전환 |

**프로덕션 코드 변경: 6파일** (모델 3 + 위젯 1 + 화면 1 + 테마 1) — PD-62 해소 + Phase 5-B 테마 강화
**테스트 변경: 8파일** (신규 14건 + 기존 6파일 enum 리터럴 전환)

**Night-36 실행 특성:**
- **Sonnet ×3 병렬 탐색** → Phase 5/7 대상 식별 → **Opus 직접 실행** (PD-62 + 테마 상수)
- **MCP/플러그인**: 탐색용 `feature-dev:code-explorer` 3대 (Phase 5/7 대상 분석)
- **build_runner 재생성**: `dart run build_runner build --delete-conflicting-outputs` 필수
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~36, **14회** 누적 감지)

### 3.7 Night-37 코드 변경 (커밋 `044da3f`)

#### Phase 7-B: Rust 서버 코드 간소화 (~125줄 감소)

| 헬퍼 함수 | 파일 | 효과 |
|---------|------|------|
| `refresh_token_expiry(config)` | `auth_service.rs` | TTL 계산 2곳 중복 → 1함수 (~10줄) |
| `is_safe_partition_suffix(s)` | `main.rs` | SQL injection 방어 3곳 → 단일 진실 원천 (~15줄) |
| `begin_alert_tx_checked(pool, user_id)` | `alert_service.rs` | `create_*_alert` 3함수 트랜잭션 보일러플레이트 통합 (~60줄) |
| `build_aggregate_sql(p)` + `build_verify_sql(p)` | `main.rs` | archive SQL 인라인 → 가독성 향상 (~40줄) |

#### Phase 7-C: Flutter 코드 간소화 (~105줄 감소)

| 변경 | 파일 | 효과 |
|------|------|------|
| `ScreenErrorWidget` 신규 | `widgets/screen_error_widget.dart` | alert/favorites/notification 3화면 에러 UI 공통화 (~75줄) |
| `_primaryButton(label, onPressed)` | `onboarding_screen.dart` | ElevatedButton 반복 통합 (~30줄) |

#### Phase 7-A: 의존성 업그레이드

| 패키지 | 이전 | 이후 | 결과 |
|--------|------|------|------|
| `cupertino_icons` | ^1.0.8 | ^1.0.9 | ✅ 적용 |
| `intl` | ^0.19.0 | ^0.20.0 | ✅ 적용 |
| `build_runner` (dev) | ^2.4.0 | ^2.13.0 | ✅ 적용 |
| `json_annotation` | 4.9.0 | — | ❌ 보류 (analyzer 충돌) |
| `json_serializable` | 6.11.2 | — | ❌ 보류 (analyzer 충돌) |
| `freezed` | 3.2.3 | — | ❌ 보류 (analyzer 충돌) |

**보류 사유**: `riverpod_generator ^3.0.0` → `analyzer <9.0.0` 요구. json 체인 업그레이드 시 `analyzer ≥9.0.0` 필요.
**해결 경로**: `riverpod_generator 4.x` + `flutter_riverpod 3.3.x` 동반 업그레이드.

**프로덕션 코드 변경: Rust 4파일 + Flutter 5파일** — 기능 변경 없이 구조 간소화
**테스트 변경: 0건** — 358건 유지 (기존 테스트 회귀 없음 확인)

**Night-37 실행 특성:**
- **Sonnet ×3 병렬 탐색** (Phase 7-B/C 대상) → **Opus 직접 실행** (간소화 + 검증)
- **Phase 7-D 리뷰**: code-reviewer + silent-failure-hunter 병렬 검증
- **Phase 8 검증**: Flutter 358건 ✅ + Rust 207건 ✅ + analyze 0 ✅ + cargo check ✅
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~37, **16회** 누적 감지)

### 3.8 Night-38 작업 내역 (커밋 `2dd797f`, `22a115e`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING 종합 업데이트 | `MORNING_BRIEFING.md` | Night-37 전략 §1.3 + Phase 완료 §5 + 지표 §8.2 + 다음 선택지 §9 전체 추가 |
| NIGHT_06_RESULT Night-38 기록 | `NIGHT_06_RESULT.md` | Night-38 문서 완결 세션 결과 + PLAN_01 이후 선택지 §9 요약 |
| 기준선 재검증 | — | Flutter 358건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ (변동 없음) |
| PLAN_02 방향 제시 | — | A~E 선택지 제시 + MCP 실측 상태 점검 (사용자 응답 대기) |

**프로덕션 코드 변경: 0건** — 순수 문서 세션
**테스트 변경: 0건** — 358건 유지

**Night-38 실행 특성:**
- **Opus 4.6 직접 실행** — Sonnet 서브에이전트 미사용
- **MCP/플러그인 미사용** — 문서 전용 세션
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~38, **18회** 누적 감지)

### 3.9 Night-39 코드 변경 (커밋 `8811c00`)

| 파일 | 변경 | 내용 |
|------|------|------|
| `test/screens/point_history_screen_test.dart` | +2건 | `referral_purchase_referred` → '추천 구매 보상' (Night-32 누락분) + `'unknown_future_type'` → 원문 폴백 (D-80) |
| `NIGHT_06_RESULT.md` | 갱신 | Night-39 결과 기록 (D-63 해소 + 테스트 360건) |

**프로덕션 코드 변경: 0건** — 테스트 + 문서 전용 세션
**테스트 변경: +2건** — 358 → **360건** (D-63 완전 해소)

**Night-39 실행 특성:**
- **Opus 4.6 직접 실행** — Sonnet 서브에이전트 미사용 (Night-38에 이어 2세션 연속)
- **MCP/플러그인 미사용** — 순수 테스트 코딩 세션
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~39, **20회** 누적 감지)

### 3.10 Night-42 작업 내역 (커밋 `ed1b2b8`, `579b0e8`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING Night-41 반영 | `MORNING_BRIEFING.md` | Night-41 커밋 해시(TBD → `e051bb5`, `d655baf`) 갱신 |
| Night-42 결과 문서화 | `NIGHT_06_RESULT.md` | Night-42 섹션 추가 — U-42 5세션 대기 + 베이스라인 재검증 |
| MORNING_BRIEFING 갱신 | `MORNING_BRIEFING.md` | Night-42 전략 §1.3 + 결과 §3.10 + 지표 §8.1 반영 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — 문서 전용 세션 (Night-40~42, **3세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-42 실행 특성:**
- **Sonnet 4.6 Sub-agent (문서)** — Night-41에 이어 2세션 연속 Sub-agent 실행
- **MCP/플러그인 미사용** — 문서 전용 세션
- **핵심 발견: 자율 실행 한계(autonomy ceiling)**: PLAN_01 완결 + 잔존 항목 소진 → 사용자 방향 없이는 코드 진전 불가. 이는 올바른 동작 — "단방향 결정 금지" 원칙 준수
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~42, **26회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.10a Night-47 작업 내역 (커밋 `f605793`, `e84089b`)

| 작업 | 파일 | 내용 |
|------|------|------|
| PLAN_01 Phase 9-14 확장 계획 | `docs/plans/PLAN_01.md` | 하단 387줄 추가 — Phase 9-14 계획 + 도구 가용성 매트릭스 |
| Phase 9 의존성 분석 실행 | `docs/plans/PLAN_01.md` | Phase 9 §9-C 산출물: Rust 11 crates + Dart 9 packages 분석 결과 |
| MORNING_BRIEFING Night-47 반영 | `MORNING_BRIEFING.md` | Night-47 결과 통합 (Phase 9 + U-42 해소 + D-82~D-84) |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — Phase 9는 분석 전용 (Night-40~47, **9세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-47 실행 특성:**
- **Opus 4.6 전략 + Sonnet 4.6 Sub-agent 실행** — Phase 9 계획 수립(Opus) + 의존성 조회(Sonnet)
- **MCP 시도**: Sonatype MCP 3개 API 호출 → **인증 실패 25세션째** → WebSearch+pub outdated 대체
- **핵심 산출물**: Phase 9 완료 + D-82~D-84 결정 항목 + Phase 9-14 확장 계획
- **U-42 해소**: 9세션 연속 대기 후 사용자 지시로 재기동 — Autonomy Ceiling 올바른 탈출
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~47, **36회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

**Night-47 Phase 9 핵심 분석 결과:**

| 구분 | CVE | BREAKING 업그레이드 | non-BREAKING |
|------|-----|-------------------|-------------|
| **Rust** | ✅ 0건 | 3건 (reqwest 0.12→0.13, jwt 9→10, sentry 0.37→0.47) | 3건 (axum 0.8.9, scraper 0.26, tokio 1.52.1) |
| **Dart** | ✅ 0건 | 8건 (kakao 2.0, riverpod_gen 4.x, go_router 17, fl_chart 1.2, google_sign_in 7.x, sign_in_with_apple 7.x, flutter_secure_storage 10.x, dio 6.x) | 4건 (build_runner, freezed, mocktail, json_annotation) |

### 3.10b Night-48 작업 내역 (커밋 `f2319d5`, `0315310`)

| 작업 | 파일 | 내용 |
|------|------|------|
| Phase 10 코드 품질 심층 리뷰 | `docs/plans/PLAN_01.md` | Phase 10 완료 마킹 + 확인점 업데이트 |
| 4대 에이전트 병렬 실행 | — | silent-failure-hunter + type-design-analyzer + feature-dev:code-reviewer + coderabbit → 17건 발견 |
| 오탐 필터링 | — | 4건 제외 (RadioGroup/new_balance/TOCTOU/is_new) → 9건 확정 |
| MORNING_BRIEFING Night-48 반영 | `MORNING_BRIEFING.md` | Night-48 전략 §1.3 + 성숙도 곡선 갱신 + §2.2 + §3 추가 |
| NIGHT_06_RESULT Night-48 기록 | `NIGHT_06_RESULT.md` | Night-48 섹션 96줄 추가 — Phase 10 결과 + D-85~D-87 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — Phase 10은 분석 전용 (Night-40~48, **10세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-48 실행 특성:**
- **Opus 4.6 전략 + Sonnet 4.6 ×4 병렬 에이전트** — Phase 10 계획 수립(Opus) + 코드 리뷰(Sonnet ×4)
- **MCP/플러그인 활용**: `coderabbit:code-reviewer` + `feature-dev:code-reviewer` + `pr-review-toolkit:silent-failure-hunter` + `pr-review-toolkit:type-design-analyzer` (4대 병렬)
- **핵심 산출물**: Phase 10 완료 + D-85~D-87 결정 항목 + 9건 확정 이슈 목록
- **Night-35 Phase 4 대비**: 37건→5건 수정(Night-35) vs 17건→9건 확정(Night-48) — 오탐률 개선 (16%→24%)
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~48, **38회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.10b Night-46 작업 내역 (커밋 TBD)

| 작업 | 파일 | 내용 |
|------|------|------|
| Night-13~45 종합 분석 | `MORNING_BRIEFING.md` | §1~§9 전체 Night-46 반영 — Opus 전략(33세션)/Sonnet 기술/코드 결과/사용자 확인 항목 종합 |
| MCP 가용성 재점검 | `MORNING_BRIEFING.md` | 활성(feature-dev/pr-review-toolkit/superpowers)/미연결(context7/playwright/serena)/비해당(tailwind/shadcn) 분류 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — 종합 분석 세션 (Night-40~46, **8세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-46 실행 특성:**
- **Opus 4.6 직접 실행 (종합 분석)** — 사용자 요청으로 Night-13~45 종합 분석 수행
- **MCP/플러그인 미사용** — 분석 전용 세션
- **U-42 9세션 대기**: 자율 실행 한계 **확정** — PLAN_02 방향 결정 없이는 코드 진전 불가
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~46, **34회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.10b Night-45 작업 내역 (커밋 `b1786bf`, `0157f99`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING Night-44 반영 | `MORNING_BRIEFING.md` | Night-44 종합 분석 결과 반영 + 커밋 해시 갱신 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — 문서 전용 세션 (Night-40~45, **7세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-45 실행 특성:**
- **Sonnet 4.6 Sub-agent (문서)** — Night-43에 이어 문서 세션 지속
- **MCP/플러그인 미사용** — 문서 전용 세션
- **U-42 8세션 대기**: 자율 실행 한계 지속
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~45, **32회** 누적)

### 3.10c Night-44 작업 내역 (커밋 N/A)

| 작업 | 파일 | 내용 |
|------|------|------|
| Night-13~44 종합 분석 | `MORNING_BRIEFING.md` | §1~§9 전체 Night-44 반영 — Opus 전략/Sonnet 기술/코드 결과/사용자 확인 항목 종합 |
| MCP 도구 매트릭스 정밀 점검 | `MORNING_BRIEFING.md` | 즉시 사용 가능(7종)/OAuth 대기(14종)/미연결(3종)/비해당(2종) 4단계 분류 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — 종합 분석 세션 (Night-40~44, **5세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-44 실행 특성:**
- **Opus 4.6 직접 실행 (종합 분석)** — Night-41~43 Sonnet Sub-agent 패턴에서 Opus 직접 전환
- **MCP/플러그인 미사용** — 분석 전용 세션
- **U-42 7세션 대기**: 자율 실행 한계 **확정** — PLAN_02 방향 결정 없이는 코드 진전 불가
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~44, **30회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.10b Night-43 작업 내역 (커밋 `4f07c41`, `c79dad5`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING Night-42 반영 | `MORNING_BRIEFING.md` | Night-42 커밋 해시(`ed1b2b8`, `579b0e8`) 갱신 + §1.3/§2.2 Night-43 추가 |
| Night-43 결과 문서화 | `NIGHT_06_RESULT.md` | Night-43 섹션 추가 — U-42 6세션 대기 + 베이스라인 재검증 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — 문서 전용 세션 (Night-40~43, **4세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-43 실행 특성:**
- **Sonnet 4.6 Sub-agent (문서)** — 3세션 연속 Sub-agent 실행 (Night-41~43)
- **MCP/플러그인 미사용** — 문서 전용 세션
- **U-42 6세션 대기**: 자율 실행 한계 지속 — 사용자 방향 결정 없이는 코드 진전 불가
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~43, **28회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.11 Night-41 작업 내역 (커밋 `e051bb5`, `d655baf`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING Night-40 반영 | `MORNING_BRIEFING.md` | Night-40 미커밋 업데이트 반영 (날짜 수정 + 커밋 해시 보완) |
| U-39 분석 | - | Vercel 플러그인 SessionEnd hook → node 미설치 원인 규명 |
| D-81 기록 | `DECISION_LOG.md` | 3가지 수정 옵션 문서화 — 사용자 선택 대기 |
| NIGHT_06_RESULT Night-41 추가 | `NIGHT_06_RESULT.md` | Night-41 분석 결과 섹션 |

**프로덕션 코드 변경: 0건** — 분석+문서화 세션
**테스트 변경: 0건** — 360건 유지

**Night-41 실행 특성:**
- **Sonnet 4.6 Sub-agent** — PLAN_01.md 참조로 실행
- **핵심 성과**: U-39 원인 규명 — Vercel 플러그인 `session-end-cleanup.mjs` + node 미설치 조합
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~41, **24회** 누적) — **D-81로 원인 명확히 규명됨**
- **베이스라인 재검증**: Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ (Night-41 실측)

### 3.11 Night-40 작업 내역 (커밋 `222f935`, `26394e3`, `73ad4c5`)

| 작업 | 파일 | 내용 |
|------|------|------|
| MORNING_BRIEFING Night-39 반영 | `MORNING_BRIEFING.md` | Night-39 미커밋 업데이트 반영 (D-63 해소, 360건 달성) |
| PLAN_02 초안 작성 | `docs/plans/PLAN_02.md` | A~E 5방향 × 세부 실행 단계 + 위험 관리 + 체크포인트 |
| MORNING_BRIEFING Night-40 반영 | `MORNING_BRIEFING.md` | Night-40 커밋 해시 업데이트 |

**프로덕션 코드 변경: 0건** — 순수 문서화 세션 (Night-38과 동일 패턴, 2세션 연속)
**테스트 변경: 0건** — 360건 유지

**Night-40 실행 특성:**
- **Sonnet 4.6 Sub-agent (문서)** — Opus 위임 문서화 세션
- **MCP/플러그인 미사용** — 문서 전용 세션
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~40, **22회** 누적 감지)
- **핵심 산출물**: `docs/plans/PLAN_02.md` — PLAN_01 완결 후 다음 방향 5가지 구체적 blueprint

### 3.12 Night-39 결정 패턴 (D-80)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-80** | default 폴백 원문 반환 테스트 | 미정의 타입 주입 → `_ => type` 폴백 원문 반환 검증 | `'unknown_future_type'` 입력 → 원문 그대로 렌더링 — 서버 신규 타입 추가 시 UI 크래시 방지 |

### 3.12 Night-37 결정 패턴 (D-78~D-79)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-78** | go_router 메이저 업그레이드 보류 | ShellRoute observer 변경 리스크 + Dart 3.9 요구 | 16→17 보류, 기존 패턴 유지 |
| **D-79** | 의존성 부분 적용 (충돌 회피) | analyzer 충돌 범위를 식별하고 안전한 것만 적용 | cupertino_icons/intl/build_runner 적용, json 체인 보류 |

### 3.13 Night-36 결정 패턴 (D-76~D-77)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-76** | AlertType String→Dart Enum | `@JsonValue` + exhaustive switch로 컴파일타임 안전성 | PD-62 해소 — type-design-analyzer 16/40→완전 해소 |
| **D-77** | `abstract final class` 테마 상수 | ThemeExtension 불필요한 값에 경량 패턴 | AppSpacing/AppTextStyles — const 컨텍스트 호환 |

### 3.14 Night-35 결정 패턴 (D-70~D-75)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-70** | 서브에이전트 오탐 필터링 | 4건 제외 (hallucination 2 + 기존 수정 2) | code-reviewer C-1/C-2, silent-failure H-1/H-3 |
| **D-71** | FOR UPDATE 후 명시적 rollback | `SELECT FOR UPDATE` 잠금 해제 보장 | alert_service.rs 3함수 — Night-23 표준 패턴 적용 |
| **D-72** | rollback `?` → warn 패턴 | 읽기 전용 경로에서 500 전파 방지 | reward_service.rs daily_checkin 이미출석 분기 |
| **D-73** | 위험한 폴백 값 제거 | `i64::MAX` → `AppError::Internal` | auth_service.rs TTL 설정 오류 시 292년 토큰 방지 |
| **D-74** | serde(default) 일관성 | 422→400 응답 표준화 | products.rs SearchQuery.q 파라미터 누락 |
| **D-75** | UX 에러 피드백 일관성 | debugPrint → showErrorSnackBar 추가 | notification_list_screen markAsRead 실패 |

### 3.15 Night-31~34 신규 테스트 패턴 (D-58~D-69)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-58** | `switch _` default 간접 검증 | 'stable' 주입 → `_TrendChip` switch `_` → '안정' 렌더링 | 미래 새 case 추가 시 regression guard |
| **D-59** | initState 에러 분기 테스트 | `FakeRewardService(error:...)` → `_loadPoints` catch → "로드 실패" | 인라인 ProviderScope, 기존 `_buildScreen` 변경 불필요 |
| **D-60** | `_formatTime` 동적 분기 검증 | `DateTime.now()` / `.subtract(Duration(hours:1))` → '방금'/'1시간 전' | static mock 불필요, 테스트 실행 1분 미만 전제 |
| **D-61** | `find.byType(Badge)` 조건부 뱃지 | 알림 탭 Badge 존재 → `findsOneWidget` | 조건부 렌더링 위젯 타입 검증 |
| **D-62** | D-56 패턴 재활용 (Semantics label) | `widget<Semantics>().properties.label` 재사용 | 접근성 레이블 안정적 검증 — 패턴 재활용 효율 |
| **D-63** | `_transactionLabel` 8케이스 중 7개 완성 | referral_welcome_referrer / purchase_referrer / admin_adjustment | 미완성: `_` default — 추후 추가 가능 |
| **D-64** | `find.widgetWithText(ListTile, ...)` 탭 | 중복 텍스트를 위젯 타입으로 좁혀 tap — 다이얼로그 내 동명 버튼 충돌 방지 | MyPage 로그아웃 ListTile vs AlertDialog 버튼 |
| **D-65** | `_formatTime` 5개 분기 전량 커버 | 방금/N분전/N시간전/N일전/M·D — Night-31~33 누적 | M/D는 `DateTime.now().subtract(Duration(days:10))` 동적 계산 |
| **D-66** | 회원 탈퇴 다이얼로그 검증 | `_showDeleteAccountDialog` → '탈퇴'/'취소' + 경고 문구 | SettingsScreen 다이얼로그 두 종류(로그아웃+탈퇴) 동시 커버 |
| **D-67** | trend null → trailing 없음 | `findsNothing` 3종 아이콘으로 null 부재 검증 | 조건부 렌더링 `s.trend != null ?` 경로의 null 분기 |
| **D-68** | buyTimingScore null → 배지 없음 | `if (product.buyTimingScore != null)` 부재 확인 | `findsNothing`이 `findsOneWidget`보다 강력한 부재 테스트 |
| **D-69** | OnboardingScreen 완료 페이지 이동 | 전체동의 + ElevatedButton('다음') → Page 3 "준비 완료!" | `_finish()` 호출 없이 Page 3 렌더링만 검증 — 서비스 mock 불필요 |

### 3.16 Night-13~40 테스트 증가 추이

```
Night-13: 176건 ──── 기준선
Night-14: 176건 ──── 순수 함수 추출 (서버 테스트만 증가)
Night-22: 180건 ──── Flutter +16건 (CI serde 포함)
Night-23: 198건 ──── +18건 (ProductDetail/Alert/Favorites)
Night-24: 216건 ──── +18건 (MyPage/PointHistory/NotificationList)
Night-25: 238건 ──── +22건 (위젯4종+프로바이더+AlertTypeBadge13)
Night-26: 248건 ──── +10건 (AuthState6+SearchScreen4)
Night-27: 260건 ──── +12건 (Favorites/MyPage/Alert 탭)
Night-28: 272건 ──── +12건 (ProductDetail/Notification/PointHistory)
Night-29: 284건 ──── +12건 (Home/Login/Onboarding)
Night-30: 296건 ──── +12건 (다이얼로그/접근성/다중알림)
Night-31: 308건 ──── +12건 (default분기/initState에러/formatTime)
          ↑ 11개 전체 화면 확장 완료 — 단위 테스트 수확 체감 구간 진입
Night-32: 320건 ──── +12건 (탭Badge/Semantics/transactionLabel분기/description)
          ↑ Alert/Login/PointHistory 미커버 분기 전량 소진 완료
Night-33: 332건 ──── +12건 (출석완료/다이얼로그취소/formatTime전분기/탈퇴경고)
          ↑ MyPage/Notification/Settings 다이얼로그+시간분기 전량 커버 완료
Night-34: 344건 ──── +12건 (Home default/ProductDetail neutral+null/Onboarding 완료페이지)
          ↑ Home/ProductDetail/Onboarding 잔여 분기 전량 소진 — ★ 단위 테스트 포화 확정 (344건)
Night-35: 344건 ──── +0건 (Phase 4 코드 품질 리뷰 — 프로덕션 수정 5건, 테스트 변동 없음)
          ↑ Phase 전환: 테스트 → 코드 품질. 병렬 서브에이전트 ×3 복귀
Night-36: 358건 ──── +14건 (Phase 5 진입: PD-62 AlertType Enum 4건 + AppSpacing 7건 + AppTextStyles 4건 - 중복 1건)
          ↑ Phase 전환: 코드 품질 → UI/UX. DEFERRED PD-62 해소 + 테마 상수 도입
Night-37: 358건 ──── +0건 (Phase 7 간소화 + Phase 8 검증 — 기능 변경 없음, 구조 개선만)
          ↑ ★★★★★★★★★★★★★★★★★ PLAN_01 전체 완결 (8/8 Phase 완료)
Night-38: 358건 ──── +0건 (문서 완결 + PLAN_02 방향 제시 — 코드 변경 0건)
          ↑ ★★★★★★★★★★★★★★★★★★ PLAN_01 문서화 완결 + PLAN_02 교차점 (사용자 결정 대기)
Night-39: 360건 ──── +2건 (D-63 완전 해소: _transactionLabel 8/8+default 전량 커버)
          ↑ ★★★★★★★★★★★★★★★★★★★ 잔존 항목 소진 + PLAN_02 방향 2세션 연속 대기
Night-40: 360건 ──── +0건 (PLAN_02.md 초안 작성 — 코드 변경 0건, 문서 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★ PLAN_02 초안 완성 + U-42 해소 준비 (사용자 결정 3세션 대기)
Night-41: 360건 ──── +0건 (U-39 원인 규명 + D-81 문서화 — 코드 변경 0건, 분석 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★ U-39 완결 + 베이스라인 재검증 (사용자 결정 4세션 대기)
Night-42: 360건 ──── +0건 (PLAN_02 U-42 대기 + 베이스라인 재검증 — 코드 변경 0건, 문서 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★ 정체 세션: U-42 5세션 대기 (Night-38~42), 코드 변경 0건 4세션 연속
Night-43: 360건 ──── +0건 (PLAN_02 U-42 대기 + 베이스라인 재검증 — 코드 변경 0건, 문서 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★ 정체 지속: U-42 6세션 대기 (Night-38~43), 코드 변경 0건 5세션 연속
Night-44: 360건 ──── +0건 (종합 분석 + MCP 도구 매트릭스 — 코드 변경 0건, 분석 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★ 정체 확정: U-42 7세션 대기 (Night-38~44), 코드 변경 0건 6세션 연속
Night-45: 360건 ──── +0건 (Night-44 커밋 해시 갱신 + 베이스라인 재검증 — 코드 변경 0건, 문서 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★ 정체 지속: U-42 8세션 대기 (Night-38~45), 코드 변경 0건 7세션 연속
Night-46: 360건 ──── +0건 (Night-13~45 종합 분석 + MCP 재점검 — 코드 변경 0건, 분석 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★ 정체 심화: U-42 9세션 대기 (Night-38~46), 코드 변경 0건 8세션 연속
Night-47: 360건 ──── +0건 (Phase 9 의존성 분석 — 코드 변경 0건, 분석 전용. U-42 해소!)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★ 재기동: U-42 해소 → Phase 9 실행, Rust 3+Dart 8 BREAKING 식별, D-82~D-84 도출
Night-48: 360건 ──── +0건 (Phase 10 코드 품질 심층 리뷰 — 코드 변경 0건, 4대 병렬 에이전트 분석 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 10 완료: 17건→9건 확정, HIGH 2+MEDIUM 3+LOW 4, D-85~D-87 도출
Night-49: 360건 ──── +0건 (Phase 11 아키텍처 분석 — 코드 변경 0건, Rust 서버 실행경로+Flutter Provider맵 분석)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 11 완료: Rust 5건+Flutter 8건 신규 GAP, Axum GAP없음/Riverpod AsyncNotifier GAP, D-88~D-92 도출
```

### 3.17 코드베이스 규모

| 항목 | **Night-48** | Night-47 | Night-46 | 변화 (vs 47) |
|------|-------------|----------|----------|-------------|
| DB 마이그레이션 (main) | 018 | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-87** | D-84 | D-81 | **+3** (D-85~D-87) |
| 순수 함수 추출 누계 | **15개**/54테스트 | 15개/54 | 15개/54 | — |
| Silent Failure 수정 | 33건+ (잔존 0건) | 33건+ | 33건+ | — |
| 프로덕션 코드 수정 (Night-48) | **0건** | 0건 | 0건 | — (분석 전용) |
| Flutter 테스트 | **360건** | 360건 | 360건 | — |
| 커밋 (main 대비) | **79** | 77 | 75+ | **+2** (`f2319d5`, `0315310`) |
| PLAN_01 Phase 완료 | **10/14** (Phase 1-10 ✅) | 9/14 | 8/8 ✅ | **Phase 10 완료** |
| PLAN_02 초안 | **✅ 완성** | ✅ 완성 | ✅ 완성 | — |

### 3.18 순수 함수 추출 목록

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

### 4.1 활성 브랜치 (2026-04-28, Night-48)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260428_0100`** ★ | **+79 commits** | Night-13~48 전체 + **PLAN_01 Phase 1-10 완료** + PLAN_02 초안 + D-81 U-39 규명 + Phase 9 의존성 분석 + Phase 10 코드 품질 리뷰 + Flutter **360건** + Rust 207건 | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (19개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0428_0100` (32개+) | **Night-48 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260428_0100 → main (79커밋, PLAN_01 Phase 1-10 완료 + D-63 해소 + PLAN_02 초안 + D-81~D-87, 충돌 없음) → 즉시 PR 가능
2. feat/dark-mode (1커밋, 독립, 충돌 낮음)
3. fix/phase0-security-stability (보안+CD, migration 019-020, 충돌 높음)
4. feat/phase2-monthly-prices (MonthlyPriceItem 중복 확인 필요)
```

---

## 5. PLAN_01.md Phase 진행 상황

| Phase | 내용 | 상태 | Night | 결과 |
|-------|------|------|-------|------|
| **1** | 의존성 보안 감사 | ✅ 완료 | 31 | Rust CVE 0, Dart CVE 0, Skia CVE 2 (엔진 대기) |
| **2** | 프레임워크 패턴 검증 | ✅ 완료 | 31 | 서버 정합, Flutter minor GAP 2건 |
| **3** | 아키텍처 심층 분석 | ✅ 완료 | 31 | 구조적 개선 불필요 판정 |
| **4** | 코드 품질 심층 리뷰 | ✅ 완료 | 35 | 병렬 3에이전트, 37건→5건 수정 |
| **5** | Flutter UI/UX 개선 | ✅ 완료 | 36 | PD-62 AlertType Enum + AppSpacing/AppTextStyles |
| **6** | 테스트 커버리지 확장 | ✅ 포화 확정 | 30-36 | 296→**358건** (+62건) |
| **7** | 코드 간소화 | ✅ **완료** | **37** | **Rust 4헬퍼 + Flutter 2위젯 (~230줄 감소) + 의존성 3건** |
| **8** | 최종 검증 및 커밋 | ✅ **완료** | **37** | **Flutter 358건 + Rust 207건 + analyze 0 + 구조화된 커밋** |
| **9** | 의존성 보안/품질 심층 분석 | ✅ **완료** | **47** | **Rust CVE 0/Dart CVE 0 + BREAKING 3+8건 식별 + D-82~D-84 결정 도출** |
| **10** | 코드 품질 심층 리뷰 | ✅ **완료** | **48** | **병렬 4대 에이전트: 17건 발견 → 오탐 4건 제외 → 9건 확정 (HIGH 2 + MEDIUM 3 + LOW 4), D-85~D-87 도출** |
| **11** | 아키텍처 + 프레임워크 최신화 | ⏳ 대기 | — | feature-dev + WebSearch 예정 |
| **12** | 프론트엔드 UI/UX 감사 | ⏳ 대기 | — | frontend-design + figma 예정 |
| **13** | 발견 사항 기반 코드 수정 | ⏳ 대기 | — | Opus 직접 + Sonnet 병렬 예정 |
| **14** | 최종 검증 + 커밋 | ⏳ 대기 | — | flutter test + analyze 예정 |

### Phase 9 결정 사항 (D-82~D-84, Night-47)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-82** | Rust BREAKING 업그레이드 범위? | A) 전체(reqwest/jwt/sentry) B) sentry만 C) 전부 보류 | ⏳ **사용자 결정 대기** |
| **D-83** | Dart BREAKING 업그레이드 범위? | A) kakao 2.0 포함 전체 B) riverpod만 C) 전부 보류 | ⏳ **사용자 결정 대기** |
| **D-84** | Dart non-BREAKING 4건 즉시 적용? | A) 전체 B) dev만 C) 보류 | ⏳ **사용자 결정 대기** |

### Phase 10 결정 사항 (D-85~D-87, Night-48)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-85** | I-01+I-02 HIGH 2건 즉시 수정? | A) Phase 13에서 수정 B) 보류 | ⏳ **사용자 결정 대기** |
| **D-86** | I-03+I-04+PD-67 MEDIUM 3건 수정 범위? | A) 전체 B) PD-67만 C) 보류 | ⏳ **사용자 결정 대기** |
| **D-87** | LOW 4건 Phase 13 포함? | A) 포함 B) 제외 | ⏳ **사용자 결정 대기** |

### Phase 10 발견 이슈 상세 (Night-48)

| # | ID | 이슈 | 파일:위치 | 심각도 |
|---|-----|------|----------|--------|
| 1 | I-01 | `tx.rollback().await?` — rollback warn 표준 패턴 불일치 (2곳) | `reward_service.rs:381,390` | **HIGH** |
| 2 | I-02 | ALLOWED_ORIGINS 잘못된 항목 조용히 skip | `main.rs:486-490` | **HIGH** |
| 3 | I-03 | current_price 0원 예측 24h 캐시 노출 | `ai_prediction_service.rs:63` | MEDIUM |
| 4 | I-04 | NULL 포함 복합 UNIQUE — NULLS NOT DISTINCT 필요 | `products` migration | MEDIUM |
| 5 | PD-67 | `product.dart:20` priceTrend String? → PriceTrend Enum 전환 필요 | `app/lib/models/product.dart` | MEDIUM |
| 6 | I-06 | 캐시 에러 다운그레이드 | server | LOW |
| 7 | I-07 | 차트 x-인덱스 | app | LOW |
| 8 | PD-65 | 타입 설계 개선 | app | LOW |
| 9 | PD-66 | 타입 설계 개선 | app | LOW |

**오탐 4건 (제외됨)**: RadioGroup(Flutter 표준 위젯), new_balance 0 덮어쓰기(서버 정상 반환), TOCTOU(Night-22 완료), is_new 리터럴(의도적 설계)

### Phase 1 미해결 결정 (PD-58~PD-61)

> **주의**: PLAN_01의 결정 ID와 NIGHT_06_RESULT의 테스트 패턴 D-58~D-60이 번호 충돌.
> PLAN_01 결정은 **PD** (Plan Decision) 접두사로 구분.

| ID | 질문 | Opus 추천 | 상태 |
|----|------|-----------|------|
| **PD-58** | minor/patch 6건 즉시 업그레이드? | A) 전체 적용 → **Night-37에서 3건 적용, 3건 보류** | 🟡 **부분 해소** (D-79) |
| **PD-59** | BREAKING 6건 범위? | C) 전부 보류 (품질 최적화 집중) | ⏸️ **사용자 결정 대기** |
| **PD-60** | riverpod 3.0→3.3? | B) 3.0 유지 → **4.x 동반 시 해소 가능** | ⏸️ **사용자 결정 대기** (U-41) |
| **PD-61** | Sonatype MCP 인증? | B) WebSearch 대체 유지 | ⏸️ **사용자 결정 대기** (U-38) |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~48 머지 방향 | `auto/night-01-20260428_0100` (79커밋, PLAN_01 Phase 1-10 완료 + D-63 해소 + PLAN_02 초안 + D-81 + Phase 9-10 분석, Flutter **360건**, Rust 207건, audit 0건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **D-85** | Phase 10 HIGH 2건 수정 | I-01(rollback warn 불일치 2곳) + I-02(ALLOWED_ORIGINS 조용한 실패) | A) Phase 13 수정 B) 보류 |
| **D-86** | Phase 10 MEDIUM 3건 수정 범위 | I-03(0원 예측 캐시) + I-04(NULL UNIQUE) + PD-67(priceTrend Enum) | A) 전체 B) PD-67만 C) 보류 |
| **D-87** | Phase 10 LOW 4건 포함 여부 | I-06/I-07/PD-65/PD-66 (캐시 에러/차트 인덱스/타입 설계) | A) 포함 B) 제외 |
| **D-82** | Rust BREAKING 업그레이드 범위 | Phase 9 발견: reqwest 0.12→0.13, jwt 9→10, sentry 0.37→0.47 (3건 모두 메이저 API 변경) | A) 전체 B) sentry만 C) 전부 보류 |
| **D-83** | Dart BREAKING 업그레이드 범위 | Phase 9 발견: kakao 2.0, riverpod_gen 4.x, go_router 17, fl_chart 1.2 외 4건 (인증 플로우 변경 리스크 포함) | A) kakao 2.0 포함 전체 B) riverpod만 C) 전부 보류 |
| **D-84** | Dart non-BREAKING 4건 즉시 적용 | build_runner, freezed, mocktail, json_annotation (dev dependency 포함) | A) 전체 B) dev만 C) 보류 |
| ~~**U-42**~~ | ~~PLAN_02 방향 선택~~ | ~~Night-38~46 9세션 대기~~ → **Night-47에서 해소 (Phase 9 실행)** | ✅ **해소됨** |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-34** | 메이저 패키지 업그레이드 | `go_router` 17.x (D-78 보류), `fl_chart` 1.2.0, `google_sign_in` 7.x, `riverpod_generator` 4.x — breaking |
| **U-41** | riverpod_generator 4.x 동반 업그레이드 | json 체인 (D-79 보류) 해소를 위해 `riverpod_generator 4.x` + `flutter_riverpod 3.3.x` 동반 필요 |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 4개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **27개+** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | `cargo test --lib`만 실행 중 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-39** | SessionEnd hook 수정 | ⚡ **Night-41 원인 규명 완료** — Vercel 플러그인 `session-end-cleanup.mjs` + node 미설치. D-81로 3가지 수정 옵션 문서화. **사용자 선택 대기**: A)Vercel비활성화 B)node설치 C)유지 |
| **U-38** | Sonatype MCP 인증 설정 | **26세션 연속 실패** — 인증 설정하거나 영구 스킵 결정 필요 |
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | 다음 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 / BREAKING 업그레이드 중 우선순위 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |
| | Flutter 엔진 Skia CVE 모니터링 | CVE-2025-27363 + CVE-2026-3909 — Flutter stable 업데이트 시 즉시 적용 |

---

## 7. Night-48에서 해결/생성된 항목

### ✅ Night-48에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 10 코드 품질 심층 리뷰** | **HIGH** | **병렬 4대 에이전트(silent-failure-hunter + type-design-analyzer + feature-dev:code-reviewer + coderabbit) → 17건 발견 → 오탐 4건 제외 → 9건 확정** |
| **Night-48 결과 문서화** | **MEDIUM** | **MORNING_BRIEFING + NIGHT_06_RESULT + PLAN_01.md Phase 10 완료 마킹 (커밋 `f2319d5`)** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-48 실측 확인** |

### 🆕 Night-48에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-85 Phase 10 HIGH 수정** | **CRITICAL** | I-01(rollback warn 불일치 2곳) + I-02(ALLOWED_ORIGINS 조용한 실패) — Phase 13 수정 범위 |
| **D-86 Phase 10 MEDIUM 수정** | **HIGH** | I-03(0원 예측 캐시) + I-04(NULL UNIQUE) + PD-67(priceTrend Enum) — 수정 범위 결정 필요 |
| **D-87 Phase 10 LOW 포함** | **MEDIUM** | I-06/I-07/PD-65/PD-66 — Phase 13 포함 여부 |
| **PD-67 priceTrend Enum 전환** | **MEDIUM** | `Product.priceTrend` String? → PriceTrend Enum — AlertType PD-62 선례 존재, Phase 13에서 실행 가능 |
| **Phase 11~14 실행 대기** | **HIGH** | Phase 10 완료 → D-85~D-87 결정 후 Phase 11(아키텍처) 또는 Phase 13(수정 실행)으로 진행 |

---

## 7. Night-47에서 해결/생성된 항목

### ✅ Night-47에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **U-42 해소 (PLAN_02 방향 결정)** | **CRITICAL** | **사용자가 종합 실무 최적화를 지시 → 9세션 연속 대기 종료, Phase 9 즉시 실행** |
| **PLAN_01 Phase 9 의존성 분석** | **HIGH** | **Rust 11 crates + Dart 9 packages 보안/버전 분석 완료, CVE 0건 확인** |
| **PLAN_01 Phase 9-14 확장 계획** | **HIGH** | **PLAN_01.md에 6개 Phase 추가 (387줄), 도구 가용성 매트릭스 + GATE 체계 수립** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-47 실측 확인** |

### 🆕 Night-47에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-82 Rust BREAKING 범위** | **CRITICAL** | reqwest 0.13 / jwt 10 / sentry 0.47 — Phase 10 전환 조건 |
| **D-83 Dart BREAKING 범위** | **CRITICAL** | kakao 2.0 포함 8건 — 인증 플로우 변경 리스크 최고 |
| **D-84 Dart non-BREAKING 4건** | **HIGH** | build_runner/freezed/mocktail/json_annotation — 안전한 즉시 적용 후보 |
| **Phase 10~14 실행 대기** | **HIGH** | Phase 9 완료 → D-82~D-84 결정 후 Phase 10(코드 품질 리뷰 4대 에이전트)으로 진행 |

---

## Night-46에서 해결/생성된 항목

### ✅ Night-46에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **Night-13~45 종합 분석** | **HIGH** | **MORNING_BRIEFING.md §1~§9 전체 Night-46 반영 — Opus 전략(33세션)/Sonnet 기술/코드 결과/사용자 확인 항목 종합** |
| **MCP 가용성 재점검** | **MEDIUM** | **활성(feature-dev/pr-review-toolkit/superpowers)/미연결(context7/playwright/serena)/비해당(tailwind/shadcn) 재분류** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-46 실측 확인 (Night-45 대비 변동 없음)** |

### 🆕 Night-46에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **U-42 9세션 연속 대기** | **CRITICAL** | Night-38~46 — 코드 변경 0건 8세션 연속. PLAN_02 방향 선택이 프로젝트 최대 병목 **확정** |
| **자율 실행 한계(Autonomy Ceiling) 심화** | **INFO** | 9세션 연속(Night-38~46) 코드 변경 0건 — "단방향 결정 금지" 원칙의 장기 안정성 실증 |

---

## Night-45에서 해결/생성된 항목

### ✅ Night-45에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **MORNING_BRIEFING Night-44 미커밋** | **MEDIUM** | **커밋 `b1786bf`로 Night-44 종합 분석 결과 반영 + `0157f99`로 해시 갱신** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-45 실측 확인** |

### 🆕 Night-45에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **U-42 8세션 연속 대기** | **CRITICAL** | Night-38~45 — 코드 변경 0건 7세션 연속. PLAN_02 방향 선택 대기 지속 |

---

## Night-44에서 해결/생성된 항목

### ✅ Night-44에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **Night-13~44 종합 분석** | **HIGH** | **MORNING_BRIEFING.md §1~§9 전체 Night-44 반영 — Opus 전략/Sonnet 기술/코드 결과/사용자 확인 항목 종합** |
| **MCP 도구 가용성 정밀 매트릭스** | **MEDIUM** | **즉시 사용(7종)/OAuth 대기(14종)/미연결(3종)/비해당(2종) 4단계 분류 완료** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-44 실측 확인 (Night-43 대비 변동 없음)** |

### 🆕 Night-44에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **자율 실행 한계(Autonomy Ceiling) 확정** | **INFO** | 7세션 연속(Night-38~44) 코드 변경 0건 — "단방향 결정 금지" 원칙이 안정적으로 작동하는 증거 |
| **U-42 7세션 연속 대기** | **CRITICAL** | Night-38~44 — 코드 변경 0건 6세션 연속. PLAN_02 방향 선택이 프로젝트 최대 병목 **확정** |

---

## Night-43에서 해결/생성된 항목

### ✅ Night-43에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **MORNING_BRIEFING Night-42 미커밋** | **MEDIUM** | **커밋 `4f07c41`로 Night-42 커밋 해시 갱신 + §1.3/§2.2 Night-43 반영** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-43 실측 확인** |

### 🆕 Night-43에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **U-42 6세션 연속 대기** | **CRITICAL** | Night-38~43 — 코드 변경 0건 5세션 연속. PLAN_02 방향 선택이 프로젝트 최대 병목 지속 |

---

## Night-42에서 해결/생성된 항목

### ✅ Night-42에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **MORNING_BRIEFING Night-41 미커밋** | **MEDIUM** | **커밋 `ed1b2b8`로 Night-41 커밋 해시(TBD → `e051bb5`, `d655baf`) 갱신 완료** |
| **Night-42 결과 문서화** | **MEDIUM** | **커밋 `579b0e8`로 NIGHT_06_RESULT Night-42 섹션 + MORNING_BRIEFING 반영** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-42 실측 확인 (Night-41 대비 변동 없음)** |

### 🆕 Night-42에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **자율 실행 한계 패턴 확인** | **INFO** | PLAN_01 완결 + 잔존 항목 소진 후 사용자 방향 없이는 코드 진전 불가 — 올바른 동작으로 판단 |
| **U-42 5세션 연속 대기** | **CRITICAL** | Night-38~42 — 코드 변경 0건 4세션 연속. PLAN_02 방향 선택이 프로젝트 최대 병목 지속 |

---

## Night-41에서 해결/생성된 항목

### ✅ Night-41에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **U-39 SessionEnd hook 원인 규명** | **MEDIUM** | **D-81: Vercel 플러그인 `session-end-cleanup.mjs` + node 미설치 조합 확인 — 3가지 수정 옵션 문서화** |
| **MORNING_BRIEFING Night-40 미커밋** | **MEDIUM** | **커밋 `e051bb5`로 Night-40 업데이트(날짜 수정 + 커밋 해시 보완) 반영 완료** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-41 실측 확인** |

### 🆕 Night-41에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-81 SessionEnd hook 수정 옵션** | **MEDIUM** | A)Vercel 비활성화(권장) B)Node.js 설치 C)현 상태 유지 — **사용자 선택 대기** |
| **U-42 5세션 연속 대기** | **CRITICAL** | Night-38~41 + 현재 — 사용자 방향 결정 없이는 의미 있는 코드 진전 불가 |

---

## Night-40에서 해결/생성된 항목

### ✅ Night-40에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **MORNING_BRIEFING Night-39 미커밋** | **MEDIUM** | **커밋 `222f935`로 Night-39 업데이트 반영 완료** |
| **PLAN_02 초안 작성** | **HIGH** | **`docs/plans/PLAN_02.md` 신규 생성 — A~E 5방향 × 세부 실행 단계 + 브랜치 머지 전제 조건** |

### 🆕 Night-40에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **docs/plans/PLAN_02.md** | **HIGH** | 5가지 방향(A~E) 각각의 구체적 실행 계획 + 위험 관리 + 체크포인트 |

---

## Night-39에서 해결/생성된 항목

### ✅ Night-39에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **D-63 완전 해소** | **HIGH** | **`_transactionLabel` 8/8 명시 케이스 + default 전량 커버 — Night-32에서 시작, Night-39에서 완결** |
| **MORNING_BRIEFING Night-38 미커밋** | **MEDIUM** | **커밋 `aebf3d5`로 Night-38 업데이트 반영 완료** |
| **Flutter 360건 달성** | **MEDIUM** | **358 → 360건 (+2건) — PLAN_01 이후 첫 테스트 추가** |

### 🆕 Night-39에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-80 default 폴백 테스트 패턴** | **LOW** | 신규 패턴 — 서버-클라이언트 forward compatibility 보장 |
| **PLAN_02 대기 2세션 연속** | **CRITICAL** | U-42 미결 지속 — 사용자 방향 결정 없이는 의미 있는 진전 불가 |

### ✅ Night-38에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **MORNING_BRIEFING 종합 업데이트** | **HIGH** | **Night-37 전략/코드/지표 섹션 전체 추가 — PLAN_01 문서화 완결** |
| **기준선 재검증** | **MEDIUM** | **Flutter 358건 / Rust 207건 / analyze 0건 — 변동 없음 확인** |
| **PLAN_02 방향 제시** | **HIGH** | **A~E 5가지 선택지 + MCP/플러그인 실측 현황 점검** |

### ✅ Night-37에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 7 코드 간소화** | **HIGH** | **Rust 4헬퍼 (~125줄) + Flutter 2위젯 (~105줄) 추출 — 기능 변경 없이 구조 개선** |
| **PLAN_01 Phase 8 최종 검증 + 커밋** | **HIGH** | **Flutter 358건 + Rust 207건 + analyze 0 + 구조화된 커밋 3개** |
| **PLAN_01 전체 완결** | **CRITICAL** | **8개 Phase 전체 완료 (Night-30 수립 → Night-37 완결, 7일 8세션)** |
| 의존성 3건 업그레이드 | MEDIUM | cupertino_icons 1.0.9 / intl 0.20 / build_runner 2.13 |
| D-78 go_router 보류 결정 | MEDIUM | ShellRoute observer 변경 리스크 → 보류 판정 |
| D-79 json 체인 충돌 식별 | MEDIUM | `riverpod_generator ^3.0.0` ↔ `analyzer <9.0.0` 충돌 → 해결 경로 문서화 |

### ✅ Night-36에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PD-62 AlertType String→Dart Enum 전환** | **HIGH** | **D-76: `@JsonValue` + exhaustive switch — 컴파일타임 타입 안전성 확보** |
| **PLAN_01 Phase 5-B 테마 시스템 강화** | **HIGH** | **D-77: AppSpacing 6단계 + AppTextStyles 4종 — `abstract final class + static const`** |
| Phase 5-A UI 패턴 분석 | MEDIUM | Sonnet ×3 탐색: 11개 화면 3,488줄 분석 → Phase 5/7 대상 식별 |
| AlertType enum 테스트 커버리지 | MEDIUM | alert_type_badge_test +3건 (AlertType.value extension 검증) |
| 테마 상수 테스트 커버리지 | MEDIUM | theme_test +11건 (AppSpacing 7건 + AppTextStyles 4건) |

### ✅ Night-35에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 4 코드 품질 심층 리뷰** | **HIGH** | **병렬 3에이전트 → 37건 발견 → 오탐 6건 제외 → 5건 수정** |
| alert_service FOR UPDATE 잠금 해제 미보장 | HIGH | D-71: 3함수에 명시적 rollback + warn 패턴 추가 |
| reward_service rollback 500 노출 | HIGH | D-72: `?` → warn 패턴으로 전환 |
| auth_service TTL i64::MAX 보안 결함 | **CRITICAL** | D-73: `unwrap_or(i64::MAX)` → `AppError::Internal` (292년 토큰 발행 방지) |
| products SearchQuery 422 비표준 응답 | MEDIUM | D-74: `#[serde(default)]` 추가 |
| notification markAsRead 에러 피드백 부재 | MEDIUM | D-75: `showErrorSnackBar` 추가 |

### ✅ Night-34에서 해결됨 (이전 세션)

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| HomeScreen trend stable/null 분기 미커버 | MEDIUM | +4건 (stable→`trending_flat`, null trailing 없음, rank 번호, URL 취소) |
| ProductDetailScreen neutral/null 분기 미커버 | MEDIUM | +4건 (평균가, neutral→"보합", 요일별 타이틀, buyTimingScore null 배지없음) |
| OnboardingScreen 완료 페이지 미커버 | MEDIUM | +4건 (히스토리 설명, 센트 보상, 이용약관 개별, 완료 "준비 완료!") |
| **Phase 6 포화 확정** | HIGH | **344건 — 11개 화면 전체 분기 소진 완료, 10세션 연속 +12건 균일 달성** |

### ✅ Night-33에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| MyPage 출석완료/로그아웃 다이얼로그 미커버 | MEDIUM | +4건 (출석완료 버튼, 복사tooltip, 로그아웃 다이얼로그, 취소닫힘) |
| NotificationList `_formatTime` 미커버 분기 | MEDIUM | +4건 (5분전, 2일전, M/D날짜, system아이콘) — **5개 분기 전량 커버 완료** |
| Settings 탈퇴/로그아웃 다이얼로그 미커버 | MEDIUM | +4건 (탈퇴 버튼, 탈퇴 취소, 로그아웃 확인, 경고 문구) |

### ✅ Night-32에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| Alert AppBar/에러/Badge 미커버 | MEDIUM | +4건 (add버튼, 다시시도, 탭Badge, threshold) |
| Login Google아이콘/Semantics 미커버 | MEDIUM | +4건 (Google아이콘, 로고레이블, TextButton, SafeArea) |
| PointHistory transactionLabel 미완 분기 | MEDIUM | +4건 (referral_welcome/purchase_referrer, admin_adjustment, description) |
| `_transactionLabel` 8케이스 중 7개 완성 | MEDIUM | D-63: default(_) 1케이스만 잔존 |

### ✅ Night-31에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| PLAN_01 Phase 1 의존성 보안 감사 | HIGH | WebSearch 대체로 Rust 30개 + Dart 17개 CVE 검증 완료 |
| PLAN_01 Phase 2 프레임워크 GAP 분석 | HIGH | 서버 정합 확인, Flutter minor GAP 2건 식별 |
| PLAN_01 Phase 3 아키텍처 심층 분석 | HIGH | 구조적 개선 불필요 판정 |

### ⏳ 잔존 항목 (PLAN_01 이후)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| **riverpod_generator 4.x 동반 업그레이드** | **HIGH** | **D-79 json 체인 충돌 해소 전제 — riverpod 3.3.x + generator 4.x 동반 필요** |
| **메이저 패키지 업그레이드 6건** | **HIGH** | breaking changes — go_router 17(D-78), fl_chart 1.2, google_sign_in 7.x 등 |
| ~~PLAN_01 Phase 5/7/8~~ | ~~HIGH~~ | ~~**✅ Night-36~37에서 전체 완료**~~ |
| ~~AlertType String→Enum~~ | ~~HIGH~~ | ~~**PD-62: ✅ Night-36에서 해소**~~ |
| 미머지 브랜치 4개 통합 | MEDIUM | 충돌 해결 + 머지 순서 결정 필요 |
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 (26세션 연속) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| ~~`_transactionLabel` default 케이스~~ | ~~LOW~~ | ~~D-63: **✅ Night-39에서 완전 해소** (8/8 + default)~~ |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 27개+ 정리 | LOW | 사용자 승인 대기 |
| SessionEnd hook `node` 미설치 | LOW | **Night-41 원인 규명 완료** — D-81: Vercel plugin hook, **38회** 누적. 옵션 A(비활성화, 권장)/B(설치)/C(유지) **사용자 결정 대기** |
| Flutter Skia CVE 2건 | INFO | Flutter 팀 패치 대기 — 코드 변경 불가 |
| **PLAN_01 Phase 1-10 완료** | **INFO** | **8/8 + Phase 9~10 완결 — Night-30 수립 → Night-37 Phase 1-8 → Night-47 Phase 9 → Night-48 Phase 10** |
| ~~PLAN_02 방향 대기~~ | ~~CRITICAL~~ | ~~사용자 결정 9세션 연속 대기~~ → **✅ Night-47 U-42 해소** |
| **D-82~D-84 결정 대기** | **CRITICAL** | **Phase 9 업그레이드 범위 — Rust/Dart BREAKING 범위 사용자 결정 필요** |
| **D-85~D-87 결정 대기** | **CRITICAL** | **Phase 10 수정 범위 — HIGH 2건 + MEDIUM 3건 + LOW 4건 실행 범위 사용자 결정 필요** |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-04-28, Night-48 실측)

| 지표 | **Night-48** | Night-47 | Night-46 | 변화 (vs 47) |
|------|------------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** ✅ | 207 | 207 | — |
| Flutter 테스트 | **360** ✅ | 360 | 360 | — |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | — |
| DECISION_LOG | **D-87** | D-84 | D-81 | **+3** (D-85~D-87) |
| PLAN_01 Phase 완료 | **10/14** (Phase 1-10 ✅) | 9/14 | 8/8 ✅ | **Phase 10 완료** |
| PLAN_02 초안 | **✅ 완성** | ✅ 완성 | ✅ 완성 | — |
| Silent Failure 수정 | **33건+** (잔존 0건) | 33건+ | 33건+ | — |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | — |
| showErrorSnackBar 통합 | **12개소** | 12개소 | 12개소 | — |
| serde rename_all 적용 enum | **7개** | 7개 | 7개 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 | 0건 | — |
| 위젯 테스트 커버리지 | **4/4** ✅ | 4/4 | 4/4 | — |
| FakeService 패턴 | **3종** | 3종 | 3종 | — |
| 순수 함수 추출 | **15개**/54테스트 | 15개/54 | 15개/54 | — |
| rollback warn 패턴 | **8곳** | 8곳 | 8곳 | — |
| 커밋 (main 대비) | **79** | 77 | 75+ | **+2** |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **완결** ✅ |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **해결됨** ✅ (AppColors + AppSpacing + AppTextStyles) |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (20건) |
| API 계약 정합성 | **완료** ✅ (serde 7개 + CI) |
| serde 파급 누락 방지 | **해결됨** ✅ (CI 자동검사) |
| TOCTOU 경쟁 조건 | **해결됨** ✅ |
| 의존성 보안 | **해결됨** ✅ (Rust 0건, Dart 0건) |
| Flutter 테스트 커버리지 | **포화 확정** ✅ (358건) |
| **PLAN_01 전체** | **✅ 완료 (8/8 Phase)** 🎉 |
| 코드 품질 심층 리뷰 | **완료** ✅ (Phase 4: 37건 발견, 5건 수정) |
| 코드 간소화 | **완료** ✅ (Phase 7: Rust ~125줄 + Flutter ~105줄 감소) |
| AlertType String→Enum | **완료** ✅ (PD-62, Night-36) |
| riverpod_generator + json 체인 | **보류** ⚠️ (analyzer 충돌 — 4.x 동반 필요) |
| 미머지 브랜치 통합 | **적체** ⚠️ (4개) |
| auto 브랜치 정리 | **미처리** ⚠️ (26개+) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (25세션 연속) |
| RUSTSEC-2026-0049 | **모니터링** ⚠️ (audit.toml ignore) |
| Flutter Skia CVE 2건 | **대기** ⚠️ (엔진 패치 필요) |
| SessionEnd hook | **원인 규명 완료** (D-81: Vercel plugin. **38회** 감지. A/B/C 옵션 대기) |
| ~~PLAN_02 방향~~ | **✅ 해소** (U-42: Night-47에서 사용자 지시 → Phase 9 실행) |
| **Phase 10 코드 품질 심층 리뷰** | **✅ 완료** (9건 확정: HIGH 2 + MEDIUM 3 + LOW 4) |
| **Phase 10 → Phase 11/13 전환** | **대기 중** ⚠️ **(D-85~D-87: 수정 범위 + D-82~D-84: BREAKING 업그레이드 범위 사용자 결정 필요)** |

---

## 9. 다음 세션 선택지 (Phase 10 완료, Phase 11 대기 — Night-48 업데이트)

> **PLAN_01 Phase 1-10 완료 + D-63 해소 + U-42 해소 + Phase 9 의존성 + Phase 10 코드 품질 완료.**
> **Night-48: 코드 변경 0건, D-85~D-87(Phase 10 수정 범위) + D-82~D-84(업그레이드 범위) 사용자 결정 대기.**
> **⚠️ 다음 결정 사항**: (1) D-85~D-87 Phase 10 수정 범위, (2) D-82~D-84 업그레이드 범위, (3) 브랜치 머지 방향 (U-3), (4) SessionEnd hook 수정 (D-81)

### 9.1 즉시 실행 가능

| 선택지 | 설명 | 활용 도구 | 예상 규모 |
|--------|------|-----------|----------|
| **A) D-85~D-87 결정 → Phase 11 또는 Phase 13 진입** | Phase 10 수정 범위 확정 후: Phase 11(아키텍처 분석) 또는 Phase 13(수정 즉시 실행) | feature-dev / Opus 직접 | 중형 |
| **B) 브랜치 Push + PR 생성** | `auto/night-01-20260428_0100` (79커밋) push → GitHub PR → main 머지 | commit-commands | 소형 |
| **C) SessionEnd hook 수정** | D-81 옵션 A(Vercel 비활성화) → `~/.claude/settings.json` 수정 | 설정 변경 | 소형 |
| **D) Dart non-BREAKING 4건 즉시 적용** | D-84 A) 선택 시 — build_runner/freezed/mocktail/json_annotation 업그레이드 | pub upgrade | 소형 |

### 9.2 Phase 11~14 실행 로드맵 (D-85~D-87 + D-82~D-84 결정 후)

> **상세 실행 계획**: `docs/plans/PLAN_01.md` Phase 9-14 참조

| Phase | 목표 | 주요 도구 | 예상 규모 | 상태 |
|-------|------|-----------|----------|------|
| ~~**10**~~ | ~~코드 품질 심층 리뷰~~ | ~~4대 병렬~~ | ~~중형~~ | **✅ Night-48 완료** |
| **11** | 아키텍처 + 프레임워크 최신화 | feature-dev:code-explorer + code-architect + WebSearch | 중형 (1~2 세션) | ⏳ 대기 |
| **12** | 프론트엔드 UI/UX 감사 | frontend-design + figma + code-simplifier | 중형 (1~2 세션) | ⏳ 대기 |
| **13** | 승인된 수정 실행 (Phase 9+10 확정분) | Opus 직접 + Sonnet 병렬 | 대형 (2~3 세션) | ⏳ 대기 |
| **14** | 최종 검증 + 구조화된 커밋 | flutter test/analyze + commit-commands | 소형 (1 세션) | ⏳ 대기 |

**Opus 추천 (Night-48 기준):**
1. **즉시**: D-85 A(HIGH 2건 수정) + D-84 A(non-BREAKING 4건 적용) + D-81 옵션 A(Vercel 비활성화)
2. **Phase 13 빠른 진입**: D-85~D-87 + D-82~D-84 일괄 결정 → Phase 11/12 스킵하고 Phase 13 수정 즉시 실행 가능 (Phase 9+10 확정분 충분)
3. **브랜치 머지**: Phase 14 완료 후 통합 PR이 효율적 (중간 커밋 적체 방지)

### 9.3 MCP/플러그인 가용성 (Night-48 실측)

| 도구 | 상태 | 활용 이력 | Phase 11~14 활용 |
|------|------|-----------|-----------------|
| sonatype-guide | ✅ (인증 미설정, **26세션**) | Phase 1/9 (WebSearch 대체) | Phase 13 업그레이드 시 |
| feature-dev (3종) | ✅ 활성 | Phase 4/5/7/9 탐색 | Phase 11 탐색 |
| pr-review-toolkit (6종) | ✅ 활성 | Phase 4/7/10 리뷰 | Phase 13 수정 리뷰 |
| coderabbit | ✅ 활성 | Night-23 + Night-48 Phase 10 | Phase 13 코드 리뷰 |
| frontend-design | ✅ 활성 | Phase 5 UI/UX | Phase 12 감사 |
| figma (6종) | ✅ 활성 | 미사용 | Phase 12 디자인 시스템 |
| code-simplifier | ✅ 활성 | Phase 7 간소화 | Phase 12~13 간소화 |
| commit-commands | ✅ 활성 | Phase 8 커밋 | Phase 14 커밋 |
| superpowers (12 skills) | ✅ 활성 | 전체 | 전체 |
| ralph-loop (limit: 10) | ✅ 활성 | 반복 모니터링 | Phase 13~14 |
| context7 | ✅ 설치됨 (**미연결**) | WebSearch로 대체 | Phase 11 문서 조회 |
| playwright / serena | ✅ 설치됨 (**미연결**) | 미사용 | E2E 필요 시 |
| mcp-tailwind-gemini / shadcn | **비해당** | — | Flutter 프로젝트 |
| chatgpt-mcp / sequential-thinking | **미설치** | brainstorm/WebSearch 대체 | 불필요 |

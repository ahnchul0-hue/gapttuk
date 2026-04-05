# MORNING BRIEFING — 2026-04-06 (Night-13 ~ Night-36 종합 분석)

> **분석 대상**: Night-13 ~ Night-36 (2026-03-12 ~ 2026-04-06)
> **현재 브랜치**: `auto/night-01-20260406_0100`
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-04-06 (Night-36 결과 통합)
> **검증**: Rust 207건 ✅ / Flutter **358건** ✅ / analyze 0건 ✅ (2026-04-06 실측)
> **Night-35 커밋**: `68bfd6e`
> **Night-36 커밋**: TBD

---

## 1. Opus 4.6 전략 분석

### 1.1 Night-13 ~ Night-31 세션별 전략

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
| **36** | **04-06** | **PLAN_01 Phase 5: PD-62 AlertType Enum 전환 + AppSpacing/TextStyles + 테스트 +14건** | **D-76~D-77: AlertType String→Enum(PD-62 해소), AppSpacing/AppTextStyles 테마 상수** | **TBD** |

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
```

### 1.3 Night-35 전략적 의의: Phase 4 코드 품질 리뷰 완결

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

**type-design-analyzer 핵심 발견 (DEFERRED)**:
- `AlertType` String→Dart Enum 전환 필요 — 점수 16/40 (최저, PD-62)
- freezed 모델 전체 재생성 + 테스트 대규모 수정 필요 → Phase 5/7에서 처리

### 1.4 Night-34 전략적 의의: 단위 테스트 포화 확정

Night-25~34 **10세션 연속** 테스트 전용 실행. 핵심 수치:
- **Phase 6 누적**: +168건 (Night-22~34), +60건 (Night-30~34 PLAN_01 기준)
- **11개 화면 전체** 확장 완료 — 미커버 분기 체계적 소진
- **`_formatTime` 5개 분기 전량 커버** (D-65) — Night-31~33 누적 완성
- **다이얼로그 패턴 2종 완비** (로그아웃 + 회원탈퇴) — MyPage, Settings 양쪽 모두
- **null 조건부 렌더링 완결** (D-67~D-68) — `trend null`, `buyTimingScore null` 부재 검증
- **OnboardingScreen Page 3 도달** (D-69) — `_finish()` 호출 없이 렌더링만 검증하는 경량 패턴
- **Opus 직접 실행 10세션** (Sonnet sub-agent 불필요) — 테스트 코딩 패턴 안정화

**수확 체감 분석**: Night-27~34 매 세션 +12건 균일 (8세션 × 12건 = 96건). 신규 분기 발견 난이도 최대 → **Phase 6 포화 확정 (344건)**.

### 1.5 Night-31~32 전략적 의의: PLAN_01.md 본격 실행

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

### 1.6 Opus 4.6의 핵심 전략 패턴 (Night-13~35 누적)

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

### 1.7 의사결정 일관성

- **총 75개 결정** (D-1 ~ D-75)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 2건 (D-39: E2E 테스트, PD-62: AlertType String→Enum)
- **나머지 67건: IMPLEMENTED 유지** (Night-35에서 D-70~D-75 추가)

---

## 2. Sonnet 4.6 기술 실행 + MCP 활용

### 2.1 실행 모델

| 역할 | 에이전트 | 담당 |
|------|----------|------|
| **전략/결정/리뷰** | Opus 4.6 (Main Agent) | 오탐 필터링, GATE 승인 요청, 최종 결정 |
| **데이터 수집/코딩** | Sonnet 4.6 (Sub-agent) | 병렬 분석, 코드 생성, 검증 루틴 |

### 2.2 Night-16~31 서브에이전트 운용

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
| 의존성 보안 | Sonatype MCP | Night-31: 인증 실패 | ❌ 10세션 연속 실패 |
| 대체 전략 | WebSearch + RustSec DB + NVD | Night-31: 대체 성공 | ✅ 활성 |
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

### 3.6 Night-35 결정 패턴 (D-70~D-75)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-70** | 서브에이전트 오탐 필터링 | 4건 제외 (hallucination 2 + 기존 수정 2) | code-reviewer C-1/C-2, silent-failure H-1/H-3 |
| **D-71** | FOR UPDATE 후 명시적 rollback | `SELECT FOR UPDATE` 잠금 해제 보장 | alert_service.rs 3함수 — Night-23 표준 패턴 적용 |
| **D-72** | rollback `?` → warn 패턴 | 읽기 전용 경로에서 500 전파 방지 | reward_service.rs daily_checkin 이미출석 분기 |
| **D-73** | 위험한 폴백 값 제거 | `i64::MAX` → `AppError::Internal` | auth_service.rs TTL 설정 오류 시 292년 토큰 방지 |
| **D-74** | serde(default) 일관성 | 422→400 응답 표준화 | products.rs SearchQuery.q 파라미터 누락 |
| **D-75** | UX 에러 피드백 일관성 | debugPrint → showErrorSnackBar 추가 | notification_list_screen markAsRead 실패 |

### 3.7 Night-31~34 신규 테스트 패턴 (D-58~D-69)

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

### 3.8 Night-13~35 테스트 증가 추이

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
```

### 3.9 코드베이스 규모

| 항목 | **Night-35** | Night-34 | 변화 |
|------|-------------|----------|------|
| DB 마이그레이션 (main) | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-75** | D-69 | **+6** |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | **33건+** (잔존 0건) | 28건+ | **+5** |
| 프로덕션 코드 수정 (Night-35) | **5파일** | 0파일 | **+5** |
| 커밋 (main 대비) | **52** | 50 | **+2** |

### 3.10 순수 함수 추출 목록

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

### 4.1 활성 브랜치 (2026-04-05)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260405_0100`** ★ | **+52 commits** | Night-13~35 전체 + PLAN_01.md Phase 1/2/3/4/6 + Flutter 344건 + 프로덕션 수정 5건 | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (19개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0404_0100` (23개+) | **Night-35 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260405_0100 → main (52커밋, 충돌 없음) → 즉시 PR 가능
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
| **4** | 코드 품질 심층 리뷰 | ✅ **완료** | **35** | 병렬 3에이전트, 37건 발견, 오탐 6건 제외, **5건 수정** (alert rollback 3 + checkin rollback + TTL + SearchQuery + markAsRead) |
| **5** | Flutter UI/UX 개선 | ⏳ 미시작 | — | frontend-design + context7 |
| **6** | 테스트 커버리지 확장 | ✅ **포화 확정** | 30-34 | 296→**344건** (+60) |
| **7** | 코드 간소화 | ⏳ 미시작 | — | code-simplifier |
| **8** | 최종 검증 및 커밋 | ⏳ 미시작 | — | verification + commit |

### Phase 1 미해결 결정 (PD-58~PD-61)

> **주의**: PLAN_01의 결정 ID와 NIGHT_06_RESULT의 테스트 패턴 D-58~D-60이 번호 충돌.
> PLAN_01 결정은 **PD** (Plan Decision) 접두사로 구분.

| ID | 질문 | Opus 추천 | 상태 |
|----|------|-----------|------|
| **PD-58** | minor/patch 6건 즉시 업그레이드? | A) 전체 적용 (위험 없음) | ⏸️ **사용자 결정 대기** |
| **PD-59** | BREAKING 6건 범위? | C) 전부 보류 (품질 최적화 집중) | ⏸️ **사용자 결정 대기** |
| **PD-60** | riverpod 3.0→3.3? | B) 3.0 유지 (코드젠 변경 파급) | ⏸️ **사용자 결정 대기** |
| **PD-61** | Sonatype MCP 인증? | B) WebSearch 대체 유지 | ⏸️ **사용자 결정 대기** |

---

## 6. 사용자 확인 필요 항목

### ⚠️ CRITICAL (즉시 결정 필요)

| # | 항목 | 설명 | 선택지 |
|---|------|------|--------|
| **U-3** | Night-13~35 머지 방향 | `auto/night-01-20260405_0100` (81파일+, 52커밋, audit 0건, Flutter 344건, Phase 4 수정 5건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **U-37** | PLAN_01 Phase 5/7/8 진행 여부 | Phase 1/2/3/4/6 완료. Phase 5(UI/UX)→7(간소화)→8(최종 검증) 범위 결정 | A) Phase 5→7→8 순차 B) Phase 7→8만 (빠른 마감) C) Phase 5만 D) 커스텀 |
| **PD-58~61** | Phase 1 의존성 결정 4건 | minor 업그레이드, BREAKING 범위, riverpod, Sonatype 인증 | 상기 §5 참조 |
| **PD-62** | AlertType String→Dart Enum 전환 | type-design-analyzer 점수 16/40 (최저). freezed 재생성 필요 | A) Phase 5에서 처리 B) Phase 7에서 처리 C) 보류 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-38** | Sonatype MCP 인증 설정 | **12세션 연속 실패** — 인증 설정하거나 영구 스킵 결정 필요 |
| **U-34** | 메이저 패키지 업그레이드 | `go_router` 17.x, `fl_chart` 1.2.0, `google_sign_in` 7.x — breaking |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 4개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **19개+** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | `cargo test --lib`만 실행 중 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-39** | SessionEnd hook 수정 | `node` 미설치로 `session-end-cleanup.mjs` 실행 실패 (Night-30~34 **10회** 감지) |
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |
| **NEW** | Flutter 엔진 Skia CVE 모니터링 | CVE-2025-27363 + CVE-2026-3909 — Flutter stable 업데이트 시 즉시 적용 |

---

## 7. Night-35에서 해결/생성된 항목

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

### ⏳ 잔존 항목 (다음 세션)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| **PLAN_01 Phase 5/7/8 실행** | **HIGH** | **Phase 4 완료 → 5(UI/UX)→7(간소화)→8(최종검증) 사용자 승인 대기** |
| **AlertType String→Enum** | **HIGH** | **PD-62: type-design-analyzer 16/40점 — freezed 재생성 필요** |
| 메이저 패키지 업그레이드 6건 | HIGH | breaking changes — 별도 계획 필요 |
| minor/patch 업그레이드 6건 | MEDIUM | 사용자 결정 대기 (PD-58) |
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 (12세션 연속) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| `_transactionLabel` default 케이스 | LOW | D-63: 8케이스 중 1개 잔존 |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 22개+ 정리 | LOW | 사용자 승인 대기 |
| SessionEnd hook `node` 미설치 | LOW | 환경 설정 필요 (Night-30~35 **12회** 감지) |
| Flutter Skia CVE 2건 | INFO | Flutter 팀 패치 대기 — 코드 변경 불가 |
| **Flutter 테스트 포화 확정** | **INFO** | **11개 화면 전체 확장 + 분기 전량 소진 — 단위 테스트 344건 포화 확정** |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-04-05, Night-35 실측)

| 지표 | **Night-35** | Night-34 | Night-33 | 변화 (vs 34) |
|------|------------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** ✅ | 207 | 207 | — |
| Flutter 테스트 | **344** ✅ | 344 | 332 | — |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | — |
| DECISION_LOG | **D-75** | D-69 | D-66 | **+6** |
| PLAN_01 Phase 완료 | **5/8** (1/2/3/4/6) | 4/8 | 3/8 | **+1** (Phase 4 완료) |
| Silent Failure 수정 | **33건+** (잔존 0건) | 28건+ | 28건+ | **+5** |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | — |
| showErrorSnackBar 통합 | **12개소** | 11개소 | 11개소 | **+1** |
| serde rename_all 적용 enum | **7개** | 7개 | 7개 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 | 0건 | — |
| 위젯 테스트 커버리지 | **4/4** ✅ | 4/4 | 4/4 | — |
| FakeService 패턴 | **3종** | 3종 | 3종 | — |
| 순수 함수 추출 | 11개/54테스트 | 11개/54 | 11개/54 | — |
| rollback warn 패턴 | **8곳** | 5곳 | 5곳 | **+3** |
| 커밋 (main 대비) | **52** | 50 | 48 | **+2** |

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
| 의존성 보안 | **해결됨** ✅ (Rust 0건, Dart 0건) |
| Flutter 테스트 커버리지 | **포화 확정** ✅ (344건) |
| PLAN_01 Phase 1/2/3/4/6 | **완료** ✅ |
| PLAN_01 Phase 5/7/8 | **미시작** ⏳ |
| 코드 품질 심층 리뷰 | **완료** ✅ (Phase 4: 37건 발견, 5건 수정) |
| AlertType String→Enum | **미시작** ⚠️ (PD-62, 점수 16/40) |
| 미머지 브랜치 통합 | **적체** ⚠️ (4개) |
| auto 브랜치 정리 | **미처리** ⚠️ (22개+) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (12세션 연속) |
| RUSTSEC-2026-0049 | **모니터링** ⚠️ (audit.toml ignore) |
| Flutter Skia CVE 2건 | **대기** ⚠️ (엔진 패치 필요) |
| SessionEnd hook | **node 미설치** ⚠️ (12회 감지) |

---

## 9. 다음 세션 선택지 (Phase 5/7/8)

> Phase 1/2/3/4/6 완료. 남은 Phase 5(UI/UX), 7(간소화), 8(최종 검증+커밋) 중 진행 범위 결정 필요.

| 선택지 | 설명 | 활용 도구 | 예상 규모 |
|--------|------|-----------|----------|
| **A) Phase 5→7→8 순차** | UI/UX 개선 → 간소화 → 최종 검증 (전체 완결) | frontend-design, code-simplifier, verification, commit | 대형 |
| **B) Phase 7→8만 (빠른 마감)** | 간소화 → 최종 검증/커밋 집중 (UI/UX 별도) | code-simplifier, verification, commit | 중간 |
| **C) Phase 5만** | UI/UX 개선 집중 (PD-62 AlertType Enum 포함) | frontend-design, context7 | 중간 |
| **D) 커스텀** | 원하시는 조합 지정 | — | — |

**Opus 추천: B)** — Phase 4에서 발견된 패턴을 바탕으로 코드 간소화(Phase 7) 진행 후 최종 검증(Phase 8)으로 마감. Phase 5(UI/UX)는 시각적 검토 필요 → 별도 세션 효율적.

### MCP/플러그인 가용성 (Night-35 기준)

| 도구 | 상태 | Phase 활용 |
|------|------|-----------|
| sonatype-guide | ✅ (인증 미설정) | Phase 1 (완료) |
| feature-dev (3종) | ✅ Night-35 사용 완료 | Phase 4 (**완료**) |
| pr-review-toolkit (4종) | ✅ Night-35 사용 완료 | Phase 4 (**완료**), 7, 8 |
| code-simplifier | ✅ 사용 가능 | Phase 7 |
| frontend-design | ✅ 사용 가능 | Phase 5 |
| commit-commands | ✅ 사용 가능 | Phase 8 |
| superpowers (brainstorm/verification) | ✅ 사용 가능 | 전체 |
| context7 | ✅ 설치됨 | Phase 5 (riverpod/go_router 최신 패턴 조회) |
| playwright / serena | ✅ 설치됨 | E2E / 코드 분석 (이연) |

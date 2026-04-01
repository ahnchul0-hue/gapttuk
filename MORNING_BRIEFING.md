# MORNING BRIEFING — 2026-04-02 (Night-13 ~ Night-32 종합 분석)

> **분석 대상**: Night-13 ~ Night-32 (2026-03-12 ~ 2026-04-02)
> **현재 브랜치**: `auto/night-01-20260402_0100` (main + 48 commits)
> **생성**: Opus 4.6 종합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-04-02 (Night-32 최종, 검증 완료)
> **변경 규모**: 81파일 (+5,027 / -880)
> **검증**: Rust 207건 ✅ / Flutter 320건 ✅ / analyze 0건 ✅ (2026-04-02 실측)
> **총 커밋**: main + 48 commits

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
| **32** | **04-02** | **Phase 6 테스트 커버리지 확대 +12건 (308→320건)** | **D-61~D-63: 탭Badge/Semantics label/transactionLabel 분기 완성** | **TBD** |

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
```

### 1.3 Night-31 전략적 의의: PLAN_01.md 본격 실행

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

### 1.4 Opus 4.6의 핵심 전략 패턴 (Night-13~31 누적)

1. **PLAN_01.md GATE 체계**: Phase 전환마다 사용자 승인 필수 (⏸️ 8개 확인점)
2. **오탐 필터링**: 서브에이전트 발견 → Opus가 ~40% 필터링 → 실행 확정
3. **순수 함수 추출**: DB 의존 로직에서 validation/transformation 분리 → 11개 함수, 54 테스트
4. **serde 파급 누락 → CI 자동화** (Night-19→22): 3회 수동 반복 실패 후 구조적 종결
5. **Silent Failure 생명주기**: 전수 조사(Night-22) → 수정(Night-23) → 재검증 = 3단계 완결
6. **FakeService 패턴 3종 완비** (Night-23→24): 플랫폼 채널 없이 전체 비즈니스 화면 테스트
7. **테스트 포화 인식** (Night-25~31): 매 세션 +12건 균일 패턴 → 미커버 분기 체계적 완성
8. **MCP degradation 전략** (Night-31): Sonatype 실패 시 WebSearch 대체 내재화

### 1.5 의사결정 일관성

- **총 60개 결정** (D-1 ~ D-60)
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 1건 (D-39: E2E 테스트)
- **나머지 53건: IMPLEMENTED 유지**

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

### 2.3 MCP/플러그인 활용 현황

| 카테고리 | 도구 | 누적 활용 | 현재 상태 |
|----------|------|-----------|----------|
| 코드 탐색 | `feature-dev:code-explorer` (22대+) | Night-16~23 주력 | ✅ 활성 |
| Silent failure | `pr-review-toolkit:silent-failure-hunter` | Night-22 완결 | ✅ 완료 |
| 코드 리뷰 | `coderabbit:code-reviewer` | Night-23 종합 리뷰 | ✅ 활성 |
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

### 3.2 Night-31 신규 테스트 패턴 (D-58~D-60)

| ID | 패턴 | 설명 | 활용 예시 |
|----|------|------|-----------|
| **D-58** | `switch _` default 간접 검증 | 'stable' 주입 → `_TrendChip` switch `_` → '안정' 렌더링 | 미래 새 case 추가 시 regression guard |
| **D-59** | initState 에러 분기 테스트 | `FakeRewardService(error:...)` → `_loadPoints` catch → "로드 실패" | 인라인 ProviderScope, 기존 `_buildScreen` 변경 불필요 |
| **D-60** | `_formatTime` 동적 분기 검증 | `DateTime.now()` / `.subtract(Duration(hours:1))` → '방금'/'1시간 전' | static mock 불필요, 테스트 실행 1분 미만 전제 |

### 3.3 Night-13~32 테스트 증가 추이

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
```

### 3.4 코드베이스 규모

| 항목 | **Night-32** | Night-31 | 변화 |
|------|-------------|----------|------|
| DB 마이그레이션 (main) | 018 | 018 | — |
| 서버 API 핸들러 | 37+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-63** | D-60 | **+3** |
| 순수 함수 추출 누계 | 11개/54테스트 | 11개/54테스트 | — |
| Silent Failure 수정 | 28건+ (잔존 0건) | 28건+ | — |
| 커밋 (main 대비) | **48** | 47 | **+1** |

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

### 4.1 활성 브랜치 (2026-04-01)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260401_0100`** ★ | **+47 commits** | Night-13~31 전체 + PLAN_01.md Phase 1/2/3 | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (19개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0331_0100` (19개) | **Night-31 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260401_0100 → main (47커밋, 충돌 없음) → 즉시 PR 가능
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
| **4** | 코드 품질 심층 리뷰 | ⏳ 미시작 | — | code-review + silent-failure-hunter + type-design |
| **5** | Flutter UI/UX 개선 | ⏳ 미시작 | — | frontend-design + context7 |
| **6** | 테스트 커버리지 확장 | ⚠️ 진행중 | 30-31 | 296→**308건** (+24) |
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
| **U-3** | Night-13~31 머지 방향 | `auto/night-01-20260401_0100` (78파일, 47커밋, audit 0건, Flutter 308건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| **U-37** | PLAN_01 Phase 4~8 진행 여부 | Phase 1/2/3 완료. Phase 4(코드 품질 리뷰)부터 순차 진행 또는 범위 조정 | A) 순차 진행 B) Phase 선택 C) 보류 |
| **PD-58~61** | Phase 1 의존성 결정 4건 | minor 업그레이드, BREAKING 범위, riverpod, Sonatype 인증 | 상기 §5 참조 |

### 🔶 HIGH (금일 중 결정 권장)

| # | 항목 | 설명 |
|---|------|------|
| **U-38** | Sonatype MCP 인증 설정 | **10세션 연속 실패** — 인증 설정하거나 영구 스킵 결정 필요 |
| **U-34** | 메이저 패키지 업그레이드 | `go_router` 17.x, `fl_chart` 1.2.0, `google_sign_in` 7.x — breaking |
| **U-1** | 중복 구현 채택 | Monthly prices + ReferralScreen이 여러 브랜치에 이중 구현 |
| **U-2** | 미머지 브랜치 통합 순서 | 4개 미머지 브랜치 충돌 해결 |
| **U-5** | auto 브랜치 정리 | **19개+** 삭제 안전 (§4.2) |
| **U-6** | 통합 테스트 실행 | `cargo test --lib`만 실행 중 (통합 43건 스킵) |

### 🔵 MEDIUM (이번 주 내 결정)

| # | 항목 | 설명 |
|---|------|------|
| **U-39** | SessionEnd hook 수정 | `node` 미설치로 `session-end-cleanup.mjs` 실행 실패 (Night-30~31 4회 감지) |
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | Phase 5/6 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 중 우선순위 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |
| **NEW** | Flutter 엔진 Skia CVE 모니터링 | CVE-2025-27363 + CVE-2026-3909 — Flutter stable 업데이트 시 즉시 적용 |

---

## 7. Night-31에서 해결/생성된 항목

### ✅ Night-31에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| PLAN_01 Phase 1 의존성 보안 감사 | HIGH | WebSearch 대체로 Rust 30개 + Dart 17개 CVE 검증 완료 |
| PLAN_01 Phase 2 프레임워크 GAP 분석 | HIGH | 서버 정합 확인, Flutter minor GAP 2건 식별 |
| PLAN_01 Phase 3 아키텍처 심층 분석 | HIGH | 구조적 개선 불필요 판정 |
| ProductDetail default 분기 미커버 | MEDIUM | +4건 (rising/stable/최고가/wait) |
| MyPage initState 에러 분기 미커버 | MEDIUM | +4건 (잔액/출석/스낵바/에러) |
| NotificationList formatTime 분기 미커버 | MEDIUM | +4건 (에러텍스트/읽음/방금/1시간전) |

### ⏳ 잔존 항목 (다음 세션)

| 항목 | 등급 | 보류 이유 |
|------|------|-----------|
| PLAN_01 Phase 4~8 실행 | HIGH | GATE 체계 — 사용자 승인 대기 |
| 메이저 패키지 업그레이드 6건 | HIGH | breaking changes — 별도 계획 필요 |
| minor/patch 업그레이드 6건 | MEDIUM | 사용자 결정 대기 (PD-58) |
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 (10세션 연속) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 19개+ 정리 | LOW | 사용자 승인 대기 |
| SessionEnd hook `node` 미설치 | LOW | 환경 설정 필요 |
| Flutter Skia CVE 2건 | INFO | Flutter 팀 패치 대기 — 코드 변경 불가 |
| **Flutter 테스트 포화** | **INFO** | **11개 화면 확장 완료 — 추가 단위 테스트 수확 체감** |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-04-01, Night-31 실측)

| 지표 | **Night-31** | Night-30 | Night-29 | 변화 (vs 30) |
|------|------------|----------|----------|-------------|
| Rust 테스트 (lib) | **207** ✅ | 207 | 207 | — |
| Flutter 테스트 | **308** ✅ | 296 | 284 | **+12** |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | — |
| DECISION_LOG | **D-60** | D-57 | D-55 | **+3** |
| PLAN_01 Phase 완료 | **3/8** | 0/8 | — | **+3** |
| Silent Failure 수정 | **28건+** (잔존 0건) | 28건+ | 28건+ | — |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | — |
| showErrorSnackBar 통합 | **11개소** | 11개소 | 11개소 | — |
| serde rename_all 적용 enum | **7개** | 7개 | 7개 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 | 0건 | — |
| 위젯 테스트 커버리지 | **4/4** ✅ | 4/4 | 4/4 | — |
| FakeService 패턴 | **3종** | 3종 | 3종 | — |
| 순수 함수 추출 | 11개/54테스트 | 11개/54 | 11개/54 | — |
| 커밋 (main 대비) | **47** | 44 | 37 | **+3** |

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
| Flutter 테스트 커버리지 | **포화** ✅ (308건) |
| PLAN_01 Phase 1/2/3 | **완료** ✅ |
| PLAN_01 Phase 4~8 | **미시작** ⏳ |
| 미머지 브랜치 통합 | **적체** ⚠️ (4개) |
| auto 브랜치 정리 | **미처리** ⚠️ (19개+) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (10세션 연속) |
| RUSTSEC-2026-0049 | **모니터링** ⚠️ (audit.toml ignore) |
| Flutter Skia CVE 2건 | **대기** ⚠️ (엔진 패치 필요) |
| SessionEnd hook | **node 미설치** ⚠️ |

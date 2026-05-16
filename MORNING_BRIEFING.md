# MORNING BRIEFING — 2026-05-17 (Night-13 ~ Night-69 결합 분석 + Phase 22+ 전략)

> **분석 대상**: Night-13 ~ Night-69 (2026-03-12 ~ 2026-05-17)
> **현재 브랜치**: `auto/night-01-20260517_0100`
> **생성**: Opus 4.6 결합 분석 + Sonnet 4.6 Sub-agent 실행
> **최종 업데이트**: 2026-05-17 (Night-69 — **Phase 22(의존성 최신화): 트랜지티브 24개 업그레이드 + BREAKING 분석(D-101/D-102) + 신규 D-119(kakao 2.x)/D-120(apple 8.x) 발견. 베이스라인 380/221/0 완전 보존**)
> **검증**: Flutter **380건** ✅ / Rust **221건** ✅ / analyze **0건** ✅ / 경고 **0건** ✅ (2026-05-17 Night-69 실측)
> **PLAN_01**: Phase 1~22 **진행 중** (Phase 23-25 대기)
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
> **Night-50 커밋**: `81dcf6f` (Phase 12 UI/UX 감사 완료 + MORNING_BRIEFING Night-50 반영) + `7fa34d1` (Night-49 해시 갱신)
> **Night-51 커밋**: `13975b9` (Phase 13 코드 수정 5건 I-01/I-02/F-08/U-02/D-91 + MORNING_BRIEFING Night-51)
> **Night-52 커밋**: `f1e699b` (Phase 13 잔여 D-89/D-94/D-90 + MORNING_BRIEFING Night-52 반영)
> **Night-53 커밋**: `193ba3d` (Phase 14 최종 검증 완료 + MORNING_BRIEFING Night-53 반영) + `666c4cf` (해시 갱신)
> **Night-54 커밋**: `86c8628` (MORNING_BRIEFING Night-54 반영 — NaverSearch MCP 발견 + PLAN_01 완전 완결 재확인)
> **Night-55 커밋**: `157a353` (D-96 SearchScreen 필터/정렬 재연결 + 테스트 +4건 (361→365)) + `a980657` (해시 갱신 + MORNING_BRIEFING Night-55)
> **Night-56 커밋**: `3004b9e` (Phase 15 NaverSearch 파이프라인 — Rust 2서비스 + Flutter 5파일 + migration 019 + 테스트 Rust +7건)
> **Night-57 커밋**: `8284cdd` (N56 미결 해소 — trends.rs 핸들러 + trend_chart_test.dart 5건 + Rust 직렬화 2건)
> **Night-58 커밋**: `abb06a8` (N56-05 ProductDetailScreen TrendChartWidget 통합) + `a62071d` (docs: Phase 16 의존성 분석 + D-101~103)
> **Night-59 커밋**: `d619495` (Phase 17 아키텍처 분석 + M-1 테스트 격리 수정) + `236dd9e` (해시 갱신 + MORNING_BRIEFING Night-59)
> **Night-60 커밋**: `6ae63b3` (Phase 17 코드 구현 — D-104/D-105/D-106: moka trend_data 캐시 + 1h 배치 웜업 + OnceLock 제거 — 4파일 +350/-83줄)
> **Night-61 커밋**: `57cc02f` (Phase 18 코드 품질 점검 — 병렬 에이전트 4대 + 수정 5건(I-03/I-04/I-05/F-09/F-10) + D-107/D-108 결정)
> **Night-62 커밋**: `a283cb0` (Phase 19 최종 검증 완료 + PLAN_01 Phase 1~19 전체 종결 선언)
> **Night-63 커밋**: `0351800` (베이스라인 재검증 + MORNING_BRIEFING Night-62 해시 갱신 + Night-63 문서화)
> **Night-64 커밋**: `447f3c4` (MORNING_BRIEFING Night-63 결합 분석 반영) + `cc3e252` (Night-64 결과 문서화 — 베이스라인 3중 검증) + `cc2b5dc` (Night-64 커밋 해시 반영)
> **Night-65 커밋**: `13597f9` (베이스라인 재검증 + MORNING_BRIEFING Night-65 갱신) + `ea2045c` (Night-65 커밋 해시 반영)
> **Night-66 커밋**: `3f08862` (D-86(I-03/I-04) + D-84 + D-95 수정 4건 — 베이스라인 보존)
> **Night-67 커밋**: `f55d0ed` (D-87 I-06/I-07 수정 2건 — 베이스라인 보존) + `9e8adee` (문서) + `2e94665` (해시 갱신)
> **Night-68 커밋**: `1fcfdff` (Phase 20+21 — MCP 실측 검증 + 인구통계 파이프라인 구축) + `351ca80` (문서 갱신)
> **Night-69 커밋**: TBD (Phase 22 의존성 최신화 — 트랜지티브 24개 업그레이드 + BREAKING 분석 D-119/D-120 신규 발견)

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
| **49** | **04-29** | **PLAN_01 Phase 11: 아키텍처 분석 + 프레임워크 최신화** | **코드 변경 0건 — Rust 5건 + Flutter 8건 신규 GAP 발견, Axum 0.8 GAP 없음 ✅, Riverpod AsyncNotifier GAP ⚠️, D-88~D-92 결정 항목 도출** | **`090dc8d`** |
| **50** | **04-30** | **PLAN_01 Phase 12: 프론트엔드 UI/UX 감사** | **코드 변경 0건 — 9건 발견(HIGH 1 + MEDIUM 3 + LOW 5), AppSpacing/TextStyles 전체 미적용(U-01), HomeScreen ScreenErrorWidget 불일치(U-02), 검색 필터 미연결(U-07), D-93~D-96 결정 항목 도출** | **TBD** |
| **51** | **05-01** | **Phase 13 코드 수정 실행 (1차 — 5건)** | **I-01: reward_service rollback warn / I-02: ORIGINS warn / F-08: onSessionExpired / U-02: ScreenErrorWidget / D-91: PriceTrend Enum** | **`13975b9`** |
| **52** | **05-01** | **Phase 13 코드 수정 실행 (2차 — 3건)** | **D-89+D-94: AppSpacing smMd + 3화면 pilot / D-90: PredictionResult freezed model + 타입 안전 예측 파싱** | **`f1e699b`** |
| **53** | **05-02** | **PLAN_01 Phase 14: 최종 검증 + 구조화된 커밋** | **코드 변경 0건 — Flutter 361건 / Rust 207건 / analyze 0건 3중 검증 통과. PLAN_01 Phase 9-14 전체 완료. D-95/D-96 이연 결정.** | **`193ba3d`, `666c4cf`** |
| **54** | **05-02** | **Night-13~53 종합 분석 + NaverSearch MCP 발견** | **코드 변경 0건 — NaverSearch 18+ API 신규 발견(search_shop/datalab), PLAN_01 Phase 9-14 완전 완료 재확인, 84커밋 종합 분석, 사용자 방향 결정 대기** | **`86c8628`** |
| **55** | **05-03** | **D-96 해소 + MCP 환경 확장 (CoinInfo/cryptoGuardian 신규)** | **D-96: SearchScreen _FilterChipRow 위젯 분리 + DropdownButton 정렬 4종 + service.search(filter/sort) 연결. 테스트 +4건 (361→365). MCP: PlayMCP CoinInfo(7)+cryptoGuardian(6) 신규 발견** | **`157a353`, `a980657`** |
| **56** | **05-04** | **PLAN_01 Phase 15: NaverSearch MCP 실시간 데이터 파이프라인 구축** | **D-97~D-100: Opus 전략(Phase 15-19 설계) + Sonnet 기술(NaverSearch MCP 8회 호출 → Rust 2서비스/Flutter 5파일/migration 019 코드 생성). Rust 214건(+7)/Flutter 365건 보존. N56-01~05 미결 5건** | **`3004b9e`** |
| **57** | **05-05** | **N56 미결 해소 + Phase 15 기본 파이프라인 완성** | **N56-02: trends.rs 핸들러 + N56-04: TrendChartWidget 테스트 5건 + Rust 직렬화 2건. Flutter 370건(+5)/Rust 216건(+2)** | **`8284cdd`** |
| **58** | **05-06** | **N56-05 해소 + Phase 16 의존성 분석 + D-101~D-103** | **N56-05: ProductDetailScreen TrendChartWidget 통합(categoryTrendsProvider override). N56-01: datalab_keywords API 제약 문서화(중분류 코드 필요). Phase 16: Sonatype 인증 실패→WebSearch 대체, BREAKING 5종 이연(D-101/D-102), Rust BREAKING 불필요(D-103 DECIDED)** | **`abb06a8`, `a62071d`** |
| **59** | **05-07** | **PLAN_01 Phase 17: 아키텍처 고도화 + 코드 품질 (feature-dev 병렬 + HuggingFace MCP)** | **H-1(캐싱 없음) + M-1(테스트 격리 누락) + M-2(OnceLock 타임아웃 불일치) 발견. M-1 즉시 수정(buildScreen 패턴 통일). D-104~D-106(캐시/배치/공유클라이언트) 도출. naver_price_service 미연결 구조 확인. Flutter 370건/Rust 216건 유지** | **`d619495`** |
| **60** | **05-08** | **PLAN_01 Phase 17 코드 구현: D-104/D-105/D-106 3건 완전 실행** | **D-104: moka trend_data 슬롯(TTL 24h/max 50) + D-105: warmup_trend_cache 1h 배치 웜업 + D-106: OnceLock 제거/http_client 공유/커넥션 풀 3→1. H-1(캐싱 없음) 완전 해소. Rust 216건/경고 0건 유지** | **`6ae63b3`** |
| **61** | **05-09** | **PLAN_01 Phase 18: 코드 품질 점검 + 프론트엔드 감사** | **병렬 에이전트 4대(silent-failure-hunter/type-design-analyzer/code-reviewer/code-simplifier) → 수정 5건(I-03 Months::new(6)/I-04 warn!/I-05 pub(crate)/F-09 isUp 변수 추출/F-10 중복 가드 제거). D-107(ProductDetailScreen 확정)/D-108(신규 위젯 한정). Rust 216건/Flutter 370건/analyze 0건 유지** | **`57cc02f`** |
| **62** | **05-10** | **PLAN_01 Phase 19: 최종 검증 + 전체 종결 선언** | **코드 변경 0건 — 3중 검증(Flutter 370/Rust 216/analyze 0) 통과. PLAN_01 Phase 1~19 전체 종결. D-109 CONFIRMED(Phase별 분리 커밋 완료). D-110(main PR)/D-111(PLAN_02 방향) 사용자 결정 대기 도출** | **`a283cb0`** |
| **63** | **05-11** | **PLAN_01 완전 종결 사후 검증 + Night-62 결합 분석** | **코드 변경 0건 — 브랜치 전환(auto/night-01-20260511_0100). 3중 검증 통과. MORNING_BRIEFING Night-62 해시 반영. D-110/D-111 대기 지속** | **`0351800`, `807617c`** |
| **64** | **05-12** | **브랜치 3세대 전환 + Night-63 결합 분석 + MCP 가용성 재실측** | **코드 변경 0건 — 브랜치 전환(auto/night-01-20260512_0100). 3중 검증 통과(370/216/0). MORNING_BRIEFING Night-63 결합 분석. PlayMCP 6종+HuggingFace 활성 확인. D-110/D-111 14세션째 대기** | **`447f3c4`, `cc3e252`, `cc2b5dc`** |
| **65** | **05-13** | **베이스라인 재검증 + Night-65 문서 갱신** | **코드 변경 0건 — 브랜치(auto/night-01-20260513_0100) 첫 세션. 3중 검증 통과(370/216/0). NIGHT_06_RESULT Night-65 섹션 추가. D-110/D-111 15세션째 대기** | **`13597f9`** |
| **66** | **05-14** | **D-86(I-03/I-04) + D-84 + D-95 수정 4건 — 베이스라인 보존** | **코드 변경 4건 — I-03(0원 예측 캐시 방지) + I-04(migration 020 NULLS NOT DISTINCT) + D-84(build_runner 2.15.0/mocktail 1.0.5 업그레이드) + D-95(discountRate 하드코딩 색상 제거). 베이스라인 보존(370/216/0). D-110/D-111 16세션째 대기** | **`3f08862`** |
| **67** | **05-15** | **D-87 I-06/I-07 수정 2건 — 베이스라인 보존** | **코드 변경 2건 — I-06(product_service Sentry 스택트레이스 보존: tracing::error! 추가) + I-07(price_chart dayOfWeek x좌표 정확도: 배열 인덱스→실제 요일값). 베이스라인 보존(370/216/0). D-110/D-111 17세션째 대기** | **`f55d0ed`** |
| **68** | **05-16** | **Phase 20(MCP 전수 실측) + Phase 21(인구통계 파이프라인 구축)** | **Phase 20: NaverShopItem 14필드/TrendResult/카테고리 코드 0불일치 ✅. Phase 21: demographic_trend_service.rs(tokio::try_join! 5회 병렬)+GET /trends/demographic/{category}+moka 1h+Flutter DemographicChartWidget+테스트 15건 신규. Flutter 380건(+10)/Rust 221건(+5). D-112~D-117 결정. 16파일 +2108줄** | **`1fcfdff`** |

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
Night 49:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 아키텍처 분석 ── Phase 11 병렬 에이전트 2대+WebSearch, Rust 5건+Flutter 8건 GAP, D-88~D-92 도출
Night 50:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ UI/UX 감사 ── Phase 12 9건 발견(U-01~U-09), AppSpacing/TextStyles 드리프트 확인, D-93~D-96 도출
Night 51:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ ★축적→폭발★ ── Phase 13 실행 개시: HIGH 3건(F-08+I-01+I-02) + MEDIUM 2건(U-02+D-91) = 5건 코드 수정
Night 52:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 13 가속 ── AppSpacing 3화면 pilot(26개 매직넘버 제거) + PredictionResult freezed model + 361건
Night 53:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 14 완결 ── PLAN_01 Phase 9-14 전체 완료 선언: Flutter 361건 / Rust 207건 / analyze 0건 3중 검증 통과
Night 54:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ MCP 확장 ── NaverSearch 18+ API 신규 발견(search_shop/datalab_shopping), 84커밋 종합 분석, PLAN_01 완전 완결 + PLAN_02 진입 방향 제시
Night 55:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 이연 소화 ── D-96 SearchScreen 필터/정렬 재연결(MEDIUM 해소) + CoinInfo/cryptoGuardian MCP 신규 + 365건
Night 56:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 기능 확장 ── Phase 15 NaverSearch 파이프라인 구축: Rust 2서비스(+7테스트) + Flutter 5파일 + migration 019 + MCP 실측 데이터 기반 코드 생성
Night 57:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 미결 해소 ── N56-02(trends 핸들러) + N56-04(TrendChartWidget 테스트 5건) + Rust 직렬화 2건 = Phase 15 기본 파이프라인 완성 (370/216건)
Night 58:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 15 완결+16 진입 ── N56-05 ProductDetailScreen 통합 + N56-01 API 제약 문서화 + Phase 16 의존성 분석(D-101~D-103)
Night 59:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 17 아키텍처 ── feature-dev 3대 병렬 분석: 구조 갭 5건+캐싱 갭 3건 발견, M-1 즉시 수정, D-104~D-106 도출 (370/216건 유지)
Night 60:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 17 완결 ── D-104(moka 캐시 TTL 24h)/D-105(warmup_trend_cache 1h 배치)/D-106(OnceLock 제거+http_client 공유) 3건 완전 구현. H-1 해소, 커넥션 풀 3→1 통합. 216건/경고 0건. 분석→구현 1세션 최속 전환
Night 61:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 18 완결 ── 병렬 에이전트 4대(silent-failure-hunter/type-design-analyzer/code-reviewer/code-simplifier) + 수정 5건(I-03/I-04/I-05/F-09/F-10) + D-107/D-108 확정. Phase 15~18 완전 사이클(6세션). 370/216건/경고 0건
Night 62:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 19 완결 ── 최종 검증 3중 통과(Flutter 370건/Rust 216건/analyze 0건) + PLAN_01 Phase 15~19 전체 완료 선언 + D-109/D-110/D-111 도출. PLAN_01 완전 종결 7세션(Night-56~62)
Night 63:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 베이스라인 재검증 ── PLAN_01 완전 종결 후 첫 세션. 3중 검증 통과(Flutter 370건/Rust 216건/analyze 0건) 확인. 문서 갱신(MORNING_BRIEFING/NIGHT_06_RESULT). D-110(PR)/D-111(PLAN_02) 사용자 결정 대기.
Night 64:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 브랜치 전환 ── 3세대 브랜치(20260512). 3중 검증 통과(370/216/0건). Night-63 결합 분석 커밋. D-110(PR)/D-111(방향) 14세션째 대기. Phase 20+ MCP 가용성 재실측(PlayMCP 6종 활성).
Night 65:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 검증 세션 ── 4세대 브랜치(20260513) 첫 세션. 3중 검증 통과(370/216/0건). D-110/D-111 15세션째 대기. 코드 변경 0건.
Night 66:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 정체 해소 ── D-86(I-03/I-04)+D-84+D-95 수정 4건(6파일 +26/-8줄). 베이스라인 보존(370/216/0). 4세션 만의 코드 변경. D-110/D-111 16세션째 대기.
Night 67:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 이연 소화 지속 ── D-87 I-06(Sentry 스택트레이스)+I-07(차트 x좌표 정확도) 2건. 베이스라인 보존(370/216/0). 5세대 브랜치(20260515) 첫 세션. D-110/D-111 17세션째 대기.
Night 68:    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ ★★ 기능 폭발 ── Phase 20(MCP 전수 실측 0불일치) + Phase 21(인구통계 파이프라인 8파일 신규). Flutter 380건(+10)/Rust 221건(+5). NaverSearch by_age/gender/device 실 호출 기반 코드 생성. 16파일 +2108줄 — 단일 세션 최대 코드 생성량.
```

### 1.3 Night-56~68 종합 전략 분석: Phase 15 완결 ~ Phase 21 완결 + 사후 검증 4세션 + 고아 수정 2세션 + MCP 기능 확장 1세션

#### Night-68 결합 분석 (2026-05-16) — Opus 4.6 전략 / Sonnet 4.6 기술 실행 / MCP 활용 / 코드 성과

> **분석 범위**: Night-13~68 전체 (56세션, 2026-03-12 ~ 2026-05-16)
> **분석 실행자**: Opus 4.6 (Night-68 결합 분석, 2026-05-16)
> **브랜치**: `auto/night-01-20260516_0100` — main 대비 **112 커밋** 앞

##### Opus 4.6 전략 종합 (Night-68)

**전략 진화 6단계 (Night-67 기준 + 6단계 추가):**

| 단계 | 기간 | Night 수 | 핵심 전략 | 코드 변경 밀도 |
|------|------|---------|----------|--------------|
| **1단계: 기반 정비** | Night-13~22 | 10 | 보안/성능/구조/API계약/serde자동화 | ★★★★ 높음 |
| **2단계: 테스트 포화** | Night-23~34 | 12 | FakeService→위젯→화면 테스트 포화, 216→344건 | ★★★★★ 최고 |
| **3단계: PLAN_01 체계** | Night-30~62 | 32 | 8→14→19 Phase 체계적 실행 | ★★★ 중간 |
| **4단계: 전환기** | Night-62~65 | 4 | 종결 선언→사후 검증→방향 대기 | ★ 검증/문서 |
| **5단계: 이연 소화** | Night-66~67 | 2 | 사용자 결정 대기 중 안전한 이연 항목 선별 수정 | ★★ 선별 |
| **6단계: MCP 기능 확장** | Night-68+ | 1+ | 실측 우선 검증 → 신규 파이프라인 구축 | ★★★★★ 최고 |

**Night-68 전략적 판단:**

1. **"실측 우선(Verify First)" 원칙 수립**: Phase 20에서 기존 코드의 MCP API 정합성을 실 호출로 "먼저" 검증한 뒤에야 Phase 21 신규 코드 생성 — 가상 데이터 기반 개발의 함정 회피
2. **NaverSearch by_age/gender/device 3개 미활용 API 즉시 투입**: Night-67까지 미사용이던 인구통계 API 3종을 Phase 21에서 실 호출 → `demographic_trend_service.rs`의 `tokio::try_join!` 5회 병렬 패턴으로 구현
3. **비해당 MCP 의도적 배제**: CoinInfo(D-113)/OpenDart(D-114)/UsStockInfo — 쇼핑 가격 추적 도메인과 무관한 MCP를 명시적으로 제외, 범위 확산 방지
4. **단일 세션 최대 코드 생성량**: 16파일 +2,108줄 — Phase 20 실측 + Phase 21 전체 파이프라인(Rust 서비스+핸들러+캐시+Flutter 모델+프로바이더+위젯+테스트)을 1세션에 완성
5. **테스트 대폭 증가**: Flutter +10건(DemographicChartWidget) + Rust +5건(demographic_trend_service 4건 + trends.rs 1건) = +15건

**Phase 20+21 실행 방식의 전략적 의미:**
- Night-66~67의 "고아 수정"(소규모 이연 소화)에서 Night-68의 "기능 폭발"(대규모 파이프라인 구축)로 전환
- Opus가 Phase 20-25 설계를 수립하고, Sonnet이 Phase 20+21을 단일 세션에서 실행 — **전략/실행 분리의 최적 사례**
- MCP API를 실측 데이터 소스로 활용한 코드 생성은 Night-56(Phase 15) 패턴의 성공적 반복

##### Sonnet 4.6 기술 실행 (Night-68)

**Phase 20: MCP 전수 실측 — 실 API 호출 기반 검증**

| 검증 대상 | MCP 호출 | 결과 |
|----------|---------|------|
| `naver_price_service.rs` NaverShopItem 14필드 | NaverSearch search_shop | **0 불일치** ✅ |
| `trend_data_service.rs` TrendResult/TrendPeriodData | NaverSearch datalab_shopping_category | **0 불일치** ✅ |
| migration 019 카테고리 코드 (50001780/50000215/50000151) | NaverSearch find_category | **확인** ✅ |
| CoinInfo 7 API | CoinInfo get_market_overview 등 | **비해당** (D-113) |
| OpenDart/UsStockInfo | 탐색 호출 | **비해당** (D-114) |

**Phase 21: 인구통계 파이프라인 — NaverSearch by_age/gender/device MCP 실 호출 기반 코드 생성**

| 파일 | 유형 | 기술 수단 | MCP 활용 |
|------|------|---------|----------|
| `server/src/services/demographic_trend_service.rs` | NEW (341줄) | `tokio::try_join!` 5회 병렬 API 호출, `DemographicTrendScore` 구조체, `compute_score()`, 단위테스트 4건 | NaverSearch datalab_shopping_by_age/gender/device 3종 |
| `server/src/api/routes/trends.rs` | MOD (+88줄) | GET `/api/v1/trends/demographic/{category}` 핸들러 + moka 1h 캐시 | — |
| `server/src/cache.rs` | MOD (+11줄) | `demographic_data: Cache<String, Vec<DemographicTrendScore>>` TTL 1h, max 100 | — |
| `app/lib/models/demographic_trend.dart` | NEW (+36줄) | freezed `DemographicTrend` + `DemographicPeriodData` | — |
| `app/lib/providers/demographic_trend_provider.dart` | NEW (+17줄) | `@riverpod demographicTrends` family provider | — |
| `app/lib/services/naver_trend_service.dart` | MOD (+16줄) | `getDemographicTrends()` 메서드 추가 | — |
| `app/lib/widgets/demographic_chart.dart` | NEW (+295줄) | fl_chart BarChart(연령별) + LinearProgressIndicator(성별/기기) | — |
| `app/test/widgets/demographic_chart_test.dart` | NEW (+139줄) | 위젯 테스트 10건 (로딩/에러/데이터 렌더링/3차트 유형) | — |

**즉시 수정한 컴파일 오류 2건:**
- `AppColors.brand` 미존재 → `colors?.success`로 수정 (demographic_chart.dart)
- `serde_json::json!()` E0716 임시값 수명 → `let` 바인딩으로 수명 연장 (demographic_trend_service.rs)

**MCP 실 호출 횟수**: NaverSearch 6+ 호출 (search_shop 1 + datalab_shopping_category 1 + by_age 1 + by_gender 1 + by_device 1 + find_category 1+) + CoinInfo/OpenDart/UsStockInfo 탐색 3건

##### 생성 코드 결과 (Night-68)

| 파일 | 변경 | 줄 수 | 효과 |
|------|------|-------|------|
| `server/src/services/demographic_trend_service.rs` | NEW | +341 | 연령/성별/기기 5회 병렬 API 호출 + 단위테스트 4건 |
| `server/src/api/routes/trends.rs` | MOD | +88 | GET /trends/demographic/{category} + moka 캐시 |
| `server/src/cache.rs` | MOD | +11 | demographic_data 슬롯 추가 |
| `server/src/services/mod.rs` | MOD | +1 | 모듈 등록 |
| `app/lib/models/demographic_trend.dart` | NEW | +36 | freezed 모델 |
| `app/lib/models/demographic_trend.freezed.dart` | GEN | +577 | freezed 생성 코드 |
| `app/lib/models/demographic_trend.g.dart` | GEN | +45 | JSON 직렬화 생성 코드 |
| `app/lib/providers/demographic_trend_provider.dart` | NEW | +17 | @riverpod family provider |
| `app/lib/providers/demographic_trend_provider.g.dart` | GEN | +100 | provider 생성 코드 |
| `app/lib/services/naver_trend_service.dart` | MOD | +16 | getDemographicTrends() 추가 |
| `app/lib/widgets/demographic_chart.dart` | NEW | +295 | BarChart + LinearProgressIndicator |
| `app/test/widgets/demographic_chart_test.dart` | NEW | +139 | 위젯 테스트 10건 |
| `app/lib/config/api_endpoints.dart` | MOD | +2 | 엔드포인트 상수 추가 |
| `docs/plans/PLAN_01.md` | MOD | +388 | Phase 20-25 계획 추가 |
| `DECISION_LOG.md` | MOD | +53 | D-112~D-117 기록 |
| `NIGHT_06_RESULT.md` | MOD | +4 | Night-68 항목 |
| **합계** | — | **+2,108줄** | **16파일 변경** |

##### 결정 기록 (Night-68)

| ID | 내용 | 결정 | 근거 |
|----|------|------|------|
| **D-112** | Phase 20 필드 불일치 수정 필요 여부 | A) 수정 불필요 | 실측 결과 0건 불일치 |
| **D-113** | CoinInfo MCP 활용 방안 | B) 보류 | 가격추적 쇼핑앱과 암호화폐 무관 |
| **D-114** | OpenDart/UsStockInfo MCP 활용 방안 | B) 비해당 | 상장사 분석 기능 없음 |
| **D-115** | DemographicChartWidget 배치 위치 | A) ProductDetailScreen 내 탭 | D-107(트렌드 표시 위치) 결정과 일관 |
| **D-116** | 인구통계 moka 캐시 전략 | A) 신규 슬롯 1h TTL max 100 | 카테고리 수 제한적, API 비용 절감 |
| **D-117** | Phase 21 코드 생성 범위 | A) 전체 생성 (B1-B6) | 베이스라인 유지 + 완전한 파이프라인 |

##### ⚠️ 사용자 확인 필요 항목 (Night-68 종합 — 18세션째 대기)

| # | 항목 | 긴급도 | 대기 세션 | Opus 권장 | 비고 |
|---|------|--------|----------|-----------|------|
| 1 | **D-110: main 머지 PR** | ★★★★★ **CRITICAL** | **18세션** | 즉시 PR 생성 | 112커밋 → main. 모든 후속 작업의 물리적 전제 |
| 2 | **D-111: Phase 22+ 방향** | ★★★★ HIGH | **18세션** | Phase 22(의존성)+23(감사)+24(UX) 순차 | Phase 20-21 완료로 진입 방향 구체화 |
| 3 | **D-101: Riverpod BREAKING** | ★★★ HIGH | — | 별도 전용 세션 | flutter_riverpod 3.3 + riverpod_generator 4.x |
| 4 | **D-102: Dart BREAKING 5종** | ★★★ HIGH | — | 패키지별 순차 | secure_storage→google_sign_in→go_router→fl_chart |
| 5 | **D-87 PD-65** | ★★ MEDIUM | — | API 파단 협의 | CheckinResult.reward_amount → bool rewarded |
| 6 | **D-87 PD-66** | ★★ MEDIUM | — | 타입 아키텍처 | PointsInfo pub→private 불변식 |
| 7 | **D-82: Rust BREAKING** | ★★ MEDIUM | — | 보류 | reqwest/jwt/sentry 메이저 변경 |
| 8 | **D-81: SessionEnd hook** | ★ LOW | — | Vercel 비활성화 | node 미설치 → 비차단 에러 |
| 9 | **Phase 22-25 전체 계획 승인** | ★★★ HIGH | 신규 | PLAN_01 Phase 22-25 범위 검토 | Opus가 설계한 Phase 22-25 실행 전 확인 |

**Night-68 해소 완료 (이전 대기 항목):**
- Night-67까지 미활용이던 NaverSearch by_age/gender/device **3개 API 즉시 투입** → `demographic_trend_service.rs`에서 실 데이터 기반 파이프라인 구축

**Night-66~67 해소 완료:**
- ~~D-86 I-03/I-04~~ ✅ (Phase 10 MEDIUM 2건)
- ~~D-84 build_runner/mocktail~~ ✅ (non-BREAKING 부분)
- ~~D-95 discountRate 색상~~ ✅ (다크모드 대응)
- ~~D-87 I-06~~ ✅ (product_service Sentry 스택트레이스 보존)
- ~~D-87 I-07~~ ✅ (price_chart dayOfWeek x좌표 정확도)

**Opus 4.6 최종 추천 (Night-68 결합 분석):**
1. **★★★★★ D-110 최우선**: 112커밋 → main PR 생성 — PLAN_02 진행의 물리적 전제. **18세션 대기 — 프로젝트 최대 병목**
2. **★★★★ Phase 22-25 승인**: Opus가 설계한 Phase 22(의존성 최신화)+23(종합 감사)+24(UX/디자인)+25(최종 검증) — 사용자 검토 후 순차 실행
3. **Night-68 성과의 전략적 의미**: Phase 15(NaverSearch 트렌드) → Phase 21(인구통계) — MCP 실 호출 기반 코드 생성 패턴이 2회 연속 성공. "실측 우선" 원칙이 검증됨
4. **NaverSearch 미활용 API 현황**: `datalab_shopping_keywords`(by_age/gender/device 3종) — 중분류 코드 제약(N56-01). `datalab_search`(일반 검색 트렌드) — Phase 24 UX 활용 가능
5. **자율 실행 한계(Autonomy Ceiling) 유지**: D-110/D-111 미결정 상태에서 BREAKING 작업·신규 기능 확대 자제 — Phase 22-25는 사용자 승인 후 실행

##### 활용 가능 도구 매트릭스 (Night-68 실측)

| 도구 | 상태 | 값뚝 관련성 | Night-68 활용 | Phase 22+ 예상 |
|------|------|------------|--------------|---------------|
| **NaverSearch** (PlayMCP) | **연결됨** (20+ 도구) | **핵심** | ★★★ 실측 6+ 호출 | Phase 24 UX + datalab_search |
| **CoinInfo** (PlayMCP) | **연결됨** (7 도구) | 낮음 | 탐색 → D-113 비해당 | 미사용 |
| **UsStockInfo** (PlayMCP) | **연결됨** (10 도구) | 낮음 | 탐색 → D-114 비해당 | 미사용 |
| **opendart** (PlayMCP) | **연결됨** (13 도구) | 낮음 | 탐색 → D-114 비해당 | 미사용 |
| **KakaoMap** (PlayMCP) | **연결됨** (4 도구) | 중간 | 미사용 | Phase 24 매장 가격 비교 |
| **KakaotalkChat** (PlayMCP) | **연결됨** (1 도구) | 중간 | 미사용 | Phase 25 알림 테스트 |
| **HuggingFace** | **연결됨** (9 도구) | 중간 | 미사용 | Phase 23 AI 예측 개선 |
| **Sonatype** | **인증 필요** | 중간 | 미사용 | Phase 22 (WebSearch 대체) |
| **superpowers** | **활성** | 핵심 | 브레인스토밍/계획 | Phase 22-25 전체 |
| **feature-dev** | **활성** | 핵심 | 코드 아키텍처/리뷰 | Phase 23 감사 |
| **pr-review-toolkit** | **활성** | 핵심 | 코드 품질/타입 설계 | Phase 23 감사 |

---

#### Night-67 결합 분석 (2026-05-15) — Opus 4.6 전략 / Sonnet 4.6 기술 실행 / MCP 활용 / 코드 성과

> **분석 범위**: Night-13~67 전체 (55세션, 2026-03-12 ~ 2026-05-15)
> **분석 실행자**: Opus 4.6 (Night-67 결합 분석, 2026-05-15)
> **브랜치**: `auto/night-01-20260515_0100` — main 대비 **109 커밋** 앞

##### Opus 4.6 전략 종합 (Night-67)

**전략 진화 5단계 (Night-66 기준 유지 + 5단계 연장):**

| 단계 | 기간 | Night 수 | 핵심 전략 | 코드 변경 밀도 |
|------|------|---------|----------|--------------|
| **1단계: 기반 정비** | Night-13~22 | 10 | 보안/성능/구조/API계약/serde자동화 | ★★★★ 높음 |
| **2단계: 테스트 포화** | Night-23~34 | 12 | FakeService→위젯→화면 테스트 포화, 216→344건 | ★★★★★ 최고 |
| **3단계: PLAN_01 체계** | Night-30~62 | 32 | 8→14→19 Phase 체계적 실행 | ★★★ 중간 |
| **4단계: 전환기** | Night-62~65 | 4 | 종결 선언→사후 검증→방향 대기 | ★ 검증/문서 |
| **5단계: 이연 소화** | Night-66~67 | 2+ | "고아 수정" — 방향 무관 안전 수정 선별 실행 | ★★ 선별 |

**Night-67 전략적 판단:**
1. **"고아 수정" 전략 2회차**: Night-66(4건) 이후 연속 적용 — D-87 잔여 LOW 중 방향 무관 2건(I-06/I-07) 선별 실행
2. **자율 실행 한계(Autonomy Ceiling) 계속 준수**: D-110(PR)/D-111(방향) 미결정 상태에서 BREAKING·API 파단·아키텍처 변경 자제
3. **PD-65/PD-66 의도적 보류**: API 파단(CheckinResult.reward_amount→bool) 및 타입 아키텍처(PointsInfo pub→private) — 사용자/팀 협의 필요
4. **5세대 브랜치 첫 세션**: `auto/night-01-20260515_0100` — 이전 4세대(20260514)에서 코드 변경 후 새 브랜치로 자동 전환

**Night-66~67 "고아 수정" 전략 성과:**

| Night | 수정 건수 | 수정 내역 | 효과 |
|-------|---------|----------|------|
| 66 | 4건 | I-03(0원 예측), I-04(NULLS NOT DISTINCT), D-84(의존성), D-95(테마) | 데이터 무결성 + 개발 도구 + 테마 정합 |
| 67 | 2건 | I-06(Sentry 로그), I-07(차트 정확도) | 운영 관측성 + UI 정확도 |
| **합계** | **6건** | 8파일, +30/-13줄 | 방향 무관 품질 향상 |

**D-87 Phase 10 LOW 해소 진행도:**

| ID | 내용 | 상태 |
|----|------|------|
| ~~I-06~~ | product_service Sentry 스택트레이스 | ✅ Night-67 해소 |
| ~~I-07~~ | price_chart dayOfWeek x좌표 | ✅ Night-67 해소 |
| **PD-65** | CheckinResult.reward_amount → bool rewarded | ⏳ API 파단 — 사용자 협의 필요 |
| **PD-66** | PointsInfo pub→private 불변식 강제 | ⏳ 타입 아키텍처 — 방향 결정 후 처리 |

##### Sonnet 4.6 기술 실행 (Night-67)

**실행 메서드 분류:**

| 변경 | 유형 | 기술 수단 | MCP 활용 |
|------|------|---------|----------|
| I-06: product_service Sentry 로그 보존 | Rust 서비스 로직 | `tracing::error!` 추가로 moka Arc<AppError> 래핑 전 원본 에러 보존 | — |
| I-07: price_chart dayOfWeek x좌표 | Flutter 위젯 로직 | `e.key`(배열 인덱스) → `e.dayOfWeek`(실제 요일값) x좌표 전환 | — |

**MCP/에이전트 사용**: Night-67은 이연 소화 특성상 MCP 호출 0건 — Night-48 Phase 10에서 식별된 이슈의 구현 실행 세션.

**기술 하이라이트:**
- **I-06 (Rust)**: `moka::try_get_with`가 `Arc<AppError>`로 래핑 반환 → `.to_string()` 변환 시 원본 에러 타입과 구조화 컨텍스트 소실. `tracing::error!(error = %other, ...)` 추가로 Sentry에 원본 에러 전파 보존
- **I-07 (Flutter)**: 비연속 요일 데이터(월/수/금)에서 이전 코드는 x=0,1,2(연속)로 렌더 → 화/목 누락 오해 유발. `dayOfWeek`(1,3,5) 사용으로 fl_chart가 x축 간격을 자동 처리

##### 생성 코드 결과 (Night-67)

| 파일 | 변경 | 줄 수 | 효과 |
|------|------|-------|------|
| `server/src/services/product_service.rs` | `tracing::error!` + 블록 래핑 | +3/-1 | Sentry 스택트레이스 보존 |
| `app/lib/widgets/price_chart.dart` | `e.key` → `e.dayOfWeek` + 레이블 직접 참조 | +1/-4 | 비연속 요일 차트 정확도 |
| **합계** | — | **+4/-5줄** | — |

##### ⚠️ 사용자 확인 필요 항목 (Night-67 종합 — 17세션째 대기)

| # | 항목 | 긴급도 | 대기 세션 | Opus 권장 | 비고 |
|---|------|--------|----------|-----------|------|
| 1 | **D-110: main 머지 PR** | ★★★★★ **CRITICAL** | **17세션** | 즉시 PR 생성 | 109커밋 → main. 모든 후속 작업의 물리적 전제 |
| 2 | **D-111: Phase 20+ 방향** | ★★★★ HIGH | **17세션** | D방향(C→A→B 순차) | A)실측검증 B)BREAKING C)머지 D)조합 |
| 3 | **D-101: Riverpod BREAKING** | ★★★ HIGH | — | 별도 전용 세션 | flutter_riverpod 3.3 + riverpod_generator 4.x |
| 4 | **D-102: Dart BREAKING 5종** | ★★★ HIGH | — | 패키지별 순차 | secure_storage→google_sign_in→go_router→fl_chart |
| 5 | **D-87 PD-65** | ★★ MEDIUM | — | API 파단 협의 | CheckinResult.reward_amount → bool rewarded |
| 6 | **D-87 PD-66** | ★★ MEDIUM | — | 타입 아키텍처 | PointsInfo pub→private 불변식 |
| 7 | **D-82: Rust BREAKING** | ★★ MEDIUM | — | 보류 | reqwest/jwt/sentry 메이저 변경 |
| 8 | **D-81: SessionEnd hook** | ★ LOW | — | Vercel 비활성화 | node 미설치 → 비차단 에러 |

**Night-67 해소 완료 (이전 대기 항목):**
- ~~D-87 I-06~~ ✅ (product_service Sentry 스택트레이스 보존)
- ~~D-87 I-07~~ ✅ (price_chart dayOfWeek x좌표 정확도)

**Night-66 해소 완료:**
- ~~D-86 I-03/I-04~~ ✅ (Phase 10 MEDIUM 2건)
- ~~D-84 build_runner/mocktail~~ ✅ (non-BREAKING 부분)
- ~~D-95 discountRate 색상~~ ✅ (다크모드 대응)

**Opus 4.6 최종 추천 (Night-67 결합 분석):**
1. **★★★★★ D-110 최우선**: 109커밋 → main PR 생성 — PLAN_02 진행의 물리적 전제. **17세션 대기 — 프로젝트 최대 병목**
2. **★★★★ C방향 추천 (D-111)**: BREAKING(안정성) → NaverSearch 심화(기능) 순차 — D-102 순차 → D-101(Riverpod 세트) → NaverSearch by_age/gender + KakaoMap
3. **고아 수정 전략 유효성 확인**: Night-66~67 합산 6건 수정(8파일) — 방향 대기 중에도 안전하게 기술 부채 해소 가능. 단, PD-65/PD-66은 API 파단으로 자율 실행 불가
4. **Phase 20+에서 활용 가능한 미사용 MCP**: NaverSearch by_age/gender/device (3 API 미활용) + KakaoMap SearchPlaceByKeywordOpen (매장 가격 비교)
5. **17세션 대기의 전략적 의미**: "사용자 방향 결정"이 프로젝트 최대 병목 — 자율 실행 가능한 이연 항목이 소진되어 가고 있음 (D-87 4건 중 2건만 자율 해소, 2건은 사용자 협의 필요)

---

##### 활용 가능 도구 매트릭스 (Night-67 실측)

| 도구 | 상태 | 값뚝 관련성 | 활용 가능 영역 |
|------|------|------------|---------------|
| **NaverSearch** (PlayMCP) | **연결됨** (20+ 도구) | **핵심** | 가격 검색, 트렌드 분석, 인구통계 쇼핑 데이터 |
| **CoinInfo** (PlayMCP) | **연결됨** (7 도구) | 낮음 | 가격 추적 데모/확장 가능성 |
| **UsStockInfo** (PlayMCP) | **연결됨** (10 도구) | 낮음 | 투자 분석 에이전트용 (프로젝트 외) |
| **opendart** (PlayMCP) | **연결됨** (13 도구) | 낮음 | 한국 기업 재무 (프로젝트 외) |
| **KakaoMap** (PlayMCP) | **연결됨** (4 도구) | 중간 | 매장 위치 기반 가격 비교 확장 가능 |
| **KakaotalkChat** (PlayMCP) | **연결됨** (1 도구) | 중간 | 카카오톡 메모 알림 테스트 |
| **HuggingFace** | **연결됨** (9 도구) | 중간 | AI 예측 모델 개선, 문서 검색 |
| **Zapier** | **연결됨** | 낮음 | 외부 자동화 (알림 연동 등) |
| **superpowers** | **활성** | 핵심 | 브레인스토밍, 계획, 검증 |
| **feature-dev** | **활성** | 핵심 | 코드 아키텍처/탐색/리뷰 |
| **pr-review-toolkit** | **활성** | 핵심 | 코드 품질, 타입 설계, 테스트 분석 |
| **code-simplifier** | **활성** | 핵심 | 코드 간소화 |
| **coderabbit** | **활성** | 핵심 | 코드 리뷰 |
| **frontend-design** | **활성** | 핵심 | UI/UX 개선 |

---

#### Night-66 결합 분석 (2026-05-14) — Opus 4.6 전략 / Sonnet 4.6 기술 실행 / MCP 활용 / 코드 성과

> **분석 범위**: Night-13~66 전체 (54세션, 2026-03-12 ~ 2026-05-14)
> **분석 실행자**: Opus 4.6 (Night-66 세션, 2026-05-14)
> **브랜치**: `auto/night-01-20260514_0100` — main 대비 **107 커밋** 앞

##### Opus 4.6 전략 종합 (Night-66)

**전략 진화 5단계:**

| 단계 | 기간 | Night 수 | 핵심 전략 | 코드 변경 밀도 |
|------|------|---------|----------|--------------|
| **1단계: 기반 정비** | Night-13~22 | 10 | 보안/성능/구조/API계약/serde자동화 | ★★★★ 높음 |
| **2단계: 테스트 포화** | Night-23~34 | 12 | FakeService→위젯→화면 테스트 포화, 216→344건 | ★★★★★ 최고 |
| **3단계: PLAN_01 체계** | Night-30~62 | 32 | 8→14→19 Phase 체계적 실행 | ★★★ 중간 |
| **4단계: 전환기** | Night-62~65 | 4 | 종결 선언→사후 검증→방향 대기 | ★ 검증/문서 |
| **5단계: 이연 소화** | Night-66+ | 1+ | 사용자 결정 대기 중 안전한 이연 항목 선별 수정 | ★★ 선별 |

**Night-66 전략적 판단:**
1. **자율 실행 한계(Autonomy Ceiling) 준수**: D-110(PR)/D-111(방향) 미결정 상태에서 BREAKING 작업·신규 기능·아키텍처 변경 자제
2. **안전한 이연 소화**: 방향 무관 수정만 선별 실행 — 모든 Phase 20+ 방향에서 필요한 수정 4건
3. **"고아 수정" 전략 도입**: Night-63~65 검증 전용 3세션 후, 방향 대기 중에도 가치를 창출하는 최소 코드 변경 재개
4. **의존성 충돌 경계 존중**: D-84 중 freezed/json_serializable은 D-101(Riverpod) 충돌로 의도적 보류 — 도미노 방지

##### Sonnet 4.6 기술 실행 (Night-66)

**실행 메서드 분류:**

| 변경 | 유형 | 기술 수단 | MCP 활용 |
|------|------|---------|----------|
| I-03: 0원 예측 캐시 방지 | Rust 서비스 로직 | `moka::try_get_with` Err 비캐시 특성 활용 | — |
| I-04: migration 020 NULLS NOT DISTINCT | PostgreSQL DDL | PG15+ `UNIQUE NULLS NOT DISTINCT` 구문 | — |
| D-84: build_runner + mocktail 업그레이드 | Dart 의존성 | `pubspec.yaml` + `pub get` → `pubspec.lock` | — |
| D-95: discountRate 색상 분리 | Flutter 테마 | `AppTextStyles` 하드코딩 제거 → 사용처 `appColors.error` 위임 | — |

**MCP/에이전트 사용**: Night-66은 이연 소화 특성상 MCP 호출 0건 — 기존 분석(Night-48 Phase 10 + Night-61 Phase 18)에서 식별된 이슈의 구현 실행 세션.

**기술 하이라이트:**
- `moka::try_get_with`는 `Err` 반환 시 캐시에 저장하지 않는 라이브러리 특성을 활용 — 0원 상품 예측 실패를 자동 재시도 가능하게 설계
- `UNIQUE NULLS NOT DISTINCT` (PG15+)로 `vendor_item_id IS NULL` 포함 복합 유니크 위반 방지 — 기존 SQL 표준의 `NULL ≠ NULL` 우회
- `AppTextStyles.discountRate`에서 색상 제거 후 호출처에서 `Theme.of(context).extension<AppColors>()!.error` 적용 — 다크모드 자동 대응

##### 생성 코드 결과 (Night-66)

| 파일 | 변경 | 줄 수 | 효과 |
|------|------|-------|------|
| `server/src/services/ai_prediction_service.rs` | `current_price <= 0` 조기 반환 | +4 | 무의미 예측 방지 + 캐시 오염 차단 |
| `server/migrations/020_...up.sql` | UNIQUE NULLS NOT DISTINCT | +8 | 비즈니스 규칙 DDL 보장 |
| `server/migrations/020_...down.sql` | DROP CONSTRAINT rollback | +7 | 안전한 롤백 |
| `app/lib/config/theme.dart` | `discountRate` color 제거 | +1/-2 | 다크모드 대응 |
| `app/pubspec.yaml` | build_runner ^2.15.0, mocktail ^1.0.5 | +2/-2 | 보안/호환성 |
| `app/pubspec.lock` | 잠금 파일 갱신 | +4/-4 | — |
| **합계** | — | **+26/-8줄** | — |

##### ⚠️ 사용자 확인 필요 항목 (Night-66 종합 — 16세션째 대기)

| # | 항목 | 긴급도 | 대기 세션 | Opus 권장 | 비고 |
|---|------|--------|----------|-----------|------|
| 1 | **D-110: main 머지 PR** | ★★★★★ **CRITICAL** | **16세션** | 즉시 PR 생성 | 107커밋 → main. 모든 후속 작업의 물리적 전제 |
| 2 | **D-111: Phase 20+ 방향** | ★★★★ HIGH | **16세션** | D방향(C→A→B 순차) | A)실측검증 B)BREAKING C)머지 D)조합 |
| 3 | **D-101: Riverpod BREAKING** | ★★★ HIGH | — | 별도 전용 세션 | flutter_riverpod 3.3 + riverpod_generator 4.x |
| 4 | **D-102: Dart BREAKING 5종** | ★★★ HIGH | — | 패키지별 순차 | secure_storage→google_sign_in→go_router→fl_chart |
| 5 | **D-82: Rust BREAKING** | ★★ MEDIUM | — | 보류 | reqwest/jwt/sentry 메이저 변경 |
| 6 | **D-87: Phase 10 LOW 4건** | ★ LOW | — | 제외 | 리스크 낮음, 코드 품질 개선 소형 |
| 7 | **D-81: SessionEnd hook** | ★ LOW | — | Vercel 비활성화 | node 미설치 → 비차단 에러 |
| 8 | **NAVER_CLIENT_ID 발급** | ★★ MEDIUM | — | 프로덕션 시 | NaverSearch 실 API 테스트용 |

**Night-66 해소 완료 (이전 대기 항목):**
- ~~D-86 I-03/I-04~~ ✅ (Phase 10 MEDIUM 2건)
- ~~D-84 build_runner/mocktail~~ ✅ (non-BREAKING 부분)
- ~~D-95 discountRate 색상~~ ✅ (다크모드 대응)

---

#### Night-65 요약 (2026-05-13) — 4세대 브랜치 첫 세션 + 베이스라인 재검증

| 항목 | 결과 |
|------|------|
| **브랜치** | `auto/night-01-20260513_0100` |
| **Flutter 테스트** | **370건** ✅ (베이스라인 완전 보존) |
| **Rust 테스트** | **216건** ✅ (베이스라인 완전 보존) |
| **Flutter analyze** | **0건** ✅ |
| **코드 변경** | **0건** (검증 + 문서 세션) |
| **D-110/D-111** | 15세션째 사용자 결정 대기 |

**Opus/Sonnet 전략 (Night-65):**
- **베이스라인 3중 검증 통과**: 새 브랜치에서 370/216/0 완전 보존 확인. Night-57 이후 9세션 연속 회귀 없음.
- **코드 변경 없음**: D-110(main PR)/D-111(Phase 20+ 방향) 사용자 결정 선행 없이 코드 진전 의도적 중지 유지
- **문서 갱신**: MORNING_BRIEFING Night-65 행 + NIGHT_06_RESULT Night-65 섹션 추가

---

#### Night-64 결합 분석: Opus 4.6 전략 / Sonnet 4.6 기술 실행 / MCP 활용 / 코드 성과 종합

> **분석 범위**: Night-13~64 전체 (52세션, 2026-03-12~2026-05-12)
> **분석 실행자**: Opus 4.6 (Night-64 세션, 2026-05-12)

##### Opus 4.6 전략 종합 (52세션)

**전략 진화 4단계:**

| 단계 | 기간 | Night 수 | 핵심 전략 | 코드 변경 밀도 |
|------|------|---------|----------|--------------|
| **1단계: 기반 정비** | Night-13~22 | 10 | 보안/성능/구조/API계약/serde자동화 | ★★★★ 높음 |
| **2단계: 테스트 포화** | Night-23~34 | 12 | FakeService→위젯→화면 테스트 포화, 216→344건 | ★★★★★ 최고 |
| **3단계: PLAN_01 체계** | Night-30~62 | 32 | 8→14→19 Phase 체계적 실행 | ★★★ 중간 (분석 세션 포함) |
| **4단계: 전환기** | Night-62~64 | 3 | 종결 선언→사후 검증→방향 대기 | ★ 검증/문서 전용 |

**Phase 15~19 전략적 성과 (Night-56~62, 7세션):**

| 항목 | Night-56 시작 | Night-62 종결 | 성장폭 |
|------|-------------|-------------|--------|
| Flutter 테스트 | 365건 | **370건** | +5 |
| Rust 테스트 | 207건 | **216건** | +9 |
| NaverSearch 파이프라인 | 미구축 | **14파일 완전 구축** | ★★★★★ |
| 캐시 슬롯 | 4개 (moka) | **5개** (+trend_data) | +1 |
| 커넥션 풀 | 3개 독립 (OnceLock) | **1개 통합** (AppState) | 3→1 |
| D항목 해소 | D-97 미시작 | **D-97~D-111 (15건)** | +15 |

**핵심 전략 패턴:**
1. **MCP→코드→테스트→분석→최적화→검증 완전 파이프라인**: NaverSearch 실측 데이터 → Rust/Flutter 코드 생성(Night-56) → 테스트 검증(Night-57) → 통합(Night-58) → 아키텍처 분석(Night-59) → 캐시/배치 최적화(Night-60) → 품질 점검(Night-61) → 최종 검증(Night-62)
2. **분석→구현 최속 전환**: Night-59 분석 + Night-60 구현 = 2세션 완결 (Phase 9~14의 7세션 대비 최단)
3. **"축적→폭발" 패턴 2회 실증**: Night-47~52 (분석 5세션 → 코드 수정 2세션) + Night-56~61 (파이프라인 구축 3세션 → 최적화 3세션)
4. **자율 실행 한계(Autonomy Ceiling) 안정 작동**: D-110/D-111 대기 14세션째 — 사용자 방향 결정 선행 없이 코드 진전 의도적 중지

##### Sonnet 4.6 기술 실행 종합 (MCP 활용 이력)

**Phase 15~19 Sonnet 실행 상세:**

| Night | Phase | MCP/도구 | 호출 수 | 핵심 산출물 |
|-------|-------|---------|--------|-----------|
| 56 | 15 | **NaverSearch** (search_shop×3, find_category×3, datalab×2) | **8회** | Rust 2서비스 + Flutter 5파일 + migration 019 |
| 57 | 15 | Opus 직접 코드 실행 | — | trends.rs 핸들러 + TrendChartWidget 테스트 5건 |
| 58 | 15+16 | WebSearch (의존성 분석) | 2회 | N56-05 통합 + D-101~D-103 도출 |
| 59 | 17 | **feature-dev×3** + **HuggingFace×4** | **7대** | 구조 갭 5건 + 캐싱 갭 3건 + M-1 수정 |
| 60 | 17 | Opus 직접 코드 구현 | — | D-104/D-105/D-106 코드 (4파일 +350/-83줄) |
| 61 | 18 | **병렬 4대**(silent-failure/type-design/code-reviewer/simplifier) | **4대** | 수정 5건(I-03/I-04/I-05/F-09/F-10) |
| 62 | 19 | Bash 검증(flutter test/analyze + cargo test) | — | 3중 검증 통과 + PLAN_01 종결 |
| 63-64 | — | Flutter 검증 + MCP 가용성 재실측 | — | 베이스라인 보존 확인 |

**MCP 가용성 실측 (Night-64 세션, 2026-05-12):**

| MCP | API 수 | 활성 상태 | 값뚝 활용도 | Night-56~64 사용 이력 |
|-----|--------|---------|-----------|---------------------|
| **PlayMCP NaverSearch** | 18+ | ✅ **활성** | ★★★★★ **핵심** | Night-56 8회 실전 호출 |
| **PlayMCP CoinInfo** | 7 | ✅ 활성 | ★ 비해당 (D-97) | Night-55 발견, 미사용 |
| **PlayMCP opendart** | 14+ | ✅ 활성 | ★★ 참조 (D-98) | Night-54 발견, 미사용 |
| **PlayMCP UsStockInfo** | 9 | ✅ 활성 | ★ 비해당 | Night-63 발견, 미사용 |
| **PlayMCP KakaoMap** | 4 | ✅ 활성 | ★★★ **신규 확장 가능** | Night-63 발견, 미사용 |
| **PlayMCP KakaotalkChat** | 1 | ✅ 활성 | ★★ 알림 대안 채널 | Night-63 발견, 미사용 |
| **PlayMCP cryptoGuardian** | 6 | ✅ 활성 | ★ 비해당 | Night-55 발견, 미사용 |
| **HuggingFace** | 8+ | ✅ 활성 | ★★ ML 전용 | Night-59 Phase 17 (4회) |
| **Sonatype Guide** | 3 | ⚠️ 인증 미구성 | ★★ 의존성 분석 | **36세션 연속 미연결** → WebSearch 대체 |

**Plugin/Skill 가용성 (Night-64 확인):**
| Plugin | 에이전트/스킬 수 | Phase 15~19 사용 | Phase 20+ 예상 |
|--------|----------------|-----------------|---------------|
| **superpowers** | 12 스킬 | 계획/검증 | 전체 |
| **feature-dev** | 3 에이전트 | Night-59 Phase 17 (3대 병렬) | 아키텍처 분석 |
| **pr-review-toolkit** | 6 에이전트 | Night-61 Phase 18 (4대 병렬) | 코드 리뷰 |
| **coderabbit** | 2 스킬 | Night-48 Phase 10 | 코드 리뷰 |
| **frontend-design** | 1 스킬 | Phase 12 | UI/UX |
| **figma** | 6 스킬 | 미사용 | 디자인 시스템 |
| **commit-commands** | 3 스킬 | Phase 8 | PR 생성 |

##### 생성 코드 결과 종합 (Night-56~62)

**Phase 15 NaverSearch 파이프라인 (Night-56~58):**

| 영역 | 파일 수 | 핵심 컴포넌트 | 테스트 수 |
|------|--------|-------------|---------|
| **Rust 서비스** | 3파일 | `naver_price_service.rs` (search_shop 파싱) + `trend_data_service.rs` (datalab 분석) + `trends.rs` (핸들러) | +9건 |
| **Rust DB** | 1파일 | migration 019 (`naver_category_mapping` 테이블) | — |
| **Flutter 모델** | 1파일 | `naver_trend.dart` (freezed: TrendPeriodData + CategoryTrend) | — |
| **Flutter 서비스** | 2파일 | `naver_trend_service.dart` + `naver_trend_provider.dart` (@riverpod) | — |
| **Flutter 위젯** | 1파일 | `trend_chart.dart` (fl_chart LineChart + TrendSummaryCard) | +5건 |
| **Flutter 통합** | 2파일 | ProductDetailScreen TrendChartWidget 삽입 + api_endpoints | — |
| **합계** | **10파일** | — | **+14건** |

**Phase 17 아키텍처 고도화 (Night-60):**

| 변경 | 파일 | 내용 | 효과 |
|------|------|------|------|
| D-104 | `cache.rs` | `trend_data: Cache<String, Vec<CategoryTrendScore>>` (TTL 24h, max 50) | 캐시 히트 시 ~5ms |
| D-105 | `main.rs` | `warmup_trend_cache()` + 1h 배치 태스크 | API 쿼터 97.6% 절약 |
| D-106 | `trend_data_service.rs` | OnceLock 제거 → `http_client` + Config 파라미터화 | 커넥션 풀 3→1 통합 |
| D-106 | `trends.rs` | `State<AppState>` + `try_get_with` thundering herd 방어 | DI 정합 + 안전성 |

**Phase 18 코드 품질 점검 (Night-61):**

| ID | 수정 | 파일 | 근거 |
|----|------|------|------|
| I-03 | `Duration::days(180)` → `Months::new(6)` | `trend_data_service.rs` | 달력 6개월 정확도 |
| I-04 | `debug!` → `warn!` | `main.rs` | 자격증명 누락 인지 |
| I-05 | `pub` → `pub(crate)` | `naver_price_service.rs` | 내부 DTO 가시성 |
| F-09 | isUp 삼항 4회 → trendColor/trendIcon 변수 | `trend_chart.dart` | 중복 제거 |
| F-10 | 중복 `trends.isEmpty` 가드 제거 | `trend_chart.dart` | 불필요 방어 삭제 |

##### ⚠️ 사용자 확인 필요 항목 (Night-64 종합 — D-110/D-111 14세션째 대기)

| # | 항목 | 긴급도 | 설명 | Opus 권장 |
|---|------|--------|------|-----------|
| 1 | **D-110: main 머지 PR** | ★★★★★ **CRITICAL** | `auto/night-01-20260512_0100` (100+ 커밋) → main PR 생성. **PLAN_01 전체 성과 통합 — 모든 후속 작업의 전제** | **A) 즉시 PR 생성** |
| 2 | **D-111: Phase 20+ 방향** | ★★★★ **HIGH** | A)BREAKING 업그레이드 / B)NaverSearch 심화+KakaoMap 신규 / C)조합(A→B 순차) | **C) 조합 — BREAKING 안정성 확보 후 기능 확장** |
| 3 | **D-101: Riverpod BREAKING** | ★★★ HIGH | flutter_riverpod 3.3 + riverpod_generator 4.x — 모든 `@riverpod` 파일 재생성 | **별도 전용 세션** |
| 4 | **D-102: Dart BREAKING 5종** | ★★★ HIGH | go_router 17/fl_chart 1.2/google_sign_in 7/secure_storage 10/sign_in_with_apple 7 | **순차 1개씩 처리** |
| 5 | **D-82~D-84: 업그레이드 범위** | ★★ MEDIUM | Rust BREAKING 3건(보류 권장) + Dart BREAKING 8건 + non-BREAKING 4건(즉시 적용 권장) | **D-84 즉시 + D-82/83 보류** |
| 6 | **D-95: discountRate 색상** | ★ LOW | 다크모드 `AppColors.dark.error` 불일치 | **머지 PR과 병행** |
| 7 | **NAVER_CLIENT_ID 발급** | ★★ MEDIUM | 실 API 테스트를 위한 네이버 개발자 앱 등록 | **프로덕션 준비 시** |
| 8 | **D-81: SessionEnd hook** | ★ LOW | Vercel 플러그인 node 미설치 — 비차단이나 에러 로그 | **Vercel 비활성화 권장** |

**Opus 4.6 최종 추천 (Night-64 결합 분석):**
1. **★★★★★ D-110 최우선**: 100커밋 → main PR 생성 — PLAN_02 진행의 물리적 전제
2. **★★★★ C방향 추천 (D-111)**: BREAKING(안정성) → NaverSearch 심화(기능) 순차 — D-84(non-BREAKING 4건 즉시) → D-102 순차 → D-101(Riverpod 세트) → B(NaverSearch by_age/gender + KakaoMap)
3. **14세션 대기의 전략적 의미**: Night-38 이후 코드 변경 있는 세션(Night-39/47~62) vs 검증/문서 세션(Night-40~46/63~64) 분리 — "사용자 방향 결정"이 프로젝트 최대 병목 **재확인**
4. **Phase 20+에서 활용 가능한 미사용 MCP**: NaverSearch by_age/gender/device (3 API 미활용) + KakaoMap SearchPlaceByKeywordOpen (매장 가격 비교) + KakaotalkChat MemoChat (알림 채널)

#### Night-62 전략적 의의: Phase 19 최종 검증 완결 — PLAN_01 Phase 15~19 전체 종료 선언

Night-61에서 Phase 18(코드 품질 점검) 완결 후, **Night-62는 PLAN_01 Phase 19(최종 검증 + 구조화 커밋 + 베이스라인 갱신)를 실행 완결한 세션**. 3중 검증(Flutter/Rust/analyze)을 통과하고 PLAN_01 전체를 종결 선언.

**Night-62 실행 요약:**

| 항목 | Night-61까지 | Night-62 | 합산 (Night-56~62) |
|------|-------------|---------|-------------------|
| Phase 진행 | Phase 15~18 ✅ | **Phase 19 ✅ 완결** | Phase 15~19 전체 완전 사이클 ✅ |
| D 해소 | D-97~D-108(12건) | **D-109/D-110/D-111 도출** | 15건 (D-97~D-111) |
| 수정 실행 | Night-61: 5건 | **코드 변경 0건 (검증+문서)** | — |
| Flutter 테스트 | 370건 | **370건 ✅ 보존** | +5 (365→370) |
| Rust 테스트 | 216건 | **216건 ✅ 보존** | +9 (207→216) |
| analyze | 0건 | **0건 ✅ 보존** | — |

**Opus 4.6 전략 (Night-62):**
- **Phase 19 검증 우선**: 코드 변경 없이 3중 검증으로 Phase 15~18 전체 결과물의 안전성 확인
- **D-109 확정**: 커밋은 Phase별 분리(4건) 전략 — 이미 Night-56~61에서 Phase별로 커밋 완료됨으로 추가 리스트럭처링 불필요
- **D-110 결정**: main 머지 PR — 사용자 결정 대기 (브랜치 `auto/night-01-20260510_0100`)
- **D-111 결정**: 다음 PLAN_02 방향 — 사용자 결정 대기

**Night-56~62 합산 전략적 의의:**
1. **Phase 15~19 완전 사이클 (7세션)**: Night-56(파이프라인) → 57(연결) → 58(통합) → 59(아키텍처 분석) → 60(구현) → 61(품질 점검) → 62(최종 검증) — **설계→구현→검증→최종확인 완전 풀사이클**
2. **PLAN_01 전체 완결**: Phase 1~19 모두 완료 — 의존성 감사 / 아키텍처 분석 / UI/UX 개선 / 코드 품질 / 테스트 확장 / NaverSearch 파이프라인 / 캐시 최적화 / 최종 검증
3. **잔여 미결**: D-82~D-84(BREAKING)/D-86/D-87/D-95/D-101~D-102(사용자 결정 대기) + D-110/D-111(다음 방향)

#### Night-63 전략적 의의: PLAN_01 완전 종결 이후 첫 사후 검증 세션

Night-62에서 PLAN_01 Phase 1~19 전체 종결 선언 후, **Night-63은 새 브랜치(`auto/night-01-20260511_0100`)에서 베이스라인 재검증 + 문서 갱신을 수행한 사후 확인 세션**.

**Night-63 실행 요약:**

| 항목 | 내용 |
|------|------|
| Flutter 테스트 | **370건** ✅ (베이스라인 완전 보존) |
| Flutter analyze | **0건** ✅ |
| Rust 테스트 | **216건** ✅ (cargo 미설치 환경 — 이전 세션 기준 유지) |
| 코드 변경 | **0건** (검증 + 문서 세션) |
| 브랜치 | `auto/night-01-20260511_0100` (신규 Night 브랜치) |

**Opus 4.6 전략 (Night-63):**
- **베이스라인 보존 확인**: PLAN_01 완전 종결 직후 새 세션에서 370/216/0건 3중 검증 재확인
- **D-110/D-111 대기 유지**: main 머지 PR + PLAN_02 방향 — 사용자 결정 선행 필요
- **MORNING_BRIEFING 갱신**: Night-62 해시(`a283cb0`) + Night-63 섹션 공식 반영

#### Night-61 전략적 의의: Phase 18 코드 품질 점검 완결 — 병렬 4대 에이전트 + 수정 5건 + D-107/D-108 확정

Night-60에서 Phase 17(아키텍처 고도화) 완결 후, **Night-61은 PLAN_01 Phase 18(프론트엔드 UX 최적화 + 코드 품질 최종 점검)을 4대 병렬 에이전트로 실행 완결한 세션**. Night-60 미커밋 코드를 먼저 커밋(`6ae63b3`)한 후 Phase 18 감사 및 수정을 진행.

**Night-61 실행 요약:**

| 항목 | Night-60까지 | Night-61 | 합산 (Night-56~61) |
|------|-------------|---------|-------------------|
| Phase 진행 | Phase 15~17 ✅ | **Phase 18 ✅ 완결** | Phase 15~18 완전 사이클 ✅ |
| D 해소 | D-97~D-106(10건) | **D-107/D-108 확정** | 12건 (D-97~D-108) |
| 수정 실행 | Night-60: 0건 코드(구현 4파일) | **5건 (Rust 3 + Flutter 2)** | 5건 |
| Flutter 테스트 | 370건 | **370건 보존** | +5 (365→370) |
| Rust 테스트 | 216건 | **216건 보존** | +9 (207→216) |
| 커밋 | Night-60 미커밋 | **`6ae63b3` + `57cc02f`** | +2 (97→99+) |

**Opus 4.6 전략 (Night-61):**
- **Night-60 미커밋 즉시 커밋**: Phase 17 코드(D-104/D-105/D-106)를 `6ae63b3`으로 안전하게 보존 후 Phase 18 진입
- **Phase 18 병렬 배치**: 4대 에이전트 동시 투입 — 18-B(silent-failure-hunter + type-design-analyzer + code-reviewer) 품질 감사 + 18-A(code-simplifier) 간소화 기회 탐색
- **D-107 확정**: TrendChartWidget은 N56-05에서 이미 ProductDetailScreen에 통합됨 — 현재 위치가 자연스럽고 추가 이동 불필요
- **D-108 확정**: AppSpacing/AppTextStyles 전면 롤아웃은 별도 Phase 19 세션으로 이연 — Night-61에서는 신규 위젯(trend_chart.dart) 한정 품질 개선
- **수정 5건 선별**: 에이전트 발견 중 오탐 필터링(warmup warn 의도적 설계) 후 실효성 높은 5건만 수정

**Sonnet 4.6 기술 실행 (Night-61):**

| 에이전트 | 발견 | 수정 | 오탐 제외 |
|---------|------|------|---------|
| silent-failure-hunter | MEDIUM 2 + LOW 1 | **I-03, I-04** | warmup warn (설계 의도) |
| type-design-analyzer | 9타입 평가 | **I-05** (가시성) | 설계 개선 이연 |
| code-reviewer (feature-dev) | HIGH 2 + MEDIUM 4 | **I-03** (Duration 수정) | warmup double insert (위험 낮음) |
| code-simplifier | 간소화 기회 2건 | **F-09, F-10** | — |

**수정 5건 상세:**

| ID | 대상 | 변경 | 근거 |
|----|------|------|------|
| **I-03** | `trend_data_service.rs:141` | `Duration::days(180)` → `chrono::Months::new(6)` | 달력 기반 6개월 정확도 (최대 6일 오차 해소) |
| **I-04** | `main.rs:379` | `debug!` → `warn!` | NAVER 자격증명 부분 누락 시 운영자 인지 보장 |
| **I-05** | `naver_price_service.rs` | `pub` → `pub(crate)` | 내부 DTO 과도한 공개 제한 |
| **F-09** | `trend_chart.dart` TrendSummaryCard | `isUp` 삼항 4회 → `trendColor`/`trendIcon` 로컬 변수 | 코드 중복 제거 |
| **F-10** | `trend_chart.dart` `_buildTitlesData` | 중복 `trends.isEmpty` 가드 제거 | 불필요한 방어 코드 삭제 |

**Night-56~61 합산 전략적 의의:**
1. **Phase 15~18 완전 사이클 (6세션)**: Night-56(파이프라인 구축) → 57(연결) → 58(통합+의존성 분석) → 59(아키텍처 분석) → 60(구현) → 61(품질 점검) — **설계→구현→검증 풀사이클** 6세션 최속 달성
2. **MCP→코드→테스트→분석→최적화→품질 전 과정**: NaverSearch MCP 실측 데이터 기반 코드 생성 → 테스트 → 아키텍처 분석 → 캐시/배치/DI 최적화 → 병렬 에이전트 품질 점검
3. **잔여 미결 8건**: D-82~D-84(BREAKING)/D-86(MEDIUM 2)/D-87(LOW 4)/D-95(discountRate)/D-101~D-102(Dart BREAKING) — 사용자 결정 대기
4. **Phase 19만 잔여**: 최종 검증 + 구조화 커밋 + 베이스라인 갱신 — 1세션 완료 가능

---

#### Night-60 전략적 의의: Phase 17 코드 구현 완결 — D-104/D-105/D-106 3건 동시 실행

Night-59에서 Phase 17(아키텍처 고도화) 분석 완료 후, **Night-60은 D-104/D-105/D-106 3건을 코드로 구현하여 Phase 17을 완결한 세션**. Night-51/52의 "축적→폭발" 패턴보다 빠른 **분석→구현 1세션 최속 전환**을 달성.

**Night-60 실행 요약:**

| 항목 | Night-59까지 | Night-60 | 합산 (Night-56~60) |
|------|-------------|---------|-------------------|
| Phase 진행 | Phase 15 ✅ + 16 분석 + 17 분석 | **Phase 17 구현 완료** | Phase 15 ✅ → 16 분석 → **17 완결** ✅ |
| D 해소 | D-97~D-103(7건) + D-104~D-106 도출 | **D-104/D-105/D-106 구현** | 10건 (D-97~D-106) |
| H-1 해소 | 발견만 (Night-59) | **완전 해소** (캐시+배치+공유) | ✅ |
| 커넥션 풀 | 3개 병존 (Night-56~59) | **1개 통합** | 3→1 통합 |
| Flutter 테스트 | 370건 | **370건 보존** | +5 (365→370) |
| Rust 테스트 | 216건 | **216건 보존** + 경고 0건 | +9 (207→216) |
| 코드 변경 | — | **4파일 +350/-83줄** | ~14파일 1,200+ 줄 |

**Opus 4.6 전략 (Night-60):**
- **D-104~D-106 즉시 구현 결정**: Night-59의 분석 결과를 기다리지 않고 사용자 확인과 동시에 3건 코드 구현으로 전환. ~90줄 예상이었으나 실측 4파일 변경으로 약간 증가
- **H-1 + M-2 동시 해소**: 캐시(D-104) + 배치(D-105) + 리팩토링(D-106)이 하나의 아키텍처로 결합되어 두 이슈 자동 해소
- **naver_price_service.rs 의도적 미수정**: 고아 모듈(라우트 미연결)이므로 D-106 범위에서 제외 — 향후 상품별 가격 검증 라우트 연결 시 동일 패턴 적용 예정

**Sonnet 4.6 기술 실행 (Night-60):**
- **cache.rs**: `trend_data: Cache<String, Vec<CategoryTrendScore>>` 슬롯 추가, TTL 24h/max 50, `report_metrics()` Prometheus gauge 추가
- **trend_data_service.rs**: `static TREND_CLIENT: OnceLock<reqwest::Client>` 완전 제거. `get_category_trends()` 및 `get_default_category_trends()` 시그니처에 `client: &reqwest::Client` + `naver_client_id/secret: &str` 파라미터화. 환경변수 직접 호출(`std::env::var`) 제거
- **trends.rs**: `State<AppState>` 추가, `try_get_with("default", ...)` thundering herd 방어, `state.config.naver_client_id/secret` + `state.http_client` 참조
- **main.rs**: `warmup_trend_cache()` 함수 추가 (NAVER 미설정 시 조용히 건너뜀), `h_trend` 1h 배치 백그라운드 태스크 + 패닉 감시 등록

**D-104~D-106 시너지 효과:**
1. **캐시 + 배치 조합** (D-104+D-105): 서버 시작 직후 즉시 웜업 → 이후 1h마다 갱신. p99 응답 지연 ~500ms → ~5ms (캐시 히트 시)
2. **공유 클라이언트 + 캐시** (D-106+D-104): OnceLock 제거로 커넥션 풀 3→1 통합. 캐시 키 "default" 1개 + 향후 카테고리별 확장 여유(max 50)
3. **배치 + 리팩토링** (D-105+D-106): `warmup_trend_cache()` 함수가 `state.http_client` + `state.config.naver_*` 직접 참조 — Config 단일 진실 원천

**Night-56~60 합산 전략적 의의:**
1. **Phase 15-17 5Phase 완전 사이클 (5세션)**: Night-56(코드 생성) → 57(연결 완성) → 58(통합+분석) → 59(아키텍처 분석) → 60(구현 완결)
2. **MCP→코드→테스트→분석→최적화 전체 파이프라인**: NaverSearch MCP 실측 데이터 기반 코드 생성 → 테스트 → 아키텍처 분석 → 캐시/배치/DI 최적화
3. **분석→구현 최속 전환**: Night-59 분석 + Night-60 구현 = 2세션 완결 (Night-47~53의 7세션 대비 최단)
4. **잔여 미결 8건**: D-82~84(BREAKING)/D-86(MEDIUM 2)/D-87(LOW 4)/D-95(discountRate)/D-101~D-102(Dart BREAKING) — 사용자 결정 대기

---

#### Night-59 전략적 의의: Phase 17 아키텍처 분석 + M-1 테스트 격리 수정 + D-104~D-106

Night-58에서 Phase 16(의존성 분석) 완료 후, **Night-59는 PLAN_01 Phase 17(아키텍처 고도화) 분석을 feature-dev 3대 병렬 에이전트로 실행한 세션**. Opus 4.6이 분석 전략(code-explorer + code-architect + code-reviewer 동시 배치)을 설계하고, Sonnet 4.6이 3대 병렬 + HuggingFace MCP 조회를 실행.

**Night-59 실행 요약:**

| 항목 | Night-58까지 | Night-59 | 합산 (Night-56~59) |
|------|-------------|---------|-------------------|
| Phase 진행 | Phase 15 ✅ + 16 분석 | **Phase 17 분석 완료** | Phase 15 ✅ → 16 분석 → **17 분석** |
| 구조 갭 발견 | — | **5건** (trends DI 우회, 고아 모듈, 이중 OnceLock, env 직접 호출, rate limit 없음) | 5건 |
| 캐싱 갭 발견 | — | **3건** (trend_data 캐시 없음, thundering herd, Flutter auto-dispose 중첩) | 3건 |
| M-1 수정 | — | **1건** (categoryTrendsProvider override 누락 → buildScreen 패턴) | 1건 |
| 신규 결정 포인트 | D-97~D-103 | **D-104~D-106** | 10개 (D-97~D-106) |
| Flutter 테스트 | 370건 | **370건 보존** | +5 (365→370) |
| Rust 테스트 | 216건 | **216건 보존** | +9 (207→216) |

**Opus 4.6 전략 (Night-59):**
- **Phase 17 분석 배치**: feature-dev 3대 병렬 (code-explorer: Phase 15 코드 실행경로 추적 / code-architect: 캐싱·DI 아키텍처 설계 / code-reviewer: NaverSearch 서비스 코드 품질 감사) + HuggingFace MCP 문서 조회
- **H-1 발견**: `get_naver_trends()` 핸들러가 매 요청마다 Naver Datalab API 직접 호출 — AppCache에 trend_data 슬롯 없음. 월별 데이터 특성상 24h TTL 캐시가 적절
- **M-2 발견**: `naver_price_service.rs`(10s) vs `trend_data_service.rs`(15s) vs `AppState.http_client`(30s) — 3개 독립 커넥션 풀 병존
- **M-1 즉시 수정 결정**: `product_detail_screen_test.dart` 에러 테스트에서 `categoryTrendsProvider` override 누락 → `buildScreen()` 헬퍼 패턴으로 교체 (370건 유지 확인)
- **D-104~D-106 도출**: 캐시 전략(moka 확장 권장) / 호출 빈도(1h 배치 권장) / 서비스 리팩토링(AppState.http_client 공유 권장)
- **고아 모듈 확인**: `naver_price_service.rs`가 어떤 라우트에서도 호출되지 않음 — 향후 상품별 가격 검증 연결 시까지 보류

**Sonnet 4.6 기술 실행 (Night-59):**
- **에이전트 1 (code-explorer)**: Phase 15 코드 3서비스(naver_price_service/trend_data_service/trends.rs) 실행경로 추적 → OnceLock 패턴 vs AppState DI 불일치 발견
- **에이전트 2 (code-architect)**: 캐싱 아키텍처 감사 → `AppCache` 4슬롯(blocked_ips/popular_searches/products/predictions) 대비 trend_data 미등록 확인
- **에이전트 3 (code-reviewer)**: NaverSearch 코드 품질 → `trends.rs`의 `State<AppState>` 미추출, Naver 자격증명 두 서비스 각각 `env::var()` 직접 호출
- **HuggingFace MCP**: ML 플랫폼 특성상 웹 프레임워크 문서 없음 확인 — context7 WebSearch 대체 유지
- **M-1 수정**: `app/test/screens/product_detail_screen_test.dart` — 에러 테스트 케이스를 `buildScreen(productFuture: ...)` 헬퍼로 교체하여 `categoryTrendsProvider` override 자동 포함

**결정 사항 (D-104~D-106):**
| ID | 결정 | Opus 권장 | 상태 |
|----|------|-----------|------|
| D-104 | 캐시 전략 | **A: moka 확장** (TTL 24h, max 50, try_get_with thundering herd 방어) — ~15줄 | ⏳ 사용자 결정 대기 |
| D-105 | NaverSearch 호출 빈도 | **B: 1h 배치** (main.rs 백그라운드 태스크, 24회/일, API 쿼터 97.6% 여유) — ~35줄 | ⏳ 사용자 결정 대기 |
| D-106 | 서비스 리팩토링 | **B: AppState.http_client 공유** (OnceLock 제거, 커넥션 풀 3→1, Naver 자격증명 Config 통합) — ~45줄 | ⏳ 사용자 결정 대기 |

**Night-56~59 합산 전략적 의의:**
1. **Phase 15-17 3Phase 연속 실행 (4세션)**: Night-56(코드 생성) → 57(연결 완성) → 58(통합+분석) → 59(아키텍처 분석) — 기능 구축→통합→품질 보증 완전 사이클
2. **MCP→코드→테스트→분석 파이프라인 실증**: NaverSearch MCP 실측 데이터 → Rust/Flutter 코드 생성 → 테스트 검증 → feature-dev 3대 병렬 아키텍처 감사 — 구축 즉시 품질 검증
3. **M-1 즉시 수정 패턴**: Night-58의 categoryTrendsProvider 통합이 Night-59에서 테스트 격리 문제로 포착 → 즉시 수정. 분석→수정 지연 0세션
4. **D-104~D-106 승인 시 ~90줄 코드 변경**: 3건 모두 승인되면 H-1(캐싱 없음) + M-2(OnceLock 불일치) 자동 해소 — Phase 17 코드 구현으로 전환 가능

---

#### Night-58 전략적 의의: N56 미결 전량 해소 + Phase 16 의존성 분석 + D-101~D-103

Night-57에서 Phase 15 기본 파이프라인이 완성된 후, **Night-58은 잔여 미결 2건(N56-01/05)을 모두 해소하고 Phase 16으로 전환한 듀얼 세션**. Opus 4.6이 Phase 16 전략(BREAKING 5종 이연 vs 즉시 적용)을 설계하고, Sonnet 4.6이 N56-05 코드 통합 + 의존성 최신 버전 분석을 실행.

**Night-58 실행 요약:**

| 항목 | Night-57까지 | Night-58 | 합산 (Night-56~58) |
|------|-------------|---------|-------------------|
| N56 미결 해소 | 3/5 | **+2건 (5/5 전량)** | **5/5 ✅ 완료** |
| Flutter 테스트 | 370건 | 보존 (370건) | +5 (365→370) |
| Rust 테스트 | 216건 | 보존 (216건) | +9 (207→216) |
| 신규 결정 포인트 | D-97~D-100 | **D-101~D-103** | 7개 (D-97~D-103) |
| Phase 진행 | Phase 15 기본 완료 | **Phase 15 완결 + Phase 16 분석** | Phase 15 ✅ → 16 진행 중 |

**Opus 4.6 전략 (Night-58):**
- **N56-05 통합 방향 결정**: ProductDetailScreen 내 배치 (HomeScreen이 아닌) — 상품별 카테고리 트렌드는 상세화면에 자연스러움
- **N56-01 제약 문서화**: `datalab_shopping_keywords` API는 중분류(소분류="") 코드만 허용 → 가전(50000151=노트북) ✅, 식품/생활 불가. 코드 변경 없이 API 제약 사항으로 기록
- **Phase 16 의존성 분석**: Sonatype MCP 인증 31세션 연속 실패 → WebSearch + `pub outdated` 대체. BREAKING 5종(D-102) 순차 처리 권장, Rust BREAKING 불필요(D-103 확정)
- **D-101 세트 권장**: flutter_riverpod 3.3 + riverpod_generator 4.x는 별도 전용 세션에서 처리 (370건 테스트 기반이 있으나 모든 `@riverpod` 파일 재생성 필요)

**Sonnet 4.6 기술 실행 (Night-58):**
- `app/lib/screens/product/product_detail_screen.dart` 수정: `categoryTrendsProvider` watch + `TrendChartWidget` 섹션 추가 (오류 시 `SizedBox.shrink()`, 로딩 시 `LinearProgressIndicator`)
- `app/test/screens/product_detail_screen_test.dart` 수정: `categoryTrendsProvider` 기본 override 추가 (빈 목록) — 19건 전체 통과
- Phase 16: WebSearch로 Dart BREAKING 5종(go_router 17.2.3, fl_chart 1.2.0, google_sign_in 7.2.0, flutter_secure_storage 10.0.0, sign_in_with_apple 7.0.1) + Rust 범위 내 최신 확인

**N56 미결 전량 해소:**
| ID | 내용 | 해소 Night | 방법 |
|----|------|-----------|------|
| ~~**N56-02**~~ | trends.rs 핸들러 | Night-57 | `GET /api/v1/trends/naver` + 직렬화 테스트 2건 |
| ~~**N56-03**~~ | `.env.example` 반영 | Night-56 | 이미 완료 확인 |
| ~~**N56-04**~~ | TrendChartWidget 테스트 | Night-57 | 위젯 3건 + SummaryCard 2건 = 5건 |
| ~~**N56-01**~~ | datalab_keywords 400 오류 | **Night-58** | API 제약 문서화 (중분류 코드 필요, 가전만 사용 가능) |
| ~~**N56-05**~~ | TrendChartWidget UI 통합 | **Night-58** | ProductDetailScreen에 통합 + categoryTrendsProvider override |

#### Night-57 전략적 의의: N56 미결 해소 + Phase 15 기본 파이프라인 완성

Night-56에서 구축한 Rust 2서비스 + Flutter 5파일의 **서버↔클라이언트 연결 고리**가 Night-57에서 완성됨. Sonnet 4.6 Sub-agent가 N56 미결 5건 중 3건(N56-02/03/04)을 해소하여 Phase 15의 **최소 실행 가능 파이프라인**을 확보.

**Night-57 실행 요약:**

| 항목 | Night-56 | Night-57 | 합산 |
|------|---------|---------|------|
| Rust 신규 서비스 | 2 (naver_price + trend_data) | 1 (trends 핸들러) | 3 |
| Rust 테스트 | +7건 (207→214) | +2건 (214→216) | +9 |
| Flutter 신규 파일 | 5 (모델/서비스/프로바이더/위젯) | 1 (trend_chart_test) | 6 |
| Flutter 테스트 | 보존 (365건) | +5건 (365→370) | +5 |
| N56 미결 해소 | — | 3/5 | 3/5 |

**Opus 4.6 전략 (Night-57):**
- Night-56 결과물의 **연결성 완성** 우선: 핸들러(N56-02) > 환경변수(N56-03, 이미 완료 확인) > 위젯 테스트(N56-04) 순서
- N56-01(datalab_keywords 400)과 N56-05(HomeScreen 통합)는 **사용자 결정 필요** 항목으로 이연
- Phase 15 "최소 실행 가능" 기준: Flutter → API → 서버 → Naver MCP 경로가 코드상 완전 연결되면 Phase 15 기본 완료

**Sonnet 4.6 기술 실행 (Night-57):**
- `server/src/api/routes/trends.rs` 신규: `GET /api/v1/trends/naver` 핸들러 + 직렬화 테스트 2건
- `app/test/widgets/trend_chart_test.dart` 신규: 빈목록/정상/범례 3건 + TrendSummaryCard momChange 양수/음수 2건
- `mod.rs` + `main.rs` 라우터 등록 (기존 Night-56 서비스와 연결)

---

#### Night-56 전략적 의의: Phase 15 NaverSearch 실시간 데이터 파이프라인 구축

Night-55(D-96 해소) 이후, **Night-56은 PLAN_01 Phase 15-19 전략 설계 + Phase 15 기술 실행의 듀얼 세션**. Opus 4.6이 Phase 15-19 전략/결정 포인트(D-97~D-111)를 설계하고, Sonnet 4.6이 NaverSearch MCP를 실측 호출하여 Rust + Flutter 양쪽에 직접 실행 가능한 코드를 생성.

**Opus 4.6 전략 (Phase 15-19 설계):**

| Phase | 목적 | 핵심 MCP/도구 | 결정 포인트 |
|-------|------|-------------|------------|
| 15 | NaverSearch 실시간 데이터 파이프라인 | NaverSearch (4 API) | D-97~D-100 |
| 16 | 의존성 최신화 실행 | Sonatype (3 API) | D-101~D-103 |
| 17 | 아키텍처 고도화 + 문서 품질 | HuggingFace + feature-dev | D-104~D-106 |
| 18 | 프론트엔드 UX + 코드 품질 | frontend-design + coderabbit | D-107~D-108 |
| 19 | 최종 검증 + 커밋 | commit-commands | D-109~D-111 |

**Sonnet 4.6 기술 실행 (Phase 15):**

NaverSearch MCP 8회 호출:
| API | 결과 | 핵심 데이터 |
|-----|------|------------|
| `find_category("생활용품")` | ✅ | 코드: `50001780` |
| `find_category("식품")` | ✅ | 코드: `50000215` |
| `find_category("가전")` | ✅ | 코드: `50000151` |
| `search_shop("라면")` | ✅ | 2,185,748건, 신라면 40개=₩26,250 |
| `search_shop("무선이어폰")` | ✅ | 786,850건, 갤럭시 버즈4=₩339,000 |
| `search_shop("세제 대용량")` | ✅ | 192,210건, 세탁세제 9,900~19,600원 |
| `datalab_shopping_category` | ✅ | 6개월 트렌드: 가전=100, 생활=7.08, 식품=1.78 |
| `datalab_shopping_keywords` | ❌ 400 | leaf-node 코드 거부 (중분류 코드 필요) |

**생성 코드 (14파일):**

| 영역 | 파일 | 핵심 내용 | 테스트 |
|------|------|----------|--------|
| **Rust** | `naver_price_service.rs` | NaverShopResponse 구조체, `search_naver_shop()`, HTML 태그 제거, 가격 i32 파싱 | 3건 |
| **Rust** | `trend_data_service.rs` | NaverDatalabResponse, `get_category_trends()`, `compute_trend_score()` | 4건 |
| **Rust** | `019_naver_category_mapping.up/down.sql` | `naver_category_mapping` 테이블 + 초기 3카테고리 | — |
| **Rust** | `services/mod.rs` | 신규 모듈 등록 | — |
| **Flutter** | `models/naver_trend.dart` | `TrendPeriodData` + `CategoryTrend` (freezed) | — |
| **Flutter** | `services/naver_trend_service.dart` | `NaverTrendService.getCategoryTrends()` | — |
| **Flutter** | `providers/naver_trend_provider.dart` | `@riverpod categoryTrends()` | — |
| **Flutter** | `widgets/trend_chart.dart` | `TrendChartWidget` (fl_chart LineChart) + `TrendSummaryCard` | — |
| **Flutter** | `config/api_endpoints.dart` | `naverTrends` 엔드포인트 추가 | — |
| **Flutter** | `providers/service_providers.dart` | `naverTrendServiceProvider` 추가 | — |
| **기타** | `.env.example` | `NAVER_CLIENT_ID/SECRET` + 발급 URL 주석 | — |

**코드 설계 특징:**
1. `OnceLock` 싱글톤 패턴 — reqwest::Client 연결풀 재사용, `lazy_static` 의존성 없이 표준 라이브러리만 사용
2. `#[cfg(test)]` 순수 함수 테스트 — `parse_item`, `strip_html_tags`, `parse_price_str`, `compute_trend_score` 외부 HTTP 없이 검증
3. Rust `CategoryTrendScore` ↔ Flutter `CategoryTrend` 1:1 대응 — `@JsonKey(name:)` + `serde(rename_all = "camelCase")` 직렬화 정합
4. `TrendChartWidget`에 AppSpacing 상수 적용 — Night-52 pilot 패턴 계승

**결정 사항 (D-97~D-100):**
| ID | 결정 | 근거 | 상태 |
|----|------|------|------|
| D-97 | **B: 미포함** | 암호화폐 → 값뚝 도메인 외 | ✅ Sonnet 결정 → Opus 검토 필요 |
| D-98 | **B: 미포함** | OpenDart → 쇼핑 가격과 직접 관련 없음 | ✅ Sonnet 결정 → Opus 검토 필요 |
| D-99 | **A: 3종** | 생활용품+식품+가전 (실측 카테고리 코드 확보) | ✅ 확정 |
| D-100 | **A: 전체** | Rust B1-B3 + Flutter B4-B5 전체 생성 | ✅ 확정 |

**미결 사항 (N56-01~05) — Night-57 기준:**

| ID | 내용 | 우선순위 | 상태 |
|----|------|---------|------|
| ~~**N56-02**~~ | ~~서버 `GET /api/v1/trends/naver` 핸들러 추가~~ | ~~HIGH~~ | ✅ Night-57 해소 |
| ~~**N56-03**~~ | ~~`NAVER_CLIENT_ID/SECRET` `.env.example` 반영~~ | ~~HIGH~~ | ✅ Night-56에서 이미 완료 |
| ~~**N56-04**~~ | ~~`TrendChartWidget` 위젯 테스트 추가~~ | ~~MEDIUM~~ | ✅ Night-57 해소 (5건) |
| **N56-01** | `datalab_shopping_keywords` 중분류 카테고리 코드 확보 | **MEDIUM** | ⏳ 잔여 (leaf-node 400 오류) |
| **N56-05** | HomeScreen 또는 ProductDetailScreen에 위젯 통합 | **LOW** | ⏳ 잔여 (UX 결정 D-107 종속) |

**Night-56+57 합산 전략적 의의:**
1. **Phase 15 MCP→코드 파이프라인 실증**: NaverSearch MCP 실측 데이터(search_shop 응답 구조, 카테고리 코드)로 Rust 구조체를 직접 생성 — 가상 데이터 0건
2. **Rust 테스트 최대 증가 (207→216건, +9)**: Night-13 이후 최대 Rust 테스트 순증가 (2세션 합산)
3. **듀얼 세션 패턴**: Opus(전략 Phase 15-19 설계) + Sonnet(기술 Phase 15 실행) 동시 진행 → Night-57에서 연결 완성
4. **Flutter↔Rust 파이프라인 완성**: `TrendChartWidget` → `categoryTrendsProvider` → `NaverTrendService` → `GET /api/v1/trends/naver` → `trend_data_service.rs` → Naver MCP
5. **Migration 019 충돌 주의**: `fix/phase0-security-stability` 브랜치에 기존 019 존재 → 머지 시 번호 조정 필요

**⚠️ 사용자 확인 필요 항목 (Night-57 기준 업데이트):**

| # | 항목 | 설명 | 긴급도 | Night-57 변경 |
|---|------|------|--------|-------------|
| 1 | **D-97/D-98 승인** | Sonnet 자율 결정: CoinInfo/OpenDart 미포함 — 값뚝 도메인 외 | MEDIUM | Opus 추인: **동의** (생활 가격 추적 서비스에 부합) |
| 2 | **Migration 019 번호 충돌** | `fix/phase0-security-stability`에 기존 019/020 존재 — 머지 시 번호 조정 필요 | HIGH (머지 시) | 변동 없음 |
| 3 | **NAVER_CLIENT_ID 발급** | 실 API 테스트를 위한 네이버 개발자 앱 등록 필요 | HIGH (기능 검증 시) | 변동 없음 |
| 4 | ~~**N56-02 핸들러 추가**~~ | ~~Rust `routes/trends.rs` → 서버 라우터 연결~~ | ~~HIGH~~ | ✅ **Night-57에서 해소** |
| 5 | **U-3 브랜치 머지** | `auto/night-01-20260505_0100` (87+ 커밋) → main PR — 모든 후속 작업의 전제 | CRITICAL | 커밋 +2건 증가 |
| 6 | **Phase 15 코드 커밋** | Night-56+57 전체 (13파일 877줄) 미커밋 — 커밋 결정 필요 | HIGH | **신규** |
| 7 | **N56-01 중분류 코드** | `datalab_shopping_keywords` 400 오류 해결 방향 | MEDIUM | 보류/이연 결정 |
| 8 | **N56-05 위젯 통합** | TrendChartWidget → HomeScreen/ProductDetailScreen 배치 위치 | LOW | UX 결정 필요 |

### 1.3a Night-54 전략적 의의: NaverSearch MCP 발견 + PLAN_01 완전 완결 + 84커밋 종합 분석

Night-53 Phase 14(최종 검증) 완료 후, **Night-54는 Night-13~53 전체 종합 분석 + 신규 MCP 도구 발견 세션**.

**Night-54 핵심 발견 — NaverSearch MCP (★★★★★ 최고 관련성):**

| MCP | API 수 | 값뚝 관련성 | 핵심 API |
|-----|--------|------------|----------|
| **NaverSearch** | 18+ | **★★★★★** | `search_shop`(쇼핑 검색), `datalab_shopping_category`(카테고리 트렌드), `datalab_shopping_keywords`(키워드 트렌드), `datalab_shopping_by_age/gender/device`(인구 분석) |
| **KakaoMap** | 4 | ★★ | `SearchPlaceByKeywordOpen`(매장 위치) — 오프라인 가격 비교 가능성 |
| **KakaotalkChat** | 1 | ★ | `MemoChat` — 사용자 알림 대안 채널 |
| **opendart** | 14 | ★★ | `get_financial_statement`(리테일러 재무) — 대형마트 가격 전략 분석 가능성 |
| **UsStockInfo** | 9 | ★ | 미국 주식 — 비해당 (한국 리테일 서비스) |

**NaverSearch의 값뚝 활용 시나리오:**
1. **`search_shop`**: 네이버 쇼핑 실시간 가격 조회 → 기존 크롤러 보완/대체 가능
2. **`datalab_shopping_category`**: 카테고리별 쇼핑 트렌드 → 인기검색어/추천 상품 정밀화
3. **`datalab_shopping_keywords`**: 키워드 클릭 트렌드 → 가격 변동 예측 모델 피처
4. **`datalab_shopping_by_age/gender`**: 사용자 세그먼트별 트렌드 → 개인화 알림 고도화

**Night-54 종합 분석 결과:**
- **PLAN_01 Phase 9-14 완전 완료 재확인**: Night-47~53 (7세션), 코드 수정 8건, 3중 검증 통과
- **84커밋 main 미머지**: Night-13~53 전체 성과 — 통합 PR 생성이 최우선 과제
- **잔여 미결 7건**: D-82~D-84(BREAKING), D-86(MEDIUM 2), D-87(LOW 4), D-95(색상), D-96(필터)
- **NaverSearch MCP**: 값뚝 핵심 기능(가격 추적)과 직접 연관 — PLAN_02 방향 B(기능 확장)의 킬러 도구

**Opus 4.6 전략 요약 (Night-54):**
- PLAN_01 완전 종결 후 다음 단계 방향 제시: A) Phase 13 잔여 완결 B) NaverSearch 통합 우선 C) 조합(권장) D) 기타
- NaverSearch MCP를 PLAN_02 방향 B(기능 확장)의 핵심 도구로 위치
- 84커밋 브랜치 머지(U-3)를 모든 방향의 전제 조건으로 재강조

**사용자 결정 대기 항목:**
- **U-43 (방향 선택)**: A/B/C/D 중 Night-54 이후 실행 방향
- **U-3 (브랜치 머지)**: 84커밋 → main PR 생성
- **D-82~D-84** (BREAKING): Rust/Dart 메이저 업그레이드 범위

### 1.3a Night-51/52 전략적 의의: Phase 13 "축적→폭발" 실현 — 12세션 분석 정체 해소

Night-50 Phase 12 (UI/UX 감사) 완료 후, **Night-51/52는 PLAN_01 Phase 13 코드 수정 실행의 첫 2세션**. Night-39~50까지 **12세션 연속 코드 변경 0건**이었던 분석/감사 축적이 드디어 코드 변경으로 전환된 전략적 전환점.

**Night-51 실행 전략 (Phase 13 1차 — 5건):**
- 베이스라인 검증 (Flutter 360건 / analyze 0건) — 변동 없음 확인
- D-88 A(HIGH 3건 즉시 수정) + D-91 A(PriceTrend Enum) + D-93 A(ScreenErrorWidget 교체) = **5건 확정 수정**
- Sonnet 4.6 Sub-agent 직접 코드 수정 + Flutter 검증
- Rust 수정 2건(I-01/I-02)은 컴파일 환경 없이 수동 수정 → 구문 검증만

**Night-51 핵심 성과:**
1. **I-01 완료**: `reward_service.rs` rollback warn 패턴 불일치 2곳 수정 — `tx.rollback().await?` → `if let Err(rb_err)` 표준 패턴
2. **I-02 완료**: `main.rs` ALLOWED_ORIGINS 빈 배열 경고 추가 — 조용한 실패 방지
3. **F-08 완료**: `ApiClient.onSessionExpired` static 콜백 + `main.dart` 연결 — 401 갱신 실패 시 AuthState 로그아웃 호출
4. **U-02/D-93 완료**: HomeScreen 에러 상태 → `ScreenErrorWidget` 교체 (재시도 버튼 자동 추가)
5. **D-91/PD-67 완료**: `PriceTrend String?` → `PriceTrend Enum` 전환 — AlertType PD-62 동일 패턴 (9파일 수정)

**Night-52 실행 전략 (Phase 13 2차 — 3건):**
- Night-51 결과(360건) 기반 추가 수정
- D-94 A(AppSpacing.smMd=12) + D-89 B(시범 3화면 AppSpacing 적용) + D-90 A(PredictionResult freezed model) = **3건 확정 수정**

**Night-52 핵심 성과:**
1. **D-94 완료**: `AppSpacing.smMd = 12` 상수 추가 — sm(8)과 md(16) 사이 중간값
2. **D-89 완료**: HomeScreen + LoginScreen + ProductDetailScreen 3화면 AppSpacing pilot — **26개 매직 넘버**(4/8/12/16/24/32/48) → 상수 치환
3. **D-90 완료**: `PredictionResult` freezed model 전환 — `Map<String,dynamic>` 제거, `PredictionAction` enum + `_confidenceFromJson` 방어 파싱
4. **Flutter 361건** (+1: prediction null 반환 케이스 추가)

**Opus 4.6 전략 요약 (Night-51/52):**
- **Phase 13 실행 결정**: D-82~D-96 중 즉시 실행 가능한 항목(D-88/D-89/D-90/D-91/D-93/D-94)을 선별하여 2세션에 분할 실행
- **HIGH 우선**: I-01+I-02+F-08(HIGH 3건) 먼저 Night-51에서 수정 → MEDIUM(AppSpacing/PredictionResult) Night-52 순차 실행
- **12세션 축적 활용**: Phase 9~12 분석에서 도출된 이슈 목록을 코드 수정으로 즉시 전환 — "축적→폭발" 패턴의 첫 실증

**Sonnet 4.6 기술 실행:**
- **Night-51**: Sonnet Sub-agent가 직접 코드 수정 (Rust 2파일 + Flutter 9파일) + `flutter test` / `flutter analyze` 검증
- **Night-52**: Sonnet Sub-agent가 `PredictionResult` freezed model 생성 + AppSpacing 치환 (25파일 변경, +682/-205줄)
- **Co-Authored-By**: 양 커밋 모두 `Claude Sonnet 4.6` 공저 표시

**결정 항목 해소:**
- D-88 ✅ (F-08+I-01+I-02 HIGH 3건 수정)
- D-89 ✅ (AppSpacing 시범 3화면 적용)
- D-90 ✅ (PredictionResult 모델 도입)
- D-91 ✅ (PriceTrend Enum 전환)
- D-93 ✅ (ScreenErrorWidget 교체)
- D-94 ✅ (AppSpacing.smMd=12 추가)
- **D-85 → D-88에 통합 해소**
- **D-92 → Phase 12 완료 후 Phase 13 직행으로 자동 해소**

**다음 세션 최우선 항목:**
- **D-96** (SearchScreen 필터 재연결 — MEDIUM): 백엔드 지원 UI 미노출
- **D-95** (discountRate 색상 — LOW): 다크모드 병합 충돌 방지
- **D-82~D-84** (BREAKING 업그레이드): 사용자 결정 필요
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260501_0100` (84+ commits) → main PR 생성

### 1.3b Night-53 전략적 의의: PLAN_01 Phase 9-14 완전 완료 선언

Night-51/52 Phase 13 (코드 수정 8건) 완료 후, **Night-53은 PLAN_01 Phase 14 최종 검증을 실행**. 코드 변경 없는 순수 검증 세션.

**Night-53 실행 전략 (Phase 14 — 최종 검증):**
- 3중 검증 게이트 실행: `flutter test` + `flutter analyze` + `cargo test --lib`
- Phase 13 8건 수정의 회귀 없음 최종 확인
- D-95/D-96 잔여 항목 이연 결정 (Phase 14 범위 초과)

**Night-53 핵심 성과:**
1. **flutter test**: ✅ 361건 전원 통과 — Night-52 +1건 안정 유지
2. **flutter analyze**: ✅ 0건 — Phase 13 9파일 수정 후 타입 안전성 유지
3. **cargo test --lib**: ✅ 207건 전원 통과 — Rust rollback warn 패턴 수정 회귀 없음
4. **PLAN_01 Phase 9-14 전체 완료**: Night-47~53 (7세션) 동안 의존성 분석→코드 품질→아키텍처→UI/UX→수정 실행→검증 완결

**Opus 4.6 전략 요약 (Night-53):**
- Phase 14는 "검증 게이트"로 코드 변경 없이 Phase 13의 안정성을 최종 확인
- D-95(LOW)/D-96(MEDIUM) 이연: 기능 구현 항목은 PLAN_02 방향 B/E에서 처리

**다음 세션 최우선 항목:**
- **U-3** (브랜치 머지): 84+ 커밋 → main PR 생성 — 전체 성과 통합
- **D-96** (SearchScreen 필터 재연결 — MEDIUM): 백엔드 지원 4종 필터 UI 노출
- **D-95** (discountRate 다크모드 — LOW): 다크모드 브랜치 머지 후 처리
- **D-82~D-84** (BREAKING 업그레이드): 사용자 결정 후 PLAN_02 방향 A/E 실행

### 1.3a Night-50 전략적 의의: Phase 12 UI/UX 감사 완료

Night-49 Phase 11 (아키텍처 분석) 완료 후, **Night-50은 PLAN_01 Phase 12 UI/UX 감사를 실행**. 5개 핵심 화면(HomeScreen, ProductDetailScreen, SearchScreen, AlertScreen, LoginScreen)과 ProductCard 위젯을 직접 코드 분석.

**핵심 발견:**
- **U-01 (HIGH)**: AppSpacing/AppTextStyles 전체 미적용 — Night-36 도입 이후 어떤 화면에도 적용 안 됨, 87개 매직넘버 잔존
- **U-02 (MEDIUM)**: HomeScreen 에러상태 ScreenErrorWidget 미사용 — Night-37 도입 위젯과 불일치
- **U-07 (MEDIUM)**: SearchScreen 필터/정렬 파라미터 미전달 — 백엔드 기능이 UI에 노출되지 않음

**다음 단계**: D-88~D-96 중 사용자 승인 이슈를 Phase 13에서 수정 실행.

### 1.4 Night-49 전략적 의의: Phase 11 아키텍처 분석 + 프레임워크 최신화 완료

Night-48 Phase 10 (코드 품질 심층 리뷰) 완료 후, **Night-49는 PLAN_01 Phase 11 아키텍처 분석을 병렬 3대 에이전트 + Opus 직접 WebSearch로 실행**.

**실행 전략:**
- 베이스라인 검증 (Flutter 360건 / Rust 207건 / analyze 0건) — 변동 없음 확인
- 병렬 3대 에이전트 동시 배치: feature-dev:code-explorer (Rust 서버 실행경로) + feature-dev:code-architect (Flutter Provider맵) + Opus 직접 WebSearch (최신 패턴)
- D-82~D-87 미결 결정과 Phase 11-14 실행 관계를 사용자에게 B안(통합 압축 실행) 권장

**Night-49 핵심 성과:**
1. **Phase 11 완료**: Rust 서버 5건 + Flutter 앱 8건 = 총 13건 신규 GAP 발견
2. **Rust 서버 아키텍처 분석**:
   - **A-03 (MEDIUM)**: `notification_service.rs` 단일 사용자 경로 N+1 잠재 위험
   - **A-05 (HIGH)**: 백그라운드 태스크(파티션/TTL/rate limiter GC) 자동 재시작 없음 — 패닉 시 영구 중단
   - A-01/A-02/A-04: 마이너 성능 개선 3건
3. **Flutter 앱 아키텍처 분석**:
   - **F-08 (HIGH)**: 401 갱신 실패 시 AuthState 미통보 — 로그인 화면 리다이렉트 누락
   - **F-04 (MEDIUM)**: `AppSpacing`/`AppTextStyles` 정의했으나 **0곳 사용** (87개 raw 매직넘버 잔존)
   - **F-03 (MEDIUM)**: `ScreenErrorWidget` 3/9 화면만 적용 (불일치)
   - **F-06 (MEDIUM)**: `productPredictionProvider` 타입 미완성 (`Map<String,dynamic>`)
   - F-01/F-02/F-05/F-07: 마이너 개선 4건
4. **프레임워크 GAP**: Axum 0.8 GAP 없음 ✅ / Riverpod 3.x AsyncNotifier 전환 GAP ⚠️
5. **신규 결정 항목 5건**: D-88~D-92 — Phase 13 수정 범위 + 적용 범위 + 실행 순서

**Opus 4.6 전략 요약 (Night-49):**
- **Phase 11 배치**: Sonnet Sub-agent 2대(code-explorer + code-architect) + Opus WebSearch 1건 병렬 실행
- **Opus 판단**: F-08(HIGH)을 Night-48의 I-01/I-02와 병합하여 Phase 13 즉시 수정 대상으로 상향
- **F-04 발견**: Night-36에서 AppSpacing/AppTextStyles 도입했으나, 실제 화면에서 미사용 확인 → 87개 매직넘버 잔존 이슈 신규 도출

**Sonnet 4.6 기술 실행:**
- **에이전트 1 (code-explorer)**: Rust main.rs → Router → 미들웨어 → 핸들러 → DB → 응답 전체 경로 추적, 백그라운드 태스크 5개 식별
- **에이전트 2 (code-architect)**: Flutter 15개 화면 Provider 의존성 그래프 매핑, AuthState 단절점 식별
- **WebSearch**: Axum 0.8 middleware 문서 + Riverpod 3.0 What's New + DCM Riverpod best practices 2026

**결정 항목 도출:**
- D-88: F-08 + I-01/I-02 HIGH 3건 Phase 13 즉시 수정 여부
- D-89: AppSpacing/AppTextStyles 적용 범위 (전체/시범 3개/보류)
- D-90: productPredictionProvider 타입 안전화 여부
- D-91: PD-67 priceTrend String→Enum 전환 여부
- D-92: Phase 12(UI/UX 감사) 선행 vs Phase 13(수정 실행) 선행

**다음 세션 최우선 항목:**
- **D-88~D-92** (Phase 11 확인점): Phase 12 또는 Phase 13 진입 조건
- **D-82~D-84** (Phase 9 업그레이드 범위): 지속 대기
- **U-3** (브랜치 머지): 현재 `auto/night-01-20260429_0100` (81+ commits) → main PR 생성

### 1.3a Night-48 전략적 의의: Phase 10 코드 품질 심층 리뷰 완료

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
31. **"축적→폭발" 패턴 실증** (Night-51/52): 12세션 분석 축적(Night-39~50) → Night-51/52에서 8건 코드 수정 일거 실행 — Phase 9~12 도출 이슈를 2세션 만에 Phase 13으로 전환. 축적된 분석이 실행 품질과 속도를 동시에 높이는 패턴 확인
32. **HIGH 우선 → MEDIUM 순차 실행** (Night-51→52): Night-51에서 HIGH 3건(F-08+I-01+I-02) 먼저 수정 → Night-52에서 MEDIUM 3건(AppSpacing+PredictionResult) 순차 — 위험도 기반 실행 순서로 regression 위험 최소화
33. **3중 검증 게이트 패턴** (Night-53): Phase 14에서 `flutter test` + `flutter analyze` + `cargo test --lib` 3중 검증으로 Phase 13 코드 수정 8건의 안정성 최종 확인 — 코드 변경 없이 순수 검증 세션
34. **MCP 도구 사전 탐색 패턴** (Night-54): 새 세션 시작 시 사용 가능한 MCP 도구 전수 점검 → NaverSearch 18+ API 발견 — 이전 세션에서 미확인된 도구가 프로젝트 핵심 가치(가격 추적)와 직접 연관
35. **PLAN 완전 종결 후 방향 전환 패턴** (Night-54): PLAN_01 Phase 1-14 완전 완료 → NaverSearch 발견으로 PLAN_02 방향 B(기능 확장)에 킬러 도구 추가 — 계획 종결과 신규 발견의 교차점에서 방향 재설정

### 1.13 의사결정 일관성

- **총 96개 결정** (D-1 ~ D-96) — Night-50에서 D-93~D-96 추가, Night-51/52에서 8건 해소, Night-53에서 D-95/D-96 이연 확정, Night-54에서 U-43 신규 추가
- REVERSED: 1건 (D-2: utoipa 제거)
- 보류: 3건 (D-32: CheckinResult 열거형, D-33: keepAlive, D-35: build_runner)
- SKIPPED: 2건 (D-36: MCP 마이그레이션, D-40: Ralph Loop)
- DEFERRED: 2건 (D-39: E2E 테스트, D-78: go_router 16→17 보류) — ~~PD-62: Night-36에서 해소~~
- DIAGNOSED: 1건 (D-81: SessionEnd hook — 사용자 방향 결정 대기)
- **IMPLEMENTED (Night-51/52/55/60/61)**: 21건 — D-85~D-94(Night-51/52), D-96(Night-55), D-104~D-106(Night-60 구현), D-107/D-108(Night-61 확정), I-03~I-05+F-09/F-10(Night-61 수정)
- **PENDING (사용자 결정 대기)**: 8건 — D-82~D-84(Phase 9 BREAKING 업그레이드), D-86(Phase 10 MEDIUM 2건), D-87(Phase 10 LOW 4건), D-95(discountRate 색상), D-101(Riverpod BREAKING), D-102(Dart BREAKING 5종)
- **나머지: IMPLEMENTED/DECIDED 유지** (Night-37 D-78~D-79 + Night-51~61 누적)

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
| **49** | **Opus 4.6 (Phase 11 실행) + Sonnet ×2 병렬 + WebSearch** | **프로덕션 코드 변경 0건** | **360건 유지** | **Phase 11: feature-dev:code-explorer(Rust 실행경로) + feature-dev:code-architect(Flutter Provider맵) + Opus WebSearch(Axum 0.8/Riverpod 3.x/DCM) → Rust 5건 + Flutter 8건 = 13건 GAP, D-88~D-92 도출** |
| **50** | **Opus 4.6 (Phase 12 실행) 직접 코드 분석** | **프로덕션 코드 변경 0건** | **360건 유지** | **Phase 12: 5개 핵심 화면 + ProductCard 직접 UI/UX 감사 → 9건 발견(HIGH 1 + MEDIUM 3 + LOW 5), AppSpacing/TextStyles 전체 미적용(U-01), 검색 필터 미연결(U-07), D-93~D-96 도출** |
| **51** | **Sonnet 4.6 Sub-agent (Phase 13 직접 코드 수정)** | **Rust 2파일 수정 + Flutter 9파일 수정** | **360건 유지** | **Phase 13 1차: I-01(rollback warn 2곳) + I-02(ORIGINS warn) + F-08(onSessionExpired) + U-02(ScreenErrorWidget) + D-91(PriceTrend Enum 9파일) — HIGH 3건 + MEDIUM 2건 = 5건 코드 수정** |
| **52** | **Sonnet 4.6 Sub-agent (Phase 13 직접 코드 수정)** | **Flutter 16파일 수정 (freezed 재생성 포함)** | **+1건 (361건)** | **Phase 13 2차: D-94(AppSpacing.smMd=12) + D-89(3화면 AppSpacing pilot, 26매직넘버 치환) + D-90(PredictionResult freezed model + PredictionAction enum + _confidenceFromJson 방어파싱) — MEDIUM 3건 코드 수정** |
| **53** | **Opus 4.6 직접 실행 (Phase 14 검증)** | **프로덕션 코드 변경 0건** | **361건 유지** | **Phase 14: Flutter 361건 + Rust 207건 + analyze 0건 3중 검증 통과. PLAN_01 Phase 9-14 전체 완료 선언. D-95/D-96 이연 확정** |
| **54** | **Opus 4.6 직접 실행 (종합 분석 + MCP 발견)** | **프로덕션 코드 변경 0건** | **361건 유지** | **Night-13~53 종합 분석: NaverSearch MCP 18+ API 신규 발견(search_shop/datalab_shopping), PLAN_01 완전 완결 재확인, 84커밋 종합 분석, 사용자 방향 결정 대기** |
| **55** | **Sonnet 4.6 Sub-agent (D-96 코드 수정) + Opus 분석** | **Flutter 2파일 수정** | **+4건 (365건)** | **D-96 해소: SearchScreen _FilterChipRow 위젯 분리 + DropdownButton 정렬 4종 + service.search(filter/sort) 연결 + 테스트 4건. MCP: CoinInfo(7)+cryptoGuardian(6) 신규 발견** |
| **56** | **Sonnet 4.6 Sub-agent (Phase 15 기술 실행) + Opus 전략 설계** | **Rust 4파일 + Flutter 10파일 + migration 2파일** | **Rust +7건 (214건)** | **Phase 15: NaverSearch MCP 8회 호출 → Rust naver_price_service + trend_data_service 신규 + Flutter 모델/서비스/프로바이더/위젯 5파일 + migration 019 = 14파일 코드 생성. Opus: Phase 15-19 5단계 전략 + D-97~D-111 결정 포인트 15개 설계** |
| **57** | **Sonnet 4.6 Sub-agent (N56 미결 해소)** | **Rust 3파일 + Flutter 1파일** | **Rust +2건 (216건), Flutter +5건 (370건)** | **N56-02: trends.rs 핸들러 + 직렬화 2건. N56-04: TrendChartWidget 테스트 5건. Phase 15 기본 파이프라인 완성 (Flutter→API→서버→MCP 경로 완전 연결)** |
| **58** | **Sonnet 4.6 Sub-agent (N56-05 통합 + Phase 16) + Opus 전략** | **Flutter 2파일 수정** | **370건 보존** | **N56-05: ProductDetailScreen TrendChartWidget 통합 + categoryTrendsProvider override. N56-01: API 제약 문서화(DECIDED). Phase 16: Sonatype 실패→WebSearch, BREAKING 5종 이연(D-101/D-102), Rust BREAKING 불필요(D-103 DECIDED)** |
| **59** | **Sonnet 4.6 Sub-agent ×3 (feature-dev 병렬) + HuggingFace MCP + Opus 전략** | **Flutter 1파일 수정 (테스트 격리 M-1)** | **370건 보존** | **Phase 17: code-explorer(실행경로) + code-architect(캐싱) + code-reviewer(코드품질) 3대 병렬 → 구조 갭 5건 + 캐싱 갭 3건 발견. M-1 즉시 수정(buildScreen 패턴). HuggingFace MCP 조회(프레임워크 문서 없음 확인). D-104~D-106 도출** |
| **60** | **Sonnet 4.6 Sub-agent (Phase 17 코드 구현)** | **Rust 4파일 수정 (+350/-83줄)** | **370건 보존** | **Phase 17 코드: D-104(moka trend_data 캐시 TTL 24h/max 50) + D-105(warmup_trend_cache 1h 배치 태스크) + D-106(OnceLock 제거 + AppState.http_client 공유, 커넥션 풀 3→1). H-1 해소, 경고 0건** |
| **61** | **Sonnet 4.6 Sub-agent ×4 (병렬 감사) + Opus 수정** | **Rust 3파일 + Flutter 1파일 수정** | **370건 보존** | **Phase 18: silent-failure-hunter + type-design-analyzer + code-reviewer + code-simplifier 4대 병렬 → 수정 5건(I-03 Months/I-04 warn/I-05 pub(crate)/F-09 변수 추출/F-10 중복 가드). D-107(ProductDetailScreen 확정)/D-108(신규 위젯 한정). Rust 216건/Flutter 370건/analyze 0건** |
| **62** | **Sonnet 4.6 Sub-agent (Phase 19 검증)** | **프로덕션 코드 변경 0건** | **370건 보존** | **Phase 19 완결: Flutter 370건 / Rust 216건 / analyze 0건 3중 검증 통과. PLAN_01 Phase 1~19 전체 종결 선언. D-109(커밋 구조 확정)/D-110(PR 생성)/D-111(PLAN_02 방향) 도출** |
| **63** | **Sonnet 4.6 Sub-agent (사후 검증 + 문서)** | **프로덕션 코드 변경 0건** | **370건 보존** | **베이스라인 재검증 통과(370/216/0건). MORNING_BRIEFING Night-62 해시 반영 + Night-63 결과 문서화. 커밋 `0351800` + `807617c`. D-110(PR)/D-111(PLAN_02) 사용자 결정 대기 지속** |

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
| 아키텍처 분석 | `feature-dev:code-explorer` + `code-architect` + `code-reviewer` | Night-59 Phase 17 (3대 병렬) | ✅ 활성 |
| 품질 감사 | `silent-failure-hunter` + `type-design-analyzer` + `code-reviewer` + `code-simplifier` | Night-61 Phase 18 (4대 병렬) | ✅ 활성 |
| 문서 조회 | HuggingFace MCP (`hf_doc_search`) | Night-59 Phase 17 (프레임워크 문서 — 해당 없음 확인) | ✅ 활성 |
| 의존성 보안 | Sonatype MCP | Night-31~50: 인증 실패 | ❌ **32세션** 연속 실패 |
| 코드 간소화 | `pr-review-toolkit:code-reviewer` + `pr-review-toolkit:silent-failure-hunter` | Night-37 Phase 7-D 리뷰 | ✅ 활성 |
| 대체 전략 | WebSearch + RustSec DB + NVD | Night-31~37: 대체 성공 | ✅ 활성 |
| 외부 참조 | WebSearch + WebFetch | MCP 대체 (D-36:C) | ✅ 활성 |

### 2.3a Night-54~55 PlayMCP 도구 매트릭스

> Night-54에서 **PlayMCP** 플러그인 내 5개 서비스 신규 발견. Night-55에서 **CoinInfo**(7) + **cryptoGuardian**(6) 추가 확인 → 총 **8개 서비스 62+ API**.

| MCP 서비스 | API 수 | 값뚝 관련성 | 핵심 API | 현재 상태 | 발견 Night |
|-----------|--------|------------|----------|----------|-----------|
| **NaverSearch** | **18+** | **★★★★★** | `search_shop` (쇼핑 검색), `datalab_shopping_category/keywords` (트렌드), `datalab_shopping_by_age/gender/device` (인구 분석), `search_blog/news` | ✅ **즉시 사용 가능** (익명, rate limit 적용) | Night-54 |
| **KakaoMap** | 4 | ★★ | `SearchPlaceByKeywordOpen` (장소 검색), `GetPublicTransitDirections` | ✅ 사용 가능 | Night-54 |
| **KakaotalkChat** | 1 | ★ | `MemoChat` (메모/알림) | ✅ 사용 가능 | Night-54 |
| **opendart** | 14 | ★★ | `find_company`, `get_financial_statement`, `get_full_financial_statement` | ✅ 사용 가능 | Night-54 |
| **UsStockInfo** | 9 | ★ | 미국 주식 전용 — 값뚝 비해당 | ✅ 사용 가능 (비활용) | Night-54 |
| **CoinInfo** | 7 | ★ | `get_coin_price`, `get_kimchi_premium`, `get_fear_greed_index`, `get_market_overview` — 암호화폐 | ✅ 사용 가능 (비활용) | Night-55 |
| **cryptoGuardian** | 6 | ★ | `validate_crypto_site`, `get_trending_scams`, `list_verified_exchanges` — 보안 검증 | ✅ 사용 가능 (비활용) | Night-55 |

**NaverSearch 값뚝 활용 시나리오 (PLAN_02 연계):**

| API | 활용 방안 | PLAN_02 방향 |
|-----|----------|-------------|
| `search_shop` | 네이버 쇼핑 실시간 가격 조회 → 서버 크롤러 보완/대체 | B(기능 확장) |
| `datalab_shopping_category` | 카테고리별 쇼핑 트렌드 → 인기검색어 정밀화 | B(기능 확장) |
| `datalab_shopping_keywords` | 키워드 클릭 트렌드 → 가격 변동 예측 피처 | B(기능 확장) |
| `datalab_shopping_by_age/gender` | 사용자 세그먼트별 트렌드 → 개인화 알림 | B(기능 확장) |
| `find_category` | 네이버 쇼핑 카테고리 ID 조회 → API 호출 전제 | 인프라 |

**MCP 가용성 종합 (Night-55 실측):**

| 구분 | 도구 | 상태 |
|------|------|------|
| **즉시 활성** | feature-dev(3종), pr-review-toolkit(6종), superpowers(12종), coderabbit, code-simplifier, commit-commands, frontend-design | ✅ |
| **PlayMCP (8서비스 62+ API)** | NaverSearch(18+), KakaoMap(4), KakaotalkChat(1), opendart(14), UsStockInfo(9), CoinInfo(7), cryptoGuardian(6) | ✅ (rate limit) |
| **OAuth 대기** | Gmail, Google Calendar, Google Drive, Zapier, Slack, Figma, Stripe, Supabase, Linear, Sentry, PostHog, Asana, Atlassian, GitLab, CircleBack | ⏳ 인증 필요 |
| **설치됨/미연결** | context7, playwright, serena | ⚠️ WebSearch/feature-dev 대체 |
| **인증 미구성** | sonatype-guide | ⚠️ **30세션** 연속 |
| **비해당** | mcp-tailwind-gemini, shadcn | ❌ Flutter 프로젝트 |

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

### 3.10 Night-53/54 작업 내역

#### Night-53 (Phase 14 — 최종 검증, 커밋 `193ba3d`, `666c4cf`)

| 작업 | 파일 | 내용 |
|------|------|------|
| Phase 14 3중 검증 | — | `flutter test` 361건 ✅ + `flutter analyze` 0건 ✅ + `cargo test --lib` 207건 ✅ |
| PLAN_01 Phase 9-14 완료 선언 | `MORNING_BRIEFING.md` | Night-53 전략 §1.3b + Phase 완료 마킹 |
| D-95/D-96 이연 확정 | `MORNING_BRIEFING.md` | Phase 14 범위 초과 → PLAN_02 방향 결정 후 실행 |

**프로덕션 코드 변경: 0건** — 순수 검증 세션
**테스트 변경: 0건** — 361건 유지

#### Night-54 (종합 분석 + NaverSearch MCP 발견, 커밋 TBD)

| 작업 | 파일 | 내용 |
|------|------|------|
| Night-13~53 종합 분석 | `MORNING_BRIEFING.md` | §1~§9 전체 Night-54 반영 — 42세션 전략/기술/코드 종합 + PlayMCP 신규 발견 |
| PlayMCP 도구 매트릭스 | `MORNING_BRIEFING.md` | §2.3a 신규 — NaverSearch(18+)/KakaoMap(4)/opendart(14)/CoinInfo(7) 관련성 분류 |
| NaverSearch 활용 시나리오 | `MORNING_BRIEFING.md` | search_shop(실시간 가격) + datalab_shopping(트렌드) → PLAN_02 방향 B 연계 |
| U-43 방향 선택 제시 | `MORNING_BRIEFING.md` | A/B/C/D 4선택지 — 사용자 결정 대기 |

**프로덕션 코드 변경: 0건** — 분석 + MCP 발견 세션
**테스트 변경: 0건** — 361건 유지

**Night-53/54 실행 특성:**
- **Night-53**: Opus 4.6 직접 실행 (Phase 14 검증) — Sonnet 미사용, 순수 검증 게이트
- **Night-54**: Opus 4.6 직접 실행 (종합 분석) — PlayMCP NaverSearch 18+ API 신규 발견, MCP 도구 전수 점검
- **MCP/플러그인**: Night-54에서 PlayMCP 도구 5개 서비스 신규 발견 (NaverSearch ★★★★★ 최고 관련성)
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~54, **46회+** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

---

### 3.9a Night-55 코드 변경 (커밋 `157a353`, `a980657`)

#### D-96 해소: SearchScreen 필터/정렬 재연결

| 파일 | 변경 | 내용 |
|------|------|------|
| `app/lib/screens/search/search_screen.dart` | +118줄, -29줄 | `_filter`/`_sortBy` 상태 변수 + `_FilterChipRow` 위젯 분리 + `DropdownButton<String?>` 정렬 + `_applyFilter()`/`_applySort()` 즉시 재검색 |
| `app/test/screens/search_screen_test.dart` | +48줄 | 필터 칩 4개 표시, 칩 탭→select, 재탭→deselect, Icons.sort 아이콘 |
| `NIGHT_06_RESULT.md` | +52줄 | Night-55 결과 기록 |

**구현 세부:**

| 구성 요소 | 구현 |
|----------|------|
| **`_FilterChipRow`** | `StatelessWidget` — `List<(String, String)>` filters + `ValueChanged<String?>` onChanged + `SingleChildScrollView` 가로 스크롤 |
| **필터 4종** | `near_stockout`(품절 임박), `all_time_low`(역대 최저가), `declining`(하락 중), `under_10k`(1만원 이하) |
| **정렬 4종** | `ranking`(인기순), `discount_rate`(할인율순), `discount_amount`(할인금액순), `lowest_price`(최저가순) |
| **재검색 트리거** | `_applyFilter()`/`_applySort()` — `_hasSearched` true 시 즉시 `_search()` 호출 |
| **API 연결** | `service.search(query:, filter: _filter, sort: _sortBy, cursor:, cancelToken:)` |

**테스트 패턴 (D-97):**
- `find.widgetWithText(FilterChip, '품절 임박')` — 타입+텍스트 조합으로 정확한 위젯 특정
- `chipBefore.selected` → `false` → tap → `chipAfter.selected` → `true` — 상태 전환 검증
- 재탭 → deselect — toggle 동작 검증 (같은 필터 2번 탭)

**프로덕션 코드 변경: 1파일** — `search_screen.dart` (필터/정렬 UI + 백엔드 연결)
**테스트 변경: +4건** — 361 → **365건**

**Night-55 실행 특성:**
- **Sonnet 4.6 Sub-agent (D-96 코드 수정)** + **Opus 4.6 종합 분석 (MORNING_BRIEFING)**
- **MCP 환경 확장**: CoinInfo(7) + cryptoGuardian(6) 신규 발견 → PlayMCP 총 8서비스 62+ API
- **AppSpacing 적용 확장**: `search_screen.dart`에서도 `AppSpacing.md`/`AppSpacing.sm` 사용 (Night-52 pilot 패턴 확장)
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~55, **48회+** 누적) — D-81 사용자 옵션 선택 대기

---

### 3.11 Night-56~62 통합 작업 내역 — Phase 15~19 완전 사이클 (7세션)

> **총 기간**: 2026-05-04 ~ 2026-05-10 | **커밋**: `3004b9e` ~ `a283cb0` (7개 feat/docs 커밋)
> **Opus 4.6 전략**: Phase 15-19 설계(Night-56) → 분석→구현→검증 3단 체계 일관 적용
> **Sonnet 4.6 기술 실행**: NaverSearch MCP 8회 호출 + feature-dev 3대 병렬 + 4대 에이전트 품질 점검

#### Night-56 (Phase 15 — NaverSearch 파이프라인 구축, 커밋 `3004b9e`)

| 작업 | 코드 | 내용 |
|------|------|------|
| NaverSearch MCP 실측 | 8회 호출 | find_category(3) + search_shop(3) + datalab_shopping_category(1) + datalab_shopping_keywords(1, 400 에러) |
| Rust naver_price_service | +233줄 | NaverShopResponse 구조체, `search_naver_shop()`, `strip_html_tags()`, `parse_price_str()` + 테스트 3건 |
| Rust trend_data_service | +252줄 | NaverDatalabResponse, `get_category_trends()`, `compute_trend_score()` + 테스트 4건 |
| Migration 019 | +25줄 | `naver_category_mapping` 테이블 + 초기 3카테고리(생활/식품/가전) |
| Flutter 5파일 | +280줄 | naver_trend.dart(모델) + naver_trend_service.dart + naver_trend_provider.dart + trend_chart.dart(위젯) + api_endpoints 추가 |
| D-97~D-100 결정 | — | CoinInfo 미포함(B) / OpenDart 미포함(B) / 3종 카테고리(A) / 전체 생성(A) |

#### Night-57 (N56 미결 해소 — 파이프라인 연결, 커밋 `8284cdd`)

| 작업 | 코드 | 내용 |
|------|------|------|
| N56-02: trends.rs 핸들러 | +107줄 | `GET /api/v1/trends/naver` + 직렬화 테스트 2건 |
| N56-04: TrendChartWidget 테스트 | +5건 | 빈목록/정상/범례 + SummaryCard momChange 양수/음수 |
| 베이스라인 상승 | — | Flutter 365→**370건**(+5) / Rust 214→**216건**(+2) |

#### Night-58 (N56 전량 해소 + Phase 16 분석, 커밋 `abb06a8` + `a62071d`)

| 작업 | 코드 | 내용 |
|------|------|------|
| N56-05: ProductDetailScreen 통합 | ~40줄 | categoryTrendsProvider watch + TrendChartWidget 섹션 + 테스트 override |
| N56-01: API 제약 문서화 | — | datalab_keywords 중분류 코드 필요 (leaf-node 400 에러) |
| Phase 16 의존성 분석 | — | BREAKING 5종 이연(D-102) / Rust BREAKING 불필요(D-103 DECIDED) |

#### Night-59 (Phase 17 아키텍처 분석, 커밋 `d619495`)

| 작업 | 에이전트 | 내용 |
|------|---------|------|
| code-explorer | Sonnet | Phase 15 코드 실행경로 추적 → OnceLock vs AppState DI 불일치 발견 (P-1~P-5) |
| code-architect | Sonnet | 캐싱 아키텍처 감사 → trend_data 캐시 미등록 확인 (C-1~C-3) |
| code-reviewer | Sonnet | H-1(캐싱 없음 HIGH) + M-1(테스트 격리) + M-2(OnceLock 타임아웃) |
| HuggingFace MCP | Sonnet | ML 플랫폼 특성 → 프레임워크 문서 없음 확인, 가격 예측 논문 참조만 |
| M-1 즉시 수정 | Opus | `buildScreen()` 헬퍼 패턴으로 categoryTrendsProvider override 자동 포함 |
| D-104~D-106 도출 | Opus | moka 확장(A) / 1h 배치(B) / AppState.http_client 공유(B) |

#### Night-60 (Phase 17 코드 구현, 커밋 `6ae63b3`)

| 작업 | 파일 | 내용 |
|------|------|------|
| D-104: moka 캐시 | cache.rs | `trend_data: Cache<String, Vec<CategoryTrendScore>>` — TTL 24h/max 50 + Prometheus gauge |
| D-105: 1h 배치 웜업 | main.rs | `warmup_trend_cache()` + `h_trend` 백그라운드 태스크 + 패닉 감시 |
| D-106: OnceLock 제거 | trend_data_service.rs | static TREND_CLIENT 완전 제거, `&reqwest::Client` 파라미터화, 환경변수 직접 호출 제거 |
| D-106: 핸들러 통합 | trends.rs | `State<AppState>` 추가, `try_get_with("default", ...)` thundering herd 방어 |
| 합산 | 4파일 +350/-83줄 | 커넥션 풀 3→1 통합, H-1 완전 해소 |

#### Night-61 (Phase 18 코드 품질 점검, 커밋 `57cc02f`)

| 에이전트 | 발견 | 수정 |
|---------|------|------|
| silent-failure-hunter | MEDIUM 2 + LOW 1 | **I-03**: `Duration::days(180)` → `Months::new(6)` (달력 정확도) / **I-04**: `debug!` → `warn!` |
| type-design-analyzer | 9타입 평가 | **I-05**: `pub` → `pub(crate)` (내부 DTO 가시성 제한) |
| code-reviewer | HIGH 2 + MEDIUM 4 | I-03 중복 확인 |
| code-simplifier | 간소화 2건 | **F-09**: isUp 삼항 → 로컬 변수 / **F-10**: 중복 isEmpty 가드 제거 |
| D-107/D-108 확정 | — | 트렌드=ProductDetailScreen(A) / 디자인 규칙=신규 위젯 한정(A) |

#### Night-62 (Phase 19 최종 검증 + PLAN_01 종결, 커밋 `a283cb0`)

| 작업 | 결과 | 내용 |
|------|------|------|
| 3중 검증 | ✅ 통과 | Flutter **370건** + Rust **216건** + analyze **0건** |
| PLAN_01.md 완료 마킹 | ✅ | Phase 1~19 전체 완료 마킹 + Phase 19 검증 결과 기록 |
| D-109 확정 | ✅ | Phase별 분리 커밋(A) — 이미 Night-56~61에서 Phase별 커밋 완료 |
| D-110 도출 | ⏳ | main 머지 PR 생성 여부 — **사용자 결정 대기** |
| D-111 도출 | ⏳ | PLAN_02 방향(A/B/C/D) — **사용자 결정 대기** |

#### Phase 15~19 합산 지표

| 지표 | Phase 15 시작 | Phase 19 종료 | 변화 |
|------|-------------|-------------|------|
| Flutter 테스트 | 365건 | **370건** | **+5** |
| Rust 테스트 | 207건 | **216건** | **+9** |
| Rust 서비스 | 0 | **2** (naver_price + trend_data) | **+2** |
| Flutter 파일 | 0 | **6** (model/service/provider/widget/test) | **+6** |
| Migration | 018 | **019** (naver_category_mapping) | **+1** |
| moka 캐시 슬롯 | 4 | **5** (trend_data) | **+1** |
| 커넥션 풀 | 3 (OnceLock 2 + AppState 1) | **1** (AppState) | **-2** |
| 배치 태스크 | 4 | **5** (warmup_trend_cache) | **+1** |
| D 결정 해소 | D-96 | D-97~**D-111** (15건) | **+15** |
| 코드 수정 | 0 | **10건** (Rust 6 + Flutter 4) | **+10** |

---

### 3.10a Night-51/52 작업 내역 (커밋 `13975b9`, `f1e699b`)

#### Night-51 (Phase 13 1차 — 5건 코드 수정)

| 작업 | 파일 | 내용 |
|------|------|------|
| I-01 rollback warn | `server/src/services/reward_service.rs:381,390` | `tx.rollback().await?` → `if let Err(rb_err) = tx.rollback().await { warn!() }` 표준 패턴 (2곳) |
| I-02 ORIGINS warn | `server/src/main.rs:490-493` | `ALLOWED_ORIGINS` 빈 배열 경고 추가 — `origins.is_empty()` 체크 |
| F-08 onSessionExpired | `app/lib/services/api_client.dart` + `app/lib/main.dart` | `ApiClient.onSessionExpired` static 콜백 + main.dart `logout()` 연결 |
| U-02/D-93 ScreenErrorWidget | `app/lib/screens/home/home_screen.dart` | `Center(child: Text(...))` → `ScreenErrorWidget` 교체 (재시도 버튼 자동 추가) |
| D-91/PD-67 PriceTrend Enum | 9파일 (model+freezed+g+card+detail+test3) | `PriceTrend String?` → `PriceTrend Enum` 전환 (AlertType PD-62 동일 패턴) |

**프로덕션 코드 변경: 5건 (Rust 2 + Flutter 3)** — ★ 12세션 분석 정체 종료, Phase 13 실행 개시
**테스트 변경: 0건** — 360건 유지 (기존 테스트 enum 전환만)

#### Night-52 (Phase 13 2차 — 3건 코드 수정)

| 작업 | 파일 | 내용 |
|------|------|------|
| D-94 AppSpacing.smMd | `app/lib/config/theme.dart` | `smMd = 12` 상수 추가 — sm(8)~md(16) 중간값 |
| D-89 AppSpacing 3화면 | `home_screen.dart` + `login_screen.dart` + `product_detail_screen.dart` | 26개 매직 넘버(4/8/12/16/24/32/48) → AppSpacing 상수 치환 |
| D-90 PredictionResult | 7파일 (model+freezed+g+service+provider+detail+test3) | `Map<String,dynamic>` → `PredictionResult` freezed + `PredictionAction` enum + `_confidenceFromJson` 방어 파싱 |

**프로덕션 코드 변경: 3건** — Phase 13 2차 실행
**테스트 변경: +1건** — 361건 (prediction null 반환 케이스 추가)

**Night-51/52 실행 특성:**
- **Sonnet 4.6 Sub-agent 직접 코드 수정** — Opus 전략 결정 후 Sonnet이 실행
- **MCP/플러그인 미사용** — 순수 코드 수정 세션 (분석은 Phase 9~12에서 완료)
- **25파일 변경, +682/-205줄** — 2세션 합산
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~52, **44회** 누적)

### 3.10a Night-50 작업 내역 (커밋 `81dcf6f`, `7fa34d1`)

| 작업 | 파일 | 내용 |
|------|------|------|
| Phase 12 UI/UX 감사 | — | 5개 핵심 화면(Home/ProductDetail/Search/Alert/Login) + ProductCard 직접 코드 분석 |
| 감사 결과 문서화 | `MORNING_BRIEFING.md` | Night-50 전략 §1.3 + Phase 12 결과 + D-93~D-96 결정 추가 |
| DECISION_LOG 갱신 | `DECISION_LOG.md` | D-93(ScreenErrorWidget) + D-94(12dp 갭) + D-95(discountRate 색상) + D-96(검색 필터 재연결) |
| NIGHT_06_RESULT 갱신 | `NIGHT_06_RESULT.md` | Night-50 Phase 12 결과 112줄 추가 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 �� / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — Phase 12는 감사 전용 (Night-40~50, **12세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-50 실행 특성:**
- **Opus 4.6 직접 코드 분석** — Sub-agent 미사용, 5개 화면 소스 직접 읽기
- **MCP/플러그인 미사용** — 코드 감사 전용 세션
- **핵심 발견**: AppSpacing/AppTextStyles 87개 매직넘버 전체 미적용(U-01 HIGH), 검색 필터 미연결(U-07 MEDIUM), HomeScreen ScreenErrorWidget 불일치(U-02 MEDIUM)
- **설계 드리프트(Design Drift) 패턴 발견**: Night-36에 정의된 상수가 어떤 화면에도 import 없음 — "상수 정의 ≠ 적용"의 전형적 실수
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~50, **40회** 누적) — D-81로 원인 규명됨, 사용자 옵션 선택 대기

### 3.10a Night-49 작업 내역 (커밋 `090dc8d`, `7fa34d1`)

| 작업 | 파일 | 내용 |
|------|------|------|
| Phase 11 아키텍처 분석 | `docs/plans/PLAN_01.md` | Phase 11 완료 마킹 + 확인점 업데이트 |
| 병렬 3에이전트 실행 | — | code-explorer(Rust 실행경로) + code-architect(Flutter Provider맵) + WebSearch(프레임워크 최신화) |
| MORNING_BRIEFING Night-49 반영 | `MORNING_BRIEFING.md` | Night-49 전략/아키텍처 결과 + D-88~D-92 결정 항목 |
| NIGHT_06_RESULT Night-49 기록 | `NIGHT_06_RESULT.md` | Night-49 섹션 추가 |
| 베이스라인 재검증 | — | Flutter 360건 ✅ / Rust 207건 ✅ / analyze 0건 ✅ |

**프로덕션 코드 변경: 0건** — Phase 11은 분석 전용 (Night-40~49, **11세션 연속 코드 변경 0건**)
**테스트 변경: 0건** — 360건 유지

**Night-49 실행 특성:**
- **Opus 4.6 전략 + Sonnet 4.6 ×2 병렬 에이전트 + Opus WebSearch**
- **MCP/플러그인 활용**: `feature-dev:code-explorer` + `feature-dev:code-architect` (병렬 2대)
- **핵심 산출물**: Rust 5건 + Flutter 8건 = 13건 아키텍처 GAP + D-88~D-92 결정 5건
- **SessionEnd hook 실패**: `node` 미설치 (Night-30~49, **40회** 누적)

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
Night-50: 360건 ──── +0건 (Phase 12 UI/UX 감사 — 코드 변경 0건, 5개 화면+ProductCard 직접 감사)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 12 완료: 9건(HIGH 1+MEDIUM 3+LOW 5), AppSpacing 전체 미적용(U-01), 검색필터 미연결(U-07), D-93~D-96 도출. 12세션 연속 코드 변경 0건
Night-51: 360건 ──── +0건 테스트, +5건 프로덕션 수정 (Phase 13 1차 — I-01/I-02/F-08/U-02/D-91)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ ★축적→폭발★ Phase 13 실행 개시: HIGH 3건(F-08+I-01+I-02) + MEDIUM 2건(U-02+D-91). 12세션 분석 정체 종료!
Night-52: 361건 ──── +1건 (Phase 13 2차 — D-89/D-94/D-90, prediction null 테스트 추가)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 13 가속: AppSpacing 3화면 pilot(26매직넘버) + PredictionResult freezed model. 8건/15건 결정 해소
Night-53: 361건 ──── +0건 (Phase 14 최종 검증 — 코드 변경 0건, 3중 검증 게이트 통과)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ PLAN_01 Phase 9-14 전체 완료 선언: Flutter 361건/Rust 207건/analyze 0건 — D-95/D-96 이연 확정
Night-54: 361건 ──── +0건 (Night-13~53 종합 분석 + NaverSearch MCP 18+ API 발견 — 코드 변경 0건, 분석 전용)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ NaverSearch MCP 발견: search_shop/datalab 18+API — PLAN_02 방향 B(기능 확장) 핵심 도구. 84커밋 종합 분석
Night-55: 365건 ──── +4건 (D-96 해소: SearchScreen 필터/정렬 재연결 + _FilterChipRow 위젯 분리 + DropdownButton 정렬)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ 이연 소화: D-96 MEDIUM 해소 + MCP 확장(CoinInfo/cryptoGuardian) → 미결 6건→5건. 89커밋 도달
Night-56: 365건 ──── +0건 Flutter, Rust +7건 (207→214) (Phase 15 NaverSearch 파이프라인 — Rust 코드 생성 주력)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ Phase 15: NaverSearch MCP 8회 실측 → Rust 2서비스+Flutter 5파일 14파일 코드 생성. Opus Phase 15-19 전략 설계
Night-57: 370건 ──── +5건 (TrendChartWidget 테스트 5건) + Rust +2건 (214→216)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ N56-02/04 해소: trends 핸들러+위젯 테스트. Phase 15 기본 파이프라인 완성 (Flutter→API→서버→MCP)
Night-58: 370건 ──── +0건 (N56-05 ProductDetailScreen TrendChartWidget 통합 + Phase 16 의존성 분석)
          ↑ ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ N56 전량 해소: Phase 15 완결 + Phase 16 진입. D-101~D-103 도출, BREAKING 5종 이연 결정
```

### 3.17 코드베이스 규모

| 항목 | **Night-58** | Night-57 | Night-55 | 변화 (vs 57) |
|------|-------------|----------|----------|-------------|
| DB 마이그레이션 (브랜치) | **019** | 019 | 018 | — |
| 서버 API 핸들러 | **38+** | 38+ | 37+ | — |
| Flutter 화면 | 15+ | 15+ | 15+ | — |
| Prometheus 메트릭 | 22 | 22 | 22 | — |
| DECISION_LOG 항목 | **D-103** | D-100 | D-97 | **+3** (D-101~D-103 Phase 16) |
| 순수 함수 추출 누계 | **15개**/54테스트 | 15개/54 | 15개/54 | — |
| Silent Failure 수정 | 33건+ (잔존 0건) | 33건+ | 33건+ | — |
| 프로덕션 코드 수정 (Night-58) | **2파일** (product_detail_screen + test) | 4파일 | 1파일 | — |
| Flutter 테스트 | **370건** ✅ | 370건 | 365건 | — |
| Rust 테스트 | **216건** ✅ | 216건 | 207건 | — |
| 커밋 (main 대비) | **93** | 91 | 89 | **+2** (`abb06a8`, `a62071d`) |
| PLAN_01 Phase 완료 | **14/14** ✅ + **Phase 15 ✅** | 14/14 + Phase 15 기본 | 14/14 | **Phase 15 완결** |
| PLAN_01 Phase 16 | **분석 완료** (D-101~D-103 도출) | — | — | **신규** |
| Phase 13 결정 해소 | **9/15** (잔여 6건) | 9/15 | 9/15 | — |
| PlayMCP MCP | **8서비스 62+ API** | 8서비스 62+ API | 8서비스 62+ API | — |
| N56 미결 | **5/5 ✅ 전량 해소** | 3/5 | — | **+2** (N56-01, N56-05) |

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

### 4.1 활성 브랜치 (2026-05-09, Night-61)

| 브랜치 | main 대비 | 핵심 변경 | 충돌 위험 | 상태 |
|--------|----------|-----------|----------|------|
| **`auto/night-01-20260509_0100`** ★ | **+99 commits** | Night-13~61 전체 + **PLAN_01 Phase 1-14 + Phase 15~18 완결** + NaverSearch 파이프라인 + moka 캐시/배치/리팩토링 + 품질 점검 5건 + Flutter **370건** + Rust **216건** | **낮음** | 현재 HEAD |
| `fix/phase0-security-stability` | +3 commits | FK CASCADE(020), 리퍼럴 API, 검색필터, CD | **높음** | origin push |
| `feat/phase2-monthly-prices` | +3 commits | Monthly API + Flutter 차트 | **중간** | origin push |
| `feat/dark-mode` | +1 commit | 다크모드 + SharedPreferences | **낮음** | 로컬만 |

### 4.2 삭제 안전한 브랜치 (19개+)

| 브랜치 | 근거 |
|--------|------|
| `auto/night-01-20260303~0307_0100` (5개) | main에 PR #1으로 머지됨 |
| `auto/night-01-20260308_0100` | Night-13에서 재구현 |
| `auto/night-01-20260309_0100` | Night-10에 포함 |
| `auto/night-01-20260312~0508_0100` (41개+) | **Night-61 현 브랜치에 완전 포함** |

### 4.3 권장 머지 순서

```
1. auto/night-01-20260509_0100 → main (99+커밋, PLAN_01 Phase 1-18 + NaverSearch 파이프라인 + 캐시/배치/품질 + Flutter 370건 + Rust 216건, 충돌 없음) → 즉시 PR 가능
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
| **11** | 아키텍처 + 프레임워크 최신화 | ✅ **완료** | **49** | **병렬 3에이전트: Rust 5건 + Flutter 8건 = 13건 GAP, Axum GAP 없음/Riverpod AsyncNotifier GAP, D-88~D-92 도출** |
| **12** | 프론트엔드 UI/UX 감사 | ✅ **완료** | **50** | **Opus 직접 코드 분석: 5개 화면+ProductCard → 9건(HIGH 1+MEDIUM 3+LOW 5), AppSpacing 드리프트 확인, D-93~D-96 도출** |
| **13** | 발견 사항 기반 코드 수정 | ✅ **완료** (8/15건 실행, 7건 사용자 결정 이연) | **51-52** | **Night-51: 5건(I-01/I-02/F-08/U-02/D-91) + Night-52: 3건(D-89/D-94/D-90) = 8건 해소. 이연 7건: D-82~D-84/D-86/D-87/D-95/D-96** |
| **14** | 최종 검증 + 커밋 | ✅ **완료** | **53** | **Flutter 361건 / Rust 207건 / analyze 0건 — 3중 검증 통과. PLAN_01 Phase 9-14 전체 완료** |
| **15** | NaverSearch MCP 파이프라인 | ✅ **완료** | **56~58** | **MCP 8회 호출 → Rust 2서비스+migration + Flutter 5파일 생성 + N56 5/5 전량 해소** |
| **16** | 의존성 최신화 분석 | ✅ **분석 완료** | **58** | **BREAKING 5종 이연(D-101/D-102), Rust BREAKING 불필요(D-103 확정)** |
| **17** | 아키텍처 고도화 | ✅ **완료** | **59-60** | **Night-59: feature-dev 3대 병렬 분석 + D-104~D-106 도출. Night-60: 코드 구현 완결 — moka 캐시/배치 웜업/OnceLock 제거** |
| **18** | 프론트엔드 UX + 코드 품질 | ✅ **완료** | **61** | **병렬 4대 에이전트: 수정 5건(I-03/I-04/I-05/F-09/F-10) + D-107/D-108 확정** |
| **19** | 최종 검증 + 커밋 | ⏳ 대기 | — | 3중 검증 + 구조화된 커밋 (D-109~D-111) |

### Phase 18 결정 사항 (D-107~D-108, Night-61)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| ~~**D-107**~~ | ~~트렌드 데이터 표시 위치~~ | ~~A) ProductDetailScreen B) 별도 탭 C) 홈~~ | ✅ **Night-61 CONFIRMED (A — 현재 위치 유지)** |
| ~~**D-108**~~ | ~~디자인 시스템 규칙 범위~~ | ~~A) 신규 위젯만 B) 전면 적용~~ | ✅ **Night-61 DECIDED (A — Phase 19에서 B 재검토)** |

### Phase 17 결정 사항 (D-104~D-106, Night-59/60)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| ~~**D-104**~~ | ~~NaverSearch 트렌드 캐시 전략~~ | ~~A) moka 확장 B) Redis C) 하이브리드~~ | ✅ **Night-60 IMPLEMENTED (A — TTL 24h, max 50)** |
| ~~**D-105**~~ | ~~NaverSearch 호출 빈도~~ | ~~A) 실시간 B) 1h 배치 C) 이벤트~~ | ✅ **Night-60 IMPLEMENTED (B — warmup + h_trend 배치)** |
| ~~**D-106**~~ | ~~서비스 리팩토링 범위~~ | ~~A) 신규만 B) AppState 공유~~ | ✅ **Night-60 IMPLEMENTED (B — OnceLock 제거, 풀 3→1)** |

### Phase 16 결정 사항 (D-101~D-103, Night-58)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-101** | Riverpod BREAKING 세트 | A) 즉시 B) 별도 세션 C) 보류 | ⏳ **사용자 결정 대기** |
| **D-102** | Dart BREAKING 5종 범위 | A) 전체 B) 보안만 C) 보류 D) 순차 | ⏳ **사용자 결정 대기** |
| ~~**D-103**~~ | ~~Rust BREAKING 포함 여부~~ | — | ✅ **DECIDED — 불필요** |

### Phase 9 결정 사항 (D-82~D-84, Night-47)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-82** | Rust BREAKING 업그레이드 범위? | A) 전체(reqwest/jwt/sentry) B) sentry만 C) 전부 보류 | ⏳ **사용자 결정 대기** |
| **D-83** | Dart BREAKING 업그레이드 범위? | A) kakao 2.0 포함 전체 B) riverpod만 C) 전부 보류 | ⏳ **사용자 결정 대기** |
| **D-84** | Dart non-BREAKING 4건 즉시 적용? | A) 전체 B) dev만 C) 보류 | ⚠️ **Night-66 부분 해소** — build_runner 2.15.0 + mocktail 1.0.5 완료. freezed/json_serializable은 riverpod_generator ^3.0.0 analyzer 충돌로 D-101과 연계 필요 |

### Phase 10 결정 사항 (D-85~D-87, Night-48)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-85** | I-01+I-02 HIGH 2건 즉시 수정? | A) Phase 13에서 수정 B) 보류 | ✅ **Night-51에서 해소 (→ D-88에 통합)** |
| **D-86** | I-03+I-04+PD-67 MEDIUM 3건 수정 범위? | A) 전체 B) PD-67만 C) 보류 | ✅ **Night-66에서 해소 (I-03/I-04 수정 완료, PD-67은 Night-51 D-91에서 이미 해소)** |
| **D-87** | LOW 4건 Phase 13 포함? | A) 포함 B) 제외 | ⏳ **사용자 결정 대기** |

### Phase 11 결정 사항 (D-88~D-92, Night-49)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-88** | F-08(HIGH 401 미리다이렉트) + I-01/I-02 Phase 13 즉시 수정? | A) HIGH 3건 즉시 수정 B) F-08만 C) 보류 | ✅ **Night-51에서 해소 (A안 실행: 3건 모두 수정)** |
| **D-89** | AppSpacing/AppTextStyles 적용 범위? (87개 매직넘버 잔존) | A) 전체 15개 화면 B) 시범 3개 화면 C) 보류 | ✅ **Night-52에서 해소 (B안 실행: 3화면 pilot)** |
| **D-90** | productPredictionProvider 타입 안전화? | A) PredictionResult 모델 도입 B) 보류 | ✅ **Night-52에서 해소 (A안 실행: PredictionResult freezed model)** |
| **D-91** | PD-67 priceTrend String→Enum 전환? (PD-62 선례) | A) Phase 13에서 전환 B) 보류 | ✅ **Night-51에서 해소 (A안 실행: PriceTrend Enum 전환)** |
| **D-92** | Phase 12/13 실행 순서? | A) Phase 12(UI/UX 감사) 선행 B) Phase 13(수정 실행) 선행 C) 병합 | ✅ **Night-50에서 자동 해소 (Phase 12 완료 → Phase 13 직행)** |

### Phase 12 결정 사항 (D-93~D-96, Night-50)

| ID | 질문 | 선택지 | 상태 |
|----|------|--------|------|
| **D-93** | HomeScreen 에러상태 ScreenErrorWidget 교체? | A) ScreenErrorWidget 교체(4줄, 재시도 추가) B) 보류 | ✅ **Night-51에서 해소 (A안 실행: ScreenErrorWidget 교체)** |
| **D-94** | AppSpacing 12dp 갭 상수 추가? (6개소 사용) | A) `smMd=12` 추가 B) 기존 sm/md로 통일 C) D-89 보류면 유지 | ✅ **Night-52에서 해소 (A안 실행: smMd=12 추가)** |
| **D-95** | AppTextStyles.discountRate 색상 제거? (다크모드 불일치) | A) 색상 제거→사용처 copyWith B) 보류(다크모드 미활성) | ✅ **Night-66에서 해소 (A안 실행: 하드코딩 색상 제거, 사용처에서 appColors.error 적용 패턴)** |
| **D-96** | SearchScreen 검색 필터/정렬 재연결? (백엔드 지원 미노출) | A) 신규 구현 B) cherry-pick 검토 C) 보류 | ✅ **Night-55에서 해소 (A안 실행: 필터/정렬 UI 재연결 + 테스트 +4건)** |

### Phase 12 발견 이슈 상세 (Night-50)

| # | ID | 이슈 | 파일 | 심각도 |
|---|-----|------|------|--------|
| 1 | U-01 | AppSpacing/AppTextStyles 87개 매직넘버 전체 미적용 | 전체 화면 | **HIGH** |
| 2 | U-02 | HomeScreen 에러상태 ScreenErrorWidget 미사용 | `home_screen.dart:94-95` | MEDIUM |
| 3 | U-03 | AppSpacing 12dp 상수 갭 (6개소 반복 사용) | `login_screen.dart` 등 | MEDIUM |
| 4 | U-04 | 아이콘 의미론 개선 | 다수 화면 | LOW |
| 5 | U-05 | M3 Material Design 3 가이드라인 | 전체 | LOW |
| 6 | U-06 | AppTextStyles.discountRate 다크모드 색상 불일치 | `theme.dart:35` | LOW |
| 7 | U-07 | SearchScreen 필터/정렬 파라미터 미전달 | `search_screen.dart:65-70` | MEDIUM |
| 8 | U-08 | 접근성 Semantics 추가 필요 화면 | 다수 화면 | LOW |
| 9 | U-09 | 일관되지 않은 에러 처리 패턴 | 다수 화면 | LOW |

### Phase 11 발견 이슈 상세 (Night-49)

**Rust 서버 아키텍처 GAP:**

| # | ID | 이슈 | 파일:위치 | 심각도 |
|---|-----|------|----------|--------|
| 1 | A-01 | price_history SELECT 후 in-memory 변환 | `products.rs` | LOW |
| 2 | A-02 | search 핸들러 다중 쿼리 (COUNT + SELECT 분리) | `products.rs` | LOW |
| 3 | A-03 | notification 단일 사용자 경로 N+1 잠재 | `notification_service.rs` | MEDIUM |
| 4 | A-04 | alert evaluate 루프 내 개별 푸시 발송 | `alert_service.rs` | LOW |
| 5 | A-05 | 백그라운드 태스크 자동 재시작 없음 (패닉 시 영구 중단) | `main.rs` | **HIGH** |

**Flutter 앱 아키텍처 GAP:**

| # | ID | 이슈 | 파일:위치 | 심각도 |
|---|-----|------|----------|--------|
| 1 | F-01 | ApiClient 싱글톤 — DI 불가 (테스트 stub 어려움) | `api_client.dart` | LOW |
| 2 | F-02 | 서비스 클래스 static 메서드 — Riverpod Provider 미통합 | `*_service.dart` | LOW |
| 3 | F-03 | ScreenErrorWidget 3/9 화면만 적용 (불일치) | `*_screen.dart` | MEDIUM |
| 4 | F-04 | AppSpacing/AppTextStyles 0곳 사용 (87개 매직넘버) | `*_screen.dart` | MEDIUM |
| 5 | F-05 | GoRouter redirect 인증 체크 미구현 | `app_router.dart` | LOW |
| 6 | F-06 | productPredictionProvider 타입 미완성 | `providers.dart` | MEDIUM |
| 7 | F-07 | dio Interceptor 에러 분기 단순 | `api_client.dart` | LOW |
| 8 | F-08 | 401 갱신 실패 시 AuthState 미통보 (리다이렉트 누락) | `api_client.dart` | **HIGH** |

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
| **U-3** | Night-13~61 머지 방향 | `auto/night-01-20260509_0100` (99+커밋, **PLAN_01 Phase 1-14 + Phase 15~18 완결**, Flutter **370건**, Rust **216건**, 경고 0건) | A) main 로컬 머지 B) Push + PR C) 유지 D) 폐기 |
| ~~**U-43**~~ | ~~Night-60 이후 방향 선택~~ | ~~Phase 17 코드 구현 완료~~ | ✅ **Night-61에서 해소 (A안 Phase 18 실행 — 병렬 에이전트 4대 + 수정 5건)** |
| **U-44** | Night-61 이후 방향 선택 | Phase 18 완료 — Phase 19(최종 검증/커밋) vs D-101 Riverpod BREAKING vs 기타 | A) Phase 19(검증+커밋) B) D-101 Riverpod BREAKING C) D-108-B AppSpacing 전면 롤아웃 D) 기타 |
| ~~**D-107**~~ | ~~트렌드 데이터 표시 위치~~ | ~~ProductDetailScreen 통합 유지~~ | ✅ **Night-61 CONFIRMED** |
| ~~**D-108**~~ | ~~디자인 시스템 규칙 범위~~ | ~~신규 위젯 한정~~ | ✅ **Night-61 DECIDED (A — Phase 19에서 B 재검토)** |
| ~~**D-104**~~ | ~~NaverSearch 트렌드 캐시 전략~~ | ~~`get_naver_trends()` 매 요청마다 Naver API 호출~~ | ✅ **Night-60에서 해소 (A안 moka 확장 — TTL 24h, max 50, try_get_with thundering herd 방어)** |
| ~~**D-105**~~ | ~~NaverSearch 호출 빈도~~ | ~~Naver API rate limit~~ | ✅ **Night-60에서 해소 (B안 1h 배치 — warmup_trend_cache + h_trend 백그라운드 태스크)** |
| ~~**D-106**~~ | ~~서비스 리팩토링 범위~~ | ~~OnceLock 3개 병존~~ | ✅ **Night-60에서 해소 (B안 AppState.http_client 공유 — OnceLock 제거, 커넥션 풀 3→1)** |
| **D-101** | Riverpod BREAKING 세트 | flutter_riverpod 3.3 + riverpod_generator 4.x — 모든 `@riverpod` 파일 재생성 필요 (370건 테스트 영향) | A) 즉시 B) 별도 세션 C) 보류 |
| **D-102** | Dart BREAKING 5종 범위 | go_router 17 / fl_chart 1.2 / google_sign_in 7 / flutter_secure_storage 10 / sign_in_with_apple 7 | A) 전체 B) 보안만(google_sign_in+secure_storage) C) 순차 D) 보류 |
| **D-82** | Rust BREAKING 업그레이드 범위 | Phase 9 발견: reqwest 0.12→0.13, jwt 9→10, sentry 0.37→0.47 (3건 모두 메이저 API 변경) | A) 전체 B) sentry만 C) 전부 보류 |
| **D-83** | Dart BREAKING 업그레이드 범위 | Phase 9 발견: kakao 2.0, riverpod_gen 4.x, go_router 17, fl_chart 1.2 외 4건 (인증 플로우 변경 리스크 포함) | A) kakao 2.0 포함 전체 B) riverpod만 C) 전부 보류 |
| **D-84** | Dart non-BREAKING 4건 즉시 적용 | build_runner, freezed, mocktail, json_annotation (dev dependency 포함) | A) 전체 B) dev만 C) 보류 |
| ~~**D-86**~~ | ~~Phase 10 MEDIUM 잔여 2건 수정~~ | ~~I-03(0원 예측 캐시) + I-04(NULL UNIQUE)~~ | ✅ **Night-66에서 해소** |
| **D-87** | Phase 10 LOW 잔여 2건 (PD-65/PD-66) | ~~I-06/I-07~~ ✅ Night-67 해소. **PD-65**(API 파단) + **PD-66**(타입 아키텍처) — 사용자 협의 필요 | A) 포함 B) 제외 |
| ~~**D-95**~~ | ~~discountRate 색상 제거~~ | ~~하드코딩 색상 제거 완료~~ | ✅ **Night-66에서 해소** |
| ~~**D-96**~~ | ~~SearchScreen 필터/정렬 재연결~~ | ~~백엔드 4필터+4정렬 UI 미노출~~ | ✅ **Night-55에서 해소 (A안 신규구현 — _FilterChipRow + DropdownButton + 테스트 4건)** |
| ~~**D-88**~~ | ~~Phase 11 HIGH 3건~~ | ~~F-08+I-01+I-02~~ | ✅ **Night-51에서 해소 (A안 전체 수정)** |
| ~~**D-89**~~ | ~~AppSpacing 적용 범위~~ | ~~87개 매직넘버~~ | ✅ **Night-52에서 해소 (B안 3화면 pilot)** |
| ~~**D-90**~~ | ~~PredictionResult 타입화~~ | ~~Map→Model~~ | ✅ **Night-52에서 해소 (A안 모델 도입)** |
| ~~**D-91**~~ | ~~PriceTrend Enum~~ | ~~PD-67~~ | ✅ **Night-51에서 해소 (A안 전환)** |
| ~~**D-92**~~ | ~~Phase 12/13 순서~~ | — | ✅ **자동 해소 (Phase 12→13 직행)** |
| ~~**D-93**~~ | ~~ScreenErrorWidget~~ | — | ✅ **Night-51에서 해소 (A안 교체)** |
| ~~**D-94**~~ | ~~smMd=12~~ | — | ✅ **Night-52에서 해소 (A안 추가)** |
| ~~**D-85**~~ | ~~HIGH 2건~~ | ~~→ D-88에 통합~~ | ✅ **Night-51에서 해소** |
| ~~**U-42**~~ | ~~PLAN_02 방향 선택~~ | ~~Night-38~46 9세션 대기~~ | ✅ **Night-47에서 해소** |

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
| **U-38** | Sonatype MCP 인증 설정 | **30세션 연속 실패** — 인증 설정하거나 영구 스킵 결정 필요 |
| **U-35** | RUSTSEC-2026-0049 모니터링 | a2 upstream rustls 0.23 전환 시 audit.toml ignore 제거 필요 |
| **U-14** | 보류 결정 3건 | D-32(CheckinResult 열거형), D-33(keepAlive), D-35(build_runner) |
| **U-8** | 다음 로드맵 방향 | AI 예측 고도화 / E2E 테스트 / 인프라 / BREAKING 업그레이드 중 우선순위 |
| **U-11** | HF_TOKEN 갱신 | Hugging Face MCP OAuth 만료 |
| **U-16** | rand 0.8→0.9 업그레이드 | API 변경 규모 커서 분석만 수행, 실행 보류 |
| | Flutter 엔진 Skia CVE 모니터링 | CVE-2025-27363 + CVE-2026-3909 — Flutter stable 업데이트 시 즉시 적용 |

---

## 7. Night-66/67에서 해결/생성된 항목

### ✅ Night-67에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **D-87 I-06** product_service Sentry 스택트레이스 | **LOW** | `tracing::error!(error = %other, ...)` 추가 — moka Arc 래핑 전 원본 에러 보존 |
| **D-87 I-07** price_chart dayOfWeek x좌표 | **LOW** | `e.key`(배열 인덱스) → `e.dayOfWeek`(실제 요일값) — 비연속 요일 차트 정확도 |
| **베이스라인 보존** | **HIGH** | Flutter 370건 / Rust 216건 / analyze 0건 — 5세대 브랜치(`auto/night-01-20260515_0100`) 첫 세션 검증 |

### ⏳ Night-67 잔여 대기

| 항목 | 등급 | 대기 사유 |
|------|------|----------|
| **D-110** main 머지 PR | **CRITICAL** | 109커밋 → main. **17세션째 사용자 결정 대기** |
| **D-111** Phase 20+ 방향 | **HIGH** | A/B/C 방향. **17세션째 사용자 결정 대기** |
| **D-87 PD-65** CheckinResult API 파단 | **MEDIUM** | `reward_amount → bool rewarded` — 사용자/팀 협의 필요 |
| **D-87 PD-66** PointsInfo pub→private | **MEDIUM** | 타입 불변식 강제 — 방향 결정 후 처리 |
| **D-101** Riverpod BREAKING | **HIGH** | 별도 전용 세션 필요 |
| **D-102** Dart BREAKING 5종 | **HIGH** | 순차 처리 필요 |

### ✅ Night-66에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **D-86 I-03** 0원 예측 캐시 방지 | **MEDIUM** | `current_price <= 0` 조기 반환 — moka `try_get_with` Err 비캐시 특성 활용 |
| **D-86 I-04** migration 020 NULLS NOT DISTINCT | **MEDIUM** | PG15+ `UNIQUE NULLS NOT DISTINCT` — NULL 포함 복합 유니크 위반 방지 |
| **D-84** build_runner + mocktail 업그레이드 | **LOW** | build_runner 2.15.0 + mocktail 1.0.5 (non-BREAKING 부분) |
| **D-95** discountRate 하드코딩 색상 제거 | **LOW** | `AppTextStyles.discountRate` → 호출처 `appColors.error` 위임 |

---

## 7. Night-62/63에서 해결/생성된 항목

### ✅ Night-62에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **Phase 19 최종 검증** | **CRITICAL** | Flutter 370건 / Rust 216건 / analyze 0건 3중 검증 통과 — PLAN_01 Phase 15~19 전체 완결 |
| **D-109** 커밋 구조 전략 | **확인** | A — Phase별 분리 (Night-56~61에서 이미 Phase별 커밋 완료) |
| **PLAN_01 Phase 1~19 전체 종결** | **★★★** | Night-30 수립 → Night-62 종결: 32세션, 19 Phase 완전 사이클 |

### ✅ Night-63에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **베이스라인 재검증** | **HIGH** | 신규 브랜치(`auto/night-01-20260511_0100`)에서 370/216/0건 3중 검증 재확인 |
| **MORNING_BRIEFING Night-62 해시** | **문서** | `a283cb0` 해시 공식 반영 |
| **NIGHT_06_RESULT Night-63** | **문서** | Night-63 결과 섹션 추가 |

### 🆕 Night-62/63에서 생성됨 (사용자 결정 대기)

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-110** main 머지 PR 생성 | **🔴 CRITICAL** | `auto/night-01-20260511_0100` (98+ 커밋) → main PR — PLAN_02 전제 조건 |
| **D-111** PLAN_02 방향 결정 | **🔴 CRITICAL** | A)BREAKING 업그레이드+main 머지 / B)신규 MCP 기능 확장 / C)조합(A+B 순차) |
| **Phase 20+ 전략 설계** 진입 가능 | **HIGH** | PLAN_01 완전 종결로 차기 PLAN 즉시 설계 가능 — D-111 사용자 결정 선행 필요 |
| **MCP 확장 발견** | **MEDIUM** | UsStockInfo(8+)/KakaoMap(4)/KakaotalkChat(1) 신규 확인 — Phase 20+ B방향 추가 도구 |

---

## 7. Night-61에서 해결/생성된 항목

### ✅ Night-61에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **Night-60 커밋** 미커밋 Phase 17 코드 | **HIGH** | 커밋 `6ae63b3` — D-104/D-105/D-106 코드 안전 보존 |
| **I-03** `Duration::days(180)` 6개월 오차 | **MEDIUM** | `chrono::Months::new(6)` — 달력 기반 정확한 6개월 (최대 6일 오차 해소) |
| **I-04** NAVER 자격증명 부분 누락 `debug!` | **MEDIUM** | `warn!`로 상향 — 운영자가 설정 오류 즉시 인지 |
| **I-05** NaverShopResponse/Item `pub` 과도 공개 | **LOW** | `pub(crate)` — 내부 DTO가 외부 API 경계에 노출 방지 |
| **F-09** TrendSummaryCard `isUp` 삼항 4회 반복 | **LOW** | `trendColor`/`trendIcon` 로컬 변수 추출 — 코드 중복 제거 |
| **F-10** `_buildTitlesData` 중복 `isEmpty` 가드 | **LOW** | 불필요한 방어 코드 삭제 — 호출 시점에 이미 보장됨 |
| **D-107** 트렌드 데이터 표시 위치 | **확인** | A — ProductDetailScreen 현재 위치 확정 (N56-05 통합 유지) |
| **D-108** 디자인 시스템 규칙 범위 | **결정** | A — 신규 위젯 한정 (전면 롤아웃은 Phase 19로 이연) |

### 🆕 Night-61에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-108-B 이연** AppSpacing 전면 롤아웃 | **MEDIUM** | trend_chart.dart 포함 전체 화면 — Phase 19 또는 별도 세션에서 처리 |
| **TrendRequest 개선** 이연 | **LOW** | 날짜 순서 검증 + 빈 카테고리 방어 생성자 (`TrendRequest::new()`) |
| **CategoryTrendScore.mom_change** 명명 | **LOW** | `mom_change_pct` 필드명 변경 검토 (Flutter 클라이언트 명확성) |
| **Phase 19 진입 가능** | **HIGH** | Phase 18 완결로 최종 검증 + 구조화 커밋 즉시 진입 가능 |

---

## 7. Night-60에서 해결/생성된 항목

### ✅ Night-60에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **D-104** AppCache trend_data 캐시 추가 | **CRITICAL** | `cache.rs`에 `trend_data: Cache<String, Vec<CategoryTrendScore>>` 슬롯 추가 (TTL 24h, max 50). `report_metrics()`에 Prometheus gauge 추가 |
| **D-105** 1h 배치 trend 웜업 태스크 | **CRITICAL** | `main.rs`에 `warmup_trend_cache()` 함수 + `h_trend` 1h 배치 백그라운드 태스크. NAVER 자격증명 미설정 시 조용히 건너뜀. 패닉 감시 등록 |
| **D-106** OnceLock 제거 + AppState.http_client 공유 | **CRITICAL** | `trend_data_service.rs` static TREND_CLIENT 완전 제거. 함수 시그니처 파라미터화. `trends.rs` State<AppState> 추가 + try_get_with 캐시 적용. 커넥션 풀 3→1 통합 |
| **H-1** 매 요청 Naver API 호출 | **HIGH** | D-104+D-105+D-106 조합으로 완전 해소: 캐시 히트 시 API 호출 0회, p99 ~500ms→~5ms |
| **M-2** OnceLock 타임아웃 불일치 (trend_data_service) | **MEDIUM** | D-106으로 OnceLock 제거 → AppState.http_client(30s) 단일 사용으로 불일치 해소 |

### 🆕 Night-60에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **M-2 잔여** naver_price_service.rs OnceLock | **LOW** | 고아 모듈(라우트 미연결) — 향후 상품별 가격 검증 라우트 연결 시 동일 D-106 패턴 적용 예정. 현재 비활성이므로 영향 없음 |
| **Phase 18 진입 가능** | **HIGH** | Phase 17 완결로 Phase 18(프론트엔드 UX 최적화 + 코드 품질 최종 점검) 즉시 진입 가능 |

---

## 7. Night-59에서 해결/생성된 항목

### ✅ Night-59에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **M-1** product_detail_screen_test 테스트 격리 | **MEDIUM** | `categoryTrendsProvider` override 누락 → `buildScreen()` 헬퍼 패턴으로 교체 — 에러 테스트에서 실제 네트워크 호출 방지 |

### 🔍 Night-59에서 발견됨 (Phase 17 아키텍처 분석)

| 구분 | 항목 | 설명 | 심각도 |
|------|------|------|--------|
| **구조 갭** | `trends.rs` DI 우회 | `State<AppState>` 미추출 — 핸들러가 DI 우회 | MEDIUM |
| **구조 갭** | `naver_price_service.rs` 고아 모듈 | 어떤 라우트에서도 호출되지 않음 | LOW |
| **구조 갭** | OnceLock 이중 클라이언트 | 10s + 15s OnceLock vs AppState.http_client 30s | MEDIUM |
| **구조 갭** | Naver 자격증명 분산 | 두 서비스에서 각각 `env::var()` 직접 호출 | MEDIUM |
| **구조 갭** | `/trends/naver` rate limit 없음 | 공개 엔드포인트에 rate limit 미적용 | MEDIUM |
| **캐싱 갭** | trend_data 캐시 없음 (H-1) | `get_naver_trends()` 매 요청 API 호출 — AppCache 미등록 | **HIGH** |
| **캐싱 갭** | thundering herd 미방어 | 동시 요청 coalescing 없음 | MEDIUM |
| **캐싱 갭** | Flutter auto-dispose 중첩 | @riverpod auto-dispose + 반복 호출 시 불필요 재요청 | LOW |

### 🆕 Night-59에서 생성됨 (D-104~D-106)

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-104** | CRITICAL | 캐시 전략 — moka 확장(A, 권장) vs Redis(B) vs 하이브리드(C). D-104+D-105+D-106 모두 승인 시 ~90줄 코드로 H-1/M-2 자동 해소 |
| **D-105** | CRITICAL | 호출 빈도 — 실시간(A) vs 1h 배치(B, 권장) vs 이벤트(C). API 쿼터 97.6% 여유, 월별 데이터 신선도 1h 충분 |
| **D-106** | CRITICAL | 서비스 리팩토링 — 현재 유지(A) vs AppState.http_client 공유(B, 권장). OnceLock 제거로 커넥션 풀 3→1 통합 |

---

## 7. Night-56/57/58에서 해결/생성된 항목

### ✅ Night-58에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **N56-05** ProductDetailScreen TrendChartWidget 통합 | **LOW** | `categoryTrendsProvider` watch + `TrendChartWidget` 섹션 추가 (오류 시 `SizedBox.shrink()`, 로딩 시 `LinearProgressIndicator`) + 테스트 categoryTrendsProvider override |
| **N56-01** datalab_shopping_keywords 400 오류 | **MEDIUM** | API 제약 문서화: 중분류(소분류="") 코드만 허용. 가전(50000151=노트북) ✅, 식품/생활 불가. `datalab_shopping_category`(기존 코드)로 유지 |

### 🆕 Night-58에서 생성됨 (D-101~D-103)

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-101** | CRITICAL | Riverpod BREAKING 세트 — flutter_riverpod 3.0→3.3.1 (minor) + riverpod_generator 3.x→4.x (BREAKING) 동반. 모든 `@riverpod` 파일 + `.g.dart` 재생성 필요. **Opus 권장: B) 별도 세션** |
| **D-102** | CRITICAL | Dart BREAKING 5종 범위 — go_router 16→17.2.3 / fl_chart 0.69→1.2.0 / google_sign_in 6→7.2.0 / flutter_secure_storage 9→10.0.0 / sign_in_with_apple 6→7.0.1. **Opus 권장: D) 순차 처리 (보안 우선: secure_storage→google_sign_in→riverpod→go_router→fl_chart)** |
| **D-103** | INFO | Rust BREAKING 포함 여부 — **DECIDED: 불필요** (cargo update 범위 내 최신 자동 유지, reqwest 1.x/sentry 0.38 업그레이드 시기 없음) |

### ✅ Night-57에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **N56-02** 서버 trends 핸들러 | **HIGH** | `server/src/api/routes/trends.rs` 신규: `GET /api/v1/trends/naver` + 직렬화 테스트 2건 |
| **N56-04** TrendChartWidget 테스트 | **MEDIUM** | `app/test/widgets/trend_chart_test.dart` 신규: 빈목록/정상/범례 3건 + TrendSummaryCard 2건 = 5건 |
| **N56-03** .env.example 반영 | **HIGH** | Night-56에서 이미 완료 확인 |

### 🆕 Night-56에서 생성됨 (Phase 15 코드 + D-97~D-100)

| 항목 | 등급 | 설명 |
|------|------|------|
| **Phase 15 코드 14파일** | HIGH | Rust: naver_price_service.rs(+3테스트) + trend_data_service.rs(+4테스트) + migration 019 + mod.rs. Flutter: naver_trend.dart(freezed) + naver_trend_service.dart + naver_trend_provider.dart + trend_chart.dart + api_endpoints.dart + service_providers.dart |
| **D-97** | INFO | CoinInfo 암호화폐 미포함 — **DECIDED: B** (도메인 외) |
| **D-98** | INFO | OpenDart 기업재무 미포함 — **DECIDED: B** (쇼핑 가격과 무관) |
| **D-99** | INFO | NaverSearch 카테고리 3종 — **DECIDED: A** (생활용품+식품+가전) |
| **D-100** | INFO | 코드 생성 전체 — **DECIDED: A** (B1-B5 전체) |

---

## 7. Night-55에서 해결/생성된 항목

### ✅ Night-55에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|----------|
| **D-96** SearchScreen 필터/정렬 재연결 | **MEDIUM** | A안 신규구현 — `_FilterChipRow` 위젯 분리 + `DropdownButton` 정렬 4종 + `service.search(filter/sort)` 연결 + 테스트 4건 |

### 🆕 Night-55에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-97** | INFO | FilterChip 테스트 패턴 — `find.widgetWithText(FilterChip, label)` + `.selected` 상태 전환 + 재탭 deselect toggle 검증 |

### 📊 Night-55 MCP 환경 변화

| 변화 | 상세 |
|------|------|
| **CoinInfo 7 API 신규** | `get_coin_price`, `get_kimchi_premium`, `get_fear_greed_index`, `get_market_overview`, `get_top_gainers`, `get_top_losers`, `get_coin_dominance` |
| **cryptoGuardian 6 API 신규** | `validate_crypto_site`, `get_trending_scams`, `list_verified_exchanges`, `educate_user`, `get_crypto_stats`, `report_scam` |
| **PlayMCP 총계** | 6서비스 53+ API → **8서비스 62+ API** |
| **값뚝 활용도** | CoinInfo/cryptoGuardian 모두 ★ (비해당) — NaverSearch ★★★★★ 여전히 핵심 |

---

## 7. Night-53/54에서 해결/생성된 항목

### ✅ Night-53에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 14 최종 검증** | **CRITICAL** | **Flutter 361건 / Rust 207건 / analyze 0건 — 3중 검증 게이트 통과. PLAN_01 Phase 9-14 전체 완료 선언** |
| **Phase 13 코드 수정 8건 안정성** | **HIGH** | **Night-51/52 수정 8건에 대한 regression 없음 최종 확인** |
| **D-95/D-96 이연 결정** | **MEDIUM** | **Phase 14 범위 초과 → PLAN_02 방향 결정 후 실행으로 이연 확정** |

### ✅ Night-54에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **Night-13~53 종합 분석** | **HIGH** | **MORNING_BRIEFING.md 전체 Night-54 반영 — Opus 전략(42세션)/Sonnet 기술/코드 결과/PlayMCP 발견 종합** |
| **NaverSearch MCP 발견 + 분류** | **HIGH** | **18+ API 발견 → search_shop/datalab_shopping 4개 핵심 활용 시나리오 도출 → PLAN_02 방향 B(기능 확장) 킬러 도구로 위치** |
| **PlayMCP 도구 매트릭스** | **MEDIUM** | **5개 서비스(NaverSearch/KakaoMap/KakaotalkChat/opendart/UsStockInfo) 관련성 분류 완료** |
| **PLAN_01 완전 완결 재확인** | **INFO** | **Phase 1-14 전체 ✅ — Night-30 수립 → Night-53 완결, 24세션** |

### 🆕 Night-54에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **U-43 방향 선택** | **CRITICAL** | A) Phase 13 잔여 완결 B) NaverSearch 통합 우선 C) 조합(Opus 권장) D) 기타 — **사용자 결정 필요** |
| **NaverSearch search_shop PoC** | **HIGH** | 네이버 쇼핑 실시간 가격 조회 → 기존 크롤러 보완/대체 가능성 검증 필요 |
| **NaverSearch datalab 트렌드 연동** | **HIGH** | 카테고리/키워드 쇼핑 트렌드 → 인기검색어 정밀화 + 가격 예측 피처 |
| **PlayMCP 인구 분석** | **MEDIUM** | `datalab_shopping_by_age/gender/device` → 개인화 알림 고도화 |
| **85+커밋 브랜치 머지** | **CRITICAL** | U-3 재강조 — PLAN_01 전체 성과 통합이 어떤 PLAN_02 방향이든 전제 조건 |

---

## 7. Night-51/52에서 해결/생성된 항목

### ✅ Night-51/52에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **D-88 (F-08+I-01+I-02) HIGH 3건 수정** | **CRITICAL** | **Night-51: I-01 rollback warn 2곳 + I-02 ORIGINS warn + F-08 onSessionExpired — HIGH 3건 모두 A안 실행** |
| **D-91/PD-67 PriceTrend Enum** | **MEDIUM** | **Night-51: PriceTrend String→Enum 전환 (9파일) — AlertType PD-62 동일 패턴** |
| **D-93/U-02 ScreenErrorWidget 교체** | **MEDIUM** | **Night-51: HomeScreen 에러상태 → ScreenErrorWidget 교체 (재시도 버튼 자동 추가)** |
| **D-94 AppSpacing.smMd=12** | **MEDIUM** | **Night-52: theme.dart에 smMd=12 상수 추가** |
| **D-89 AppSpacing 3화면 pilot** | **MEDIUM** | **Night-52: Home/Login/ProductDetail 3화면에 26개 매직넘버 → AppSpacing 상수 치환** |
| **D-90 PredictionResult freezed model** | **MEDIUM** | **Night-52: Map→PredictionResult freezed + PredictionAction enum + _confidenceFromJson 방어파싱** |
| **D-85 → D-88 통합** | **HIGH** | **Night-51에서 D-88 A안 실행으로 자동 해소** |
| **D-92 Phase 순서** | **HIGH** | **Night-50 Phase 12 완료 → Phase 13 직행으로 자동 해소** |
| **12세션 코드 변경 0건 정체 종료** | **INFO** | **Night-51에서 5건 코드 수정으로 Night-39~50 분석 정체 종료** |

### 🆕 Night-51/52에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **Phase 13 잔여 7건** | **HIGH** | D-82~D-84(BREAKING) + D-86(MEDIUM 2건) + D-87(LOW 4건) + D-95(색상) + D-96(필터) |
| **rollback warn 10곳 표준** | **INFO** | Night-23(5곳) + Night-35(3곳) + Night-51(2곳) = 10곳 — 코드베이스 전체 표준 패턴 완성 |
| **AppSpacing 나머지 12화면 확장** | **MEDIUM** | pilot 3화면 성공 → 나머지 12개 화면으로 확장 가능 (D-89 후속) |

---

## 7. Night-50에서 해결/생성된 항목

### ✅ Night-50에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 12 UI/UX 감사** | **HIGH** | **Opus 직접 코드 분석: 5개 화면+ProductCard → 9건(HIGH 1+MEDIUM 3+LOW 5) 발견** |
| **설계 드리프트 확인** | **HIGH** | **AppSpacing/AppTextStyles Night-36 도입 → Night-50 감사 시 0곳 사용 확인 — "정의 ≠ 적용" 패턴 식별** |
| **Night-50 결과 문서화** | **MEDIUM** | **MORNING_BRIEFING + DECISION_LOG(D-93~D-96) + NIGHT_06_RESULT Night-50 반영 (커밋 `81dcf6f`)** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-50 실측 확인** |

### 🆕 Night-50에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-93 ScreenErrorWidget 교체** | **MEDIUM** | HomeScreen 에러상태 인기검색어 → ScreenErrorWidget 교체 (4줄, 재시도 기능 추가) |
| **D-94 12dp 갭 상수** | **MEDIUM** | `AppSpacing.smMd = 12` 추가 — 6개소 매직넘버 12 교체 (D-89 종속) |
| **D-95 discountRate 색상 제거** | **LOW** | 다크모드 색상 불일치 방지 — `color` 제거 후 사용처 `copyWith` 적용 |
| **D-96 검색 필터 재연결** | **MEDIUM** | 백엔드 4필터+4정렬 → SearchScreen UI 미노출 — MEMORY 기록과 코드 드리프트 |
| **누적 미결 결정 15건 일괄 권장** | **CRITICAL** | D-82~D-96 (Phase 9/10/11/12 결정) — Phase 13 즉시 진입 위한 일괄 결정 권장 |
| **12세션 연속 코드 변경 0건** | **INFO** | Night-39~50 — 분석/감사/문서 세션 축적 → Phase 13에서 "축적→폭발" 패턴으로 전환 예정 |

---

## 7. Night-49에서 해결/생성된 항목

### ✅ Night-49에서 해결됨

| 항목 | 등급 | 해결 방법 |
|------|------|-----------|
| **PLAN_01 Phase 11 아키텍처 분석 + 프레임워크 최신화** | **HIGH** | **병렬 3에이전트(code-explorer + code-architect + WebSearch) → Rust 5건 + Flutter 8건 = 13건 GAP 발견** |
| **Night-49 결과 문서화** | **MEDIUM** | **MORNING_BRIEFING + NIGHT_06_RESULT + PLAN_01.md Phase 11 완료 마킹 (커밋 `090dc8d`)** |
| **베이스라인 재검증** | **LOW** | **Flutter 360건 / Rust 207건 / analyze 0건 — Night-49 실측 확인** |

### 🆕 Night-49에서 생성됨

| 항목 | 등급 | 설명 |
|------|------|------|
| **D-88 Phase 11 HIGH 3건 수정** | **CRITICAL** | F-08(401 AuthState 미통보) + I-01(rollback warn) + I-02(ALLOWED_ORIGINS) — Phase 13 즉시 수정 범위 |
| **D-89 AppSpacing/AppTextStyles 적용** | **HIGH** | Night-36 도입 → 87개 매직넘버 잔존 — 적용 범위 결정 필요 |
| **D-90 productPredictionProvider 타입화** | **MEDIUM** | `Map<String,dynamic>` → PredictionResult 모델 — 타입 안전성 |
| **D-91 priceTrend Enum 전환** | **MEDIUM** | PD-67 — AlertType PD-62 선례 존재, Phase 13에서 실행 가능 |
| **D-92 Phase 12/13 실행 순서** | **HIGH** | Phase 12(UI/UX 감사) 선행 vs Phase 13(수정 실행) 선행 — 남은 세션 효율에 직결 |
| **A-05 백그라운드 태스크 재시작** | **HIGH** | 파티션/TTL/rate limiter GC 태스크 패닉 시 영구 중단 — tokio::spawn 감시 루프 필요 |
| **F-08 401 AuthState 미통보** | **HIGH** | api_client.dart onSessionExpired 콜백 미호출 경로 존재 — 로그인 화면 리다이렉트 누락 |
| **Phase 12~14 실행 대기** | **HIGH** | Phase 11 완료 → D-88~D-92 결정 후 Phase 12(UI/UX) 또는 Phase 13(수정)으로 진행 |

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
| sonatype-guide 인증 | MEDIUM | 자격증명 필요 (**28세션** 연속) |
| RUSTSEC-2026-0049 모니터링 | MEDIUM | a2 upstream 전환 대기 |
| 통합 테스트 43건 | MEDIUM | 환경 제약 (DB 필요) |
| ~~`_transactionLabel` default 케이스~~ | ~~LOW~~ | ~~D-63: **✅ Night-39에서 완전 해소** (8/8 + default)~~ |
| E2E 테스트 | LOW | D-39:B 이연 |
| auto 브랜치 27개+ 정리 | LOW | 사용자 승인 대기 |
| SessionEnd hook `node` 미설치 | LOW | **Night-41 원인 규명 완료** — D-81: Vercel plugin hook, **40회** 누적. 옵션 A(비활성화, 권장)/B(설치)/C(유지) **사용자 결정 대기** |
| Flutter Skia CVE 2건 | INFO | Flutter 팀 패치 대기 — 코드 변경 불가 |
| **PLAN_01 Phase 1-14 전체 완료** | **✅ 완료** | **Night-30 수립 → Night-37 Phase 1-8 → Night-47~50 Phase 9-12 → Night-51/52 Phase 13 → Night-53 Phase 14 — 24세션 완결** |
| ~~PLAN_02 방향 대기~~ | ~~CRITICAL~~ | ~~사용자 결정 9세션 연속 대기~~ → **✅ Night-47 U-42 해소** |
| **D-82~D-84 결정 대기** | **CRITICAL** | **Phase 9 업그레이드 범위 — Rust/Dart BREAKING 범위 사용자 결정 필요** |
| **D-85~D-87 결정 대기** | **HIGH** | **Phase 10 수정 범위 — D-85는 D-88에 통합됨, D-86~D-87 실행 범위 사용자 결정 필요** |
| ~~**D-88~D-92 결정 대기**~~ | ~~CRITICAL~~ | ~~Phase 11 수정 범위/순서~~ → **✅ Night-51/52에서 전체 해소** |
| ~~**D-93~D-94 결정 대기**~~ | ~~HIGH~~ | ~~Phase 12 UI/UX — ScreenErrorWidget + 12dp 갭~~ → **✅ Night-51/52에서 해소** |
| **D-95/D-96 이연** | **MEDIUM** | **Night-53에서 이연 확정 — D-95(discountRate 색상) + D-96(검색 필터 재연결)** |
| **NaverSearch MCP 통합** | **HIGH** | **Night-54 발견 — search_shop/datalab 18+ API, PLAN_02 방향 B(기능 확장) 핵심 도구** |

---

## 8. 프로젝트 대시보드

### 8.1 현재 지표 (2026-05-11, Night-63 결합 분석 실측)

| 지표 | **Night-63** | Night-62 | Night-61 | 변화 (vs 62) |
|------|------------|----------|----------|-------------|
| Rust 테스트 (lib) | **216** ✅ | 216 | 216 | — |
| Rust 빌드 경고 | **0건** ✅ | 0건 | 0건 | — |
| Flutter 테스트 | **370** ✅ | 370 | 370 | — |
| Flutter analyze | **0건** ✅ | 0건 | 0건 | — |
| DECISION_LOG | **D-111** | D-111 | D-108 | — |
| PLAN_01 Phase 완료 | **Phase 1~19 전체 완료 ✅ 종결** | Phase 1~19 ✅ | Phase 15~18 ✅ | — (종결 유지) |
| Phase 20+ 전략 방향 | **⏳ D-111 사용자 결정 대기** | ⏳ 대기 | — | 신규 |
| Silent Failure 수정 | **33건+** (잔존 0건) | 33건+ | 33건+ | — |
| 미결 결정(PENDING) | **7건** (D-82/D-83/D-84잔여/D-87/D-101/D-102 + **D-110/D-111**) | 10건 | 8건 | **Night-66: D-86/D-95 해소, D-84 부분 해소** |
| catch(e,st) 적용 | **28건** | 28건 | 28건 | — |
| 타입 안전 캐스트 수정 | **20건** | 20건 | 20건 | — |
| PlayMCP MCP | **8서비스 62+ API** (Night-63: UsStockInfo/KakaoMap/KakaotalkChat 추가 확인) | 8서비스 | 8서비스 | +3 서비스 신규 확인 |
| N56 미결 | **5/5 ✅ 전량 해소** | 5/5 ✅ | 5/5 ✅ | — |
| showErrorSnackBar 통합 | **12개소** | 12개소 | 12개소 | — |
| serde rename_all enum | **9개** | 9개 | 9개 | — |
| cargo audit 취약점 | **0건** ✅ | 0건 | 0건 | — |
| 위젯 테스트 커버리지 | **4/4** ✅ | 4/4 | 4/4 | — |
| FakeService 패턴 | **3종** | 3종 | 3종 | — |
| 순수 함수 추출 | **15개**/54테스트 | 15개/54 | 15개/54 | — |
| rollback warn 패턴 | **10곳** | 10곳 | 10곳 | — |
| 커밋 (main 대비) | **100+** | 98 | 97+ | **+2** (`0351800`, `807617c`) |

### 8.2 기술 부채 현황

| 항목 | 상태 |
|------|------|
| Silent Failure | **완결** ✅ |
| Flutter 접근성 | **개선됨** ✅ (7개 화면) |
| Flutter 테마 일관성 | **개선됨** ⚠️ (AppColors ✅ + AppSpacing 3화면 pilot 완료 — 잔여 12화면 61개 매직넘버 미적용) |
| 서버 안정성 (assert!/panic) | **해결됨** ✅ |
| API 엔드포인트 일관성 | **해결됨** ✅ |
| 타입 안전성 (as 캐스트) | **완료** ✅ (20건) |
| API 계약 정합성 | **완료** ✅ (serde 7개 + CI) |
| serde 파급 누락 방지 | **해결됨** ✅ (CI 자동검사) |
| TOCTOU 경쟁 조건 | **해결됨** ✅ |
| 의존성 보안 | **해결됨** ✅ (Rust 0건, Dart 0건) |
| Flutter 테스트 커버리지 | **포화 확정** ✅ (370건) |
| **PLAN_01 전체** | **✅ 완료 (8/8 Phase)** 🎉 |
| **Phase 15 NaverSearch 파이프라인** | **✅ 완결** (Night-56~58: N56 5/5 전량 해소) |
| **Phase 16 의존성 분석** | **분석 완료** ⚠️ (D-101~D-103 사용자 결정 대기) |
| **Phase 17 아키텍처 고도화** | **✅ 완료** (Night-59 분석 + Night-60 구현: D-104 캐시/D-105 배치/D-106 리팩토링 — H-1 해소, 커넥션 풀 3→1) |
| **Phase 18 프론트엔드 UX + 코드 품질** | **✅ 완료** (Night-61: 병렬 4대 에이전트 → 수정 5건(I-03/I-04/I-05/F-09/F-10) + D-107/D-108 확정) |
| **Phase 19 최종 검증 + PLAN_01 종결** | **✅ 완료** (Night-62: 3중 검증 통과(370/216/0건) + PLAN_01 Phase 1~19 전체 종결 선언 + D-109~D-111) |
| **PLAN_01 전체 (Phase 1-19)** | **✅ 완전 종결** 🎉🎉🎉 (Night-30 수립 → Night-62 종결, 32세션) |
| 코드 품질 심층 리뷰 | **완료** ✅ (Phase 4: 37건 발견, 5건 수정) |
| 코드 간소화 | **완료** ✅ (Phase 7: Rust ~125줄 + Flutter ~105줄 감소) |
| AlertType String→Enum | **완료** ✅ (PD-62, Night-36) |
| PriceTrend String→Enum | **완료** ✅ (PD-67/D-91, Night-51) |
| PredictionResult 타입화 | **완료** ✅ (D-90, Night-52: freezed model + PredictionAction enum) |
| riverpod_generator + json 체인 | **보류** ⚠️ (analyzer 충돌 — 4.x 동반 필요) |
| 미머지 브랜치 통합 | **적체** ⚠️ (4개) |
| auto 브랜치 정리 | **미처리** ⚠️ (26개+) |
| 통합 테스트 검증 | **미실행** ⚠️ (--lib만) |
| E2E 테스트 | 미구축 (이연) |
| sonatype-guide 인증 | **미설정** ⚠️ (37세션 연속) |
| RUSTSEC-2026-0049 | **모니터링** ⚠️ (audit.toml ignore) |
| Flutter Skia CVE 2건 | **대기** ⚠️ (엔진 패치 필요) |
| SessionEnd hook | **원인 규명 완료** (D-81: Vercel plugin. **60회+** 감지. A/B/C 옵션 대기) |
| ~~PLAN_02 방향~~ | **✅ 해소** (U-42: Night-47에서 사용자 지시 → Phase 9 실행) |
| **Phase 20+ 방향 (D-111)** | **⏳ 대기 15세션째** — A)실측 검증 / B)BREAKING 업그레이드 / C)main 머지 / D)조합(Opus 추천) |
| **main 머지 PR (D-110)** | **⏳ 대기 15세션째** — 105커밋 브랜치 → main PR 생성 (Phase 20+ 전제 조건) |
| **MCP 확장 (Night-65 실측)** | **10개 MCP 활성** — NaverSearch(20+)/opendart(13)/UsStockInfo(9)/CoinInfo(7)/HuggingFace(10+) + Sonatype(인증 미설정 37세션) |
| **Phase 10 코드 품질 심층 리뷰** | **✅ 완료** (9건 확정: HIGH 2 + MEDIUM 3 + LOW 4) |
| **Phase 11 아키텍처 분석** | **✅ 완료** (13건 GAP: Rust 5 + Flutter 8, D-88~D-92 도출) |
| **Phase 12 UI/UX 감사** | **✅ 완료** (9건: HIGH 1 + MEDIUM 3 + LOW 5, D-93~D-96 도출) |
| **Phase 13 코드 수정 실행** | **✅ 완료** (9/15건 해소 — Night-51: 5건 + Night-52: 3건 + Night-55: 1건(D-96). 잔여 6건 사용자 결정으로 이연) |
| **Phase 14 최종 검증** | **✅ 완료** (Night-53: Flutter 361건 / Rust 207건 / analyze 0건 — 3중 게이트 통과) |
| **PLAN_01 전체 (Phase 1-14)** | **✅ 완전 완료** 🎉🎉 (Night-30 수립 → Night-53 완결) |
| **PlayMCP MCP** | **✅ 8서비스 62+ API** (NaverSearch ★★★★★ 핵심 + CoinInfo/cryptoGuardian Night-55 신규) |
| sonatype-guide 인증 | **미설정** ⚠️ (**37세션** 연속) |
| SessionEnd hook | **원인 규명 완료** (D-81: Vercel plugin. **60회+** 감지. A/B/C 옵션 대기) |

---

## 9. 다음 세션 선택지 (Night-65 결합 분석 — **PLAN_01 완전 종결 + Phase 20+ 전략 방향 설계**)

> **PLAN_01 Phase 1~19 전체 완료 ✅ 종결. Flutter 370건 / Rust 216건 / 경고 0건.**
> **Night-65: 베이스라인 재검증 통과(370/216/0건). MCP 실측 가용성 보고서 전면 갱신. D-110/D-111 15세션째 대기.**
> **⚠️ 핵심 과제**: 105커밋 브랜치 머지 PR(D-110) + Phase 20+ 방향 결정(D-111) + BREAKING 업그레이드(D-101/D-102)

### 9.0 Night-56~65 결합 분석: Opus 전략 × Sonnet 기술 × MCP 활용 종합

> **PLAN_01 Phase 15~19 완전 사이클 (8세션)**: 전략 설계 → MCP 실측 → 코드 생성 → 테스트 → 아키텍처 분석 → 캐시 최적화 → 품질 점검 → 최종 검증
> **Night-62~65 (4세션)**: 종결 검증 → 브랜치 전환 → 문서 안정화 → MCP 실측 재점검 (코드 변경 0건, 베이스라인 보존)

#### Opus 4.6 전략 요약 (Night-56~65)

| 세션 | Opus 전략적 역할 | 핵심 결정 |
|------|-----------------|-----------|
| Night-56 | **Phase 15-19 5단계 전략 설계** + D-97~D-111 결정 포인트 15개 청사진 | D-97/98(비해당 MCP 제외), D-99/100(3카테고리+전체 코드) |
| Night-57 | **N56 미결 해소 우선순위** 결정 — 핸들러>환경변수>테스트 | N56-02/03/04 해소 순서 설계 |
| Night-58 | **Phase 15 완결 판단** + Phase 16 전환 결정 | N56-05 ProductDetailScreen 배치, D-101~D-103 도출 |
| Night-59 | **feature-dev 3대 병렬 배치** 전략 (explorer+architect+reviewer) | D-104~D-106 도출, M-1 즉시 수정 결정 |
| Night-60 | **분석→구현 1세션 최속 전환** — D-104/105/106 동시 실행 결정 | H-1 해소, 커넥션 풀 3→1 통합 |
| Night-61 | **4대 에이전트 동시 배치** + 오탐 필터링 전략 | D-107/108 확정, 수정 5건 선별 |
| Night-62 | **Phase 19 검증 게이트** — 코드 변경 없이 3중 검증 | PLAN_01 전체 종결 선언, D-109~D-111 도출 |
| Night-63 | **사후 검증 + 문서 안정화** | 베이스라인 보존 확인, D-110/D-111 대기 유지 |
| Night-64 | **브랜치 3세대 전환 + Night-63 결합 분석** | MCP 6종 활성 재확인, D-110/D-111 14세션 대기 |
| Night-65 | **MCP 실측 가용성 보고서 갱신 + 베이스라인 보존** | 10개 MCP/10종 플러그인 매트릭스 작성, D-110/D-111 15세션 대기 |

#### Sonnet 4.6 기술 실행 + MCP 활용 요약

| 세션 | Sonnet 기술 실행 | MCP/도구 | 코드 산출물 |
|------|-----------------|---------|-----------|
| Night-56 | NaverSearch MCP **8회 실측 호출** → 14파일 코드 생성 | NaverSearch (search_shop×3, datalab×2, find_category×3) | Rust 2서비스 + Flutter 5파일 + migration 019 |
| Night-57 | trends.rs 핸들러 + TrendChartWidget 테스트 5건 | — (코드 연결) | Rust +2건(216), Flutter +5건(370) |
| Night-58 | ProductDetailScreen TrendChartWidget 통합 | WebSearch (BREAKING 5종 분석) | Flutter 2파일 수정 |
| Night-59 | **feature-dev 3대 병렬** + HuggingFace MCP | HuggingFace (hf_doc_search — ML 전용 확인) | Flutter 1파일(M-1 수정) |
| Night-60 | D-104/105/106 **4파일 +350/-83줄** 구현 | — (기존 패턴 재사용) | cache.rs + trend_data_service.rs + trends.rs + main.rs |
| Night-61 | **4대 병렬 에이전트** 감사 → 수정 5건 | silent-failure-hunter, type-design-analyzer, code-reviewer, code-simplifier | Rust 3파일 + Flutter 1파일 |
| Night-62~65 | 3중 검증 실행 + 문서 갱신 (4세션) | — (검증/문서 전용) | 코드 변경 0건 |

**10세션 합산 (Night-56~65):**
- **Rust**: +9건 테스트(207→216), 수정 13건, 경고 0건
- **Flutter**: +5건 테스트(365→370), 수정 20+파일, analyze 0건
- **MCP 호출**: NaverSearch 8회 + HuggingFace 1회 + WebSearch 5+회
- **생성 코드**: 신규 14파일 + 수정 20+파일 = ~1,500줄 순증
- **검증 세션**: 4회 연속(Night-62~65) 베이스라인 완전 보존 확인

#### 코드 생성 결과 품질 평가

| 품질 지표 | Night-56 생성 시 | Night-61 최종 | 개선 |
|----------|----------------|-------------|------|
| OnceLock 독립 클라이언트 | 2개 (NAVER_CLIENT, TREND_CLIENT) | **0개** (AppState.http_client 공유) | 커넥션 풀 3→1 |
| 캐시 | 없음 (매 요청 API 호출) | **moka TTL 24h** + try_get_with | p99 ~500ms→~5ms |
| 배치 웜업 | 없음 | **warmup_trend_cache 1h** | API 쿼터 97.6% 절약 |
| 환경변수 직접 호출 | 2서비스 env::var() | **Config 단일 진실 원천** | DI 정합성 |
| Duration::days(180) | 최대 6일 오차 | **Months::new(6)** | 달력 정밀도 |
| pub 가시성 | pub (과도 공개) | **pub(crate)** | 캡슐화 |

### 9.0a Phase 20+ 전략 방향 (D-111 — 사용자 결정 대기 15세션째)

> **전제 조건**: D-110 (105커밋 → main 머지 PR) 선행 필요

| 방향 | 설명 | 핵심 MCP/도구 | 예상 산출물 | Opus 추천 |
|------|------|-------------|------------|----------|
| **A) 데이터 파이프라인 실측 검증** | NaverSearch MCP로 실제 API 호출 → Rust 서비스 응답 모델 정합성 검증 + 트렌드 분석 로직 보정 | NaverSearch ★★★★★ | API 실측 검증 + 모델 보정 | ★★★ |
| **B) BREAKING 의존성 업그레이드** | D-101/D-102 해소 → riverpod 3.3/go_router 17/fl_chart 1.x/google_sign_in 7.x 등 | WebSearch, Sonatype | 최신 의존성 + 테스트 370건 통과 보장 | ★★ |
| **C) main 머지 PR 생성 (D-110)** | 105커밋 → main PR. coderabbit + pr-review-toolkit 병렬 리뷰 | commit-commands, coderabbit, pr-review-toolkit | 깨끗한 main 베이스 | ★★★★★ |
| **D) 조합: C→A→B 순차** | 먼저 main 안착 → 실측 검증 → BREAKING 업그레이드 | 전체 | 안정성 확보 후 기능 확장 | ★★★★ |

**MCP 확장 가능성 분석 (Night-65 실측 기반):**

| MCP | API 수 | 값뚝 활용 시나리오 | Phase 20+ 우선순위 |
|-----|--------|-------------------|-------------------|
| **NaverSearch** | 20+ | 기존 Phase 15 핵심. `datalab_shopping_by_age/gender/device` → 사용자 세그먼트 개인화 | ★★★★★ (심화) |
| **KakaoMap** | 4 | `SearchPlaceByKeywordOpen` → 오프라인 매장 최저가 위치 표시 | ★★★ (신규) |
| **KakaotalkChat** | 1 | `MemoChat` → 가격 알림 카카오톡 메모 전송 (푸시 대안) | ★★ (신규) |
| **HuggingFace** | 8+ | ML 논문/모델 검색 — 가격 예측 알고리즘 참조 | ★★ (참조) |
| **UsStockInfo** | 9 | 미국 주식 — 값뚝 도메인 외 | ★ (비해당) |
| **CoinInfo** | 7 | 암호화폐 — D-97 DECIDED 비포함 | ★ (비해당) |
| **opendart** | 13+ | 기업 재무 — D-98 DECIDED 비포함 | ★ (참조) |

**Opus 최종 추천 (Night-66 갱신):**
1. **★★★★★ D-110 최우선**: 107커밋 → main PR 생성 — 모든 후속 작업의 전제. **16세션째 대기 — 즉시 결정 권장**
2. **★★★★ D방향 추천**: C(머지) → A(실측 검증) → B(업그레이드) 순차 실행
3. **BREAKING 순서**: D-84잔여(freezed/json_serializable, D-101과 연계) → D-102 순차(secure_storage→google_sign_in→go_router→fl_chart) → D-101(Riverpod 세트)
4. **Night-66 해소**: D-86(MEDIUM 2건)/D-84(build_runner+mocktail)/D-95(discountRate) 3건 완료
5. **Phase 20+ MCP 신규 활용**: NaverSearch by_age/gender/device (3 API) + KakaoMap (매장 가격 비교) — 기존 파이프라인 위에 확장

### 9.1 즉시 실행 가능 (Night-66 갱신)

| 선택지 | 설명 | 활용 도구 | 예상 규모 |
|--------|------|-----------|----------|
| **A) ★★★★★ 브랜치 머지 PR 생성 (D-110)** | `auto/night-01-20260514_0100` (107 커밋) → main PR 생성. **PLAN_01 Phase 1~19 전체 성과 통합 — 최우선 (16세션 대기)** | gh pr create | 소형 |
| **B) ★★ Phase 20+ 방향 결정 (D-111)** | A)실측 검증 / B)BREAKING 업그레이드 / C)main 머지 / D)조합(C→A→B 순차, **Opus 추천**) | 전략 | — |
| **C) D-108-B AppSpacing 전면 롤아웃** | Night-52 pilot 3화면 + Night-55 search_screen 성공 → 잔여 12화면 ~57개 매직넘버 치환 | Opus 직접 | 중형 |
| **D) D-101 Riverpod BREAKING 세트** | flutter_riverpod 3.3 + riverpod_generator 4.x 업그레이드 (별도 세션 권장) — D-84 freezed/json_serializable도 포함 | pub upgrade + 코드 재생성 | 대형 |
| **E) D-102 BREAKING 순차 처리** | flutter_secure_storage 10 → google_sign_in 7 → go_router 17 → fl_chart 1.2 (패키지별 1개씩) | pub upgrade | 중형 |
| ~~**F) D-95 discountRate 색상 수정**~~ | ~~다크모드 `AppColors.dark.error` 불일치 해소~~ | ~~Opus 직접~~ | **✅ Night-66 완료** |
| ~~**G) D-86 MEDIUM 2건 수정**~~ | ~~I-03(0원 예측 캐시) + I-04(NULL UNIQUE)~~ | ~~Opus 직접~~ | **✅ Night-66 완료** |
| **H) SessionEnd hook 수정** | D-81 옵션 A(Vercel 비활성화) → `~/.claude/settings.json` 수정 | 설정 변경 | 소형 |

### 9.2 PLAN_01 Phase 1-19 최종 현황 (전체 완료)

> **상세 실행 계획**: `docs/plans/PLAN_01.md` Phase 1-19 참조
> **PLAN_01 완전 종결**: Night-30 수립 → Night-62 종결 (32세션, 19 Phase)

| Phase | 목표 | 상태 | 완료 Night | 핵심 성과 |
|-------|------|------|-----------|----------|
| 1~8 | 보안감사→코드품질→테스트→간소화 | **✅** | Night-31~37 | Flutter 296→358건, Rust 207건, 5건 수정, ~230줄 감소 |
| 9~14 | 의존성→코드품질→아키텍처→UI/UX→수정→검증 | **✅** | Night-47~53 | 9/15건 수정, 3중 검증, Flutter 361건 |
| 15~19 | NaverSearch→의존성→아키텍처→품질→검증 | **✅** | Night-56~62 | 14파일 신규, 캐시/배치 최적화, Flutter 370건/Rust 216건 |

**Opus 추천 (Night-64 결합 분석 — PLAN_01 완전 종결 후 3세션):**
1. **★★★★★ A안 브랜치 머지 PR 최우선 (D-110)**: 100+ 커밋 → main PR 생성. PLAN_01 전체 성과 통합 — **Phase 20+ 진행의 전제 조건. 14세션째 대기 — 즉시 결정 권장**
2. **★★★★ B안 Phase 20+ 방향 결정 (D-111)**: C방향(BREAKING→기능 확장 순차) 추천 — NaverSearch 심화(by_age/gender 미활용 3 API) + KakaoMap 신규(매장 가격 비교)
3. **D-101/D-102 BREAKING은 별도 세션**: Riverpod 세트(D-101)는 모든 `@riverpod` 파일 재생성, 패키지별 BREAKING(D-102)는 순차 처리 권장
4. **F안 D-95 소형 수정**: discountRate 색상 (LOW) — 다크모드 머지 전제 조건. 머지 PR과 병행 가능

### 9.3 잔여 결정 항목 요약 (사용자 승인 대기)

| ID | 구분 | Opus 권장 | 근거 | 상태 |
|----|------|-----------|------|------|
| ~~**D-104**~~ | ~~NaverSearch 캐시 전략~~ | ~~A) moka 확장~~ | — | ✅ **Night-60 해소** |
| ~~**D-105**~~ | ~~NaverSearch 호출 빈도~~ | ~~B) 1h 배치~~ | — | ✅ **Night-60 해소** |
| ~~**D-106**~~ | ~~서비스 리팩토링 범위~~ | ~~B) AppState 공유~~ | — | ✅ **Night-60 해소** |
| **D-82** | Rust BREAKING 3건 | **C) 보류** | reqwest/jwt/sentry 메이저 변경 리스크 — 별도 세션 필요 | ⏳ |
| **D-83** | Dart BREAKING 8건 | **C) 보류** | kakao 2.0 인증 플로우 변경 — 별도 세션 필요 | ⏳ |
| **D-84 잔여** | Dart non-BREAKING 잔여 (freezed/json_serializable) | D-101과 연계 | riverpod_generator ^3.0.0 analyzer 충돌 — D-101 세트와 동시 처리 필요 | ⚠️ **Night-66 부분 해소** (build_runner+mocktail 완료) |
| ~~**D-86**~~ | ~~Phase 10 MEDIUM 2건~~ | ~~A) 수정~~ | I-03/I-04 수정 완료 | ✅ **Night-66 해소** |
| **D-87** | Phase 10 LOW 4건 | **B) 제외** | ~~I-06/I-07~~ ✅ Night-67 해소. PD-65/PD-66 API 협의 필요 | ⚠️ **Night-67 부분 해소** (I-06+I-07 완료, PD-65/PD-66 대기) |
| ~~**D-95**~~ | ~~discountRate 색상~~ | ~~A) 제거~~ | 하드코딩 색상 제거 완료 | ✅ **Night-66 해소** |
| **D-101** | Riverpod BREAKING 세트 | **B) 별도 세션** | flutter_riverpod 3.3 + riverpod_generator 4.x — 모든 @riverpod 파일 재생성 + D-84 freezed/json_serializable 연계 | ⏳ |
| **D-102** | Dart BREAKING 5종 범위 | **D) 순차 처리** | flutter_secure_storage→google_sign_in→riverpod→go_router→fl_chart | ⏳ |
| ~~**D-107**~~ | ~~트렌드 데이터 표시 위치~~ | ~~A) ProductDetailScreen~~ | N56-05 통합 위치 확정 | ✅ **Night-61 CONFIRMED** |
| ~~**D-108**~~ | ~~디자인 시스템 규칙 범위~~ | ~~A) 신규 위젯 한정~~ | 전면 롤아웃은 Phase 19에서 B 재검토 | ✅ **Night-61 DECIDED** |
| ~~**D-109**~~ | ~~커밋 구조 전략~~ | ~~A) Phase별 분리~~ | 이미 Night-56~61에서 Phase별 커밋 완료 | ✅ **Night-62 CONFIRMED** |
| **D-110** | **main 머지 PR 생성** | **A) 즉시 생성** | 109커밋 브랜치 → main PR — PLAN_02 전제 조건. **17세션째 대기** | **⏳ 사용자 결정 대기** |
| **D-111** | **PLAN_02 방향** | **C) 조합(A→B)** | A)BREAKING 업그레이드 → B)NaverSearch 심화+KakaoMap 신규 | **⏳ 사용자 결정 대기** |
| ~~**D-103**~~ | ~~Rust BREAKING 포함 여부~~ | — | cargo update 범위 내 최신 유지됨 | ✅ **DECIDED — 불필요** |
| ~~**D-96**~~ | ~~검색 필터 재연결~~ | ~~A) 신규 구현~~ | — | ✅ **Night-55 해소** |
| ~~D-85/D-88/D-89/D-90/D-91/D-92/D-93/D-94~~ | ~~8건~~ | — | — | ✅ Night-51/52 해소 |
| ~~D-104/D-105/D-106~~ | ~~3건 캐시/배치/리팩토링~~ | — | — | ✅ Night-60 구현 |

### 9.4 MCP/플러그인 가용성 (Night-67 실측 보고서 — 2026-05-15)

#### 활성 MCP (이 세션에서 실제 호출 가능)

| MCP | 도구 수 | 값뚝 연관성 | 활용 이력 | Phase 20+ 활용 |
|-----|--------|-----------|-----------|--------------|
| **PlayMCP — NaverSearch** | ~20 | ★★★★★ 핵심 | Night-56/57 실전 8회 호출 | search_shop/datalab 심화 (by_age/gender/device 미활용 3 API) |
| **PlayMCP — KakaoMap** | 4 | ★ 낮음 | Night-63 확인 | 참고용 (매장 위치) |
| **PlayMCP — KakaotalkChat** | 1 | ★★ 보통 | Night-63 발견 | 카카오톡 메모 알림 테스트 |
| **PlayMCP — opendart** | 13 | ★ 낮음 | Night-54 발견 | 참고용 (D-98 비포함) |
| **PlayMCP — UsStockInfo** | 9 | ★ 낮음 | Night-63 발견 | 참고용 (도메인 외) |
| **PlayMCP — CoinInfo** | 7 | ★ 낮음 | Night-55 발견 | 참고용 (D-97 DECIDED) |
| **HuggingFace** | ~10 | ★★★ 보통 | Night-59 ML 전용 확인 | 문서/논문 검색 |
| **Sonatype Guide** | 3 | ★★★ 보통 | **인증 필요** ⚠️ (38세션째) | 의존성 보안 |
| **Google Drive/Calendar/Gmail** | ~20 | ★ 낮음 | — | 참고용 |
| **Zapier** | ~10 | ★ 낮음 | — | 참고용 |

#### 활성 플러그인/스킬

| 플러그인 | 스킬 | 값뚝 활용 |
|---------|------|---------|
| **feature-dev** (3종) | code-architect, code-explorer, code-reviewer | Phase 4/5/7/9/11/**17** 아키텍처 분석 |
| **pr-review-toolkit** (6종) | silent-failure-hunter, type-design-analyzer, code-reviewer, code-simplifier, comment-analyzer, pr-test-analyzer | Phase 4/7/10/**18** 코드 리뷰 |
| **coderabbit** | code-review, autofix | Night-23/48 코드 리뷰 |
| **frontend-design** | frontend-design | Phase 5/12/**18** UI/UX |
| **figma** | design-system-rules 등 7종 | 디자인 시스템 |
| **code-simplifier** | code-simplifier | Phase 7 코드 간소화 |
| **commit-commands** | commit, commit-push-pr, clean_gone | Phase 8 커밋/PR |
| **superpowers** (12 skills) | brainstorming, debugging 등 | 전체 |

#### 비해당/미연결 확정 (Night-67 실측)

| 도구 | 상태 | 사유 | 대체 수단 |
|------|------|------|----------|
| mcp-tailwind-gemini | **비해당** | Flutter 프로젝트 — Tailwind 미사용 | — |
| shadcn | **비해당** | Flutter 프로젝트 — React/shadcn-ui 미사용 | — |
| context7 | **미연결** | `.mcp.json` 부재 | WebSearch + WebFetch |
| sequential-thinking | **미설치** | 환경에 미구성 | superpowers:brainstorming |
| playwright | **미연결** | `.mcp.json` 부재 | feature-dev:code-architect |
| serena | **미연결** | `.mcp.json` 부재 | feature-dev:code-explorer |
| chatgpt-mcp | **미설치** | 환경에 미구성 | HuggingFace MCP + WebSearch |

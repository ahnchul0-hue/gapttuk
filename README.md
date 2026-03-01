# 값뚝 (gapttuk)

쿠팡 · 네이버쇼핑 상품의 가격 변동을 추적하고, 최적의 구매 타이밍을 알려주는 **완전 무료** 크로스플랫폼 가격 알림 앱.

> "값이 뚝!" — 가격이 떨어지는 순간을 포착한다.

## 기술 스택

- **모바일/웹:** Flutter (Dart) — Android + iOS + Web
- **백엔드:** Axum (Rust) — Tokio 비동기, 단일 바이너리
- **DB:** PostgreSQL 17.9 — SQLx 컴파일타임 SQL 검증
- **배포:** systemd (로컬 우선)

## 프로젝트 구조

```
gapttuk/
├── documents/     # 설계 문서 (PRD, plan, schema 등)
├── server/        # Rust 백엔드 (Axum)
├── app/           # Flutter 앱 (M2에서 시작)
├── scripts/       # 유틸리티 스크립트
└── backups/       # pg_dump 일일 백업 (gitignore)
```

## 문서

- `documents/prd.md` — 제품 요구사항
- `documents/plan.md` — 구현 계획
- `documents/schema-design.md` — DB 스키마 설계
- `documents/ui-architecture.md` — UI 화면 구조
- `documents/tech-stack-research.md` — 기술 스택 비교 분석

# ============================================================
# 값뚝(gapttuk) Server — Multi-stage Docker Build
# ============================================================
# Stage 1: cargo-chef — 의존성 캐싱 (변경 없으면 레이어 재사용)
# Stage 2: builder   — 애플리케이션 빌드
# Stage 3: runtime   — 최소 런타임 이미지 (~80MB)
# ============================================================

# --- Stage 1: Planner ---
FROM lukemathwalker/cargo-chef:latest-rust-1 AS chef
WORKDIR /app

FROM chef AS planner
COPY server/Cargo.toml server/Cargo.lock* ./
COPY server/src/ src/
COPY server/migrations/ migrations/
RUN cargo chef prepare --recipe-path recipe.json

# --- Stage 2: Builder ---
FROM chef AS builder

# 의존성만 먼저 빌드 (소스 변경 시에도 캐시 히트)
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

# 전체 소스 복사 + 빌드
COPY server/Cargo.toml server/Cargo.lock* ./
COPY server/src/ src/
COPY server/migrations/ migrations/
RUN cargo build --release

# --- Stage 3: Runtime ---
FROM debian:bookworm-slim AS runtime

# 런타임 필수 패키지: TLS 인증서 + curl (헬스체크용)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# 비루트 사용자로 실행
RUN groupadd -r gapttuk && useradd -r -g gapttuk -d /app gapttuk
WORKDIR /app

# 바이너리 + 마이그레이션 파일 복사
COPY --from=builder /app/target/release/gapttuk-server /usr/local/bin/gapttuk-server
COPY server/migrations/ /app/migrations/

# 소유권 설정
RUN chown -R gapttuk:gapttuk /app
USER gapttuk

# 기본 포트
EXPOSE 8080

# 헬스체크 — /health 엔드포인트 호출
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["gapttuk-server"]

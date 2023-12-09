FROM rust:1.74.1-alpine AS installer
RUN apk update && apk upgrade && apk add --no-cache musl-dev
RUN rustup target add "$(uname -m)"-unknown-linux-musl
RUN cargo install sqlx-cli --no-default-features --features rustls --target "$(uname -m)"-unknown-linux-musl

FROM debian:bookworm-slim AS builder
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y clang
COPY migrate.c ./
RUN clang -Os -static -o migrate migrate.c

FROM scratch AS runner
COPY migrations /usr/src/app/migrations
COPY --from=installer /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx
COPY --from=builder /usr/src/app/migrate /usr/src/local/bin/migrate
CMD ["/usr/src/local/bin/migrate"]

FROM rust:1.82.0-alpine AS installer
WORKDIR /usr/src/app
RUN apk update && apk upgrade && apk add --no-cache musl-dev
RUN rustup target add "$(uname -m)"-unknown-linux-musl
RUN cargo install sqlx-cli --no-default-features --features rustls,postgres --target "$(uname -m)"-unknown-linux-musl

FROM debian:bookworm-slim AS runner
COPY migrations /usr/src/app/migrations
COPY migrate.sh /usr/src/app/
COPY --from=installer /usr/local/cargo/bin/sqlx /usr/src/bin/
CMD ["sh", "/usr/src/app/migrate.sh"]

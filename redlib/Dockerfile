# supported versions here: https://hub.docker.com/_/rust
ARG ALPINE_VERSION=3.22

FROM rust:alpine${ALPINE_VERSION} AS builder

ARG REDLIB_SRC=https://github.com/chowder/redlib.git
ARG REDLIB_BRANCH=feature/tls-openssl

RUN apk add --no-cache git make musl-dev perl

WORKDIR /redlib

RUN git clone --depth 1 --branch "${REDLIB_BRANCH}" "${REDLIB_SRC}" .
RUN cargo build --release --locked --bin redlib
RUN echo "finished building redlib from ${REDLIB_SRC}/${REDLIB_BRANCH}!"

FROM alpine:${ALPINE_VERSION} AS release

RUN apk add --no-cache ca-certificates

COPY --from=builder /redlib/target/release/redlib /usr/local/bin/redlib

RUN adduser --home /nonexistent --no-create-home --disabled-password redlib
USER redlib

EXPOSE 8080

HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider -q http://localhost:8080/settings || exit 1

CMD ["redlib"]

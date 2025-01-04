FROM caddy:2.8.4-builder AS builder

ENV GOARCH $TARGETARCH

RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/caddyserver/transform-encoder \
	--with github.com/pberkel/caddy-storage-redis \
	--with github.com/mholt/caddy-l4 \
	--with github.com/sagikazarmark/caddy-fs-s3

FROM caddy:2.8.4
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ARG version=2.10.0

FROM caddy:${version}-builder-alpine AS builder

RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/caddyserver/transform-encoder \
	--with github.com/pberkel/caddy-storage-redis \
	--with github.com/mholt/caddy-l4 \
	--with github.com/sagikazarmark/caddy-fs-s3

FROM caddy:${version}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

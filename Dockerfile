FROM alpine:3.22 AS downloader

RUN apk add --no-cache git ca-certificates

ARG SQLIME_REF=main

RUN git clone \
    --depth 1 \
    --single-branch \
    --branch "${SQLIME_REF}" \
    https://github.com/nalgeon/sqlime.git \
    /sqlime \
    && test -f /sqlime/index.html \
    && test -f /sqlime/js/sqlite/sqlean.js \
    && test -f /sqlime/js/sqlite/sqlean.wasm \
    && rm -rf /sqlime/.git \
    && rm -f /sqlime/CNAME

FROM nginx:1.28-alpine

COPY --from=downloader /sqlime/ /usr/share/nginx/html/
COPY default.conf.template /etc/nginx/templates/default.conf.template

ENV PORT=8080

EXPOSE 8080


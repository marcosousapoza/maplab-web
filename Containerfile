# syntax=docker/dockerfile:1.7
FROM docker.io/library/node:24.19-bookworm-slim AS builder

ARG VERSION=0.0.0
ARG WASM_VERSION
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN --mount=type=secret,id=npm_token,required=true \
    token=$(cat /run/secrets/npm_token) \
    && printf '@marcosousapoza:registry=https://npm.pkg.github.com\n//npm.pkg.github.com/:_authToken=%s\n' "$token" > /tmp/npmrc \
    && npm --userconfig=/tmp/npmrc install --no-save --package-lock=false "@marcosousapoza/maplab-wasm@${WASM_VERSION}" \
    && rm /tmp/npmrc \
    && npm run wasm:sync -- node_modules/@marcosousapoza/maplab-wasm \
    && npm run build

FROM docker.io/nginxinc/nginx-unprivileged:1.29-alpine

ARG VERSION=0.0.0
LABEL org.opencontainers.image.source="https://github.com/marcosousapoza/maplab-web" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="GPL-3.0-only"

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 8080

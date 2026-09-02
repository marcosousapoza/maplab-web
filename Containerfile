FROM docker.io/library/node:24.19-bookworm-slim AS builder

ARG VERSION=0.0.0
ARG WASM_VERSION
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm install --no-save --package-lock=false "@marcosousapoza/maplab-wasm@${WASM_VERSION}" \
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

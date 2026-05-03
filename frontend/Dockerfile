# syntax=docker/dockerfile:1

# Build stage: install deps + build SPA with bun
FROM oven/bun:1-alpine AS build
WORKDIR /app

# Self-host build flag — frontend resolves API/WS host at runtime from window.location
ENV VITE_SAME_ORIGIN=true

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY . .
RUN bun run build

# Runtime stage: nginx serves the SPA and reverse-proxies the API/cable
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

FROM alpine:3.21

RUN apk add --no-cache redis

USER redis

CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no", "--port", "6379"]
FROM alpine:3.19

ARG PORTAINER_VERSION=2.33.2

RUN apk add --no-cache curl \
    && mkdir -p /opt/portainer /data \
    && curl -L https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz \
       | tar xz -C /opt \
    && apk del curl

WORKDIR /opt/portainer
EXPOSE 9000

CMD ["./portainer", "--data", "/data", "--bind", ":9000"]
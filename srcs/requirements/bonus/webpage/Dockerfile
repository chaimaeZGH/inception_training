FROM alpine:3.19

RUN apk update && apk add --no-cache nginx && rm -rf /var/cache/apk/*

COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY tools/index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
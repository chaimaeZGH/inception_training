FROM alpine:3.19

RUN apk add --no-cache nginx openssl

COPY conf/default.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
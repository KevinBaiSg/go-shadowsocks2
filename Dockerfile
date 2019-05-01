FROM golang:1.11.3-alpine3.8 AS builder

RUN apk upgrade \
    && apk add git \
    && go get -ldflags '-w -s' \
        github.com/shadowsocks/go-shadowsocks2

FROM alpine:3.8

LABEL maintainer="Kevin Bai <kevin.bai.sin@gmail.com>"

RUN apk upgrade \
    && apk add bash tzdata \
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/go-shadowsocks2 /usr/bin/shadowsocks
COPY start.sh /start.sh

ENV SS_PASSWORD password
ENV SS_METHOD aes-128-cfb

EXPOSE 8558
CMD ["sh", "start.sh"]
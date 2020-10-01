FROM alpine

RUN apk add --no-cache supervisor socat

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT supervisord -c /etc/supervisord.conf


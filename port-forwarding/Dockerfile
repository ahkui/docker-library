FROM alpine

RUN apk add --no-cache parallel socat

CMD parallel -v -N2 -j 2 'socat TCP-LISTEN:{1},reuseaddr,fork TCP:$HOST:{2}' ::: $PORT

FROM ubuntu
LABEL maintainer="ahkui <ahkui@outlook.com>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

RUN apt update -qq && \
    apt install -yqq --no-install-recommends \
    build-essential \
    libssl-dev \
    git \
    && \
    git config --global http.sslVerify false && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/* && \
    git clone --depth 1 https://github.com/wg/wrk.git wrk && \
    cd wrk && \
    make --quiet -j $(nproc) && \
    mv wrk /usr/bin && \
    cd .. && \
    rm -rf wrk

ENTRYPOINT "/usr/bin/wrk"

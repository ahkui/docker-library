FROM ubuntu
LABEL maintainer="ahkui <ahkui@outlook.com>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

RUN apt update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    git \
    && \
    git config --global http.sslVerify false && \
    apt-get clean \
    && \
    rm -rf /var/lib/apt/lists/* && \
    git clone --depth 1 https://github.com/wg/wrk.git wrk && \
    cd wrk && \
    make -j $(nproc) && \
    mv wrk /usr/bin && \
    cd .. && \
    rm -rf wrk

ENTRYPOINT "/usr/bin/wrk"

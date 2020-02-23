ARG CUDA_VERSION=10.2
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak

RUN apt update -qq && \
    apt install -yqq jq curl && \
    export COUNTRY=$(curl ipinfo.io | jq '.country' | tr -d "\"") && \
    sed -i "s|http:\/\/security|http:\/\/$COUNTRY.archive|g" /etc/apt/sources.list && \
    sed -i "s|http:\/\/archive|http:\/\/$COUNTRY.archive|g" /etc/apt/sources.list

FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel
LABEL maintainer="ahkui <ahkui@outlook.com>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

USER root

WORKDIR /root

COPY --from=0 /etc/apt/sources.list /etc/apt/sources.list
COPY --from=0 /etc/apt/sources.list.bak /etc/apt/sources.list.bak
COPY --from=ahkui/wrk:latest /usr/bin/wrk /usr/bin/wrk

ENV PATH="/opt/cmake-3.14.2-Linux-x86_64/bin:${PATH}"
RUN apt update -qq && apt install -yqq --no-install-recommends \
    software-properties-common \
    build-essential \
    python \
    python-dev \
    python3 \
    python3-dev \
    pkg-config \
    file \
    rsync \
    curl \
    wget \
    unzip \
    iputils-ping \
    net-tools \
    netcat \
    git \
    openssh-server \
    vim \
    htop \
    nmap \
    nmon \
    iperf3 \
    texlive-full \
    pandoc \
    p7zip-full \
    tree \
    apache2 \
    nginx \
    libpng-dev \
    libzmq3-dev \
    libpq-dev \
    && \
    git config --global http.sslVerify false \
    && \
    git config --global credential.helper store \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/* \
    && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.14.2/cmake-3.14.2-Linux-x86_64.tar.gz \
    && \
    tar xzf cmake-3.14.2-Linux-x86_64.tar.gz -C /opt \
    && \
    rm cmake-3.14.2-Linux-x86_64.tar.gz

ENV PYTHONPATH /usr/local/python:$PYTHONPATH

RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    mv tini /usr/bin/tini && \
    chmod +x /usr/bin/tini

RUN wget --quiet -L https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && \
    apt update -qq && apt install -yqq --no-install-recommends \
    nodejs \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip --no-cache-dir install \
    git+git://github.com/powerline/powerline \
    selenium \
    psycopg2-binary \
    psycopg2 \
    Pillow \
    h5py \
    ipykernel \
    jupyter \
    notebook \
    matplotlib \
    numpy \
    pandas \
    scipy \
    sklearn \
    flask \
    gunicorn \
    pymongo \
    redis \
    requests \
    ipyparallel \
    bs4 \
    nbconvert \
    pandoc \
    django \
    selenium \
    jupyterlab \
    jupyterlab-git \
    jupyterlab_github \
    tornado==5.1.1 \
    jupyterhub \
    && \
    python3 -m ipykernel.kernelspec

RUN npm install -g --unsafe-perm=true \
    @vue/cli \
    @vue/cli-service-global \
    ijavascript \
    && \
    ijsinstall \
    && \
    rm -rf ~/.npm

RUN add-apt-repository ppa:ondrej/php && \
    apt update -qq && apt install -yqq --no-install-recommends \
    php7.3 \
    php7.3-fpm \
    php7.3-curl \
    php7.3-zmq \
    && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    composer global require hirak/prestissimo && \
    wget -q https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar && \
    php ./jupyter-php-installer.phar install && \
    rm jupyter-php-installer.phar \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/*

RUN export TODAY=$(date +'%Y-%m-%d') && \
    echo $TODAY && \
    echo https://root.cern.ch/download/cling/cling_${TODAY}_ubuntu18.tar.bz2 && \
    wget -L https://root.cern.ch/download/cling/cling_${TODAY}_ubuntu18.tar.bz2 -q || { \
    unset TODAY && \
    export TODAY=$(date -d 'yesterday'  +'%Y-%m-%d') && \
    echo $TODAY && \
    echo https://root.cern.ch/download/cling/cling_${TODAY}_ubuntu18.tar.bz2 && \
    wget -L https://root.cern.ch/download/cling/cling_${TODAY}_ubuntu18.tar.bz2 -q \
    ;} && \
    tar -xf cling_${TODAY}_ubuntu18.tar.bz2 && \
    rm cling_${TODAY}_ubuntu18.tar.bz2 && \
    rsync -aq ./cling_${TODAY}_ubuntu18/ /usr/ && \
    cd /usr/share/cling/Jupyter/kernel/ && \
    python3 -m pip install -e . && \
    jupyter-kernelspec install cling-cpp11 && \
    jupyter-kernelspec install cling-cpp14 && \
    jupyter-kernelspec install cling-cpp17

ARG GRADLE_MAVEN=5.6.2
ENV PATH=$PATH:/opt/gradle/gradle-$GRADLE_MAVEN/bin
RUN apt update -qq && apt install -yqq default-jdk maven && \
    wget -q https://services.gradle.org/distributions/gradle-$GRADLE_MAVEN-bin.zip && \
    mkdir /opt/gradle && \
    unzip -qq -d /opt/gradle gradle-$GRADLE_MAVEN-bin.zip && \
    rm gradle-$GRADLE_MAVEN-bin.zip \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/SpencerPark/IJava.git && \
    cd IJava/ && \
    chmod u+x gradlew && ./gradlew installKernel

RUN jupyter labextension install \
    @fissio/hub-topbar-buttons \
    @jupyterlab/git \
    @jupyterlab/github \
    @jupyterlab/toc \
    @jupyterlab/google-drive \
    @jupyter-widgets/jupyterlab-manager \
    && \
    jupyter serverextension enable --py jupyterlab_git \
    && \
    jupyter serverextension enable --py jupyterlab_github \
    && \
    jupyter lab clean \
    && \
    jupyter lab build

RUN ln -s -f /usr/bin/python3 /usr/bin/python

COPY jupyter_notebook_config.py /root/.jupyter/

RUN cd ~ && \
    git clone --depth 1 https://github.com/ahkui/.vim.git && \
    ln -s -f ~/.vim/vimrc-powerline ~/.vimrc && \
    cd ~/.vim/ && \
    ./install.sh && \
    echo . /usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh >> ~/.bashrc && \
    echo export LC_ALL=C.UTF-8 >> ~/.bashrc && \
    echo export LANG=C.UTF-8 >> ~/.bashrc

COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start-notebook.sh
RUN chmod +x /usr/local/bin/start-singleuser.sh

EXPOSE 6006 8888

ENTRYPOINT ["tini", "--"]

CMD ["start-notebook.sh"]

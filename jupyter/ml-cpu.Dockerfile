FROM ahkui/jupyter:ml
ARG DEBIAN_FRONTEND=noninteractive

ARG JUPYTERHUB_ENABLE_NVIDIA=false

RUN if [ ${JUPYTERHUB_ENABLE_NVIDIA} = true ]; then \
    python2 -m pip --no-cache-dir install \
    tensorflow-gpu \
    && \
    python3 -m pip --no-cache-dir install \
    tensorflow-gpu \
    ;else \
    python2 -m pip --no-cache-dir install \
    tensorflow \
    && \
    python3 -m pip --no-cache-dir install \
    tensorflow \
    ;fi

RUN if [ ${JUPYTERHUB_ENABLE_NVIDIA} = true ]; then \
    apt-get update && apt-get install -y --no-install-recommends \
    caffe-cuda \
    libcaffe-cuda-dev \
    && \
    apt-get clean \
    && \
    rm -rf /var/lib/apt/lists/* \
    ;else \
    apt-get update && apt-get install -y --no-install-recommends \
    caffe-cpu \
    libcaffe-cpu-dev \
    && \
    apt-get clean \
    && \
    rm -rf /var/lib/apt/lists/* \
    ;fi

RUN cd openpose/build \
    && \
    if [ ${JUPYTERHUB_ENABLE_NVIDIA} = true ]; then \
    echo ENABLE NVIDIA $JUPYTERHUB_ENABLE_NVIDIA && \
    cmake -D USE_OPENCV=ON -D USE_NCCL=ON -D BUILD_PYTHON=ON .. \
    ;else \
    echo ENABLE NVIDIA $JUPYTERHUB_ENABLE_NVIDIA && \
    cmake -D BUILD_PYTHON=ON -D GPU_MODE=CPU_ONLY .. || true && \
    sed -i "362i }" ../3rdparty/caffe/src/caffe/layers/mkldnn_inner_product_layer.cpp \
    && \
    sed -i "358i {" ../3rdparty/caffe/src/caffe/layers/mkldnn_inner_product_layer.cpp \
    && \
    cmake -D BUILD_PYTHON=ON -D GPU_MODE=CPU_ONLY .. \
    ;fi \
    && \
    make -j`nproc` \
    && \
    make install


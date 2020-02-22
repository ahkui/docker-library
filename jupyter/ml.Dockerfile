FROM ahkui/jupyter:latest
ARG DEBIAN_FRONTEND=noninteractive

COPY notebooks /root/notebooks

ARG PIP="opencv-python keras keras_applications keras_preprocessing"
RUN python2 -m pip --no-cache-dir install \
    ${PIP} && \
    python3 -m pip --no-cache-dir install \
    ${PIP}

RUN export CUDA_VERSION_DASH=`echo ${CUDA_VERSION} | cut -c1-4 | sed -e "s/\./-/g"` && \
    export NVINFER_VERSION=`if [ "$CUDA_VERSION_DASH" = "10-1" ]; then echo 5; else echo 6; fi` && \
    apt update -qq && apt install -yqq --no-install-recommends --allow-change-held-packages \
    cuda-command-line-tools-$CUDA_VERSION_DASH \
    libcublas10 \
    libcublas-dev \
    cuda-cufft-${CUDA_VERSION_DASH} \
    cuda-curand-${CUDA_VERSION_DASH} \
    cuda-cusolver-${CUDA_VERSION_DASH} \
    cuda-cusparse-${CUDA_VERSION_DASH} \
    libnccl2 \
    libnccl-dev \
    libfreetype6-dev \
    protobuf-compiler \
    libnvinfer$NVINFER_VERSION \
    libnvinfer-dev \
    libprotobuf-dev \
    libopencv-dev \
    libgoogle-glog-dev \
    libboost-all-dev \
    libhdf5-dev \
    libhdf5-serial-dev \
    libatlas-base-dev \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ARG OPENPOSE_MODELS_PROVIDER=http://posefs1.perception.cs.cmu.edu/OpenPose/models/
RUN git clone --depth=1 https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
    && \
    cd openpose \
    && \
    git submodule update --init --recursive \
    && \
    cd models \
    && \
    sed -i "s,http://posefs1.perception.cs.cmu.edu/OpenPose/models/,$OPENPOSE_MODELS_PROVIDER,g" getModels.sh \
    && \
    ./getModels.sh >nul \
    && \
    cd .. \
    && \
    mkdir build

ARG JUPYTERHUB_ENABLE_NVIDIA=true

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
    apt update -qq && apt install -yqq --no-install-recommends \
    caffe-cuda \
    libcaffe-cuda-dev \
    && \
    apt clean \
    && \
    rm -rf /var/lib/apt/lists/* \
    ;else \
    apt update -qq && apt install -yqq --no-install-recommends \
    caffe-cpu \
    libcaffe-cpu-dev \
    && \
    apt clean \
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

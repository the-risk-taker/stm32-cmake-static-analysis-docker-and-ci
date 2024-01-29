FROM ubuntu:latest

# packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    g++ \
    git \
    ninja-build \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/sandbox

# tools directory
ARG TOOLS_DIRECTORY=/home/opt
RUN mkdir -p ${TOOLS_DIRECTORY}

# arm toolchain
ARG ARM_TOOLCHAIN_VERSION=13.2
ARG ARM_TOOLCHAIN_FILE=arm-gnu-toolchain-${ARM_TOOLCHAIN_VERSION}.rel1-x86_64-arm-none-eabi.tar.xz
ARG ARM_TOOLCHAIN_DIRECTORY=arm-gnu-toolchain-${ARM_TOOLCHAIN_VERSION}.Rel1-x86_64-arm-none-eabi

RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_TOOLCHAIN_VERSION}.rel1/binrel/${ARM_TOOLCHAIN_FILE} \
    && tar xf ${ARM_TOOLCHAIN_FILE} -C ${TOOLS_DIRECTORY} \
    && rm ${ARM_TOOLCHAIN_FILE}
ENV PATH=${PATH}:${TOOLS_DIRECTORY}/${ARM_TOOLCHAIN_DIRECTORY}/bin

# cppcheck
ARG CPPCHECK_VERSION=2.13.0
RUN git clone https://github.com/danmar/cppcheck.git && cd cppcheck && git checkout 2.13.0 \
    && cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DUSE_MATCHCOMPILER=ON -G Ninja \
    && cmake --build build && cmake --install build \
    && cd .. && rm -rf cppcheck

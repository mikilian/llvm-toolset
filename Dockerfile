FROM alpine:edge AS builder

LABEL maintainer="Michael Kilian <michael.kilian@gmail.com>" \
    alpine-version="edge"\
    architecture="linux/amd64" \
    build="27-Dec-2020" \
    llvm-version="11.0.0" \
    clang-version="11.0.0"

ENV VERSION_LLVM='11.0.0'

RUN apk update \
    && apk add --no-cache \
        autoconf \
        automake \
        cmake \
        dpkg \
        gcc \
        g++ \
        git \
        libc-dev \
        libstdc++ \
        make \
        python3-dev \
        python3 \
        wget \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 10\
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 10\
    && update-alternatives --auto cc \
    && update-alternatives --auto c++ \
    && update-alternatives --display cc \
    && update-alternatives --display c++ \
    && ln -sf /usr/bin/clang /usr/bin/cc \
    && ln -sf /usr/bin/clang++ /usr/bin/c++

WORKDIR /llvm-project
RUN git clone https://github.com/llvm/llvm-project.git . \
    && git checkout "llvmorg-${VERSION_LLVM}"

WORKDIR /llvm-project/build
RUN cmake -DLLVM_ENABLE_PROJECTS='clang' -DCMAKE_BUILD_TYPE='Release' ../llvm \
    && cmake --build . --target install -- -j20

FROM alpine:3.12 as build
RUN apk add --no-cache libstdc++ libc-dev make cmake

COPY --from=builder \
    /usr/local/bin/clang \
    /usr/local/bin/clang++ \
    /usr/local/bin/clang-format \
    /usr/local/bin/llvm-cov \
    /usr/local/bin/llvm-profdata \
    /usr/local/bin/

COPY --from=builder \
    /usr/local/include/clang \
    /usr/local/include/

COPY --from=builder \
    /usr/local/lib/libclang.so \
    /usr/local/lib/libclang-cpp.so \
    /usr/local/lib/

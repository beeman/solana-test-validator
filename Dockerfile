FROM debian:bullseye AS base

ARG AGAVE_VERSION=2.0.15
ARG RUST_VERSION=stable

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /workspace

RUN mkdir -pv "/workspace/bin" && echo 'echo test' > '/workspace/bin/test.sh' && chmod +x '/workspace/bin/test.sh'

ENV PATH="/workspace/bin:${PATH}"

FROM base AS builder

# Install os deps
RUN apt update && \
    apt-get install -y build-essential clang cmake curl libudev-dev pkg-config protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# Setup rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_VERSION -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Get the agave source
RUN curl https://codeload.github.com/anza-xyz/agave/tar.gz/refs/tags/v$AGAVE_VERSION | tar xvz
RUN mv /workspace/agave-$AGAVE_VERSION /workspace/agave

# Build the solana-test-validator
WORKDIR /workspace/agave
RUN cargo build --bin solana-test-validator --release
RUN cp target/release/solana-test-validator /workspace/bin/

FROM base AS final

## Install os deps
RUN apt update && \
    apt-get install -y bzip2 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /workspace/bin/* /workspace/bin

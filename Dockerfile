FROM debian:bullseye AS base

ARG AGAVE_VERSION=2.0.15
ARG RUST_VERSION=stable

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /workspace

ENV PATH="/workspace/bin:${PATH}"

# Expose the Solana Test Validator ports
EXPOSE 8899 8900

# Base os deps
RUN apt update && \
    apt-get install -y bzip2 tini && \
    rm -rf /var/lib/apt/lists/*

# Use tini as the entry point
ENTRYPOINT ["/usr/bin/tini", "--"]

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

# Copy the binary to the /workspace/bin directory
RUN mkdir -pv "/workspace/bin/" && cp target/release/solana-test-validator /workspace/bin/solana-test-validator
ENV PATH="/workspace/bin:${PATH}"

# Create the final image
FROM base AS final

# Copy the binary from the builder image
COPY --from=builder /workspace/bin/* /workspace/bin/

# Run the solana-test-validator by default
CMD ["solana-test-validator"]
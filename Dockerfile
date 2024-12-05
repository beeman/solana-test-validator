FROM debian:bullseye AS base

ARG AGAVE_VERSION=2.0.18
ARG RUST_VERSION=stable

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /workspace

ENV PATH="/workspace/bin:${PATH}"

# Expose the Solana Test Validator ports
EXPOSE 8899 8900

# Base OS dependencies
RUN apt update && \
    apt-get install -y bzip2 tini && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --gid 1000 solana && \
    useradd --uid 1000 --gid solana --create-home --shell /bin/bash solana && \
    mkdir -p /workspace && chown -R solana:solana /workspace

# Use tini as the entry point
ENTRYPOINT ["/usr/bin/tini", "--"]

FROM base AS builder

# Install OS dependencies
RUN apt update && \
    apt-get install -y build-essential clang cmake curl libudev-dev pkg-config protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# Setup Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_VERSION -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Get the Agave source
RUN curl https://codeload.github.com/anza-xyz/agave/tar.gz/refs/tags/v$AGAVE_VERSION | tar xvz
RUN mv /workspace/agave-$AGAVE_VERSION /workspace/agave

# Build the solana-test-validator
WORKDIR /workspace/agave
RUN cargo build --bin solana-test-validator --release

# Copy the binary to the /workspace/bin directory
RUN mkdir -pv "/workspace/bin/" && cp target/release/solana-test-validator /workspace/bin/solana-test-validator

# Ensure permissions for the non-root user
RUN chown -R solana:solana /workspace

# Create the final image
FROM base AS final

# Copy the binary from the builder image
COPY --from=builder /workspace/bin/* /workspace/bin/

# Set ownership for the non-root user
RUN chown -R solana:solana /workspace

# Switch to the non-root user
USER solana

# Run the solana-test-validator by default
CMD ["solana-test-validator"]

### BASE IMAGE ###
FROM debian:bullseye AS base

# Set the Agave and Rust versions
ARG AGAVE_VERSION=2.0.18
ARG RUST_VERSION=stable

# Set the working directory
WORKDIR /workspace

# Base OS dependencies
RUN apt update && \
    apt-get install -y bzip2 ca-certificates tini && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --gid 1000 solana && \
    useradd --uid 1000 --gid solana --create-home --shell /bin/bash solana && \
    mkdir -p /workspace && chown -R solana:solana /workspace

# Use tini as the entry point
ENTRYPOINT ["/usr/bin/tini", "--"]

### BUILDER IMAGE ###
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

### FINAL IMAGE ###
FROM base AS final

# Expose the Solana Test Validator ports
EXPOSE 8899 8900

# Copy the binary from the builder image
COPY --from=builder /workspace/bin/* /workspace/bin/

# Set ownership for the non-root user
RUN chown -R solana:solana /workspace

# Switch to the non-root user
USER solana

# Add the bin directory to the PATH
ENV PATH="/workspace/bin:${PATH}"

# Run the solana-test-validator by default
CMD ["solana-test-validator"]

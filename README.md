# Solana Test Validator on Docker

This repository contains a Docker image for the Solana Test Validator.

This Docker image is built each night for `linux/amd64` as well as `linux/arm64` platforms.

This makes it possible to run this image on devices with Apple Silicon processors.

## Usage

To run the Solana Test Validator, you can use the following command:

```shell
docker run -it -p 8899:8899 -p 8900:8900 --rm --name solana-test-validator ghcr.io/beeman/solana-test-validator:latest
```

This will start the Solana Test Validator on port 8899 and 8900.

See the [examples](https://github.com/beeman/solana-test-validator/tree/main/examples) directory for more information.

### Note on `io_uring`

Agave v2.0+ uses `io_uring` to significantly improve snapshot unpacking performance (see [PR #6535](https://github.com/anza-xyz/agave/pull/6535)). Docker's default security profile (`seccomp`) blocks necessary syscalls (like `io_uring_setup`), causing the validator to fail. Using `--security-opt seccomp=unconfined` (or a custom profile) is required to allow these syscalls.

```sh
docker run --security-opt seccomp=unconfined ghcr.io/beeman/solana-test-validator:latest
# alternatively, create a seccomp profile that allows io_uring and other required syscalls
```

## Building the Docker image

To build the Docker image, you can use the following command using [just](https://github.com/casey/just):

```shell
just build
```

This will build the Docker image and tag it as `ghcr.io/beeman/solana-test-validator`.

## Running the Docker image

To run the Docker image, you can use the following command:

```shell
just run
```

This will start the Solana Test Validator on port 8899 and 8900.

## Running a shell in the Docker image

To run a shell in the Docker image, you can use the following command:

```shell
just run-sh
```

This will start a shell in the Docker image.

## Running an examples

To run an example, you can use the following command:

```shell
just example <example-name>
```

For example, to run the `docker-compose` example, you can use the following command:

```shell
just example docker-compose
```

This will start the Docker Compose example.

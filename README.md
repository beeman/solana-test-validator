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

## Building the Docker image

To build the Docker image, you can use the following command using [just](https://github.com/casey/just):

```shell
just build
```

This will build the Docker image and tag it as `ghcr.io/beeman/solana-test-validator`.


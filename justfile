DOCKER_USER := "ghcr.io/beeman"
DOCKER_REPO := "solana-test-validator"
DOCKER_TAG := "latest"

# [misc]

_default: _fmt

@_fmt:
    just --fmt --unstable
    just --list

alias b := build

# [docker]

build:
    docker build -t {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }} .

push:
    docker push {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }}

run:
    docker run --rm -it -p 8899:8899 -p 8900:8900 --name solana-test-validator --rm {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }}

run-sh:
    docker run --rm -it --name solana-test-validator --rm --entrypoint bash {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }}

#    "docker:build": "docker buildx build --platform=linux/amd64 --load . -t ghcr.io/beeman/solana-test-validator:latest",
#    "docker:push": "docker push ghcr.io/beeman/solana-test-validator",
#    "docker:run": "docker run --rm -it -p 8899:8899 -p 8900:8900 --platform=linux/amd64 --name solana-docker-m1 ghcr.io/beeman/solana-test-validator",
#    "docker:run-sh": "docker run --rm -it --platform=linux/amd64 --name solana-docker-m1-sh --entrypoint bash ghcr.io/beeman/solana-test-validator"

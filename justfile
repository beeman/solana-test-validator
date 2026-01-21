CONTAINER_NAME := "solana-test-validator"
CONTAINER_PARAMS := "-it -p 8899:8899 -p 8900:8900 --security-opt seccomp=unconfined --rm"
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

run:
    docker run {{ CONTAINER_PARAMS }} --name {{ CONTAINER_NAME }} {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }}

run-sh:
    docker run {{ CONTAINER_PARAMS }} --name {{ CONTAINER_NAME }} --entrypoint bash {{ DOCKER_USER }}/{{ DOCKER_REPO }}:{{ DOCKER_TAG }}

# [examples]
example name:
    case {{ name }} in \
           "docker-compose") \
               cd examples/docker-compose && docker compose up; \
               ;; \
           "dockerfile") \
               cd examples/dockerfile && docker build . -t examples-dockerfile && docker run {{ CONTAINER_PARAMS }} --name {{ CONTAINER_NAME }} examples-dockerfile \
               ;; \
           *) \
               echo "Error: example '{{ name }}' does not exist"; \
               exit 1; \
               ;; \
       esac

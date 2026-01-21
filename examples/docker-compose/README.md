# Solana Test Validator with Docker Compose

You can use this image in a Docker Compose file like so:

### Note on `io_uring`

Agave v2.0+ uses `io_uring` to significantly improve snapshot unpacking performance (see [PR #6535](https://github.com/anza-xyz/agave/pull/6535)). Docker's default security profile (`seccomp`) blocks necessary syscalls (like `io_uring_setup`), causing the validator to fail. The `security_opt` configuration is necessary to allow these syscalls.

```yaml
# docker-compose.yml
services:
  validator:
    image: ghcr.io/beeman/solana-test-validator:latest
    # Clone the Metaplex program from the Solana Devnet cluster
    command: "solana-test-validator --url https://api.devnet.solana.com --clone metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s --clone PwDiXFxQsGra4sFFTT8r1QWRMd4vfumiWC1jfWNfdYT"
    ports:
      - "8899:8899"
      - "8900:8900"
    security_opt:
      - seccomp:unconfined
```

Then run it like this:

```shell
docker compose up
```

After running this command, you can access the Solana Test Validator at http://localhost:8899 and http://localhost:8900.

You can see the Metaplex program at the [Solana Explorer](https://explorer.solana.com/address/metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s?cluster=custom).

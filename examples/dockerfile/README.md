# Solana Test Validator with custom Docker image

You can use this image in a custom Docker image like so:

```dockerfile
FROM ghcr.io/beeman/solana-test-validator:latest
# Clone the Metaplex program from the Solana Devnet cluster
CMD ["solana-test-validator", "--url", "https://api.devnet.solana.com", "--clone", "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s"]
```

Then run it like this:

```shell
# Build the custom Docker image
docker build . -t my-custom-solana-test-validator
# Run the custom Docker image
docker run -it -p 8899:8899 -p 8900:8900 --rm --name my-test-validator my-custom-solana-test-validator
```

After running this command, you can access the Solana Test Validator at http://localhost:8899 and http://localhost:8900.

You can see the Metaplex program at the [Solana Explorer](https://explorer.solana.com/address/metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s?cluster=custom).

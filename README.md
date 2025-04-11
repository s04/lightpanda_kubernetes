# lightpanda_kubernetes

## Building the Docker Image

### Using the Makefile (Recommended)

The project includes a Makefile with targets for building and pushing images:

```bash
# Create a buildx builder (only needed once)
docker buildx create --use

# Build images for both architectures
make build-all

# Push images for both architectures to DockerHub
make push-all

# Create and push multi-architecture manifest
make manifest
```

You can also build and push individual architectures:
```bash
# For x86_64/amd64
make build-x86_64
make push-x86_64

# For ARM64
make build-arm64
make push-arm64
```

### For testing the Github Actions

For testing the x86_64 workflow:
```bash
act workflow_dispatch -W .github/workflows/lightpanda-x86_64.yml --secret-file my.secrets --container-architecture linux/amd64
```

For testing the ARM64 workflow:
```bash
act workflow_dispatch -W .github/workflows/lightpanda-arm64.yml --secret-file my.secrets --container-architecture linux/amd64
```

To test both workflows in sequence:
```bash
act workflow_dispatch -W .github/workflows/lightpanda-x86_64.yml --secret-file my.secrets --container-architecture linux/amd64 && \
act workflow_dispatch -W .github/workflows/lightpanda-arm64.yml --secret-file my.secrets --container-architecture linux/amd64
```

Note: When testing locally with `act`, we use `--container-architecture linux/amd64` for both workflows since `act` runs in containers on your local machine. The actual GitHub Actions will build for the correct target architectures.
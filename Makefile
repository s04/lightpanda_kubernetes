# Makefile for Lightpanda Browser Docker images

# Variables (can be overridden)
DOCKER_REPO := andalouse/lightpanda-browser
NIGHTLY_TAG := nightly
COMMIT_HASH := $(shell git rev-parse --short HEAD)

.PHONY: build-x86_64 build-arm64 build-all \
        push-x86_64 push-arm64 push-all \
        manifest help

help:
	@echo "Available targets:"
	@echo "  build-x86_64  - Build x86_64 Docker image"
	@echo "  build-arm64   - Build ARM64 Docker image"
	@echo "  build-all     - Build both architecture images"
	@echo "  push-x86_64   - Push x86_64 Docker image"
	@echo "  push-arm64    - Push ARM64 Docker image"
	@echo "  push-all      - Push both architecture images"
	@echo "  manifest      - Create and push multi-arch manifest"
	@echo "  help          - Show this help message"

# For local builds, we use --load to make the image available locally
build-x86_64:
	docker buildx build --platform linux/amd64 \
		--load \
		-t $(DOCKER_REPO):$(NIGHTLY_TAG)-amd64 \
		-t $(DOCKER_REPO):$(COMMIT_HASH)-amd64 \
		-f x86_64.Dockerfile .

# For local builds, we use --load to make the image available locally
build-arm64:
	docker buildx build --platform linux/arm64 \
		--load \
		-t $(DOCKER_REPO):$(NIGHTLY_TAG)-arm64 \
		-t $(DOCKER_REPO):$(COMMIT_HASH)-arm64 \
		-f arm64.Dockerfile .

build-all: build-x86_64 build-arm64

push-x86_64:
	docker buildx build --platform linux/amd64 \
		--push \
		-t $(DOCKER_REPO):$(NIGHTLY_TAG)-amd64 \
		-t $(DOCKER_REPO):$(COMMIT_HASH)-amd64 \
		-f x86_64.Dockerfile .

push-arm64:
	docker buildx build --platform linux/arm64 \
		--push \
		-t $(DOCKER_REPO):$(NIGHTLY_TAG)-arm64 \
		-t $(DOCKER_REPO):$(COMMIT_HASH)-arm64 \
		-f arm64.Dockerfile .

push-all: push-x86_64 push-arm64

manifest:
	docker manifest create $(DOCKER_REPO):$(NIGHTLY_TAG) \
		$(DOCKER_REPO):$(NIGHTLY_TAG)-amd64 \
		$(DOCKER_REPO):$(NIGHTLY_TAG)-arm64
	docker manifest push $(DOCKER_REPO):$(NIGHTLY_TAG)
	
	docker manifest create $(DOCKER_REPO):$(COMMIT_HASH) \
		$(DOCKER_REPO):$(COMMIT_HASH)-amd64 \
		$(DOCKER_REPO):$(COMMIT_HASH)-arm64
	docker manifest push $(DOCKER_REPO):$(COMMIT_HASH) 
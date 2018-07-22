
DOCKER_IMAGE_NAME ?= docker-asciidoctor-openjdk-node
DOCKERHUB_USERNAME ?= muenchhausen
DOCKER_IMAGE_TEST_TAG ?= $(shell git rev-parse --short HEAD)
DOCKER_IMAGE_NAME_TO_TEST ?= $(DOCKERHUB_USERNAME)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TEST_TAG)
DOCKER_IMAGE_NAME_LATEST ?= $(DOCKERHUB_USERNAME)/$(DOCKER_IMAGE_NAME):latest
CURRENT_GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_IMAGE_NAME_BUILD ?= $(DOCKER_IMAGE_NAME)_build
DOCKER_IMAGE_NAME_BUILDCONTAINER ?= $(DOCKER_IMAGE_NAME)_buildcontainer

export DOCKER_IMAGE_NAME_TO_TEST 

all: build test deploy

build:
	docker build \
		-t $(DOCKER_IMAGE_NAME_TO_TEST) \
		-f Dockerfile \
		$(CURDIR)/
	docker tag $(DOCKER_IMAGE_NAME_TO_TEST) $(DOCKER_IMAGE_NAME_LATEST)

test:
	docker build -t $(DOCKER_IMAGE_NAME_BUILD) -f $(CURDIR)/test/Dockerfile_build $(CURDIR)/test/
	docker rm -f $(DOCKER_IMAGE_NAME_BUILDCONTAINER) || true
	docker run -it --name $(DOCKER_IMAGE_NAME_BUILDCONTAINER) $(DOCKER_IMAGE_NAME_BUILD) bats /app/test_suite.bats

deploy:
	curl -H "Content-Type: application/json" \
		--data '{"source_type": "Branch", "source_name": "$(CURRENT_GIT_BRANCH)"}' \
		-X POST https://registry.hub.docker.com/u/$(DOCKERHUB_USERNAME)/$(DOCKER_IMAGE_NAME)/trigger/$(DOCKER_HUB_TOKEN)/

.PHONY: all build test deploy
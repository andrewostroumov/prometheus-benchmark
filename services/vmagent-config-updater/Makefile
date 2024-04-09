# All these commands must run from repository root.

IMAGE_NAMESPACE := andrewostroumov

GIT_BUILD_TAG ?= $(shell echo $$(git rev-parse --abbrev-ref HEAD)-$$(git rev-parse --short HEAD))
GIT_TAG ?= $(shell git tag --list --points-at HEAD)
IMAGE_TAG ?= $(GIT_TAG)

ifeq ($(IMAGE_TAG),)
IMAGE_TAG := $(GIT_BUILD_TAG)
endif

vmagent-config-updater-build:
	docker buildx build  \
		--platform linux/arm64,linux/amd64 \
		--build-arg GOLANG_IMAGE_VERSION=1.22 \
		--build-arg ALPINE_IMAGE_VERSION=3.19 \
		-t $(IMAGE_NAMESPACE)/vmagent-config-updater:$(IMAGE_TAG) services/vmagent-config-updater
ifneq ($(GIT_TAG),)
	docker tag $(IMAGE_NAMESPACE)/vmagent-config-updater:$(IMAGE_TAG) \
		$(IMAGE_NAMESPACE)/vmagent-config-updater:latest
endif

vmagent-config-updater-push: vmagent-config-updater-build
	docker push $(IMAGE_NAMESPACE)/vmagent-config-updater:$(IMAGE_TAG)
ifneq ($(GIT_TAG),)
	docker push $(IMAGE_NAMESPACE)/vmagent-config-updater:latest
endif

vmagent-config-updater-run: vmagent-config-updater-build
	docker run -it --rm \
		-p 8436:8436 \
		--name vmagent-config-updater \
		$(IMAGE_NAMESPACE)/vmagent-config-updater:$(IMAGE_TAG)

IMAGE_NAME = opklnm102/hello-next
IMAGE_TAG := $(shell git branch --show-current | sed -e "s/\//-/g")-$(shell git rev-parse HEAD)
IMAGE = $(IMAGE_NAME):$(IMAGE_TAG)

.DEFAULT_GOAL := run

.PHONY: clean
clean:
	rm -rf node_modules .next

.PHONY: deps
deps:
	yarn install

.PHONY: build
build: deps
	yarn build

.PHONY: run
run: build
	yarn start

.PHONY: run-dev
run-dev:
	yarn dev

.PHONY: build-image
build-image:
	docker build -t $(IMAGE) -f ./Dockerfile .

.PHONY: push-image
push-image: build-image
	docker push $(IMAGE)

.PHONY: clean-image
clean-image:
	docker image rm -f $(IMAGE)

.PHONY: run-image
run-container:
	docker run -p 3000:3000 $(IMAGE)

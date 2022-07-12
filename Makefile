DOCKER_TAG ?= $(shell git rev-parse --short HEAD)

.PHONY: build
build:
	docker build -t taccwma/protx-geospatial:$(DOCKER_TAG) -t taccwma/protx-geospatial .
	docker tag taccwma/protx-geospatial:$(DOCKER_TAG) taccwma/protx-geospatial:latest

.PHONY: publish
publish:
	docker push taccwma/protx-geospatial:$(DOCKER_TAG)
	docker push taccwma/protx-geospatial:latest

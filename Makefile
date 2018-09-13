include ./Makefile.properties

DOCKERREPO=$(DOCKERUSER)/$(DOCKERIMAGE)
BUILD_ARTIFACTS_PATH=./.make.build

build: get.version.alpine
	docker build \
		--build-arg "VERSION_ALPINE=$$(cat ./$(BUILD_ARTIFACTS_PATH)/version.alpine)" \
		--tag $(DOCKERREPO):latest \
		.
	-@rm -rf $(BUILD_ARTIFACTS_PATH)

build.tests: get.version.alpine
	docker build \
		--build-arg "VERSION_ALPINE=$$(cat ./$(BUILD_ARTIFACTS_PATH)/version.alpine)" \
		--tag $(DOCKERREPO):tests-latest \
		./tests
	-@rm -rf $(BUILD_ARTIFACTS_PATH)

test: build.tests
	./tests/entrypoint.sh

publish: build
	docker tag $(DOCKERREPO):latest $(DOCKERREGISTRY)/$(DOCKERREPO):latest
	docker push $(DOCKERREPO):latest
	docker push $(DOCKERREGISTRY)/$(DOCKERREPO):latest

get.version.alpine:
	-@mkdir -p $(BUILD_ARTIFACTS_PATH)
	@curl \
		-s "https://hub.docker.com/v2/repositories/library/alpine/tags/?page_size=100" \
		| jq '.results[].name' \
		| egrep -oi '[0-9]+\.[0-9]+\.*[0-9]*' \
		| sort -Vr \
		| head -n 1 \
		> $(BUILD_ARTIFACTS_PATH)/version.alpine
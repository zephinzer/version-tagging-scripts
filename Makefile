include ./Makefile.properties

DOCKERREPO=$(DOCKERUSER)/$(DOCKERIMAGE)

build:
	docker build \
		--tag $(DOCKERREPO):latest \
		.

build.tests:
	docker build \
		--tag $(DOCKERREPO):tests-latest \
		./tests

test: build.tests
	./tests/entrypoint.sh

publish: build
	docker tag $(DOCKERREPO):latest $(DOCKERREGISTRY)/$(DOCKERREPO):latest
	docker push $(DOCKERREPO):latest
	docker push $(DOCKERREGISTRY)/$(DOCKERREPO):latest
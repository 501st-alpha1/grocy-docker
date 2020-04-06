.PHONY: all push

USER=501stalpha1
ifeq ($(shell uname -m), i686)
  PLATFORM=386
else
  PLATFORM=amd64
endif
VERSION=v2.6.2
BUILD=3
GITHUB_API_TOKEN=

all: .last-docker-build

.last-docker-build: Dockerfile-grocy Dockerfile-grocy-nginx
	docker build -t "$(USER)/grocy-nginx:$(VERSION)-$(BUILD)-$(PLATFORM)" -f Dockerfile-grocy-nginx .
	docker build --build-arg GROCY_VERSION=$(VERSION) --build-arg GITHUB_API_TOKEN=$(GITHUB_API_TOKEN) -t "$(USER)/grocy:$(VERSION)-$(BUILD)-$(PLATFORM)" -f Dockerfile-grocy .
	@touch $@

push: .last-docker-push

.last-docker-push: .last-docker-build
	docker push "$(USER)/grocy-nginx:$(VERSION)-$(BUILD)-$(PLATFORM)"
	docker push "$(USER)/grocy:$(VERSION)-$(BUILD)-$(PLATFORM)"
	manifest-tool push from-spec ./manifest-nginx.yml --ignore-missing
	manifest-tool push from-spec ./manifest-grocy.yml --ignore-missing
	@touch $@

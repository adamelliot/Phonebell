
VERSION := $(shell cat VERSION)

all: build

build:
	docker build --platform linux/arm/v7 -t ghcr.io/adamelliot/phonebell:$(VERSION) .

push: build
	docker push ghcr.io/adamelliot/phonebell:$(VERSION)

pull:
	docker pull ghcr.io/adamelliot/phonebell:$(VERSION)

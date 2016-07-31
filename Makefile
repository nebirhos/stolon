NAME = stolon
VERSION = master
DOCKERCONTEXT=./examples/kubernetes/image/docker

.PHONY: all build

all: build image

build:
	./build

image:
	docker build -t $(NAME):$(VERSION) --rm $(DOCKERCONTEXT)

clean:
	rm -rf $(DOCKERCONTEXT)/bin/*
	rm -rf ./gopath/*
	rm -rf ./bin/*

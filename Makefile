BINARY        ?= oauth2_proxy
SOURCES        = $(shell find . -name '*.go')
GOPKGS        = $(shell go list ./... | grep -v /vendor/)
BUILD_FLAGS   ?=
LDFLAGS       ?= -w -s

build.local: build/$(BINARY)
build.linux: build/linux/$(BINARY)
build.osx: build/osx/$(BINARY)

test:
	go test ./...

build: build/$(BINARY)

build/$(BINARY): $(SOURCES)
	CGO_ENABLED=0 go build -o build/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

build/linux/$(BINARY): $(SOURCES)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o build/linux/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

build/osx/$(BINARY): $(SOURCES)
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o build/osx/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

clean:
	@rm -rf build

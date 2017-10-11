INTERNAL_BIN_DIR=_internal_bin
GOVERSION=$(shell go version)
GOOS=$(word 1,$(subst /, , $(lastword $(GOVERSION))))
GOARCH=$(word 2,$(subst /, , $(lastword $(GOVERSION))))
RELEASE_DIR=releases
HAVE_GLIDE:=$(shell which glide)

build: $(RELEASE_DIR)/sonar2csv_$(GOOS)_$(GOARCH)/sonar2csv$(SUFFIX)

$(INTERNAL_BIN_DIR)/$(GOOS)/$(GOARCH)/glide:
ifeq ($(HAVE_GLIDE),)
	@echo "Installing glide for $(GOOS)/$(GOARCH)..."
	@mkdir -p $(INTERNAL_BIN_DIR)/$(GOOS)/$(GOARCH)
	@wget -O - https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-$(GOOS)-$(GOARCH).tar.gz | tar xvz
	@mv $(GOOS)-$(GOARCH)/glide $(INTERNAL_BIN_DIR)/$(GOOS)/$(GOARCH)/glide
	@rm -rf $(GOOS)-$(GOARCH)
endif

glide: $(INTERNAL_BIN_DIR)/$(GOOS)/$(GOARCH)/glide

installdeps: glide
	@echo "Installing dependencies..."
	@PATH=$(INTERNAL_BIN_DIR)/$(GOOS)/$(GOARCH):$(PATH) glide install

build-windows-amd64:
	@$(MAKE) build GOOS=windows GOARCH=amd64 SUFFIX=.exe

build-windows-386:
	@$(MAKE) build GOOS=windows GOARCH=386 SUFFIX=.exe

build-linux-amd64:
	@$(MAKE) build GOOS=linux GOARCH=amd64

build-linux-386:
	@$(MAKE) build GOOS=linux GOARCH=386

build-darwin-amd64:
	@$(MAKE) build GOOS=darwin GOARCH=amd64

build-darwin-386:
	@$(MAKE) build GOOS=darwin GOARCH=386

$(RELEASE_DIR)/sonar2csv_$(GOOS)_$(GOARCH)/sonar2csv$(SUFFIX):
	go build -o $(RELEASE_DIR)/sonar2csv_$(GOOS)_$(GOARCH)/sonar2csv$(SUFFIX) main.go

all: installdeps build-windows-amd64 build-windows-386 build-linux-amd64 build-linux-386 build-darwin-amd64 build-darwin-386

PREFIX?=/usr/local

PRODUCT_NAME=fugen
PRODUCT_VERSION=1.0.0-alpha.1
TEMPLATES_NAME=Templates
README_NAME=README.md
LICENSE_NAME=LICENSE

REPOSITORY=https://github.com/almazrafi/$(PRODUCT_NAME)
RELEASE_TAR = $(REPOSITORY)/archive/$(PRODUCT_VERSION).tar.gz
RELEASE_SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')

SOURCES_MAIN_PATH=Sources/Fugen/main.swift
RELEASE_PATH=.build/release/$(PRODUCT_NAME)-$(PRODUCT_VERSION)
RELEASE_ZIP_PATH = ./$(PRODUCT_NAME)-$(PRODUCT_VERSION).zip
PRODUCT_PATH=.build/release/$(PRODUCT_NAME)
TEMPLATES_PATH=$(TEMPLATES_NAME)

README_PATH=$(README_NAME)
LICENSE_PATH=$(LICENSE_NAME)

BIN_PATH=$(PREFIX)/bin
BIN_PRODUCT_PATH=$(BIN_PATH)/$(PRODUCT_NAME)
SHARE_PRODUCT_PATH=$(PREFIX)/share/$(PRODUCT_NAME)

HOMEBREW_FORMULA_PATH=Formula/Fugen.rb

.PHONY: all version bootstrap lint build install uninstall

version:
	@echo $(PRODUCT_VERSION)

bootstrap:
	Scripts/bootstrap.sh

lint:
	Scripts/swiftlint.sh

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(BIN_PATH)
	cp -f $(PRODUCT_PATH) $(BIN_PRODUCT_PATH)

	mkdir -p $(SHARE_PRODUCT_PATH)
	cp -r $(TEMPLATES_PATH)/. $(SHARE_PRODUCT_PATH)

uninstall:
	rm -rf $(BIN_PRODUCT_PATH)
	rm -rf $(SHARE_PRODUCT_PATH)

release: build
	sed -i '' 's|\(let PRODUCT_VERSION = "\)\(.*\)\("\)|\1$(PRODUCT_VERSION)\3|' $(SOURCES_MAIN_PATH)
	mkdir -p $(RELEASE_PATH)
	cp -f $(PRODUCT_PATH) $(RELEASE_PATH)
	cp -r $(TEMPLATES_PATH) $(RELEASE_PATH)
	cp -f $(README_PATH) $(RELEASE_PATH)
	cp -f $(LICENSE_PATH) $(RELEASE_PATH)
	(cd $(RELEASE_PATH); zip -yr - $(PRODUCT_NAME) $(TEMPLATES_NAME) $(README_NAME) $(LICENSE_NAME)) > $(RELEASE_ZIP_PATH)

release_brew:
	sed -i '' 's|\(url ".*/archive/\)\(.*\)\(.tar\)|\1$(PRODUCT_VERSION)\3|' $(HOMEBREW_FORMULA_PATH)
	sed -i '' 's|\(sha256 "\)\(.*\)\("\)|\1$(RELEASE_SHA)\3|' $(HOMEBREW_FORMULA_PATH)

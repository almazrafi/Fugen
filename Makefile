PRODUCT_NAME = fugen
VERSION = 1.0.0-dev

PRODUCT_PATH = .build/release/$(PRODUCT_NAME)
TEMPLATES_PATH = Templates

PREFIX = /usr/local

BIN_PATH = $(PREFIX)/bin
BIN_PRODUCT_PATH = $(PREFIX)/bin/$(PRODUCT_NAME)
SHARE_PRODUCT_PATH = $(PREFIX)/share/$(PRODUCT_NAME)
SHARE_TEMPLATES_PATH = $(PREFIX)/share/$(PRODUCT_NAME)/Templates

.PHONY: all build install uninstall lint

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(BIN_PATH)
	cp -f $(PRODUCT_PATH) $(BIN_PRODUCT_PATH)

	mkdir -p $(SHARE_PRODUCT_PATH)
	cp -R $(TEMPLATES_PATH) $(SHARE_TEMPLATES_PATH)

uninstall:
	rm -rf $(BIN_PRODUCT_PATH)
	rm -rf $(SHARE_PRODUCT_PATH)

lint:
	swiftlint lint --quiet

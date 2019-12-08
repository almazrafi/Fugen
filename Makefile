PREFIX?=/usr/local

PRODUCT_NAME=fugen
PRODUCT_VERSION=1.0.0
TEMPLATES_NAME=Templates
README_NAME=README.md
LICENSE_NAME=LICENSE

DEMO_PATH=Demo
DEMO_WORKSPACE=FugenDemo.xcworkspace
DEMO_TEST_SCHEME=FugenDemo
DEMO_TEST_DESTINATION=platform=iOS Simulator,name=iPhone 11
DEMO_TEST_LOG_PATH=.build/demo_test.json

RELEASE_PATH=.build/release/$(PRODUCT_NAME)-$(PRODUCT_VERSION)
RELEASE_ZIP_PATH=$(PRODUCT_NAME)-$(PRODUCT_VERSION).zip
PRODUCT_PATH=.build/release/$(PRODUCT_NAME)
TEMPLATES_PATH=$(TEMPLATES_NAME)

README_PATH=$(README_NAME)
LICENSE_PATH=$(LICENSE_NAME)

BIN_PATH=$(PREFIX)/bin
BIN_PRODUCT_PATH=$(BIN_PATH)/$(PRODUCT_NAME)
SHARE_PRODUCT_PATH=$(PREFIX)/share/$(PRODUCT_NAME)

SOURCES_MAIN_PATH=Sources/Fugen/main.swift
DEMO_PODFILE_PATH=$(DEMO_PATH)/Podfile

.PHONY: all version bootstrap lint build test test_demo install uninstall update_version release

version:
	@echo $(PRODUCT_VERSION)

bootstrap:
	Scripts/bootstrap.sh

lint:
	Scripts/swiftlint.sh

build:
	swift package clean
	swift build --disable-sandbox -c release

test:
	swift package clean
	swift test

test_demo: build
	cp -f $(PRODUCT_PATH) $(DEMO_PATH)
	cp -r $(TEMPLATES_PATH) $(DEMO_PATH)

	cd $(DEMO_PATH); \
		./fugen generate; \
		xcodebuild clean build -workspace "$(DEMO_WORKSPACE)" -scheme "$(DEMO_TEST_SCHEME)" -destination "$(DEMO_TEST_DESTINATION)" | XCPRETTY_JSON_FILE_OUTPUT="../$(DEMO_TEST_LOG_PATH)" xcpretty -f `xcpretty-json-formatter`

install: build
	mkdir -p $(BIN_PATH)
	cp -f $(PRODUCT_PATH) $(BIN_PRODUCT_PATH)
	mkdir -p $(SHARE_PRODUCT_PATH)
	cp -r $(TEMPLATES_PATH)/. $(SHARE_PRODUCT_PATH)

uninstall:
	rm -rf $(BIN_PRODUCT_PATH)
	rm -rf $(SHARE_PRODUCT_PATH)

update_version:
	sed -i '' 's|\(let version = "\)\(.*\)\("\)|\1$(PRODUCT_VERSION)\3|' $(SOURCES_MAIN_PATH)
	sed -i '' 's|\(pod '\''Fugen'\'', '\''~> \)\(.*\)\('\''\)|\1$(PRODUCT_VERSION)\3|' $(DEMO_PODFILE_PATH)

release: update_version build
	mkdir -p $(RELEASE_PATH)
	cp -f $(PRODUCT_PATH) $(RELEASE_PATH)
	cp -r $(TEMPLATES_PATH) $(RELEASE_PATH)
	cp -f $(README_PATH) $(RELEASE_PATH)
	cp -f $(LICENSE_PATH) $(RELEASE_PATH)
	(cd $(RELEASE_PATH); zip -yr - $(PRODUCT_NAME) $(TEMPLATES_NAME) $(README_NAME) $(LICENSE_NAME)) > $(RELEASE_ZIP_PATH)

NAME = SwiftZSV
CONFIG = debug

GENERIC_PLATFORM_MACOS = platform=macOS
SIM_PLATFORM_MACOS = platform=macOS

GREEN='\033[0;32m'
NC='\033[0m'

build-all-platforms:
	for platform in \
	  "$(GENERIC_PLATFORM_MACOS)"; \
	do \
		echo -e "\n${GREEN}Building $$platform ${NC}"\n; \
		set -o pipefail && xcrun xcodebuild build \
			-workspace $(NAME).xcworkspace \
			-scheme $(NAME) \
			-configuration $(CONFIG) \
			-destination "$$platform" | xcpretty || exit 1; \
	done;

test-all-platforms:
	for platform in \
	  "$(SIM_PLATFORM_MACOS)"; \
	do \
		echo -e "\n${GREEN}Testing $$platform ${NC}\n"; \
		set -o pipefail && xcrun xcodebuild test \
			-workspace $(NAME).xcworkspace \
			-scheme $(NAME) \
			-configuration $(CONFIG) \
			-destination "$$platform" | xcpretty || exit 1; \
	done;

lint:
	swiftlint lint --strict

spell:
	cspell-cli lint --no-progress

all: lint spell build-all-platforms test-all-platforms

.PHONY: all
.DEFAULT_GOAL := all

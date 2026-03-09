SHELL := /bin/bash

PLATFORM ?= iOS Simulator

.PHONY: generate build open clean

generate:
	@test -f .env || (echo "Error: .env file not found. Copy .env.example to .env and fill in GITHUB_ACCESS_TOKEN." && exit 1)
	@source .env && \
		git config --global url."https://oauth2:$${GITHUB_ACCESS_TOKEN}@github.com/MoveLab-Studio/".insteadOf "https://github.com/MoveLab-Studio/" && \
		.ops/tuist install && .ops/tuist generate; \
		EXIT_CODE=$$?; \
		git config --global --unset "url.https://oauth2:$${GITHUB_ACCESS_TOKEN}@github.com/MoveLab-Studio/.insteadOf" 2>/dev/null || true; \
		exit $$EXIT_CODE

build:
	xcodebuild \
		-workspace ConnectionsSDKSample.xcworkspace \
		-scheme ConnectionsSDKSample \
		-destination 'generic/platform=$(PLATFORM)' \
		build

open:
	open ConnectionsSDKSample.xcworkspace

clean:
	.ops/tuist clean
	rm -rf DerivedData/

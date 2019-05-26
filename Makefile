# Old-skool build tools.
#
# Targets (see each target for more information):
#   all: Build code.
#   build: Build code.
#   check: Run verify, build, unit tests and cmd tests.
#   test: Run all tests.
#   run: Run all-in-one server
#   clean: Clean up.

OUT_DIR = _output

export GOFLAGS
export TESTFLAGS
# May be used to set additional arguments passed to the image build commands for
# mounting secrets specific to a build environment.
export OS_BUILD_IMAGE_ARGS

# Tests run using `make` are most often run by the CI system, so we are OK to
# assume the user wants jUnit output and will turn it off if they don't.
JUNIT_REPORT ?= true

# Build code.
#
# Args:
#   WHAT: Directory names to build.  If any of these directories has a 'main'
#     package, the build will produce executable files under $(OUT_DIR)/local/bin.
#     If not specified, "everything" will be built.
#   GOFLAGS: Extra flags to pass to 'go' when building.
#   GOGCFLAGS: Additional go compile flags passed to 'go' when building.
#   TESTFLAGS: Extra flags that should only be passed to hack/test-go.sh
#
# Example:
#   make
#   make all
#   make all WHAT=cmd/oc GOFLAGS=-v
#   make all GOGCFLAGS="-N -l"
all build:
	hack/build-go.sh $(WHAT) $(GOFLAGS)
.PHONY: all build

build-network:
	hack/build-go.sh cmd/openshift-sdn cmd/sdn-cni-plugin vendor/github.com/containernetworking/plugins/plugins/ipam/host-local vendor/github.com/containernetworking/plugins/plugins/main/loopback
.PHONY: build-network

# Update vendored dependencies
#
# Example:
#	make update-deps
update-deps:
	hack/update-deps.sh
.PHONY: update-deps

# Build the cross compiled release binaries
#
# Example:
#   make build-cross
build-cross:
	hack/build-cross.sh
.PHONY: build-cross


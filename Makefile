# ==============================================================================
# APEX VISION IVI — Build & Execution Makefile
# Targets:
#   make / make all   : Configures and builds the binary
#   make run          : Builds and launches the APEX VISION IVI application
#   make clean        : Cleans build artifacts
#   make rebuild      : Cleans, reconfigures, and builds
# ==============================================================================

BUILD_DIR ?= build
EXECUTABLE ?= $(BUILD_DIR)/apex_vision_ivi

# Detect Qt 6 Prefix Path if not explicitly set
ifeq ($(strip $(CMAKE_PREFIX_PATH)),)
  ifneq ($(wildcard /opt/homebrew/opt/qt),)
    CMAKE_PREFIX_PATH := /opt/homebrew/opt/qt
  else ifneq ($(wildcard /usr/local/opt/qt),)
    CMAKE_PREFIX_PATH := /usr/local/opt/qt
  else ifneq ($(wildcard /usr/lib/aarch64-linux-gnu/cmake/Qt6),)
    CMAKE_PREFIX_PATH := /usr/lib/aarch64-linux-gnu
  endif
endif

CMAKE_FLAGS ?=
ifneq ($(strip $(CMAKE_PREFIX_PATH)),)
  CMAKE_FLAGS += -DCMAKE_PREFIX_PATH="$(CMAKE_PREFIX_PATH)"
endif

.PHONY: all build run clean rebuild config help

all: build

config: $(BUILD_DIR)/Makefile

$(BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "==> Configuring APEX VISION IVI with CMake..."
	@mkdir -p $(BUILD_DIR)
	cmake -B $(BUILD_DIR) -S . $(CMAKE_FLAGS)

build: config
	@echo "==> Building APEX VISION IVI..."
	cmake --build $(BUILD_DIR) -j

run: build
	@echo "==> Launching APEX VISION IVI..."
	./$(EXECUTABLE)

clean:
	@echo "==> Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)

rebuild: clean all

help:
	@echo "APEX VISION IVI Commands:"
	@echo "  make              - Build the application"
	@echo "  make run          - Build and launch the application"
	@echo "  make clean        - Remove build directory"
	@echo "  make rebuild      - Clean and re-build from scratch"

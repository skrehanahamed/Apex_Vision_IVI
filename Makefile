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
NPROCS ?= $(shell sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

# Detect Qt 6 Prefix Path if not explicitly set
ifeq ($(strip $(CMAKE_PREFIX_PATH)),)
  ifneq ($(wildcard /opt/homebrew/opt/qt),)
    CMAKE_PREFIX_PATH := /opt/homebrew/opt/qt;/opt/homebrew/opt/qtwebengine;/opt/homebrew/opt/qtmultimedia
  else ifneq ($(wildcard /usr/local/opt/qt),)
    CMAKE_PREFIX_PATH := /usr/local/opt/qt;/usr/local/opt/qtwebengine;/usr/local/opt/qtmultimedia
  else ifneq ($(wildcard /usr/lib/aarch64-linux-gnu/cmake/Qt6),)
    CMAKE_PREFIX_PATH := /usr/lib/aarch64-linux-gnu
  endif
endif

CMAKE_FLAGS ?=
ifneq ($(strip $(CMAKE_PREFIX_PATH)),)
  CMAKE_FLAGS += -DCMAKE_PREFIX_PATH="$(CMAKE_PREFIX_PATH)"
endif

.PHONY: all build run run-bg stop clean rebuild config help

all: build

config: $(BUILD_DIR)/CMakeCache.txt

$(BUILD_DIR)/CMakeCache.txt: CMakeLists.txt
	@echo "==> Configuring APEX VISION IVI with CMake..."
	@mkdir -p $(BUILD_DIR)
	cmake -B $(BUILD_DIR) -S . $(CMAKE_FLAGS)

build: config
	@echo "==> Building APEX VISION IVI..."
	cmake --build $(BUILD_DIR) -j $(NPROCS)

stop:
	@echo "==> Terminating any running APEX VISION IVI session(s)..."
	@-pkill -f apex_vision_ivi 2>/dev/null || true

run: stop
	@$(MAKE) build
	@echo "==> Launching APEX VISION IVI..."
	./$(EXECUTABLE)

run-bg: stop
	@$(MAKE) build
	@echo "==> Launching APEX VISION IVI in background..."
	@nohup ./$(EXECUTABLE) >/tmp/apex_vision_ivi.log 2>&1 &

clean:
	@echo "==> Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)

rebuild: clean all

help:
	@echo "APEX VISION IVI Commands:"
	@echo "  make              - Build the application"
	@echo "  make run          - Terminate previous session, build, and run in foreground"
	@echo "  make run-bg       - Terminate previous session, build, and run in background"
	@echo "  make stop         - Terminate any running APEX VISION IVI instances"
	@echo "  make clean        - Remove build directory"
	@echo "  make rebuild      - Clean and re-build from scratch"

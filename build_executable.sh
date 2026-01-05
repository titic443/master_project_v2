#!/bin/bash
#
# Build Flutter Test Generator Executable
#
# This script compiles the Flutter Test Generator into standalone executables
# for multiple platforms.
#
# Usage:
#   ./build_executable.sh          # Build for current platform
#   ./build_executable.sh all      # Build for all platforms (requires cross-compilation setup)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tool information
TOOL_NAME="flutter_test_gen"
SOURCE_FILE="tools/flutter_test_generator.dart"
OUTPUT_DIR="bin"
DIST_DIR="dist"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Flutter Test Generator - Build Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo -e "${RED}✗ Error: Dart is not installed${NC}"
    echo "  Please install Dart/Flutter first: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${GREEN}✓ Dart found:${NC} $(dart --version 2>&1)"
echo ""

# Create output directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$DIST_DIR"

# Function to build for specific platform
build_platform() {
    local platform=$1
    local output_name=$2

    echo -e "${YELLOW}Building for $platform...${NC}"

    if [ "$platform" == "current" ]; then
        # Build for current platform
        dart compile exe "$SOURCE_FILE" -o "$OUTPUT_DIR/$output_name"

        if [ $? -eq 0 ]; then
            local size=$(du -h "$OUTPUT_DIR/$output_name" | cut -f1)
            echo -e "${GREEN}✓ Built successfully:${NC} $OUTPUT_DIR/$output_name ($size)"

            # Make executable
            chmod +x "$OUTPUT_DIR/$output_name"

            # Create distribution package
            echo -e "${YELLOW}Creating distribution package...${NC}"
            local dist_name="${TOOL_NAME}-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)"
            mkdir -p "$DIST_DIR/$dist_name"
            cp "$OUTPUT_DIR/$output_name" "$DIST_DIR/$dist_name/$TOOL_NAME"
            cp "EXECUTABLE_README.md" "$DIST_DIR/$dist_name/README.md" 2>/dev/null || true

            # Create tarball
            (cd "$DIST_DIR" && tar -czf "${dist_name}.tar.gz" "$dist_name")
            rm -rf "$DIST_DIR/$dist_name"

            echo -e "${GREEN}✓ Distribution package:${NC} $DIST_DIR/${dist_name}.tar.gz"
        else
            echo -e "${RED}✗ Build failed for $platform${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ Cross-compilation not yet implemented${NC}"
        echo "  To build for other platforms, run this script on the target platform."
    fi

    echo ""
}

# Parse arguments
BUILD_MODE="${1:-current}"

case "$BUILD_MODE" in
    "all")
        echo "Building for all platforms..."
        echo ""
        build_platform "current" "$TOOL_NAME"
        echo -e "${YELLOW}Note: To build for other platforms (Windows, Linux, macOS),${NC}"
        echo -e "${YELLOW}      run this script on each target platform.${NC}"
        ;;
    "current"|"")
        build_platform "current" "$TOOL_NAME"
        ;;
    *)
        echo -e "${RED}✗ Unknown build mode: $BUILD_MODE${NC}"
        echo ""
        echo "Usage:"
        echo "  ./build_executable.sh          # Build for current platform"
        echo "  ./build_executable.sh all      # Build for all platforms"
        exit 1
        ;;
esac

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Build complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Executables created in: $OUTPUT_DIR/"
echo "Distribution packages in: $DIST_DIR/"
echo ""
echo "To use the executable:"
echo "  ./$OUTPUT_DIR/$TOOL_NAME --help"
echo "  ./$OUTPUT_DIR/$TOOL_NAME lib/demos/your_page.dart --skip-datasets"
echo ""

#!/bin/bash

# Widget Coverage Wrapper Script
# Usage: ./tools/check_widget_coverage.sh [page_name]
#
# Example:
#   ./tools/check_widget_coverage.sh customer_details_page
#   ./tools/check_widget_coverage.sh

set -e

# Default page
PAGE_NAME="${1:-customer_details_page}"

# Paths
MANIFEST="output/manifest/demos/${PAGE_NAME}.manifest.json"
TEST_FILE="integration_test/${PAGE_NAME}_flow_test.dart"

# Alternative paths
if [ ! -f "$MANIFEST" ]; then
    MANIFEST="output/manifest/${PAGE_NAME}.manifest.json"
fi

# Check files exist
if [ ! -f "$MANIFEST" ]; then
    echo "Error: Manifest not found"
    echo "  Tried: output/manifest/demos/${PAGE_NAME}.manifest.json"
    echo "  Tried: output/manifest/${PAGE_NAME}.manifest.json"
    echo ""
    echo "Available manifests:"
    find output/manifest -name "*.manifest.json" 2>/dev/null || echo "  (none found)"
    exit 1
fi

if [ ! -f "$TEST_FILE" ]; then
    echo "Error: Test file not found: $TEST_FILE"
    echo ""
    echo "Available test files:"
    find integration_test -name "*_flow_test.dart" 2>/dev/null || echo "  (none found)"
    exit 1
fi

# Run widget coverage
dart run tools/widget_coverage.dart "$MANIFEST" "$TEST_FILE"

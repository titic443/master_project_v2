#!/bin/bash

# Test Verification Script
# Usage: ./tools/verify_tests.sh <test_file>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Symbols
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
WARN="${YELLOW}⚠${NC}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Flutter Test Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if test file provided
if [ -z "$1" ]; then
    echo -e "${CROSS} Error: No test file specified"
    echo "Usage: ./tools/verify_tests.sh integration_test/customer_details_page_flow_test.dart"
    exit 1
fi

TEST_FILE="$1"

if [ ! -f "$TEST_FILE" ]; then
    echo -e "${CROSS} Error: Test file not found: $TEST_FILE"
    exit 1
fi

echo -e "${BLUE}Test File:${NC} $TEST_FILE"
echo ""

# Phase 1: Syntax & Build Check
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phase 1: Syntax & Build Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -n "Running flutter analyze... "
if flutter analyze --no-pub > /tmp/analyze_output.txt 2>&1; then
    echo -e "$CHECK ${GREEN}Passed${NC}"
else
    echo -e "$CROSS ${RED}Failed${NC}"
    cat /tmp/analyze_output.txt
    exit 1
fi

echo -n "Running build check (dry-run)... "
if flutter test "$TEST_FILE" --dry-run > /tmp/dryrun_output.txt 2>&1; then
    echo -e "$CHECK ${GREEN}Passed${NC}"
else
    echo -e "$CROSS ${RED}Failed${NC}"
    cat /tmp/dryrun_output.txt
    exit 1
fi

echo ""

# Phase 2: Execute Tests
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phase 2: Execute Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Running tests..."
START_TIME=$(date +%s)

if flutter test "$TEST_FILE" > /tmp/test_output.txt 2>&1; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo -e "$CHECK ${GREEN}All tests passed${NC}"
    echo ""

    # Extract test count
    TEST_COUNT=$(grep -o '+[0-9]\+:' /tmp/test_output.txt | tail -1 | grep -o '[0-9]\+' || echo "0")
    echo "  • Total tests: $TEST_COUNT"
    echo "  • Execution time: ${DURATION}s"

    if [ "$DURATION" -gt 30 ]; then
        echo -e "  $WARN Tests took longer than 30s (consider optimization)"
    fi
else
    echo -e "$CROSS ${RED}Tests failed${NC}"
    echo ""
    cat /tmp/test_output.txt
    exit 1
fi

echo ""

# Phase 3: Coverage Analysis
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phase 3: Coverage Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Generating coverage report..."
if flutter test "$TEST_FILE" --coverage > /dev/null 2>&1; then
    echo -e "$CHECK Coverage data generated"

    # Check if lcov is installed
    if command -v lcov &> /dev/null; then
        # Parse coverage
        COVERAGE_SUMMARY=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" || echo "")

        if [ -n "$COVERAGE_SUMMARY" ]; then
            echo ""
            echo "Coverage Summary:"
            echo "$COVERAGE_SUMMARY"

            # Extract line coverage percentage
            LINE_COV=$(echo "$COVERAGE_SUMMARY" | grep -o '[0-9]\+\.[0-9]\+%' | head -1 || echo "0%")
            LINE_COV_NUM=$(echo "$LINE_COV" | sed 's/%//')

            echo ""
            if (( $(echo "$LINE_COV_NUM >= 80" | bc -l) )); then
                echo -e "$CHECK Line coverage is excellent (≥80%): $LINE_COV"
            elif (( $(echo "$LINE_COV_NUM >= 70" | bc -l) )); then
                echo -e "$WARN Line coverage is acceptable (≥70%): $LINE_COV"
            else
                echo -e "$CROSS Line coverage is low (<70%): $LINE_COV"
            fi
        fi

        # Generate HTML report
        if command -v genhtml &> /dev/null; then
            echo ""
            echo -n "Generating HTML coverage report... "
            if genhtml coverage/lcov.info -o coverage/html --quiet 2>&1; then
                echo -e "$CHECK ${GREEN}Done${NC}"
                echo "  → Open: coverage/html/index.html"
            else
                echo -e "$WARN ${YELLOW}Failed to generate HTML${NC}"
            fi
        else
            echo ""
            echo -e "$WARN genhtml not installed (run: brew install lcov)"
        fi
    else
        echo -e "$WARN lcov not installed (run: brew install lcov)"
        echo "  → Coverage file saved: coverage/lcov.info"
    fi
else
    echo -e "$CROSS ${RED}Coverage generation failed${NC}"
fi

echo ""

# Phase 4: Test Quality Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phase 4: Test Quality Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Count test cases
PAIRWISE_COUNT=$(grep -c "testWidgets('pairwise" "$TEST_FILE" || echo "0")
VALID_COUNT=$(grep -c "testWidgets('valid_only" "$TEST_FILE" || echo "0")
TOTAL_TESTS=$(grep -c "testWidgets(" "$TEST_FILE" || echo "0")

echo "Test Distribution:"
echo "  • Pairwise (invalid) cases: $PAIRWISE_COUNT"
echo "  • Valid only cases: $VALID_COUNT"
echo "  • Total test cases: $TOTAL_TESTS"

# Count assertions
ASSERT_COUNT=$(grep -c "expect(" "$TEST_FILE" || echo "0")
echo ""
echo "Assertions:"
echo "  • Total assertions: $ASSERT_COUNT"
if [ "$TOTAL_TESTS" -gt 0 ]; then
    AVG_ASSERTIONS=$((ASSERT_COUNT / TOTAL_TESTS))
    echo "  • Average per test: $AVG_ASSERTIONS"

    if [ "$AVG_ASSERTIONS" -lt 1 ]; then
        echo -e "  $WARN Low assertion count (add more verification)"
    elif [ "$AVG_ASSERTIONS" -ge 3 ]; then
        echo -e "  $CHECK Good assertion coverage"
    fi
fi

echo ""

# Final Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verification Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "$CHECK Phase 1: Syntax & Build - ${GREEN}PASSED${NC}"
echo -e "$CHECK Phase 2: Test Execution - ${GREEN}PASSED${NC}"
echo -e "$CHECK Phase 3: Coverage Analysis - ${GREEN}COMPLETED${NC}"
echo -e "$CHECK Phase 4: Quality Summary - ${GREEN}COMPLETED${NC}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}✓ All verifications passed!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Next Steps:"
echo "  1. Review coverage report: open coverage/html/index.html"
echo "  2. Review TEST_VERIFICATION_GUIDE.md for manual checks"
echo "  3. Commit tests if quality gates met"
echo ""

# Test Verification Guide

## Overview

After generating tests with `flutter_test_gen`, developers must verify test quality and effectiveness. This guide provides a comprehensive verification workflow.

---

## ✅ Verification Checklist

### Phase 1: Syntax & Build Check

#### 1.1 Run Static Analysis
```bash
flutter analyze
```

**Expected:** No errors or warnings

**Common Issues:**
- Missing imports
- Unused variables
- Type mismatches

---

#### 1.2 Dry Run Test Build
```bash
flutter test integration_test/customer_details_page_flow_test.dart --dry-run
```

**Expected:** "All tests passed!" (without actually running tests)

**Common Issues:**
- Missing dependencies in `pubspec.yaml`
- Import path errors
- Widget key mismatches

---

### Phase 2: Execute Tests

#### 2.1 Run All Tests
```bash
flutter test integration_test/customer_details_page_flow_test.dart
```

**Expected Output:**
```
00:01 +1: pairwise_valid_invalid_cases_1
00:02 +2: pairwise_valid_invalid_cases_2
...
00:15 +12: All tests passed!
```

**What to Check:**
- ✅ All tests passed
- ✅ No timeout errors
- ✅ Reasonable execution time (< 2 sec per test)

---

#### 2.2 Run with Verbose Output
```bash
flutter test integration_test/customer_details_page_flow_test.dart --verbose
```

**What to Check:**
- Widget interactions execute correctly
- No "Widget not found" errors
- State transitions happen as expected

---

#### 2.3 Analyze Test Failures (if any)

**Common Failure Reasons:**

| Error | Cause | Solution |
|-------|-------|----------|
| `Widget not found: Key('customer_01_submit')` | Missing widget key | Add key to UI widget |
| `Expected: true Actual: false` | Wrong assertion | Fix test data or UI logic |
| `TimeoutException` | Widget not rendered | Add `pumpAndSettle()` |
| `Cubit not found` | Missing BlocProvider | Check test setup |

---

### Phase 3: Coverage Analysis

#### 3.1 Run Tests with Coverage
```bash
flutter test --coverage
```

**Output:** `coverage/lcov.info`

---

#### 3.2 Generate HTML Report
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report
open coverage/html/index.html
```

---

#### 3.3 Review Coverage Metrics

**Target Metrics:**

| Metric | Target | Good | Excellent |
|--------|--------|------|-----------|
| **Line Coverage** | ≥ 70% | ≥ 80% | ≥ 90% |
| **Branch Coverage** | ≥ 60% | ≥ 75% | ≥ 85% |
| **Function Coverage** | ≥ 80% | ≥ 90% | ≥ 95% |

**What to Check:**
- ✅ All widget build methods covered
- ✅ Cubit state transitions covered
- ✅ Validation logic covered (both valid/invalid paths)
- ✅ Error handling paths covered

**Uncovered Code Examples:**
```dart
// Example: Uncovered error path
if (state.email.isEmpty) {
  return;  // ← This line not covered by tests
}
```

**Action:** Add test cases for uncovered scenarios

---

### Phase 4: Test Quality Review

#### 4.1 Review Test Structure

**Good Test Structure:**
```dart
testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
  // 1. ARRANGE: Setup
  await tester.pumpWidget(...);

  // 2. ACT: Perform actions
  await tester.tap(find.byKey(...));
  await tester.enterText(...);

  // 3. ASSERT: Verify results
  expect(find.text('Error message'), findsOneWidget);
});
```

**Checklist:**
- ✅ Test name describes scenario
- ✅ Clear arrange-act-assert structure
- ✅ No hardcoded delays (`Future.delayed`)
- ✅ Uses `pumpAndSettle()` for async operations

---

#### 4.2 Review Assertions

**Good Assertions:**
```dart
// ✅ Specific and meaningful
expect(find.text('Email is required'), findsOneWidget);
expect(find.byKey(const Key('success_message')), findsOneWidget);

// ❌ Too generic
expect(find.text('Error'), findsOneWidget);  // Which error?
```

**Checklist:**
- ✅ Assertions verify expected behavior
- ✅ Both success and failure paths tested
- ✅ Error messages validated
- ✅ State transitions verified

---

#### 4.3 Review Test Data

**Good Test Data (from AI):**
```json
{
  "valid": "Alice",           // Realistic name
  "invalid": "A",             // Edge case (too short)
  "invalidRuleMessages": "Minimum 2 characters"
}
```

**Checklist:**
- ✅ Realistic values (not "test123")
- ✅ Edge cases covered (min/max length, boundaries)
- ✅ Invalid data respects input formatters
- ✅ Error messages match validation rules

---

### Phase 5: Effectiveness Testing (Advanced)

#### 5.1 Manual Bug Injection

**Purpose:** Verify tests can catch real bugs

**Process:**
1. Inject a bug into UI code
2. Run tests
3. Verify tests fail
4. Fix bug
5. Verify tests pass

**Example:**
```dart
// Original code (correct)
if (state.email.isEmpty) {
  return 'Email is required';
}

// Inject bug: Remove validation
// if (state.email.isEmpty) {
//   return 'Email is required';
// }

// Run tests → Should FAIL
// Fix bug → Tests should PASS
```

**What This Proves:**
- Tests are sensitive to code changes
- Tests detect regressions
- Assertions are meaningful

---

#### 5.2 Mutation Testing Metrics

**Manual Mutation Checklist:**

| Mutation Type | Example | Test Should Detect? |
|---------------|---------|---------------------|
| Remove validation | Delete `if (isEmpty)` | ✅ Yes |
| Change operator | `>` → `>=` | ✅ Yes |
| Change constant | `minLength: 2` → `3` | ✅ Yes |
| Remove assertion | Delete error message | ✅ Yes |
| Change state | `success` → `error` | ✅ Yes |

---

### Phase 6: Documentation & Reporting

#### 6.1 Generate Test Report

**Create:** `test_report.md`

```markdown
# Test Report: customer_details_page

**Date:** 2026-01-05
**Generated By:** flutter_test_gen
**UI File:** lib/demos/customer_details_page.dart

## Summary

| Metric | Value |
|--------|-------|
| Total Test Cases | 12 |
| Passed | 12 |
| Failed | 0 |
| Line Coverage | 87% |
| Branch Coverage | 82% |
| Execution Time | 14.2s |

## Test Cases

### Pairwise Invalid Cases (Failure Tests)
- ✅ pairwise_valid_invalid_cases_1: Invalid firstname, phone, lastname
- ✅ pairwise_valid_invalid_cases_2: Invalid firstname, phone
- ...

### Valid Only Cases (Success Tests)
- ✅ valid_only_cases_1: All fields valid
- ✅ valid_only_cases_2: All fields valid (different values)
- ...

## Coverage Gaps

- Error handling for network timeout (not covered)
- Edge case: Very long text input (> 1000 chars)

## Recommendations

1. Add manual test for network errors
2. Add test for maximum input length
3. Consider adding performance tests
```

---

#### 6.2 Verification Checklist Template

**Create:** `test_verification_checklist.md`

```markdown
## Test Verification Checklist

Page: __customer_details_page__
Date: __2026-01-05__
Verified By: __[Your Name]__

### Phase 1: Syntax & Build
- [ ] `flutter analyze` passed
- [ ] `flutter test --dry-run` passed

### Phase 2: Execution
- [ ] All tests passed
- [ ] No timeout errors
- [ ] Execution time < 30s

### Phase 3: Coverage
- [ ] Line coverage ≥ 80%
- [ ] Branch coverage ≥ 75%
- [ ] Generated HTML report

### Phase 4: Quality
- [ ] Test names are descriptive
- [ ] Assertions are meaningful
- [ ] Test data is realistic
- [ ] Success & failure paths covered

### Phase 5: Effectiveness (Optional)
- [ ] Injected bugs detected by tests
- [ ] Tests fail when expected

### Phase 6: Documentation
- [ ] Test report created
- [ ] Coverage gaps documented
- [ ] Tests committed to repository

**Overall Status:** ✅ PASS / ❌ FAIL

**Notes:**
_[Add any additional observations or concerns]_
```

---

## 🔧 Useful Commands Reference

### Basic Testing
```bash
# Run specific test file
flutter test integration_test/customer_details_page_flow_test.dart

# Run all tests
flutter test

# Run with verbose output
flutter test --verbose

# Dry run (check build without executing)
flutter test --dry-run
```

### Coverage
```bash
# Generate coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Filter coverage (exclude generated files)
lcov --remove coverage/lcov.info '*.g.dart' -o coverage/filtered.info
```

### Debugging
```bash
# Run single test
flutter test --plain-name="pairwise_valid_invalid_cases_1"

# Update golden files (for widget snapshot tests)
flutter test --update-goldens

# Run with debugger
flutter test --start-paused
```

### Performance
```bash
# Measure test execution time
time flutter test integration_test/customer_details_page_flow_test.dart

# Profile tests
flutter test --profile
```

---

## 📊 Quality Gates

Before merging tests to main branch:

### Minimum Requirements
- ✅ All tests must pass
- ✅ Line coverage ≥ 70%
- ✅ No syntax/analysis errors
- ✅ Test report created

### Recommended
- ✅ Branch coverage ≥ 75%
- ✅ Manual review completed
- ✅ Effectiveness testing performed

### Excellent
- ✅ Line coverage ≥ 85%
- ✅ Branch coverage ≥ 80%
- ✅ Mutation testing passed
- ✅ Performance benchmarks met

---

## 🚨 Common Issues & Solutions

### Issue 1: Tests Pass but Don't Cover Real Scenarios
**Symptom:** 100% coverage but bugs still slip through

**Solution:**
- Review test assertions (are they meaningful?)
- Perform mutation testing
- Add boundary value tests

---

### Issue 2: Flaky Tests (Randomly Fail)
**Symptom:** Tests pass sometimes, fail other times

**Causes:**
- Race conditions
- Async timing issues
- Random test data

**Solutions:**
```dart
// ❌ Bad: Hardcoded delay
await Future.delayed(Duration(seconds: 1));

// ✅ Good: Wait for state changes
await tester.pumpAndSettle();

// ✅ Good: Wait for specific condition
await tester.pump(Duration(milliseconds: 100));
```

---

### Issue 3: Tests Too Slow
**Symptom:** Tests take > 1 minute to run

**Solutions:**
- Use `pumpAndSettle()` sparingly
- Mock expensive operations (API calls)
- Split large test files
- Run tests in parallel

---

### Issue 4: Low Coverage Despite Many Tests
**Symptom:** Many tests but coverage < 60%

**Causes:**
- Tests focus on happy path only
- Error handling not tested
- Edge cases ignored

**Solutions:**
- Add negative test cases
- Test error paths explicitly
- Use pairwise testing (already done by flutter_test_gen!)

---

## 🎯 Best Practices

### DO ✅
- Run tests locally before committing
- Review generated tests manually
- Supplement with custom tests for complex scenarios
- Keep tests fast (< 1 sec per test)
- Use meaningful test names
- Check coverage regularly

### DON'T ❌
- Skip test verification
- Commit failing tests
- Ignore coverage reports
- Use hardcoded delays
- Test implementation details (test behavior, not internals)
- Duplicate test cases unnecessarily

---

## 📚 Additional Resources

### Flutter Testing Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Coverage Tools
- [lcov](https://github.com/linux-test-project/lcov)
- [Codecov](https://about.codecov.io/)
- [Coveralls](https://coveralls.io/)

### Testing Patterns
- [Arrange-Act-Assert](https://automationpanda.com/2020/07/07/arrange-act-assert-a-pattern-for-writing-good-tests/)
- [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)

---

## 🔄 Continuous Integration

### GitHub Actions Example
```yaml
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: genhtml coverage/lcov.info -o coverage/html
      - uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info
```

---

## Summary

Test verification is **critical** for ensuring quality. Follow these phases:

1. **Syntax Check** → `flutter analyze`
2. **Execute Tests** → `flutter test`
3. **Coverage Analysis** → `flutter test --coverage`
4. **Quality Review** → Manual inspection
5. **Effectiveness Testing** → Mutation testing
6. **Documentation** → Create reports

**Remember:** Generated tests are a starting point, not the finish line!

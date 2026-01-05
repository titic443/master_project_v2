# UI Testing Metrics Guide (Widget Tests)

## Overview

UI testing (Widget Testing) มี metrics ที่แตกต่างจาก Unit Testing เพราะเน้นที่ **user interaction** และ **visual feedback** มากกว่า code logic

---

## 📊 Core Metrics สำหรับ UI Testing

### 1. Widget Coverage (ความครอบคลุม Widgets)

#### 1.1 Widget Rendering Coverage
**วัดอะไร:** เปอร์เซ็นต์ของ widgets ที่ถูก render ใน test

**ตัวอย่าง Page:**
```dart
// customer_details_page.dart มี widgets:
1. Title Dropdown
2. First Name TextField
3. Phone TextField
4. Last Name TextField
5. Age Radio Group (3 options)
6. Terms Checkbox
7. Newsletter Checkbox
8. Submit Button
```

**Test Coverage:**
```dart
// Test 1: Render all widgets
testWidgets('all_widgets_render', (tester) async {
  await tester.pumpWidget(CustomerDetailsPage());

  expect(find.byKey(Key('customer_01_title_dropdown')), findsOne); // ✓
  expect(find.byKey(Key('customer_02_firstname_textfield')), findsOne); // ✓
  expect(find.byKey(Key('customer_03_phone_textfield')), findsOne); // ✓
  // ... all 8 widgets
});
```

**คำนวณ:**
```
Widget Coverage = (Widgets Tested / Total Widgets) × 100
                = (8 / 8) × 100 = 100% ✅
```

**เป้าหมาย:** 100% (ควร test ทุก widget ที่มี)

---

#### 1.2 Widget State Coverage
**วัดอะไร:** ครอบคลุม states ต่างๆ ของ widget หรือไม่

**ตัวอย่าง:**
```dart
// TextField มี states:
1. Empty (initial)
2. Valid input
3. Invalid input (error)
4. Disabled
5. Focused
```

**Test Coverage:**
```dart
// ❌ Weak: Test เฉพาะ valid state
testWidgets('textfield_valid', (tester) async {
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  // Widget State Coverage = 20% (1/5 states)
});

// ✅ Strong: Test multiple states
testWidgets('textfield_states', (tester) async {
  // State 1: Empty
  expect(find.text(''), findsWidgets);

  // State 2: Valid
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');

  // State 3: Invalid (error)
  await tester.enterText(find.byKey(Key('email')), 'invalid');
  expect(find.text('Invalid email'), findsOne);

  // Widget State Coverage = 60% (3/5 states) ✅
});
```

**เป้าหมาย:** ≥ 80% widget states

---

#### 1.3 Conditional Widget Coverage
**วัดอะไร:** Test widgets ที่แสดงแบบมีเงื่อนไข

**ตัวอย่าง:**
```dart
// UI code
if (state.status == LoginStatus.loading) {
  return CircularProgressIndicator();  // ← Conditional widget
}
if (state.errorMessage != null) {
  return ErrorWidget(state.errorMessage); // ← Conditional widget
}
```

**Test:**
```dart
// Test loading state
testWidgets('loading_indicator_shows', (tester) async {
  // Trigger loading
  cubit.login();
  await tester.pump();

  expect(find.byType(CircularProgressIndicator), findsOne); // ✓
});

// Test error state
testWidgets('error_widget_shows', (tester) async {
  // Trigger error
  cubit.emitError();
  await tester.pump();

  expect(find.byType(ErrorWidget), findsOne); // ✓
});
```

**เป้าหมาย:** 100% conditional widgets ต้องถูก test

---

### 2. User Flow Coverage (ความครอบคลุม User Flows)

#### 2.1 Happy Path Coverage
**วัดอะไร:** Test สถานการณ์ที่ user ทำถูกต้อง

**ตัวอย่าง Flow:**
```
1. เปิดหน้า Login
2. กรอก email ถูกต้อง
3. กรอก password ถูกต้อง
4. กด Submit
5. เห็น Success message
6. Navigate ไป Home
```

**Test:**
```dart
testWidgets('login_happy_path', (tester) async {
  await tester.pumpWidget(LoginPage());

  // Step 1: Page loaded
  expect(find.text('Login'), findsOne);

  // Step 2-3: Enter valid data
  await tester.enterText(find.byKey(Key('email')), 'user@test.com');
  await tester.enterText(find.byKey(Key('password')), 'password123');

  // Step 4: Submit
  await tester.tap(find.byKey(Key('submit')));
  await tester.pumpAndSettle();

  // Step 5: Success message
  expect(find.text('Login successful'), findsOne);

  // Step 6: Navigation
  expect(find.byType(HomePage), findsOne);
});
```

**เป้าหมาย:** Test ทุก happy path (แต่ละ feature อย่างน้อย 1 test)

---

#### 2.2 Error Path Coverage
**วัดอะไร:** Test สถานการณ์ที่เกิด errors

**ตัวอย่าง Error Scenarios:**
```
1. Empty email → "Email required"
2. Invalid email → "Invalid email format"
3. Empty password → "Password required"
4. Wrong password → "Invalid credentials"
5. Network error → "Network error occurred"
```

**Test:**
```dart
testWidgets('login_empty_email_error', (tester) async {
  await tester.pumpWidget(LoginPage());

  // Leave email empty, tap submit
  await tester.tap(find.byKey(Key('submit')));
  await tester.pump();

  // Should show error
  expect(find.text('Email required'), findsOne); // ✓
});

testWidgets('login_invalid_email_error', (tester) async {
  await tester.enterText(find.byKey(Key('email')), 'notanemail');
  await tester.tap(find.byKey(Key('submit')));
  await tester.pump();

  expect(find.text('Invalid email format'), findsOne); // ✓
});
```

**คำนวณ:**
```
Error Path Coverage = (Error Scenarios Tested / Total Error Scenarios) × 100
                    = (5 / 5) × 100 = 100% ✅
```

**เป้าหมาย:** ≥ 80% error scenarios

---

#### 2.3 Edge Case Coverage
**วัดอะไร:** Test กรณีพิเศษ/ขอบเขต

**ตัวอย่าง Edge Cases:**

| Field | Edge Cases |
|-------|------------|
| **Text Input** | Empty, Max length, Special chars, Emoji |
| **Number Input** | 0, Negative, Max value, Decimal |
| **Dropdown** | First option, Last option, Default |
| **Date Picker** | Today, Past, Future, Min/Max date |

**Test:**
```dart
testWidgets('firstname_max_length_edge_case', (tester) async {
  // Test max length = 50
  final maxLengthText = 'A' * 50;
  await tester.enterText(find.byKey(Key('firstname')), maxLengthText);

  expect(find.text(maxLengthText), findsOne); // ✓ Accepts exactly 50

  // Test max length + 1
  final tooLongText = 'A' * 51;
  await tester.enterText(find.byKey(Key('firstname')), tooLongText);

  // Should be truncated to 50
  final actualText = tester.widget<TextField>(find.byKey(Key('firstname'))).controller!.text;
  expect(actualText.length, equals(50)); // ✓
});
```

**เป้าหมาย:** Test อย่างน้อย 2-3 edge cases per field

---

### 3. Interaction Coverage (ความครอบคลุม User Interactions)

#### 3.1 Input Interactions
**วัดอะไร:** Test user input actions

**Actions to Test:**

| Widget | Interactions |
|--------|--------------|
| TextField | enterText, clear, paste |
| Button | tap, long press, disabled |
| Checkbox | check, uncheck |
| Radio | select different options |
| Dropdown | open, select, close |
| Slider | drag, setValue |

**ตัวอย่าง:**
```dart
testWidgets('textfield_interactions', (tester) async {
  // 1. Enter text
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  expect(find.text('test@test.com'), findsOne);

  // 2. Clear text
  await tester.enterText(find.byKey(Key('email')), '');
  expect(find.text(''), findsWidgets);

  // 3. Focus
  await tester.tap(find.byKey(Key('email')));
  await tester.pump();
  // Check if focused (keyboard shown, cursor visible)
});
```

**เป้าหมาย:** Test ทุก interaction ที่สำคัญ

---

#### 3.2 Navigation Interactions
**วัดอะไร:** Test การเปลี่ยนหน้า

**ตัวอย่าง:**
```dart
testWidgets('navigation_to_register', (tester) async {
  await tester.pumpWidget(LoginPage());

  // Tap "Register" link
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();

  // Should navigate to RegisterPage
  expect(find.byType(RegisterPage), findsOne); // ✓
});

testWidgets('back_navigation', (tester) async {
  // Navigate to detail page
  await tester.tap(find.text('View Details'));
  await tester.pumpAndSettle();

  // Tap back button
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Should return to previous page
  expect(find.byType(HomePage), findsOne); // ✓
});
```

---

#### 3.3 Dialog & Overlay Interactions
**วัดอะไร:** Test popup dialogs, snackbars, bottom sheets

**ตัวอย่าง:**
```dart
testWidgets('confirmation_dialog_shows', (tester) async {
  // Trigger dialog
  await tester.tap(find.byKey(Key('delete_button')));
  await tester.pumpAndSettle();

  // Dialog should appear
  expect(find.byType(AlertDialog), findsOne);
  expect(find.text('Are you sure?'), findsOne);

  // Tap confirm
  await tester.tap(find.text('Confirm'));
  await tester.pumpAndSettle();

  // Dialog should close
  expect(find.byType(AlertDialog), findsNothing);
});
```

---

### 4. Assertion Quality Metrics

#### 4.1 Visual Assertion Coverage
**วัดอะไร:** ตรวจสอบ UI elements ที่มองเห็น

**Types of Visual Assertions:**

```dart
// 1. Text visibility
expect(find.text('Welcome'), findsOne);

// 2. Widget existence
expect(find.byKey(Key('submit_button')), findsOne);

// 3. Widget type
expect(find.byType(CircularProgressIndicator), findsOne);

// 4. Widget count
expect(find.byType(ListTile), findsNWidgets(5));

// 5. Icon visibility
expect(find.byIcon(Icons.check), findsOne);

// 6. Image visibility
expect(find.byType(Image), findsOne);
```

**เป้าหมาย:** อย่างน้อย 3 visual assertions per test

---

#### 4.2 State Assertion Coverage
**วัดอะไร:** ตรวจสอบ internal state

**ตัวอย่าง:**
```dart
testWidgets('cubit_state_assertions', (tester) async {
  final cubit = LoginCubit();

  await tester.pumpWidget(
    BlocProvider.value(
      value: cubit,
      child: LoginPage(),
    ),
  );

  // Assert initial state
  expect(cubit.state.status, equals(LoginStatus.initial)); // ✓

  // Trigger action
  await tester.tap(find.byKey(Key('submit')));
  await tester.pump();

  // Assert loading state
  expect(cubit.state.status, equals(LoginStatus.loading)); // ✓

  await tester.pumpAndSettle();

  // Assert final state
  expect(cubit.state.status, equals(LoginStatus.success)); // ✓
});
```

---

#### 4.3 Behavior Assertion Coverage
**วัดอะไร:** ตรวจสอบพฤติกรรม (side effects)

**ตัวอย่าง:**
```dart
testWidgets('snackbar_shows_on_success', (tester) async {
  await tester.pumpWidget(MyApp());

  // Trigger action
  await tester.tap(find.byKey(Key('submit')));
  await tester.pumpAndSettle();

  // Assert snackbar appeared
  expect(find.byType(SnackBar), findsOne);
  expect(find.text('Success!'), findsOne);
});

testWidgets('api_called_with_correct_data', (tester) async {
  final mockApi = MockApiService();

  // ... setup

  await tester.tap(find.byKey(Key('submit')));
  await tester.pumpAndSettle();

  // Verify API was called
  verify(mockApi.login(email: 'test@test.com', password: 'pass')).called(1);
});
```

---

## 📈 วิธีวัด UI Test Metrics

### 1. Widget Coverage Checklist

สร้าง checklist ของ widgets ทั้งหมด:

```markdown
## Widget Coverage Checklist: customer_details_page.dart

### Form Widgets
- [x] Title Dropdown (customer_01)
- [x] FirstName TextField (customer_02)
- [x] Phone TextField (customer_03)
- [x] LastName TextField (customer_04)
- [x] Age Radio Group (customer_05)
  - [x] Age 10-20 option
  - [x] Age 30-40 option
  - [x] Age 40-50 option
- [x] Terms Checkbox (customer_06)
- [x] Newsletter Checkbox (customer_07)
- [x] Submit Button

### Conditional Widgets
- [x] Loading Spinner (when submitting)
- [x] Error Messages (validation errors)
- [x] Success Message (after submit)

**Coverage: 14/14 widgets = 100% ✅**
```

---

### 2. User Flow Coverage Matrix

| Flow | Tested? | Test Name |
|------|---------|-----------|
| **Happy Paths** |||
| Valid form → Success | ✅ | valid_only_cases_1 |
| All fields filled → Submit | ✅ | valid_only_cases_2 |
| **Error Paths** |||
| Empty email → Error | ✅ | pairwise_invalid_1 |
| Invalid phone → Error | ✅ | pairwise_invalid_2 |
| Terms unchecked → Block submit | ✅ | pairwise_invalid_3 |
| **Edge Cases** |||
| Max length input | ❌ | (missing) |
| Special characters | ❌ | (missing) |

**Coverage: 5/7 scenarios = 71% ⚠️**

---

### 3. Assertion Density

```bash
# Count assertions per test
grep -A 50 "testWidgets(" test_file.dart | grep -c "expect("

# Calculate density
Total assertions: 36
Total tests: 12
Assertion Density = 36/12 = 3.0 assertions/test ✅
```

---

## 🎯 UI Testing Quality Gates

### Minimum Requirements
```
✅ Widget Coverage ≥ 90%
✅ Happy Path Coverage = 100%
✅ Error Path Coverage ≥ 70%
✅ Assertion Density ≥ 2
✅ All tests pass
✅ No flaky tests
```

### Recommended
```
✅ Widget Coverage = 100%
✅ Error Path Coverage ≥ 80%
✅ Edge Case Coverage ≥ 50%
✅ Assertion Density ≥ 3
✅ Test execution < 30s
```

### Excellent
```
✅ All metrics at 100%
✅ Edge Case Coverage ≥ 80%
✅ Assertion Density ≥ 4
✅ Test execution < 20s
✅ Visual regression tests
```

---

## 📊 UI Test Report Template

```markdown
# UI Test Report: customer_details_page

**Date:** 2026-01-05
**Tester:** Developer Name

## Widget Coverage
- Total Widgets: 14
- Tested Widgets: 14
- **Coverage: 100% ✅**

## User Flow Coverage
| Category | Tested | Total | Coverage |
|----------|--------|-------|----------|
| Happy Paths | 2 | 2 | 100% ✅ |
| Error Paths | 6 | 8 | 75% ⚠️ |
| Edge Cases | 0 | 4 | 0% ❌ |

## Interaction Coverage
- Input interactions: 100% ✅
- Navigation: 100% ✅
- Dialogs: N/A

## Assertion Quality
- Total Assertions: 36
- Visual Assertions: 28
- State Assertions: 6
- Behavior Assertions: 2
- **Assertion Density: 3.0/test ✅**

## Test Execution
- Total Tests: 12
- Passed: 12
- Failed: 0
- **Execution Time: 14.5s ✅**

## Recommendations
1. ❌ Add edge case tests (max length, special chars)
2. ⚠️ Add missing error path tests
3. ✅ Widget coverage is excellent
```

---

## 🔍 Best Practices

### DO ✅
- Test user-visible behavior (not implementation)
- Use meaningful assertions
- Test all widget states
- Cover happy + error paths
- Test edge cases
- Keep tests fast (<1s each)

### DON'T ❌
- Test private methods
- Hardcode delays (`Future.delayed`)
- Ignore flaky tests
- Skip error scenarios
- Over-assert (test too many details)

---

## Summary

**UI Testing Metrics สำคัญที่สุด:**

1. **Widget Coverage** → ทุก widget ถูก render และ test
2. **User Flow Coverage** → Happy + Error paths ครบ
3. **Interaction Coverage** → Test ทุก user action
4. **Assertion Quality** → Meaningful และเพียงพอ

**เป้าหมายหลัก:**
- Widget Coverage ≥ 90%
- Happy Path = 100%
- Error Path ≥ 80%
- Assertion Density ≥ 3

**สิ่งที่ `flutter_test_gen` ช่วยได้:**
- ✅ Widget Coverage (auto-generates tests for all widgets)
- ✅ Happy Path (valid_only cases)
- ✅ Error Path (pairwise_invalid cases)
- ✅ Assertions (auto-generates relevant assertions)

**สิ่งที่ developer ต้องเพิ่มเอง:**
- ❌ Edge cases (complex scenarios)
- ❌ Custom business logic tests
- ❌ Visual regression tests
- ❌ Performance tests

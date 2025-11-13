# Naming Conventions - Widget Key Guidelines

## Overview

Widget keys are **critical** for manifest extraction and test generation. This document defines the naming conventions and explains how keys impact the automated testing pipeline.

---

## 🔑 Why Keys Matter

### Impact on Manifest Extraction

| **With Key** | **Without Key** |
|--------------|-----------------|
| ✅ Manifest includes `"key"` field | ❌ No `"key"` field in manifest |
| ✅ Text widgets get `displayBinding` | ❌ No `displayBinding` extraction |
| ✅ Precise test targeting via `find.byKey()` | ❌ Ambiguous targeting via `find.byType()` |
| ✅ Clear widget identification in test plans | ❌ Cannot distinguish multiple widgets of same type |

### Example: Text Widget with State Binding

**With Key:**
```dart
Text(
  key: const Key('username_display'),
  'Username: ${state.username}',
)
```
**Manifest Output:**
```json
{
  "widgetType": "Text",
  "key": "username_display",
  "displayBinding": {
    "key": "username_display",
    "stateField": "username"
  }
}
```

**Without Key:**
```dart
Text('Username: ${state.username}')
```
**Manifest Output:**
```json
{
  "widgetType": "Text",
  "textLiteral": "Username: "
}
```
⚠️ **Lost Information:** No `displayBinding` extracted, cannot verify state updates in tests!

---

## Widget Key Naming Pattern

### Format: `{page}_{descriptor}_{type}`

- **page**: Page/feature name (e.g., `login`, `register`, `dashboard`)
- **descriptor**: Semantic name or purpose (e.g., `username`, `submit`, `cancel`)
- **type**: Widget type identifier (e.g., `textfield`, `button`, `radio`)

### Examples:

#### TextFormField Keys
- `buttons_textfield` - หลัก username field
- `buttons_1_textfield` - รอง password field  
- Pattern: `{page}_{index?}_textfield`

#### Radio Group Keys
- `buttons_radio2_group` - Radio group ที่ 2 (approve/reject/pending)
- `buttons_radio3_group` - Radio group ที่ 3 (manu/che)  
- `buttons_radio4_group` - Radio group ที่ 4 (android/window/ios)
- Pattern: `{page}_radio{n}_group`

#### Individual Radio Keys
- `buttons_approve_radio` - Yes option (value=1)
- `buttons_reject_radio` - No option (value=0)
- `buttons_pending_radio` - Pending option (value=0)
- `buttons_manu_radio` - Manual option (value=1)
- `buttons_che_radio` - Check option (value=0)
- `buttons_android_radio` - Android option (value=1)
- `buttons_window_radio` - Windows option (value=0)
- `buttons_ios_radio` - iOS option (value=0)
- Pattern: `{page}_{option}_radio`

#### Dropdown Keys
- `buttons_dropdown` - Dropdown with items: Apple, Banana, Cherry
- Pattern: `{page}_dropdown`

#### Button Keys
- `buttons_endapi_button` - Main API call button
- Pattern: `{page}_{action}_button`

#### Status Keys (BlocListener)
- `buttons_status_200` - Success dialog key
- `buttons_status_400` - Error 400 dialog key
- `buttons_status_500` - Error 500 dialog key
- Pattern: `{page}_status_{code}`

---

## 📋 Supported Key Formats

The manifest extraction script supports the following key formats:

### Basic Key Constructors
```dart
// ✅ Supported - Simple Key
key: const Key('my_widget')
key: Key('my_widget')

// ✅ Supported - ValueKey with type
key: const ValueKey<String>('my_widget')
key: ValueKey('my_widget')

// ✅ Supported - ObjectKey with array
key: const ObjectKey(['my_widget'])
```

### String Interpolation
```dart
// ✅ Supported - const variable interpolation
const baseName = 'register';
key: const Key('${baseName}_username_textfield')
// → Extracted as: "register_username_textfield"

// ✅ Supported - template with const
const prefix = 'login';
key: Key('${prefix}_button')
// → Extracted as: "login_button"
```

### ❌ Unsupported Formats
```dart
// ❌ Dynamic/runtime keys (cannot extract at static analysis time)
key: Key('${widget.id}_button')
key: ValueKey(controller.text)
key: ObjectKey(user)

// ❌ Computed keys
key: Key('item_${index}')  // index is runtime variable
```

---

## 🎯 Key Requirements by Widget Type

### Required Keys (High Priority)

These widgets **MUST** have keys for proper manifest extraction:

| Widget Type | Reason | Example |
|-------------|--------|---------|
| **TextFormField** | Test input entry, validation | `key: Key('username_textfield')` |
| **FormField** | Custom form fields with validation | `key: Key('age_group_formfield')` |
| **Radio** | Individual radio button selection | `key: Key('gender_male_radio')` |
| **ElevatedButton** | Action triggering in tests | `key: Key('submit_button')` |
| **DropdownButtonFormField** | Selection testing | `key: Key('country_dropdown')` |
| **Text** (with state) | Verify state display updates | `key: Key('status_text')` |

### Recommended Keys (Medium Priority)

| Widget Type | Reason | Example |
|-------------|--------|---------|
| **Checkbox** | Boolean state verification | `key: Key('terms_checkbox')` |
| **Switch** | Toggle state testing | `key: Key('notifications_switch')` |
| **IconButton** | Toolbar/action button testing | `key: Key('delete_icon_button')` |
| **TextButton** | Secondary actions | `key: Key('cancel_button')` |

### Optional Keys (Low Priority)

| Widget Type | When to Use |
|-------------|-------------|
| **Text** (static) | Only if referenced in assertions |
| **Icon** | Rarely needed |
| **Container** | Only if tested for presence/visibility |

---

## 💡 Best Practices

### 1. **Consistent Naming Structure**
```dart
// ✅ Good: Consistent pattern
key: const Key('login_username_textfield')
key: const Key('login_password_textfield')
key: const Key('login_submit_button')

// ❌ Bad: Inconsistent pattern
key: const Key('usernamefield')
key: const Key('pwd_input')
key: const Key('btnSubmit')
```

### 2. **Semantic Over Generic**
```dart
// ✅ Good: Semantic naming
key: const Key('profile_edit_button')
key: const Key('order_cancel_button')

// ❌ Bad: Generic naming
key: const Key('button1')
key: const Key('btn_2')
```

### 3. **Always Use `const` When Possible**
```dart
// ✅ Good: Compile-time constant
key: const Key('submit_button')

// ⚠️ Acceptable but not optimal
key: Key('submit_button')
```

### 4. **Group Related Keys with Prefixes**
```dart
// Radio group example
key: const Key('gender_male_radio')
key: const Key('gender_female_radio')
key: const Key('gender_other_radio')

// Form field example
key: const Key('address_street_textfield')
key: const Key('address_city_textfield')
key: const Key('address_zipcode_textfield')
```

### 5. **Status/Response Keys Pattern**
```dart
// Dialog/response keys follow HTTP status codes
key: const Key('register_status_200')  // Success
key: const Key('register_status_400')  // Bad Request
key: const Key('register_status_401')  // Unauthorized
key: const Key('register_status_500')  // Server Error
```

---

## ⚠️ Common Pitfalls

### 1. **Missing Keys on Form Fields**
```dart
// ❌ Problem: Cannot distinguish multiple TextFormFields
TextFormField(decoration: InputDecoration(labelText: 'Username'))
TextFormField(decoration: InputDecoration(labelText: 'Password'))
TextFormField(decoration: InputDecoration(labelText: 'Email'))

// ✅ Solution: Add unique keys
TextFormField(
  key: const Key('register_username_textfield'),
  decoration: InputDecoration(labelText: 'Username'),
)
TextFormField(
  key: const Key('register_password_textfield'),
  decoration: InputDecoration(labelText: 'Password'),
)
TextFormField(
  key: const Key('register_email_textfield'),
  decoration: InputDecoration(labelText: 'Email'),
)
```

### 2. **Missing Keys on State-Bound Text Widgets**
```dart
// ❌ Problem: displayBinding not extracted
Text('Count: ${state.count}')

// ✅ Solution: Add key for state tracking
Text(
  key: const Key('counter_display'),
  'Count: ${state.count}',
)
```

### 3. **Duplicate Keys**
```dart
// ❌ Problem: Same key on multiple widgets
ElevatedButton(key: const Key('button'), ...)
TextButton(key: const Key('button'), ...)

// ✅ Solution: Unique descriptive keys
ElevatedButton(key: const Key('submit_button'), ...)
TextButton(key: const Key('cancel_button'), ...)
```

---

## State Management (BLoC/Cubit)

### Event Methods
- `onTextChanged(String value)` - TextFormField change handler
- `onOptionSelected(int value)` - Radio button selection handler
- `onEndButton()` - Final submit/API call handler

### State Patterns
- Success state: `response.code == 200`
- Client error: `exception.code == 400` 
- Server error: `exception.code == 500`

### BlocListener Response Handling
```dart
BlocListener<ButtonsCubit, ButtonsState>(
  listener: (context, state) {
    if (state.response?.code == 200) {
      // Show success dialog with key: buttons_status_200
    } else if (state.exception?.code == 400) {
      // Show error dialog with key: buttons_status_400  
    } else if (state.exception?.code == 500) {
      // Show error dialog with key: buttons_status_500
    }
  }
)
```

## Validation Patterns

### TextFormField Validators
- **Required validation**: "Required" message
- **Length limits**: maxLength property + lengthLimit formatter
- **Character patterns**: RegExp formatters (e.g., `[a-zA-Z0-9]`)

### Radio Group Validators  
- **Selection required**: "กรุณาเลือกตัวเลือก" message
- **Value binding**: `field.value` for group selection

### Dropdown Validators
- **Selection required**: "กรุณาเลือกค่าใน dropdown" message
- **Items**: Predefined list in `options` array

## Meta Information

### TextFormField Meta
```json
{
  "maxLength": 10,
  "inputFormatters": [
    {"type": "allow", "pattern": "[a-zA-Z0-9]"},
    {"type": "lengthLimit", "max": 10}
  ],
  "validator": true,
  "validatorMessages": ["Required"],
  "hints": ["nonEmpty"]
}
```

### Radio Meta
```json
{
  "valueExpr": "1",           // 1 = Yes, 0 = No
  "groupValueBinding": "field.value"
}
```

### Dropdown Meta  
```json
{
  "validator": true,
  "validatorMessages": ["กรุณาเลือกค่าใน dropdown"],
  "itemsCount": 3,
  "hasValue": true,
  "options": ["Apple", "Banana", "Cherry"]
}
```

## Test Generation Patterns

### Factor Detection Rules
1. **TextFormFields** → Boundary values: `min`, `min+1`, `nominal`, `max-1`, `max`
2. **Radio Groups** → All combinations of options per group
3. **Dropdowns** → All available items
4. **API Outcomes** → Success/400/500 (excluded from pairwise)

### Test Case Naming
- Test functions: `testWidgets('Test case {n}: {description}', ...)`
- Factor combinations: Generated based on pairwise algorithm
- Expected coverage: 100% pair coverage with ~89% test case reduction

### Generated Test Structure
```dart
testWidgets('Test case 1: min TEXT, approve RADIO2, manu RADIO3, android RADIO4, Apple DROPDOWN', (tester) async {
  // Test implementation with factor combinations
});
```

## File Structure Patterns

### IR Generation
- Input: `lib/demos/{page}_page.dart`
- Output: `test_ir/actions/{page}_page.ir.json`

### Test Plans  
- Input: IR JSON + Strategy (pairwise/full-flow)
- Output: `test_data/{page}_page.testdata.json`

### Generated Tests
- Input: Test plan JSON  
- Output: `test/generated/{page}_page_flow_test.dart`

## Command Patterns

### IR Generation
```bash
dart run tools/ir_action_lister.dart lib/demos/{page}_page.dart
```

### Test Plan Generation
```bash
# Pairwise strategy
dart run tools/script_v2/generate_test_data.dart --pairwise-merge

# Full-flow strategy
dart run tools/script_v2/generate_test_data.dart
```

### Test Generation
```bash
dart run tools/script_v2/generate_test_script.dart
```

### Test Execution
```bash
flutter test test/generated/
```

---

## 📚 Quick Reference Guide

### Key Checklist for New Pages

When creating a new page, ensure keys are added for:

- [ ] All `TextFormField` widgets
- [ ] All `FormField<T>` custom form fields
- [ ] All `Radio` buttons (individual + group if using FormField)
- [ ] All `DropdownButtonFormField` / `DropdownButton` widgets
- [ ] All primary action buttons (`ElevatedButton`, `TextButton`, `OutlinedButton`)
- [ ] All `Checkbox` / `Switch` widgets
- [ ] All `Text` widgets that display state values (e.g., `${state.count}`)
- [ ] Status/dialog Text widgets shown in `BlocListener`
- [ ] Navigation target pages (e.g., next page after success)

### Key Naming Quick Reference

| Widget | Pattern | Example |
|--------|---------|---------|
| TextFormField | `{page}_{field}_textfield` | `login_username_textfield` |
| FormField | `{page}_{field}_formfield` | `profile_gender_formfield` |
| Radio (individual) | `{page}_{option}_radio` | `survey_agree_radio` |
| Radio (group) | `{page}_{group}_group` | `survey_opinion_group` |
| DropdownButtonFormField | `{page}_{field}_dropdown` | `order_country_dropdown` |
| ElevatedButton | `{page}_{action}_button` | `checkout_submit_button` |
| TextButton | `{page}_{action}_button` | `form_cancel_button` |
| IconButton | `{page}_{action}_icon_button` | `profile_edit_icon_button` |
| Checkbox | `{page}_{field}_checkbox` | `terms_accept_checkbox` |
| Switch | `{page}_{field}_switch` | `settings_notifications_switch` |
| Text (state) | `{page}_{purpose}_text` | `dashboard_counter_text` |
| Status dialog | `{page}_status_{code}` | `login_status_401` |

### Manifest Extraction Impact Summary

```
┌─────────────────────────────────────────────────────────────┐
│ Widget Has Key?                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  YES → ✅ Full manifest extraction                         │
│        ✅ displayBinding for state-bound Text              │
│        ✅ Precise test targeting                           │
│        ✅ Clear test plan generation                       │
│                                                             │
│  NO  → ❌ Limited manifest data                            │
│        ❌ No displayBinding                                │
│        ❌ Ambiguous test targeting                         │
│        ❌ Cannot distinguish multiple widgets              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Example: Complete Form with Keys

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ✅ TextFormField with key
            TextFormField(
              key: const Key('login_username_textfield'),
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),

            // ✅ TextFormField with key
            TextFormField(
              key: const Key('login_password_textfield'),
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),

            // ✅ Checkbox with key
            CheckboxListTile(
              key: const Key('login_remember_checkbox'),
              title: const Text('Remember me'),
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
            ),

            // ✅ Button with key
            ElevatedButton(
              key: const Key('login_submit_button'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _cubit.login();
                }
              },
              child: const Text('Login'),
            ),

            // ✅ State-bound Text with key
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) => Text(
                key: const Key('login_status_text'),
                'Status: ${state.status}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Resulting Manifest:** All widgets properly identified with keys, state bindings extracted, ready for test generation.

---

## 🔗 Related Documentation

- [CLAUDE.md](./CLAUDE.md) - Project overview and development commands
- [tools/script_v2/extract_ui_manifest.dart](./tools/script_v2/extract_ui_manifest.dart) - Manifest extraction script
- [tools/script_v2/generate_test_data.dart](./tools/script_v2/generate_test_data.dart) - Test plan generation
- [tools/script_v2/generate_test_script.dart](./tools/script_v2/generate_test_script.dart) - Test script generation

---

**Last Updated:** 2025-01-07
**Version:** 2.0
**Scope:** All pages in `lib/` following `*_page.dart` pattern
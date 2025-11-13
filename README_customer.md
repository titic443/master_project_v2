# Customer Details Form Layout Snapshot

```text
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/customer_cubit.dart';
import 'package:master_project/cubit/customer_state.dart';
import 'package:master_project/demos/customer_details_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('customer_details_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'J');
        await tester.pump();
        // dataset: byKey.customer_03_lastname_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('customer_03_lastname_textfield')), 'Smith');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_04_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_04_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_05_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_end_button')));
        await tester.tap(find.byKey(const Key('customer_07_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
```

## Form Elements and Keys

### 1. Title Dropdown
- **Key**: `customer_title_dropdown`
- **Type**: `DropdownButtonFormField<String>`
- **Options**: Mr., Mrs., Ms., Dr.
- **Cubit Method**: `onTitleChanged(String?)`
- **Validator**: Required (must select a title)

### 2. First Name TextFormField
- **Key**: `customer_firstname_textfield`
- **Type**: `TextFormField`
- **Input Formatters**: Only letters (a-zA-Z), max 50 characters
- **Cubit Method**: `onFirstNameChanged(String)`
- **Validator**: Regex `^[a-zA-Z]{2,}$` - Only letters, minimum 2 characters

### 3. Last Name TextFormField
- **Key**: `customer_lastname_textfield`
- **Type**: `TextFormField`
- **Input Formatters**: Only letters (a-zA-Z), max 50 characters
- **Cubit Method**: `onLastNameChanged(String)`
- **Validator**: Regex `^[a-zA-Z]{2,}$` - Only letters, minimum 2 characters

### 4. Age Range FormField
- **Key**: `customer_age_range_formfield`
- **Type**: `FormField<int>` with Radio buttons
- **Radio Keys**:
  - `customer_age_10_20_radio` (value: 1)
  - `customer_age_30_40_radio` (value: 2)
  - `customer_age_40_50_radio` (value: 3)
- **Cubit Method**: `onAgeRangeSelected(int)`
- **Validator**: Required (must select an age range)

### 5. Agree to Terms FormField
- **Key**: `customer_agree_terms_formfield`
- **Checkbox Key**: `customer_agree_terms_checkbox`
- **Type**: `FormField<bool>` with Checkbox
- **Cubit Method**: `onAgreeToTermsChanged(bool)`
- **Validator**: Required (must be true)

### 6. Subscribe Newsletter Checkbox
- **Key**: `customer_subscribe_newsletter_checkbox`
- **Type**: `Checkbox` (optional, no FormField wrapper)
- **Cubit Method**: `onSubscribeNewsletterChanged(bool)`
- **Validator**: None (optional field)

### 7. Submit Button
- **Key**: `customer_submit_button`
- **Type**: `ElevatedButton`
- **Action**: Validates form and calls `submitCustomerDetails()`
- **Disabled**: When loading state is active

## Validation Rules

### Text Fields (First Name & Last Name)
- **Pattern**: `^[a-zA-Z]{2,}$`
- **Rules**:
  - Only alphabetic characters (a-z, A-Z)
  - Minimum 2 characters
  - Maximum 50 characters (enforced by input formatter)
- **Error Message**: "First/Last name must contain only letters (minimum 2 characters)"

### Dropdown & FormFields
- All required fields show appropriate error messages when not filled
- Validation triggers on form submission

## State Management

### CustomerCubit Methods
- `onTitleChanged(String? value)`
- `onFirstNameChanged(String value)`
- `onLastNameChanged(String value)`
- `onAgeRangeSelected(int value)`
- `onAgreeToTermsChanged(bool value)`
- `onSubscribeNewsletterChanged(bool value)`
- `submitCustomerDetails()`

### Status Feedback
- **Success**: Shows green SnackBar with key `customer_status_200`
- **Error**: Shows red SnackBar with key `customer_status_error`

---

## Manifest JSON Structure

The manifest file (`customer_details_page.manifest.json`) is generated by running:
```bash
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_page.dart
```

### Example Structure (Updated)

```json
{
  "source": {
    "file": "lib/demos/customer_details_page.dart",
    "pageClass": "CustomerDetailsPage",
    "cubitClass": "CustomerCubit",
    "stateClass": "CustomerState"
  },
  "widgets": [
    {
      "widgetType": "DropdownButtonFormField<String>",
      "key": "customer_title_dropdown",
      "actions": [
        {
          "event": "onChanged",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onTitleChanged"
            }
          ]
        }
      ],
      "meta": {
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Please select a title"
          }
        ],
        "itemsCount": 4,
        "hasValue": true,
        "options": [
          {"value": "Mr.", "text": "Mr."},
          {"value": "Mrs.", "text": "Mrs."},
          {"value": "Ms.", "text": "Ms."},
          {"value": "Dr.", "text": "Dr."}
        ]
      }
    },
    {
      "widgetType": "TextFormField",
      "key": "customer_firstname_textfield",
      "actions": [
        {
          "event": "onChanged",
          "argType": "String",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onFirstNameChanged"
            }
          ]
        }
      ],
      "meta": {
        "inputFormatters": [
          {
            "type": "allow",
            "pattern": "[a-zA-Z]"
          },
          {
            "type": "lengthLimit",
            "max": 50
          }
        ],
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "First name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
            "message": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    },
    {
      "widgetType": "TextFormField",
      "key": "customer_lastname_textfield",
      "actions": [
        {
          "event": "onChanged",
          "argType": "String",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onLastNameChanged"
            }
          ]
        }
      ],
      "meta": {
        "inputFormatters": [
          {
            "type": "allow",
            "pattern": "[a-zA-Z]"
          },
          {
            "type": "lengthLimit",
            "max": 50
          }
        ],
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Last name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
            "message": "Last name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    },
    {
      "widgetType": "FormField<int>",
      "key": "customer_age_range_formfield",
      "actions": [
        {
          "event": "onChanged",
          "calls": [
            {
              "target": "formState",
              "method": "didChange"
            },
            {
              "target": "CustomerCubit",
              "method": "onAgeRangeSelected"
            }
          ]
        }
      ],
      "meta": {
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null",
            "message": "Please select an age range"
          }
        ],
        "options": [
          {
            "key": "customer_age_10_20_radio",
            "value": "1",
            "label": "10-20"
          },
          {
            "key": "customer_age_30_40_radio",
            "value": "2",
            "label": "30-40"
          },
          {
            "key": "customer_age_40_50_radio",
            "value": "3",
            "label": "40-50"
          }
        ]
      }
    },
    {
      "widgetType": "Radio<int>",
      "key": "customer_age_10_20_radio",
      "actions": [
        {
          "event": "onChanged",
          "argType": "int",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onAgeRangeSelected"
            },
            {
              "target": "formState",
              "method": "didChange"
            }
          ]
        }
      ],
      "meta": {
        "valueExpr": "1",
        "groupValueBinding": "state.ageRange"
      }
    },
    {
      "widgetType": "FormField<bool>",
      "key": "customer_agree_terms_formfield",
      "actions": [
        {
          "event": "onChanged",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onAgreeToTermsChanged"
            },
            {
              "target": "formState",
              "method": "didChange"
            }
          ]
        }
      ],
      "meta": {
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || !value",
            "message": "You must agree to terms"
          }
        ]
      }
    },
    {
      "widgetType": "Checkbox",
      "key": "customer_agree_terms_checkbox",
      "actions": [
        {
          "event": "onChanged",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onAgreeToTermsChanged"
            }
          ]
        }
      ],
      "meta": {
        "valueBinding": "state.agreeToTerms"
      }
    },
    {
      "widgetType": "Checkbox",
      "key": "customer_subscribe_newsletter_checkbox",
      "actions": [
        {
          "event": "onChanged",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onSubscribeNewsletterChanged"
            }
          ]
        }
      ],
      "meta": {
        "valueBinding": "state.subscribeNewsletter"
      }
    },
    {
      "widgetType": "ElevatedButton",
      "key": "customer_submit_button",
      "actions": [
        {
          "event": "onPressed",
          "argType": "void",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "submitCustomerDetails"
            }
          ]
        }
      ]
    }
  ]
}
```

### Manifest Structure Explanation

#### Source Section
- **file**: Path to the source Dart file
- **pageClass**: Main widget class name
- **cubitClass**: Cubit class name (auto-detected from BlocBuilder/BlocListener)
- **stateClass**: State class name (auto-detected from BlocBuilder/BlocListener generics)

#### Widgets Section
Each widget entry contains:

**1. Basic Properties:**
- `widgetType`: Widget class name with generics (e.g., `TextFormField`, `Radio<int>`)
- `key`: Unique identifier for testing (extracted from Key/ValueKey)

**2. Actions Array:**
Lists user interaction events:
- `event`: Event name (`onChanged`, `onPressed`, `onTap`, etc.)
- `argType`: Argument type (`String`, `int`, `bool`, `void`)
- `calls`: Methods called in the event handler
  - `target`: Target object (Cubit name, Navigator, etc.)
  - `method`: Method name being called

**3. Meta Object:**
Widget-specific metadata:

**For TextFormField:**
- `inputFormatters`: Array of input restrictions
  - `type`: `allow`, `deny`, `digitsOnly`, `lengthLimit`, etc.
  - `pattern`: Regex pattern (for allow/deny types)
  - `max`: Maximum length (for lengthLimit type)
- `validator`: Boolean indicating presence of validator
- `required`: Boolean indicating if field is required
- `validatorRules`: Array of validation rules
  - `condition`: Dart condition expression
  - `message`: Error message to display

**For DropdownButtonFormField:**
- `itemsCount`: Number of dropdown items
- `hasValue`: Boolean indicating if value is bound
- `options`: Array of dropdown options
  - `value`: Option value
  - `text`: Display text

**For FormField with Radio buttons:**
- `options`: Array of radio options
  - `key`: Radio button key
  - `value`: Radio value
  - `label`: Display label

**For Radio:**
- `valueExpr`: Value expression for this radio button
- `groupValueBinding`: Binding to current selected value (e.g., `state.ageRange`)

**For Checkbox:**
- `valueBinding`: State binding (e.g., `state.agreeToTerms`)

### Usage in Test Generation

This manifest is used by:
1. **`generate_test_data.dart`**: Creates test cases based on validators and options
2. **`generate_test_script.dart`**: Generates Flutter widget tests using keys and expected behaviors
3. **Documentation**: Provides comprehensive UI structure reference

---

## Lean Manifest Structure (Minimal)

For optimal performance and reduced file size, you can use a **lean version** that includes only the fields required for test generation:

### Lean Example

```json
{
  "source": {
    "file": "lib/demos/customer_details_page.dart",
    "pageClass": "CustomerDetailsPage",
    "cubitClass": "CustomerCubit",
    "stateClass": "CustomerState"
  },
  "widgets": [
    {
      "widgetType": "DropdownButtonFormField<String>",
      "key": "customer_title_dropdown",
      "actions": [
        {
          "calls": [
            {"target": "CustomerCubit"}
          ]
        }
      ],
      "meta": {
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Please select a title"
          }
        ],
        "options": [
          {"value": "Mr.", "text": "Mr."},
          {"value": "Mrs.", "text": "Mrs."},
          {"value": "Ms.", "text": "Ms."},
          {"value": "Dr.", "text": "Dr."}
        ]
      }
    },
    {
      "widgetType": "TextFormField",
      "key": "customer_firstname_textfield",
      "actions": [
        {
          "calls": [
            {"target": "CustomerCubit"}
          ]
        }
      ],
      "meta": {
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z]"},
          {"type": "lengthLimit", "max": 50}
        ],
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "First name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
            "message": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    },
    {
      "widgetType": "FormField<int>",
      "key": "customer_age_range_formfield",
      "meta": {
        "validatorRules": [
          {
            "condition": "value == null",
            "message": "Please select an age range"
          }
        ],
        "options": [
          {"key": "customer_age_10_20_radio", "value": "1", "label": "10-20"},
          {"key": "customer_age_30_40_radio", "value": "2", "label": "30-40"},
          {"key": "customer_age_40_50_radio", "value": "3", "label": "40-50"}
        ]
      }
    },
    {
      "widgetType": "Checkbox",
      "key": "customer_agree_terms_checkbox"
    },
    {
      "widgetType": "Checkbox",
      "key": "customer_subscribe_newsletter_checkbox"
    },
    {
      "widgetType": "ElevatedButton",
      "key": "customer_submit_button",
      "actions": [
        {
          "calls": [
            {"target": "CustomerCubit"}
          ]
        }
      ]
    }
  ]
}
```

### Comparison: Full vs Lean

| Field | Full Manifest | Lean Manifest | Used By Tests? |
|-------|---------------|---------------|----------------|
| `source.file` | ✅ | ✅ | **Yes** |
| `source.pageClass` | ✅ | ✅ | **Yes** |
| `source.cubitClass` | ✅ | ✅ | **Yes** (Provider detection) |
| `source.stateClass` | ✅ | ✅ | No (documentation) |
| `widgetType` | ✅ | ✅ | **Yes** |
| `key` | ✅ | ✅ | **Yes** |
| `actions[].event` | ✅ | ❌ | No |
| `actions[].argType` | ✅ | ❌ | No |
| `actions[].calls[].target` | ✅ | ✅ | **Yes** (Cubit detection) |
| `actions[].calls[].method` | ✅ | ❌ | No |
| `meta.inputFormatters` | ✅ | ✅ | **Yes** (maxLength) |
| `meta.validatorRules` | ✅ | ✅ | **Yes** (assertions) |
| `meta.validator` | ✅ | ❌ | No (redundant) |
| `meta.required` | ✅ | ❌ | No (redundant) |
| `meta.options` | ✅ | ✅ | **Yes** (factors) |
| `meta.itemsCount` | ✅ | ❌ | No |
| `meta.hasValue` | ✅ | ❌ | No |
| `meta.valueExpr` | ✅ | ❌ | No |
| `meta.groupValueBinding` | ✅ | ❌ | No |
| `meta.valueBinding` | ✅ | ❌ | No |
| `displayBinding` | ✅ | ❌ | No |
| `textLiteral` | ✅ | ❌ | No |
| `wrappers` | ✅ | ❌ | No |

### Benefits of Lean Manifest

1. **Smaller file size**: ~50-60% reduction
2. **Faster parsing**: Less data to process
3. **Easier maintenance**: Focus on essential fields only
4. **Same test output**: All test generation features work identically

### Fields Required for Test Generation

**Minimum required fields:**
- `source.file`, `source.pageClass`, `source.cubitClass`
- `widgetType`, `key`
- `actions[].calls[].target` (for Cubit detection)
- `meta.inputFormatters` (for maxLength extraction)
- `meta.validatorRules` (for validation error assertions)
- `meta.options` (for Dropdown/Radio factors)

**Optional but recommended:**
- `meta.maxLength` (if not in inputFormatters)
- `meta.keyboardType`, `meta.obscureText` (for documentation)

### Important Notes for Lean Manifest

1. **Radio Groups**: Use `FormField<int>` with `meta.options` containing radio button information. Individual `Radio<int>` widgets are **optional** and not required for test generation.

2. **Dropdown Detection**: `DropdownButtonFormField` widgets are detected by `widgetType` and `meta.options`. The `actions` field is **optional**.

3. **TextFormField**: Must have `actions[].calls[]` with at least one entry to be included in test factors (ensures the field is interactive).

4. **Checkbox Detection**: Checkbox widgets are detected by `widgetType` and `key` only. No additional metadata required for basic test generation.

### Migration from Full to Lean Manifest

To convert existing full manifest to lean version:

**Remove these fields:**
- `source.route` (optional)
- `actions[].event`, `actions[].argType`
- `actions[].calls[].method` (keep only `target`)
- `meta.validator`, `meta.required` (redundant with validatorRules)
- `meta.itemsCount`, `meta.hasValue`
- `meta.valueExpr`, `meta.groupValueBinding`, `meta.valueBinding`
- `displayBinding`, `textLiteral`, `wrappers`
- Individual `Radio<int>` widget entries (if already defined in FormField options)

**Keep these fields:**
- `source.file`, `source.pageClass`, `source.cubitClass`, `source.stateClass`
- `widgetType`, `key`
- `actions[].calls[].target` (only target, not method)
- `meta.inputFormatters`, `meta.validatorRules`, `meta.options`

---

## Google Gemini API Payload Structure

เมื่อมีการเรียกใช้ปัญญาประดิษฐ์เพื่อสร้างข้อมูลทดสอบ ระบบจะสร้างและส่ง payload ไปยัง Google Gemini API ในรูปแบบดังนี้:

### Payload Structure (generate_datasets.dart:366-376)

```dart
final payload = {
  'contents': [
    {
      'role': 'user',
      'parts': [
        {'text': instructions},
        {'text': 'Context (JSON):\n${jsonEncode(context)}'},
      ]
    }
  ]
};
```

### โครงสร้างของ Payload

#### 1. **contents** (Array)
เป็น array ที่เก็บข้อความสนทนาระหว่าง user และ AI โดยแต่ละรายการประกอบด้วย:

#### 2. **role** (String)
ระบุบทบาทของผู้ส่งข้อความ:
- `"user"`: ข้อความจากผู้ใช้ (ในกรณีนี้คือระบบที่ส่ง prompt)
- `"model"`: ข้อความจาก AI (ใช้เมื่อต้องการสร้างบทสนทนาแบบ multi-turn)

#### 3. **parts** (Array)
เป็น array ที่เก็บส่วนต่างๆ ของข้อความ โดยแต่ละส่วนเป็น Object ที่มี key `text`:

**Part 1: Instructions (คำสั่งหลัก)**
```dart
{'text': instructions}
```

เป็นคำสั่งที่อธิบายรายละเอียดว่าต้องการให้ AI ทำอะไร ประกอบด้วย 6 ส่วนหลัก:
- **CONTEXT**: บริบทของงาน (Test data generator for Flutter form validation)
- **TARGET AUDIENCE**: กลุ่มเป้าหมาย (QA engineers)
- **OBJECTIVE**: วัตถุประสงค์และขั้นตอนการทำงาน (4 ขั้นตอน)
- **EXECUTION FORMAT**: รูปแบบ JSON ที่ต้องการและกฎการทำงาน
- **OUTPUT STYLE**: รูปแบบการตอบกลับ (JSON only, realistic values)
- **QUALITY REQUIREMENTS & EXAMPLE**: เกณฑ์คุณภาพและตัวอย่างการใช้งาน

**Part 2: Context (ข้อมูลเมตาจาก Manifest)**
```dart
{'text': 'Context (JSON):\n${jsonEncode(context)}'}
```

เป็นข้อมูลเมตาจริงจากไฟล์ manifest ที่ต้องการให้ AI สร้างข้อมูลทดสอบ โดย `context` มีโครงสร้างดังนี้:

```json
{
  "file": "lib/demos/customer_details_page.dart",
  "fields": [
    {
      "key": "customer_firstname_textfield",
      "meta": {
        "maxLength": 50,
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z]"},
          {"type": "lengthLimit", "max": 50}
        ],
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "First name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
            "message": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    }
  ]
}
```

### ตัวอย่าง Payload สมบูรณ์

```json
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "=== CONTEXT ===\nTest data generator for Flutter form validation. Output for widget tests.\n\n=== TARGET AUDIENCE ===\nQA engineers need realistic test data covering happy path and errors.\n\n=== OBJECTIVE ===\nGenerate test datasets for form fields:\n1. Analyze constraints (maxLength, pattern, validatorRules)\n2. Generate valid values passing ALL rules\n3. Generate invalid values violating EACH rule (1:1 mapping)\n4. Output valid JSON matching schema\n\n=== EXECUTION FORMAT ===\nOutput: {\"file\":\"lib/demos/customer_details_page.dart\",\"datasets\":{\"byKey\":{\"<key>\":{\"valid\":[...],\"invalid\":[...]}}}}\n\nRules:\n- Fields WITH rules: valid.length == invalid.length == rule count\n- Fields WITHOUT rules: 1 valid, empty invalid\n- Valid MUST respect maxLength; invalid CAN exceed\n\nGuidelines:\n- username: ≤40 chars (e.g., \"testuser123\")\n- email: ≤25 chars (e.g., \"test@co.com\")\n- password: special chars if pattern allows\n\n=== OUTPUT STYLE ===\n- JSON only (no markdown, no comments)\n- Realistic values (not \"value1\", \"...\")\n- String arrays only\n\n=== QUALITY REQUIREMENTS ===\nVerify:\n1. Valid values satisfy maxLength\n2. Valid values pass all rules\n3. Invalid violates specific rule\n4. Correct array lengths\n\n=== EXAMPLE ===\nInput: {\"key\":\"user\",\"meta\":{\"maxLength\":15,\"validatorRules\":[{\"condition\":\"isEmpty\"},{\"condition\":\"length < 3\"}]}}\nOutput: {\"user\":{\"valid\":[\"abc\",\"test\"],\"invalid\":[\"\",\"ab\"]}}\nWhy: 2 rules → 2 pairs. \"abc\" passes all, \"\" violates isEmpty. \"test\" passes all, \"ab\" violates length<3."
        },
        {
          "text": "Context (JSON):\n{\"file\":\"lib/demos/customer_details_page.dart\",\"fields\":[{\"key\":\"customer_firstname_textfield\",\"meta\":{\"maxLength\":50,\"inputFormatters\":[{\"type\":\"allow\",\"pattern\":\"[a-zA-Z]\"},{\"type\":\"lengthLimit\",\"max\":50}],\"validatorRules\":[{\"condition\":\"value == null || value.isEmpty\",\"message\":\"First name is required\"},{\"condition\":\"!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)\",\"message\":\"First name must contain only letters (minimum 2 characters)\"}]}}]}"
        }
      ]
    }
  ]
}
```

### การส่ง Payload ไปยัง API

Payload ถูกส่งไปยัง Google Gemini API endpoint:

```
POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={apiKey}
```

โดย:
- `{model}`: ชื่อโมเดล เช่น `gemini-2.5-flash`, `gemini-1.5-pro`
- `{apiKey}`: API key สำหรับ authentication

Headers:
```
Content-Type: application/json
```

### ตัวอย่าง Response จาก API

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "{\"file\":\"lib/demos/customer_details_page.dart\",\"datasets\":{\"byKey\":{\"customer_firstname_textfield\":{\"valid\":[\"ab\",\"John\"],\"invalid\":[\"\",\"J\"]}}}}"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP"
    }
  ]
}
```

### การประมวลผล Response

ระบบจะ:
1. **ดึงข้อความจาก response** (`candidates[0].content.parts[0].text`)
2. **ลบ code fences** (ถ้ามี) เช่น ` ```json ... ``` `
3. **แปลง JSON string** เป็น Object
4. **บันทึกลงไฟล์** `output/test_data/<page>.datasets.json`

### สรุปการไหลของข้อมูล

```
Manifest JSON
    ↓
Extract TextFormField metadata
    ↓
Build Payload (instructions + context)
    ↓
POST to Gemini API
    ↓
Receive Response
    ↓
Parse JSON
    ↓
Save to datasets.json
```

### ข้อดีของโครงสร้างแบบ Multi-part

1. **แยกคำสั่งออกจากข้อมูล**: ทำให้ปรับเปลี่ยนคำสั่งได้โดยไม่กระทบข้อมูล
2. **อ่านง่าย**: แยกส่วน instructions และ context ชัดเจน
3. **รองรับการขยาย**: สามารถเพิ่ม parts อื่นๆ ได้ในอนาคต เช่น images, examples
4. **Debugging ง่าย**: สามารถ log แต่ละส่วนแยกกันได้

### Gemini Prompt & Response Example

#### Quick Rule Mapping Example
- **Input**
  ```json
  {"key":"user","meta":{"maxLength":15,"validatorRules":[{"condition":"isEmpty"},{"condition":"length < 3"}]}}
  ```
- **Output**
  ```json
  {"user":{"valid":["abc","test"],"invalid":["","ab"]}}
  ```
- **เหตุผล**
  มี 2 rules จึงต้องได้ผลลัพธ์ 2 คู่: `"abc"` และ `"test"` ผ่านทุก rule, `""` ฝ่าฝืน isEmpty, `"ab"` ฝ่าฝืน length < 3

#### Prompt Payload ที่ส่งให้ Gemini
```text
=== (CONTEXT) ===
Test data generator for Flutter form validation.

=== (TARGET) ===
QA engineers need realistic test data for happy path and errors.

=== (OBJECTIVE) ===
1. Analyze constraints (maxLength, pattern, validatorRules)
2. Generate valid values passing ALL rules
3. Generate invalid values violating EACH rule (1:1 mapping)
4. Output valid JSON

=== (EXECUTION) ===
Step 1: Read maxLength, pattern from meta.inputFormatters; read rules from meta.validatorRules
Step 2: Create valid values that satisfy maxLength, match pattern, pass all rules
Step 3: Create invalid values - one per rule, each violates its specific rule only
Step 4: Format as {"file":"...","datasets":{"byKey":{"<key>":{"valid":[...],"invalid":[...]}}}}

Constraints:
- WITH rules: valid.length == invalid.length == rule count
- WITHOUT rules: 1 valid, empty invalid
- Valid ≤ maxLength; invalid CAN exceed

Example:
Input: {"key":"user","meta":{"maxLength":15,"validatorRules":[{"condition":"isEmpty"},{"condition":"length < 3"}]}}
Output: {"user":{"valid":["abc","test"],"invalid":["","ab"]}}
Explanation: 2 rules → 2 pairs. "abc" passes all, "" violates isEmpty. "test" passes all, "ab" violates length<3.

=== (STYLE) ===
- JSON only (no markdown, no comments)
- Realistic values (not "value1")
- String arrays only
```

#### Context (JSON) ที่แนบไปกับคำขอ
```json
{"file":"lib/demos/customer_details_page.dart","fields":[{"key":"customer_firstname_textfield","meta":{"inputFormatters":[{"type":"allow","pattern":"[a-zA-Z]"},{"type":"lengthLimit","max":50}],"validator":true,"required":true,"validatorRules":[{"condition":"value == null || value.isEmpty","message":"First name is required"},{"condition":"!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)","message":"First name must contain only letters (minimum 2 characters)"}]}},{"key":"customer_lastname_textfield","meta":{"inputFormatters":[{"type":"allow","pattern":"[a-zA-Z]"},{"type":"lengthLimit","max":50}],"validator":true,"required":true,"validatorRules":[{"condition":"value == null || value.isEmpty","message":"Last name is required"},{"condition":"!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)","message":"Last name must contain only letters (minimum 2 characters)"}]}}]}
```

#### ตัวอย่างคำตอบจาก Gemini
```json
{"file":"lib/demos/customer_details_page.dart","datasets":{"byKey":{"customer_firstname_textfield":{"valid":["John","Alice"],"invalid":["","J"]},"customer_lastname_textfield":{"valid":["Doe","Smith"],"invalid":["","S"]}}}}
```

> เคล็ดลับ: เปิดไฟล์ `output/test_data/customer_details_page.datasets.json` เพื่อเปรียบเทียบค่าจริงที่สร้างกับตัวอย่างด้านบน

### ตัวอย่างการใช้งานจริง

```bash
# ตัวอย่างการ run script
dart run tools/script_v2/generate_datasets.dart output/manifest/customer_details_page.manifest.json

# Output
=== datasets_from_ai: PROMPT (model=gemini-2.5-flash) ===
=== CONTEXT ===
Test data generator for Flutter form validation...
[full instructions here]
--- Context (JSON) ---
{"file":"lib/demos/customer_details_page.dart","fields":[...]}
=== end PROMPT ===

=== datasets_from_ai: AI RESPONSE (raw text) ===
{"file":"lib/demos/customer_details_page.dart","datasets":{"byKey":{...}}}
=== end AI RESPONSE ===

  ✓ Generated: output/test_data/customer_details_page.datasets.json
```

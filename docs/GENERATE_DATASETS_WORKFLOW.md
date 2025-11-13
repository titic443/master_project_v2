# Generate Datasets Workflow

## 📖 Overview

`generate_datasets.dart` เป็น script ที่ใช้ **Google Gemini AI** สร้าง test datasets จาก UI manifest โดยอัตโนมัติ

---

## 🔄 Workflow: Script ทำงานยังไง

```
┌─────────────────────────────────────────────────────────────────┐
│                   GENERATE DATASETS WORKFLOW                    │
└─────────────────────────────────────────────────────────────────┘

INPUT: manifest/demos/register_page.manifest.json
  │
  ├─ 1. Read Manifest File
  │    ├─ Extract widgets list
  │    ├─ Filter TextField/TextFormField widgets
  │    └─ Collect metadata (maxLength, validators, patterns)
  │
  ├─ 2. Build AI Prompt
  │    ├─ Create field context (keys + meta)
  │    ├─ Add hard constraints (maxLength, patterns)
  │    └─ Format instructions for JSON output
  │
  ├─ 3. Call Gemini API
  │    ├─ Endpoint: generativelanguage.googleapis.com/v1beta/models
  │    ├─ Model: gemini-1.5-flash (default)
  │    ├─ Send: Manifest context + Instructions
  │    └─ Receive: AI-generated datasets JSON
  │
  ├─ 4. Parse AI Response
  │    ├─ Extract text from Gemini response
  │    ├─ Strip code fences (```json...```)
  │    └─ Parse JSON to Map<String, dynamic>
  │
  ├─ 5. Validate & Merge Data
  │    ├─ Check maxLength constraints
  │    ├─ Filter out invalid values
  │    ├─ Merge with validator rules
  │    └─ Generate fallback if AI data insufficient
  │
  └─ 6. Write Output
       └─ Save to: test_data/register_page.datasets.json

OUTPUT: test_data/register_page.datasets.json
```

---

## 📋 Detailed Step-by-Step

### Step 1: Read Manifest & Extract Fields

```dart
// Read manifest file
final raw = File(manifestPath).readAsStringSync();
final manifest = jsonDecode(raw);
final widgets = manifest['widgets'] ?? [];

// Extract TextField/TextFormField with keys
for (final widget in widgets) {
  if (widget['widgetType'].startsWith('TextField') &&
      widget['key'] != null) {
    fields.add({
      'key': widget['key'],
      'meta': widget['meta'] ?? {}
    });
  }
}
```

**Example Field Extracted:**
```json
{
  "key": "register_username_textfield",
  "meta": {
    "maxLength": 10,
    "inputFormatters": [
      {"type": "allow", "pattern": "[a-zA-Z0-9]"}
    ],
    "validatorRules": [
      {
        "condition": "value == null || value.isEmpty",
        "message": "Required"
      }
    ]
  }
}
```

---

### Step 2: Build AI Prompt

Script สร้าง prompt ส่งให้ Gemini โดยมี 2 ส่วน:

**Part 1: Instructions**
```
Generate test datasets for the given Flutter form fields.
Output strictly valid JSON, no code fences, no comments.
Format:
{"file":"...","datasets":{"byKey":{
  "<fieldKey>": {"valid": ["..."], "invalid": ["..."]], ...
}}}

Critical Rules:
- MUST respect meta.maxLength constraints
- For email_textfield with maxLength=25: generate emails ≤ 25 chars
- Use meta.inputFormatters.pattern for format requirements
- valid/invalid arrays must contain strings only
- Invalid data can exceed maxLength to test validation
```

**Part 2: Context (JSON)**
```json
{
  "file": "lib/register/register_page.dart",
  "fields": [
    {
      "key": "register_username_textfield",
      "meta": {
        "maxLength": 10,
        "inputFormatters": [...]
      }
    },
    {
      "key": "register_email_textfield",
      "meta": {
        "maxLength": 25,
        "keyboardType": "emailAddress"
      }
    }
  ]
}
```

---

### Step 3: Call Gemini API

```dart
final endpoint = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta/models/'
  '$model:generateContent?key=$apiKey'
);

final payload = {
  'contents': [
    {
      'role': 'user',
      'parts': [
        {'text': instructions},
        {'text': 'Context (JSON):\n${jsonEncode(context)}'}
      ]
    }
  ]
};

// Send POST request
final response = await http.post(endpoint, body: jsonEncode(payload));
```

**AI Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "{\n  \"file\": \"lib/register/register_page.dart\",\n  \"datasets\": {\n    \"byKey\": {\n      \"register_username_textfield\": {\n        \"valid\": [\"john123\", \"user456\", \"alice\"],\n        \"invalid\": [\"\", \"a\", \"tooooooooolong\"]\n      },\n      \"register_email_textfield\": {\n        \"valid\": [\"test@co.com\", \"a@b.org\"],\n        \"invalid\": [\"invalid\", \"no@\"]\n      }\n    }\n  }\n}"
          }
        ]
      }
    }
  ]
}
```

---

### Step 4: Parse AI Response

```dart
// Extract text from Gemini response
final text = _extractTextFromGemini(decoded);

// Strip code fences if present
final cleaned = _stripCodeFences(text);
// "```json\n{...}\n```" → "{...}"

// Parse JSON
final parsed = jsonDecode(cleaned);
```

---

### Step 5: Validate & Merge Data

**Validation Rules:**
1. ✅ Check `maxLength` constraints
2. ✅ Filter valid values that exceed limits
3. ✅ Keep invalid values (for testing violations)
4. ✅ Generate fallback if AI data insufficient

```dart
// Get AI data for field
final aiValid = aiEntry['valid'] ?? [];
final aiInvalid = aiEntry['invalid'] ?? [];

// Filter by maxLength
final maxLen = meta['maxLength'] ?? 50;
final validFiltered = aiValid.where((v) => v.length <= maxLen);

// Generate fallback if needed
if (validFiltered.isEmpty) {
  final fallback = _generateValidData(key, constraints);
  validFiltered.add(fallback);
  print('Warning: AI values exceeded maxLength, using fallback');
}

// Final output
byKey[key] = {
  'valid': validFiltered,
  'invalid': aiInvalid
};
```

---

### Step 6: Write Output

```dart
final result = {
  'file': 'lib/register/register_page.dart',
  'datasets': {
    'byKey': {
      'register_username_textfield': {
        'valid': ['john123', 'user456', 'alice'],
        'invalid': ['', 'a', 'toolongusername']
      },
      'register_email_textfield': {
        'valid': ['test@co.com', 'a@b.org'],
        'invalid': ['invalid', 'no@']
      }
    }
  }
};

// Write to test_data/<page>.datasets.json
File(outPath).writeAsStringSync(
  JsonEncoder.withIndent('  ').convert(result)
);
```

**Final Output:** `test_data/register_page.datasets.json`

---

## 🤖 AI vs Local Generation

### AI Mode (Default - Required)
- ✅ **Realistic data** based on field semantics
- ✅ **Context-aware** (email field → valid emails)
- ✅ **Diverse values** for better coverage
- ✅ Respects constraints (maxLength, patterns)

**Example AI Output:**
```json
"register_username_textfield": {
  "valid": ["alice", "bob123", "charlie"],
  "invalid": ["", "a", "user@invalid"]
}
```

### Local Mode (Fallback - `--local-only`)
- ⚠️ **Generic data** without context
- ⚠️ Pattern-based generation only
- ⚠️ Less realistic

**Example Local Output:**
```json
"register_username_textfield": {
  "valid": ["abc123xy"],
  "invalid": [":::"]
}
```

---

## 🔑 Key Features

### 1. **Constraint Awareness**
Script respects all metadata constraints:
- `maxLength` → Never generate valid values exceeding limit
- `inputFormatters.pattern` → Follow character rules
- `validatorRules` → Generate data for each validation rule
- `keyboardType` → Infer field type (email, number)

### 2. **Per-Rule Dataset Generation**
For fields with multiple validation rules, generates **1:1 mapping**:

```json
{
  "validatorRules": [
    {"condition": "isEmpty", "message": "Required"},
    {"condition": "!RegExp('[0-9]').hasMatch", "message": "Must have number"}
  ],
  "datasets": {
    "valid": ["pass123", "secret1"],
    "invalid": ["", "password"]
  }
}
```
- Index 0: Tests "Required" rule
- Index 1: Tests "Must have number" rule

### 3. **Smart Field Type Detection**
```dart
// Detect from key name
if (key.contains('email')) → generate emails
if (key.contains('username')) → generate usernames
if (key.contains('password')) → generate passwords

// Detect from metadata
if (inputFormatters contains 'digitsOnly') → generate numbers
if (keyboardType == 'emailAddress') → generate emails
```

---

## 📊 Example: Complete Flow

**Input Manifest:**
```json
{
  "source": {"file": "lib/login/login_page.dart"},
  "widgets": [
    {
      "widgetType": "TextFormField",
      "key": "login_username_textfield",
      "meta": {
        "maxLength": 15,
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z0-9]"}
        ],
        "validator": true,
        "validatorRules": [
          {"condition": "value == null || value.isEmpty", "message": "Required"}
        ]
      }
    }
  ]
}
```

**AI Prompt Sent:**
```
Generate test datasets for the given Flutter form fields.
[... instructions ...]

Context (JSON):
{
  "file": "lib/login/login_page.dart",
  "fields": [
    {
      "key": "login_username_textfield",
      "meta": {"maxLength": 15, ...}
    }
  ]
}
```

**AI Response:**
```json
{
  "file": "lib/login/login_page.dart",
  "datasets": {
    "byKey": {
      "login_username_textfield": {
        "valid": ["alice", "bob123", "charlie99"],
        "invalid": ["", "a!", "verylongusername123"]
      }
    }
  }
}
```

**Output File:** `test_data/login_page.datasets.json`
```json
{
  "file": "lib/login/login_page.dart",
  "datasets": {
    "byKey": {
      "login_username_textfield": {
        "valid": ["alice", "bob123", "charlie99"],
        "invalid": ["", "a!", "verylongusername123"]
      }
    }
  }
}
```

---

## 🔑 API Key Configuration

### Recommended: .env File (Easiest)
Create a `.env` file in project root:

```bash
# .env
GEMINI_API_KEY=your_actual_api_key_here
```

**Priority Order:**
1. `--api-key` flag (highest priority)
2. `.env` file
3. `GEMINI_API_KEY` environment variable (lowest priority)

**Benefits:**
- ✅ No need to export environment variables
- ✅ Safe from accidental commits (`.env` is in `.gitignore`)
- ✅ Easy to share template via `.env.example`

### Alternative: Environment Variable
```bash
export GEMINI_API_KEY=your_actual_api_key_here
```

### Get Your API Key
Visit: https://aistudio.google.com/app/apikey

---

## 🛠️ Command Usage

### Batch Mode (Process All Manifests) ⚡
```bash
# Automatically scan and process all *.manifest.json files in manifest/ folder
dart run tools/script_v2/generate_datasets.dart
```

**Output Example:**
```
📁 Found 3 manifest file(s)
🚀 Starting batch dataset generation...

[ 1/3] Processing: manifest/demos/login_page.manifest.json
  ✓ Generated: test_data/login_page.datasets.json
[ 2/3] Processing: manifest/demos/register_page.manifest.json
  ✓ Generated: test_data/register_page.datasets.json
[ 3/3] Processing: manifest/demos/submit_page.manifest.json
  ✓ Generated: test_data/submit_page.datasets.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Batch Summary:
  ✓ Success: 3 files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Single File Mode
```bash
dart run tools/script_v2/generate_datasets.dart \
  manifest/demos/register_page.manifest.json
```

### With Custom Model
```bash
dart run tools/script_v2/generate_datasets.dart \
  manifest/demos/register_page.manifest.json \
  --model=gemini-2.0-flash-exp
```

### With Inline API Key (overrides .env)
```bash
dart run tools/script_v2/generate_datasets.dart \
  manifest/demos/register_page.manifest.json \
  --api-key=YOUR_KEY_HERE
```

### Local-Only Mode (No AI)
```bash
dart run tools/script_v2/generate_datasets.dart \
  manifest/demos/register_page.manifest.json \
  --local-only
```

---

## 🔍 Logging & Debugging

Script prints detailed logs:

```
=== datasets_from_ai: PROMPT (model=gemini-1.5-flash) ===
Generate test datasets for the given Flutter form fields...
--- Context (JSON) ---
{"file":"lib/register/register_page.dart","fields":[...]}
=== end PROMPT ===

=== datasets_from_ai: AI RESPONSE (raw text) ===
{"file":"...","datasets":{...}}
=== end AI RESPONSE ===

✓ AI datasets generated: test_data/register_page.datasets.json
```

---

## 🚨 Error Handling

### API Key Missing
```
Error: GEMINI_API_KEY not set in .env file, environment variable, or --api-key flag. AI is required.
Tip: Create a .env file in project root with: GEMINI_API_KEY=your_key_here
```
**Fix:** Create `.env` file, set environment variable, or use `--api-key` flag

### AI Call Failed
```
! Gemini call failed: HttpException: HTTP 400: ...
! AI call failed and fallback is disabled. Aborting.
```
**Fix:** Check API key validity, network connection, model name

### Insufficient AI Data
```
! AI did not provide sufficient data for field: login_username_textfield
```
**Fix:** Retry or use `--local-only` mode

### MaxLength Violation
```
Warning: Valid value "verylongusername123" exceeds maxLength=10, using fallback
```
**Fix:** Automatic - script generates fallback value

---

## 🎯 Best Practices

1. **Use .env file** for API key management (avoid repeated export commands)
2. **Use batch mode** when generating datasets for multiple pages (faster workflow)
3. **Always use AI mode** for production tests (more realistic data)
4. **Verify output** after generation (check `test_data/*.datasets.json`)
5. **Use specific models** for better results (`gemini-2.0-flash-exp`)
6. **Keep manifests clean** (remove unused widgets to reduce AI cost)
7. **Review AI suggestions** (may need manual adjustments for edge cases)

## 🛡️ Security

- `.env` is in `.gitignore` - your API key won't be committed
- Use `.env.example` as a template for team members
- Never commit actual API keys to version control

---

**Related Scripts:**
- [extract_ui_manifest.dart](../tools/script_v2/extract_ui_manifest.dart) - Generate manifests
- [generate_test_data.dart](../tools/script_v2/generate_test_data.dart) - Generate test plans
- [generate_test_script.dart](../tools/script_v2/generate_test_script.dart) - Generate tests

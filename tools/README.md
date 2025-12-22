# Flutter Test Generator

Automated test generation tool for Flutter applications using combinatorial testing and AI-powered test data generation.

## Overview

This tool automatically generates comprehensive integration tests for Flutter UI pages by:
1. Extracting UI widgets and their metadata from Flutter code
2. Generating realistic test data using AI (optional)
3. Creating pairwise test combinations for optimal coverage
4. Generating complete Flutter integration test scripts

## Quick Start

### Basic Usage

```bash
# Generate tests for a specific UI file
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart --skip-datasets

# With AI-powered test data generation
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart

# Show help
dart run tools/flutter_test_generator.dart --help
```

### Example Output

```
Flutter Test Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Processing: lib/demos/customer_details_page.dart

[1/4] Extracting UI manifest... ✓
  → Manifest: output/manifest/demos/customer_details_page.manifest.json

[2/4] Generating datasets (AI)... ✓
  → Datasets: output/test_data/customer_details_page.datasets.json

[3/4] Generating test plan (PICT)... ✓
  → Test plan: output/test_data/customer_details_page.testdata.json

[4/4] Generating test script... ✓
  → Test file: integration_test/customer_details_page_flow_test.dart

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ SUCCESS - Test generation complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
  flutter test integration_test/customer_details_page_flow_test.dart
```

## CLI Options

| Option | Description | Default |
|--------|-------------|---------|
| `--skip-datasets` | Skip AI-powered dataset generation | `false` |
| `--verbose`, `-v` | Show detailed logs | `false` |
| `--api-key=<KEY>` | Gemini API key (overrides .env) | Read from `.env` |
| `--pict-bin=<PATH>` | Path to PICT binary | `./pict` |
| `--help`, `-h` | Show help message | - |

## Pipeline Steps

### Step 1: Extract UI Manifest

Analyzes Flutter UI files to extract:
- Widget types (TextFormField, ElevatedButton, DropdownButton, etc.)
- Widget keys
- Validation rules
- Input formatters
- Dropdown/Radio options

**Input:** `lib/demos/customer_details_page.dart`
**Output:** `output/manifest/demos/customer_details_page.manifest.json`

### Step 2: Generate Test Datasets (Optional)

Uses Google Gemini AI to generate realistic valid/invalid test data based on validation rules.

**Input:** `output/manifest/demos/customer_details_page.manifest.json`
**Output:** `output/test_data/customer_details_page.datasets.json`

**Requirements:**
- Gemini API key (get from https://aistudio.google.com/app/apikey)
- Set in `.env` file: `GEMINI_API_KEY=your_key_here`

### Step 3: Generate Test Plan

Creates optimal test combinations using pairwise testing (PICT algorithm) to achieve maximum coverage with minimal test cases.

**Input:** `output/manifest/demos/customer_details_page.manifest.json`
**Output:** `output/test_data/customer_details_page.testdata.json`

**Test Coverage:**
- Pairwise valid/invalid combinations
- Edge cases (empty fields, boundary values)
- All widget interaction paths

### Step 4: Generate Test Script

Generates complete Flutter integration test code with:
- Real provider setup
- Step-by-step UI interactions
- Comprehensive assertions

**Input:** `output/test_data/customer_details_page.testdata.json`
**Output:** `integration_test/customer_details_page_flow_test.dart`

## Setup

### 1. Prerequisites

```bash
# Ensure Dart/Flutter is installed
flutter --version

# Install dependencies
flutter pub get
```

### 2. Optional: Setup Gemini API

Create a `.env` file in the project root:

```bash
GEMINI_API_KEY=your_gemini_api_key_here
```

Get your API key from: https://aistudio.google.com/app/apikey

### 3. Optional: Install PICT (for optimal pairwise testing)

Download PICT from: https://github.com/microsoft/pict

```bash
# macOS/Linux: Place pict binary in project root
chmod +x ./pict

# Or specify custom path
dart run tools/flutter_test_generator.dart <file> --pict-bin=/path/to/pict
```

**Note:** If PICT is not available, the tool uses a built-in fallback algorithm.

## Advanced Usage

### Using Individual Scripts

You can still use the individual scripts for specific steps:

```bash
# Step 1: Extract manifest only
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_page.dart

# Step 2: Generate datasets only
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/customer_details_page.manifest.json

# Step 3: Generate test plan only
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/customer_details_page.manifest.json

# Step 4: Generate test script only
dart run tools/script_v2/generate_test_script.dart output/test_data/customer_details_page.testdata.json
```

### Batch Processing

Process all pages at once:

```bash
# Extract all manifests
dart run tools/script_v2/extract_ui_manifest.dart

# Generate all datasets
dart run tools/script_v2/generate_datasets.dart

# Generate all test plans
dart run tools/script_v2/generate_test_data.dart

# Generate all test scripts
dart run tools/script_v2/generate_test_script.dart
```

## Widget Key Naming Convention

For best results, use this naming pattern for widget keys:

```
<sequence>_<description>_<widget_type>
```

**Examples:**
```dart
TextFormField(
  key: const Key('1_customer_firstname_textfield'),
  ...
)

ElevatedButton(
  key: const Key('2_submit_button'),
  ...
)

DropdownButton(
  key: const Key('3_country_dropdown'),
  ...
)
```

**Benefits:**
- Automatic sorting by sequence number
- Clear, descriptive test output
- Better test organization

## Supported Widgets

- ✅ **TextFormField** - with validation rules and formatters
- ✅ **TextField** - basic text input
- ✅ **ElevatedButton** - action buttons
- ✅ **TextButton** - secondary buttons
- ✅ **DropdownButton** - select options
- ✅ **Radio** - radio button groups
- ✅ **Checkbox** - boolean toggles
- ✅ **Text** - display bindings (state.field)

## Output Structure

```
project/
├── lib/
│   └── demos/
│       └── customer_details_page.dart         # Input UI file
├── output/
│   ├── manifest/
│   │   └── demos/
│   │       └── customer_details_page.manifest.json  # Step 1 output
│   └── test_data/
│       ├── customer_details_page.datasets.json      # Step 2 output
│       └── customer_details_page.testdata.json      # Step 3 output
├── integration_test/
│   └── customer_details_page_flow_test.dart         # Step 4 output (final tests)
└── tools/
    ├── flutter_test_generator.dart             # Main CLI tool
    └── script_v2/                              # Individual scripts
```

## Running Generated Tests

```bash
# Run specific test file
flutter test integration_test/customer_details_page_flow_test.dart

# Run all integration tests
flutter test integration_test/

# Run with verbose output
flutter test integration_test/customer_details_page_flow_test.dart -v
```

## Troubleshooting

### Error: "File not found"
- Ensure the input file path is correct
- Use relative path from project root (e.g., `lib/demos/page.dart`)

### Error: "API key not found"
- Create `.env` file with `GEMINI_API_KEY=your_key`
- Or use `--api-key=your_key` flag
- Or use `--skip-datasets` to skip AI generation

### Error: "No widgets found"
- Ensure your UI file contains supported widgets with keys
- Check widget key naming convention
- Use verbose mode to see what was detected: `--verbose`

### PICT not found
- Download from https://github.com/microsoft/pict
- Place in project root as `./pict`
- Or specify path: `--pict-bin=/path/to/pict`
- Tool will automatically fallback to internal algorithm if PICT is unavailable

## Examples

### Example 1: Basic Test Generation

```bash
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart --skip-datasets
```

### Example 2: With AI Datasets

First, create `.env`:
```
GEMINI_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXX
```

Then run:
```bash
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart
```

### Example 3: Custom API Key

```bash
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart \
  --api-key=YOUR_API_KEY
```

### Example 4: Verbose Output

```bash
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart \
  --skip-datasets \
  --verbose
```

### Example 5: Custom PICT Binary

```bash
dart run tools/flutter_test_generator.dart lib/demos/customer_details_page.dart \
  --skip-datasets \
  --pict-bin=/usr/local/bin/pict
```

## Technical Details

### Pairwise Testing
Uses Microsoft PICT (Pairwise Independent Combinatorial Testing) to generate minimal test sets that cover all pairwise combinations of input factors. This dramatically reduces test count while maintaining excellent bug detection rates.

**Example:**
- Without pairwise: 1000+ test cases
- With pairwise: ~50 test cases
- Coverage: All pairwise interactions

### Test Data Generation
Google Gemini AI analyzes validation rules and generates:
- Realistic valid values (e.g., "John Doe" for name fields)
- Targeted invalid values (e.g., "J" for 2-character minimum)
- Edge cases (empty, boundary values, special characters)

### Widget Detection
Uses regex-based parsing to extract:
- Widget constructors
- Key values
- Validation rules (validators, maxLength, inputFormatters)
- Action bindings (onPressed, onChanged)
- Display bindings (Text widgets showing state values)

## Contributing

### Adding Support for New Widgets

Edit `tools/script_v2/extract_ui_manifest.dart` to add new widget patterns:

```dart
// Add to _scanWidgets function
if (line.contains('NewWidget(')) {
  // Extract widget metadata
  final widget = {
    'widgetType': 'NewWidget',
    'key': extractedKey,
    // ... other properties
  };
  widgets.add(widget);
}
```

## License

This project is part of the master_project_v2 Flutter application.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Run with `--verbose` to see detailed logs
3. Review the generated manifest file to verify widget detection
4. Check individual script outputs in `output/` directory

---

**Generated with ❤️ by Flutter Test Generator**

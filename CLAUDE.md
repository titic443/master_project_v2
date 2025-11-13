# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter project focused on automated test plan generation from UI components using BLoC/Cubit pattern. The project demonstrates UI widgets with automated test case generation based on intermediate representation (IR) files.

## Architecture

- **Main App**: `lib/main.dart` - Flutter app entry point with MultiBlocProvider setup
- __Demo UI__: `lib/demos/buttons_page.dart` - ButtonsDemo page with various widgets (TextFormField, DropdownButton, ElevatedButton)
- **State Management**: BLoC/Cubit pattern
   - `lib/cubit/buttons_cubit.dart` - Business logic with API simulation
   - `lib/cubit/buttons_state.dart` - State classes including ApiResponse and ButtonsException

- **Test Generation Tools**:
   - `tools/ir_action_lister.dart` - Extracts UI actions to IR JSON files
   - `tools/script_v2/generate_test_data.dart` - Generates test plans from IR files
   - `tools/script_v2/generate_test_script.dart` - Generates Flutter widget tests from test plans

## Key Development Commands

### Generate IR from UI

```sh
dart run tools/ir_action_lister.dart lib/demos/buttons_page.dart
```

Output: `test_ir/actions/buttons_page.ir.json`

### Generate Test Plans

```sh
# Pairwise-merge mode (reduced test cases)
dart run tools/script_v2/generate_test_data.dart --pairwise-merge test_ir/actions/buttons_page.ir.json

# Full-flow mode (complete test steps)
dart run tools/script_v2/generate_test_data.dart test_ir/actions/buttons_page.ir.json

# Plan summary (factor analysis)
dart run tools/script_v2/generate_test_data.dart --plan-summary test_ir/actions/buttons_page.ir.json
```

### Generate Flutter Tests

```sh
dart run tools/script_v2/generate_test_script.dart test_data/buttons_page.testdata.json
```

Output: `test/generated/buttons_page_flow_test.dart`

### Run Tests

```sh
flutter test test/generated/buttons_page_flow_test.dart
flutter test  # Run all tests
```

### Build and Lint

```sh
flutter build apk          # Build Android APK
flutter build web          # Build for web
flutter analyze            # Static analysis
dart format .               # Format code
```

## Test Plan Structure

Test plans are JSON files in `test_data/` containing:

- **Cases**: Test scenarios with success/failure variations
- **Steps**: UI interaction sequences
- **Asserts**: Expected outcomes using keys like:
   - `{"byKey": "<key>", "exists": true|false}`
   - `{"byKey": "<key>", "textEquals": "..."}`
   - `{"byKey": "<key>", "textContains": "..."}`
   - `{"text": "...", "exists": true|false}`

- **Setup**: API response simulation via `setup.response` JSON

## Key Directories

- `lib/` - Flutter application code
- `tools/` - Code generation scripts
- `test_ir/actions/` - UI action intermediate representation files
- `test_data/` - Generated test plan JSON files
- `test/generated/` - Generated Flutter widget test files

## Testing Architecture

The project uses a sophisticated test generation system:

1. UI components are analyzed to extract possible actions and states
2. Test plans combine these actions using pairwise or full-flow strategies
3. Generated tests use custom Cubit stubs to simulate API responses
4. Each test case can specify expected API responses in `setup.response`
5. Tests verify UI state through key-based assertions

## BLoC/Cubit Pattern

- `ButtonsCubit` manages form state (username, options, count) and API calls
- `shouldSucceed` parameter controls API simulation behavior
- Test generation creates `_SuccessButtonsCubit` variants for different scenarios
- API responses are modeled as `ApiResponse` with message/code fields
- Errors use `ButtonsException` with HTTP-like status codes
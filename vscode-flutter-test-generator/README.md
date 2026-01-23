# Flutter Test Generator - VS Code Extension

Generate Flutter widget tests using pairwise combinatorial testing with PICT constraints.

## Features

- **Visual UI** - Easy-to-use webview panel for configuring test generation
- **File Browser** - Browse and select Dart files directly
- **Widget Scanning** - Automatically scan UI files for testable widgets
- **PICT Constraints** - Support for PICT constraints to customize test combinations
- **AI Dataset Generation** - Optional AI-powered test data generation using Gemini
- **Progress Tracking** - Real-time progress updates during generation
- **One-Click Run** - Run generated tests directly from VS Code

## Usage

```sh

```

### Open the Panel

1. **Command Palette**: Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Flutter Test Generator: Open Panel"
3. Press Enter

### From Context Menu

1. Right-click on a `.dart` file in the Explorer
2. Select "Flutter Test Generator: Generate Tests from This File"

### Generate Tests

1. Select a UI file (e.g., `lib/demos/buttons_page.dart`)
2. Configure options:
   - Skip AI Dataset Generation (optional)
   - Use PICT Constraints (optional)
   - Verbose Logging (optional)

3. Click "Generate Tests"
4. Wait for the pipeline to complete
5. Open or run the generated test file

## Configuration

### Extension Settings

- `flutterTestGenerator.pictBinaryPath`: Path to PICT binary (default: `./pict`)
- `flutterTestGenerator.geminiApiKey`: API key for AI dataset generation
- `flutterTestGenerator.defaultSkipDatasets`: Skip AI dataset generation by default

### PICT Constraints

Create a constraints file at `output/model_pairwise/<page>.constraints.txt`:

```pict
IF [state.ageRange] = "age_10_20_radio" THEN [customer_01_title_dropdown] <> "Dr.";
IF [customer_02_firstname_textfield] = "invalid" THEN [customer_06_agree_terms_checkbox] = "unchecked";
```

## Requirements

- VS Code 1.74.0 or higher
- Dart SDK installed
- Flutter SDK installed (for running tests)
- PICT binary (for pairwise testing)
- Gemini API key (optional, for AI dataset generation)

## Installation

### From Source

1. Clone the repository
2. Run `npm install`
3. Run `npm run compile`
4. Press F5 to launch Extension Development Host

### From VSIX

1. Download the `.vsix` file
2. In VS Code, go to Extensions view
3. Click "..." menu → "Install from VSIX..."
4. Select the downloaded file

## Pipeline Steps

1. **Extract UI Manifest** - Parse Dart file to extract widget information
2. **Generate Datasets (AI)** - Create test data using AI (optional)
3. **Generate Test Plan (PICT)** - Create pairwise test combinations
4. **Generate Test Script** - Create Flutter widget test file

## Troubleshooting

### PICT Binary Not Found

Make sure PICT is installed and available at the configured path:

```bash
# Check if PICT is available
./pict --help

# Or set custom path in settings
"flutterTestGenerator.pictBinaryPath": "/path/to/pict"
```

### API Key Issues

Set your Gemini API key in VS Code settings:

1. Open Settings (`Cmd+,` or `Ctrl+,`)
2. Search for "Flutter Test Generator"
3. Enter your API key in "Gemini Api Key"

## License

MIT

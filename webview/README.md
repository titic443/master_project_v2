# Flutter Test Generator WebView

Web-based UI for generating Flutter widget tests using pairwise combinatorial testing.

## Quick Start

### 1. Start the Server

```sh
cd /Users/70009215/Desktop/101/master_project_v2
dart run webview/server.dart
```

Server will start at `http://localhost:8080`

### 2. Open in Browser

Open `http://localhost:8080` in your browser.

Or open the file directly:
```sh
open webview/index.html
```

Note: If opening the HTML file directly, the server must still be running for API calls to work.

## Features

- **Select UI File**: Browse and select Dart UI files from `lib/demos/`
- **Scan Widgets**: Preview number of widgets that will be tested
- **Options**:
  - Skip AI Dataset Generation
  - Run Tests After Generation
  - Generate Coverage Report
- **Progress Tracking**: Real-time progress for each generation step
- **Generate All**: Process all UI files at once

## Generation Pipeline

1. **Extract UI Manifest** - Analyzes UI file and extracts widget interactions
2. **Generate Datasets (AI)** - Creates test data using Gemini AI
3. **Generate Test Plan (PICT)** - Creates pairwise test combinations
4. **Generate Test Script** - Creates Flutter integration test file
5. **Run Tests** - Executes the generated tests (optional)

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/files` | GET | List available Dart files |
| `/scan` | POST | Scan widgets in a file |
| `/extract-manifest` | POST | Extract UI manifest |
| `/generate-datasets` | POST | Generate test datasets |
| `/generate-test-data` | POST | Generate test plan |
| `/generate-test-script` | POST | Generate test script |
| `/run-tests` | POST | Run Flutter tests |
| `/generate-all` | POST | Generate tests for all files |

## Requirements

- Dart SDK
- Flutter SDK
- PICT binary (`./pict`)
- Gemini API key (for AI datasets, optional)

## File Structure

```
webview/
├── index.html      # Main HTML page
├── styles.css      # Styling
├── main.js         # Frontend JavaScript
├── server.dart     # Backend Dart server
└── README.md       # This file
```

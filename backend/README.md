# Backend API Documentation

FastAPI backend server for Flutter form validation demos.

## Overview

This backend provides REST API endpoints for validating form submissions from Flutter applications. It mirrors the validation logic implemented in the Flutter UI to ensure consistent validation on both client and server sides.

## Features

- **FastAPI Framework**: Modern, fast Python web framework
- **Automatic API Documentation**: Swagger UI and ReDoc
- **CORS Enabled**: Allows requests from Flutter apps
- **Validation Mirroring**: Server-side validation matches Flutter validators
- **Test Support**: `forceCode` parameter for testing success/failure scenarios

## Prerequisites

- Python 3.10 or higher
- pip (Python package manager)

## Installation

```bash
# Navigate to backend directory
cd backend

# Create a virtual environment (optional but recommended)
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

## Running the Server

### Method 1: Using Python directly

```bash
python main.py
```

### Method 2: Using uvicorn command

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Method 3: From project root

```bash
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

The server will start at: **http://localhost:8000**

## API Documentation

Once the server is running, access the auto-generated documentation:

- **Swagger UI**: http://localhost:8000/docs (interactive API testing)
- **ReDoc**: http://localhost:8000/redoc (API reference documentation)

---

## Available Endpoints

### Health Check

```http
GET /health
```

Returns server status.

**Response:**
```json
{
  "status": "ok"
}
```

---

### 1. Buttons Demo

```http
POST /api/demo/buttons
```

**Request Body:**
```txt
customer_01_title_dropdown: "Mr.", "Mrs.", "Ms", "Dr"
customer_02_firstname_textfield: invalid
customer_03_phone_textfield: invalid
customer_04_agree_terms_checkbox: checked, unchecked

IF [customer_04_agree_terms_checkbox] = "checked" THEN customer_02_firstname_textfield = "invalid"

```

**Validation Rules:**
- `username`: Required, alphanumeric only (`^[a-zA-Z0-9]+$`)
- `password`: Required, must contain at least one digit
- `email`: Required, valid email format
- `option`: "reject" → 400, "pending" → 500, else → 200

**Success Response (200):**
```json
{
  "message": "ok",
  "code": 200
}
```

**Error Response (400):**
```json
{
  "message": "Please enter a valid username",
  "code": 400
}
```

---

### 2. Customer Details

```http
POST /api/demo/customer
```

**Request Body:**
```json
{
  "title": "Mr.",
  "firstName": "John",
  "lastName": "Smith",
  "ageRange": 2,
  "agreeToTerms": true,
  "subscribeNewsletter": false,
  "forceCode": null
}
```

**Validation Rules:**
- `title`: Required, not empty
- `firstName`: Required, letters only, minimum 2 characters (`^[a-zA-Z]{2,}$`)
- `lastName`: Required, letters only, minimum 2 characters (`^[a-zA-Z]{2,}$`)
- `ageRange`: Required, must be 1, 2, or 3
  - 1 = 10-20 years
  - 2 = 30-40 years
  - 3 = 50-60 years
- `agreeToTerms`: Required, must be true
- `subscribeNewsletter`: Optional

**Success Response (200):**
```json
{
  "message": "ok",
  "code": 200
}
```

**Error Response (400):**
```json
{
  "message": "First name must contain only letters (minimum 2 characters)",
  "code": 400
}
```

---

### 3. Product Registration

```http
POST /api/demo/product
```

**Request Body:**
```json
{
  "productName": "Laptop Pro",
  "category": "Electronics",
  "sku": "ELEC-12345",
  "quantity": 100,
  "priceRange": 3,
  "inStock": true,
  "featured": false,
  "forceCode": null
}
```

**Validation Rules:**
- `productName`: Required, minimum 3 characters
- `category`: Required, must be one of: Electronics, Clothing, Food, Books
- `sku`: Required, uppercase alphanumeric with dash, minimum 5 characters (`^[A-Z0-9\-]{5,}$`)
- `quantity`: Required, 1 to 999999
- `priceRange`: Required, must be 1, 2, or 3
  - 1 = 0-100
  - 2 = 100-500
  - 3 = 500+
- `inStock`: Required, must be true
- `featured`: Optional

**Success Response (200):**
```json
{
  "message": "ok",
  "code": 200
}
```

**Error Response (400):**
```json
{
  "message": "SKU must be uppercase alphanumeric with dash (min 5 chars)",
  "code": 400
}
```

---

### 4. Employee Survey

```http
POST /api/demo/employee
```

**Request Body:**
```json
{
  "employeeId": "EMP-12345",
  "department": "Engineering",
  "email": "employee@company.com",
  "yearsOfService": 5,
  "satisfactionRating": 3,
  "recommendCompany": true,
  "attendTraining": false,
  "forceCode": null
}
```

**Validation Rules:**
- `employeeId`: Required, must match format `EMP-12345` (`^EMP-\d{5}$`)
- `department`: Required, must be one of: Engineering, Sales, HR, Marketing
- `email`: Required, valid email format (`^[\w\.\-]+@[\w\.\-]+\.\w{2,}$`)
- `yearsOfService`: Required, 0 to 50
- `satisfactionRating`: Required, must be 1, 2, or 3
  - 1 = Poor
  - 2 = Fair
  - 3 = Excellent
- `recommendCompany`: Required, must be true
- `attendTraining`: Optional

**Success Response (200):**
```json
{
  "message": "ok",
  "code": 200
}
```

**Error Response (400):**
```json
{
  "message": "Employee ID must match format: EMP-12345",
  "code": 400
}
```

---

## Testing with forceCode

All endpoints support a `forceCode` parameter for testing purposes:

**Force Success:**
```json
{
  "forceCode": 200
}
```

**Force Bad Request:**
```json
{
  "forceCode": 400
}
```

**Force Server Error:**
```txt
(.venv) titichangpoo@AYMACMJ7CVH232W master_project_v2 % ./build_release.sh 1.0.0
📦 Building flutter_test_gen_v1.0.0 ...
✅ Done!
   File    : /Users/titichangpoo/Desktop/MASTER_FINAL/master_project_v2/flutter_test_gen_v1.0.0.zip
   Size    :  92K
   Entries : 23 files

วิธีใช้:
   unzip flutter_test_gen_v1.0.0.zip
   cd flutter_test_gen_v1.0.0
   ./run_tool.sh /path/to/your_flutter_project
(.venv) titichangpoo@AYMACMJ7CVH232W master_project_v2 % unzip flutter_test_gen_v1.0.0.zip
Archive:  flutter_test_gen_v1.0.0.zip
   creating: flutter_test_gen_v1.0.0
   creating: flutter_test_gen_v1.0.0/tools
   creating: flutter_test_gen_v1.0.0/tools/script_v2
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/extract_ui_manifest.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/generator_pict.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/generate_test_script.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/utils.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/generate_datasets.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/clear_manifest.dart  
  inflating: flutter_test_gen_v1.0.0/tools/script_v2/generate_test_data.dart  
  inflating: flutter_test_gen_v1.0.0/Dockerfile  
  inflating: flutter_test_gen_v1.0.0/pubspec.lock  
   creating: flutter_test_gen_v1.0.0/webview
  inflating: flutter_test_gen_v1.0.0/webview/index.html  
  inflating: flutter_test_gen_v1.0.0/webview/styles.css  
  inflating: flutter_test_gen_v1.0.0/webview/host_runner.dart  
  inflating: flutter_test_gen_v1.0.0/webview/main.js  
  inflating: flutter_test_gen_v1.0.0/webview/coverage_runner.dart  
  inflating: flutter_test_gen_v1.0.0/webview/server.dart  
  inflating: flutter_test_gen_v1.0.0/INSTALL.md  
  inflating: flutter_test_gen_v1.0.0/docker-entrypoint.sh  
  inflating: flutter_test_gen_v1.0.0/pubspec.yaml  
  inflating: flutter_test_gen_v1.0.0/run_tool.sh  
(.venv) titichangpoo@AYMACMJ7CVH232W master_project_v2 % cd flutter_test_gen_v1.0.0 
(.venv) titichangpoo@AYMACMJ7CVH232W flutter_test_gen_v1.0.0 % ./run_tool.sh --build ../../master_project_v2 
Building Docker image (this may take a few minutes on first run)...
```

When `forceCode` is provided, the server will return the specified status code **regardless of validation results**. This is useful for testing error handling in the Flutter app.

---

## Response Status Codes

| Code | Description |
|------|-------------|
| 200 | Success - All validations passed |
| 400 | Bad Request - Validation failed |
| 500 | Internal Server Error - Server error or forced via forceCode |

---

## Error Response Format

All error responses follow this format:

**400 Bad Request:**
```json
{
  "message": "Validation error message",
  "code": 400
}
```

**500 Internal Server Error:**
```http
HTTP/1.1 500 Internal Server Error
{
  "detail": {
    "message": "server_error",
    "code": 500
  }
}
```

---

## Integration with Flutter

### Update Flutter App Configuration

In your Flutter Cubit files, ensure the backend URL is correct:

```dart
final response = await http.post(
  Uri.parse('http://localhost:8000/api/demo/customer'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({...}),
);
```

### Platform-Specific URLs

**For Android Emulator:**
```dart
Uri.parse('http://10.0.2.2:8000/api/demo/customer')
```

**For iOS Simulator:**
```dart
Uri.parse('http://localhost:8000/api/demo/customer')
```

**For Physical Device:**
```dart
Uri.parse('http://192.168.1.100:8000/api/demo/customer')
```
*(Replace with your machine's IP address)*

---

## Development

### Project Structure

```
backend/
├── main.py              # Main application file with all endpoints
├── README.md            # This file
└── requirements.txt     # Python dependencies
```

### CORS Configuration

CORS is configured to allow all origins for development:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**⚠️ Warning**: For production, configure specific allowed origins.

---

## Troubleshooting

### Port Already in Use

If port 8000 is already in use, specify a different port:

```bash
uvicorn main:app --reload --port 8001
```

Then update your Flutter app to use the new port.

### Module Import Errors

Make sure you're in the correct directory:

```bash
# If running from backend directory
python main.py

# If running from project root
python -m backend.main
```

### CORS Errors

If you encounter CORS errors from Flutter:
1. Ensure the backend server is running
2. Check that CORS middleware is properly configured
3. Verify the Flutter app is using the correct backend URL

---

## Quick Test with curl

### Test Customer Endpoint

```bash
curl -X POST http://localhost:8000/api/demo/customer \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Mr.",
    "firstName": "John",
    "lastName": "Smith",
    "ageRange": 2,
    "agreeToTerms": true,
    "subscribeNewsletter": false
  }'
```

### Test Product Endpoint

```bash
curl -X POST http://localhost:8000/api/demo/product \
  -H "Content-Type: application/json" \
  -d '{
    "productName": "Laptop Pro",
    "category": "Electronics",
    "sku": "ELEC-12345",
    "quantity": 100,
    "priceRange": 3,
    "inStock": true,
    "featured": false
  }'
```

### Test Employee Endpoint

```bash
curl -X POST http://localhost:8000/api/demo/employee \
  -H "Content-Type: application/json" \
  -d '{
    "employeeId": "EMP-12345",
    "department": "Engineering",
    "email": "employee@company.com",
    "yearsOfService": 5,
    "satisfactionRating": 3,
    "recommendCompany": true,
    "attendTraining": false
  }'
```

---

## License

This backend is part of the master_project_v2 Flutter application.

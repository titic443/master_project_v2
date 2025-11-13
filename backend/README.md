Python FastAPI backend for Buttons demo

Quickstart

- Create a virtualenv (optional):
  - python3 -m venv .venv && source .venv/bin/activate
- Install deps:
  - pip install -r requirements.txt
- Run dev server:
  - uvicorn backend.main:app --reload --port 8000

HTTP endpoints

- GET /health
  - Returns {"status":"ok"}

- POST /api/demo/buttons
  - Request JSON (all fields optional):
    {
      "username": "user123",
      "password": "Pass1234",
      "email": "test@example.com",
      "option": "approve|reject|pending",   # maps to Radio2
      "radio3": "manu|che",
      "platform": "android|window|ios",     # maps to Radio4
      "dropdown": "Apple|Banana|Cherry",
      "forceCode": 200|400|500               # overrides validation outcome
    }
  - Response JSON (shape expected by Flutter):
    {
      "message": "ok" | "validation_failed" | "server_error",
      "code": 200 | 400 | 500
    }

Notes

- CORS is enabled for all origins for ease of local development.
- Validation mirrors basic rules in the Flutter page:
  - username: required, alphanumeric
  - password: required, must contain at least one digit
  - email: required, basic email pattern


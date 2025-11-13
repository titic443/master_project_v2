from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import re

app = FastAPI(title="Buttons Demo Backend", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ButtonsRequest(BaseModel):
    username: str | None = Field(default=None)
    password: str | None = Field(default=None)
    email: str | None = Field(default=None)
    option: str | None = Field(default=None, description="approve|reject|pending")
    radio3: str | None = Field(default=None, description="manu|che")
    platform: str | None = Field(default=None, description="android|window|ios")
    dropdown: str | None = Field(default=None)
    forceCode: int | None = Field(default=None, description="200|400|500")


class CustomerRequest(BaseModel):
    title: str | None = Field(default=None)
    firstName: str | None = Field(default=None)
    lastName: str | None = Field(default=None)
    ageRange: int | None = Field(default=None, description="1|2|3")
    agreeToTerms: bool | None = Field(default=None)
    subscribeNewsletter: bool | None = Field(default=None)
    forceCode: int | None = Field(default=None, description="200|400|500")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/api/demo/buttons")
def demo_buttons(req: ButtonsRequest):
    print(req)
    # If forceCode provided, honor it
    if req.forceCode in (200, 400, 500):
        return _response_for_code(req.forceCode)

    # Basic validations mirroring Flutter validators
    if not req.username or not req.username.strip():
        return {"message": "Required", "code": 400}
    if not re.fullmatch(r"^[a-zA-Z0-9]+$", req.username):
        return {"message": "Please enter a valid username", "code": 400}

    if not req.password or not req.password.strip():
        return {"message": "Required", "code": 400}
    if not re.search(r"\d", req.password):
        return {"message": "Please enter a valid password", "code": 400}

    if not req.email or not req.email.strip():
        return {"message": "Required", "code": 400}
    if not re.fullmatch(r"[a-zA-Z0-9@.\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}", req.email):
        return {"message": "Please enter a valid email address", "code": 400}

    # Simple behavior: reject => 400, pending => 500, else 200
    opt = (req.option or "").lower()
    print(opt)
    if opt == "reject":
        return _response_for_code(400)
    if opt == "pending":
        return _response_for_code(500)

    # Otherwise OK
    return _response_for_code(200)


@app.post("/api/demo/customer")
def demo_customer(req: CustomerRequest):
    print(req)
    # If forceCode provided, honor it
    if req.forceCode in (200, 400, 500):
        return _response_for_code(req.forceCode)

    # Validate title (required, not empty)
    if not req.title or not req.title.strip():
        return {"message": "Please select a title", "code": 400}

    # Validate firstName (required, must match pattern ^[a-zA-Z]{2,}$)
    if not req.firstName or not req.firstName.strip():
        return {"message": "First name is required", "code": 400}
    if not re.fullmatch(r"^[a-zA-Z]{2,}$", req.firstName):
        return {"message": "First name must contain only letters (minimum 2 characters)", "code": 400}

    # Validate lastName (required, must match pattern ^[a-zA-Z]{2,}$)
    if not req.lastName or not req.lastName.strip():
        return {"message": "Last name is required", "code": 400}
    if not re.fullmatch(r"^[a-zA-Z]{2,}$", req.lastName):
        return {"message": "Last name must contain only letters (minimum 2 characters)", "code": 400}

    # Validate ageRange (required, must be 1, 2, or 3)
    if req.ageRange is None:
        return {"message": "Please select an age range", "code": 400}
    if req.ageRange not in (1, 2, 3):
        return {"message": "Invalid age range", "code": 400}

    # Validate agreeToTerms (required, must be true)
    if req.agreeToTerms is None or not req.agreeToTerms:
        return {"message": "You must agree to terms", "code": 400}

    # subscribeNewsletter is optional, no validation needed

    # All validations passed
    return _response_for_code(200)


def _response_for_code(code: int):
    if code == 200:
        return {"message": "ok", "code": 200}
    if code == 400:
        raise HTTPException(status_code=400, detail={"message": "bad_request", "code": 400})
    raise HTTPException(status_code=500, detail={"message": "server_error", "code": 500})


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("backend.main:app", host="0.0.0.0", port=8000, reload=True)


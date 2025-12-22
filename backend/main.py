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


class ProductRequest(BaseModel):
    productName: str | None = Field(default=None)
    category: str | None = Field(default=None)
    sku: str | None = Field(default=None)
    quantity: int | None = Field(default=None)
    priceRange: int | None = Field(default=None, description="1|2|3")
    inStock: bool | None = Field(default=None)
    featured: bool | None = Field(default=None)
    forceCode: int | None = Field(default=None, description="200|400|500")


class EmployeeRequest(BaseModel):
    employeeId: str | None = Field(default=None)
    department: str | None = Field(default=None)
    email: str | None = Field(default=None)
    yearsOfService: int | None = Field(default=None)
    satisfactionRating: int | None = Field(default=None, description="1|2|3")
    recommendCompany: bool | None = Field(default=None)
    attendTraining: bool | None = Field(default=None)
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


@app.post("/api/demo/product")
def demo_product(req: ProductRequest):
    print(req)
    # If forceCode provided, honor it
    if req.forceCode in (200, 400, 500):
        return _response_for_code(req.forceCode)

    # Validate productName (required, min 3 characters)
    if not req.productName or not req.productName.strip():
        return {"message": "Product name is required", "code": 400}
    if len(req.productName.strip()) < 3:
        return {"message": "Product name must be at least 3 characters", "code": 400}

    # Validate category (required, not empty)
    if not req.category or not req.category.strip():
        return {"message": "Please select a category", "code": 400}

    # Validate SKU (required, must match pattern ^[A-Z0-9\-]{5,}$)
    if not req.sku or not req.sku.strip():
        return {"message": "SKU is required", "code": 400}
    if not re.fullmatch(r"^[A-Z0-9\-]{5,}$", req.sku):
        return {"message": "SKU must be uppercase alphanumeric with dash (min 5 chars)", "code": 400}

    # Validate quantity (required, must be >= 1)
    if req.quantity is None:
        return {"message": "Quantity is required", "code": 400}
    if req.quantity < 1:
        return {"message": "Quantity must be at least 1", "code": 400}
    if req.quantity > 999999:
        return {"message": "Quantity cannot exceed 999999", "code": 400}

    # Validate priceRange (required, must be 1, 2, or 3)
    if req.priceRange is None:
        return {"message": "Please select a price range", "code": 400}
    if req.priceRange not in (1, 2, 3):
        return {"message": "Invalid price range", "code": 400}

    # Validate inStock (required, must be true)
    if req.inStock is None or not req.inStock:
        return {"message": "Product must be in stock to register", "code": 400}

    # featured is optional, no validation needed

    # All validations passed
    return _response_for_code(200)


@app.post("/api/demo/employee")
def demo_employee(req: EmployeeRequest):
    print(req)
    # If forceCode provided, honor it
    if req.forceCode in (200, 400, 500):
        return _response_for_code(req.forceCode)

    # Validate employeeId (required, must match format EMP-12345)
    if not req.employeeId or not req.employeeId.strip():
        return {"message": "Employee ID is required", "code": 400}
    if not re.fullmatch(r"^EMP-\d{5}$", req.employeeId):
        return {"message": "Employee ID must match format: EMP-12345", "code": 400}

    # Validate department (required, not empty)
    if not req.department or not req.department.strip():
        return {"message": "Please select a department", "code": 400}

    # Validate email (required, valid email format)
    if not req.email or not req.email.strip():
        return {"message": "Email is required", "code": 400}
    if not re.fullmatch(r"^[\w\.\-]+@[\w\.\-]+\.\w{2,}$", req.email):
        return {"message": "Please enter a valid email address", "code": 400}

    # Validate yearsOfService (required, must be 0-50)
    if req.yearsOfService is None:
        return {"message": "Years of service is required", "code": 400}
    if req.yearsOfService < 0:
        return {"message": "Years must be 0 or greater", "code": 400}
    if req.yearsOfService > 50:
        return {"message": "Years cannot exceed 50", "code": 400}

    # Validate satisfactionRating (required, must be 1, 2, or 3)
    if req.satisfactionRating is None:
        return {"message": "Please select a satisfaction rating", "code": 400}
    if req.satisfactionRating not in (1, 2, 3):
        return {"message": "Invalid satisfaction rating", "code": 400}

    # Validate recommendCompany (required, must be true)
    if req.recommendCompany is None or not req.recommendCompany:
        return {"message": "You must recommend the company to proceed", "code": 400}

    # attendTraining is optional, no validation needed

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


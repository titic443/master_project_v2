from contextlib import asynccontextmanager
from typing import Literal, Optional
from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel, EmailStr, Field, field_validator, model_validator
from pydantic_settings import BaseSettings
from bson import ObjectId
import uvicorn


# ─── Settings ─────────────────────────────────────────────────────────────────

class Settings(BaseSettings):
    mongo_uri: str = "mongodb://localhost:27017/linkedin_profiles"
    port: int = 8000

    class Config:
        env_file = ".env"


settings = Settings()


# ─── Database ─────────────────────────────────────────────────────────────────

class Database:
    client: AsyncIOMotorClient = None
    collection = None
    jobs_collection = None
    properties_collection = None
    appointments_collection = None


db = Database()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    db.client = AsyncIOMotorClient(settings.mongo_uri)
    db.collection = db.client.get_default_database()["profiles"]
    db.jobs_collection = db.client.get_default_database()["jobs"]
    db.properties_collection = db.client.get_default_database()["properties"]
    db.appointments_collection = db.client.get_default_database()["clinic_appointments"]
    print(f"✅ Connected to MongoDB: {settings.mongo_uri}")
    yield
    # Shutdown
    db.client.close()
    print("🔌 MongoDB disconnected")


# ─── App ──────────────────────────────────────────────────────────────────────

app = FastAPI(title="LinkedIn Profile API", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"message": exc.detail, "code": exc.status_code},
    )


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = exc.errors()
    msg = errors[0]["msg"] if errors else "Validation error"
    return JSONResponse(
        status_code=422,
        content={"message": msg, "code": 422},
    )


# ─── Schemas ──────────────────────────────────────────────────────────────────

class ProfileIn(BaseModel):
    fullName: str = Field(..., min_length=2, max_length=100)
    email: str = Field(..., max_length=50)
    position: str = Field(..., min_length=2, max_length=100)
    company: str = Field(..., min_length=2, max_length=100)
    experience: int = Field(..., ge=0, le=50)
    employmentType: Literal["Full-time", "Part-time", "Contract", "Freelance"]
    educationLevel: Literal[1, 2, 3]  # 1=Bachelor, 2=Master, 3=PhD
    university: str = Field(..., min_length=2, max_length=100)
    agreeTerms: bool
    openToWork: bool = False

    @field_validator("fullName")
    @classmethod
    def full_name_letters_only(cls, v: str) -> str:
        import re
        if not re.fullmatch(r"[a-zA-Z\s]+", v):
            raise ValueError("Full name must contain only letters and spaces")
        return v

    @field_validator("email")
    @classmethod
    def valid_email(cls, v: str) -> str:
        import re
        if not re.fullmatch(r"[\w.\-]+@[\w.\-]+\.\w{2,}", v):
            raise ValueError("Please enter a valid email address")
        return v

    @field_validator("agreeTerms")
    @classmethod
    def must_agree(cls, v: bool) -> bool:
        if not v:
            raise ValueError("You must agree to terms")
        return v


class ApiResponse(BaseModel):
    message: str
    code: int


# ─── Job Board Schemas ────────────────────────────────────────────────────────

class JobIn(BaseModel):
    title: str = Field(..., min_length=3, max_length=100)
    company: str = Field(..., min_length=2, max_length=100)
    location: str = Field(..., min_length=2, max_length=100)
    category: Literal["IT & Tech", "Finance", "Marketing", "Engineering", "Healthcare", "Education"]
    employmentType: Literal["Full-time", "Part-time", "Contract", "Freelance", "Internship"]
    experienceLevel: Literal["Entry Level", "Junior", "Mid-Level", "Senior"]
    salaryMin: int = Field(..., ge=0, le=10_000_000)
    salaryMax: int = Field(..., ge=0, le=10_000_000)
    description: str = Field(..., min_length=20, max_length=5000)
    skills: str = Field(..., min_length=2, max_length=500)
    isRemote: bool = False

    @model_validator(mode="after")
    def salary_range_valid(self) -> "JobIn":
        if self.salaryMax < self.salaryMin:
            raise ValueError("Max salary must be >= min salary")
        return self


# ─── Routes ───────────────────────────────────────────────────────────────────

@app.post("/api/demo/linkedin", response_model=ApiResponse)
async def submit_profile(profile: ProfileIn):
    """Submit LinkedIn profile — called by Flutter cubit"""
    doc = profile.model_dump()
    result = await db.collection.insert_one(doc)
    print(f"📥 Profile saved: {result.inserted_id}")
    return ApiResponse(message="Profile submitted successfully", code=200)


@app.get("/api/demo/linkedin")
async def list_profiles():
    """List all saved profiles"""
    profiles = []
    async for doc in db.collection.find().sort("_id", -1):
        doc["id"] = str(doc.pop("_id"))
        profiles.append(doc)
    return {"profiles": profiles, "total": len(profiles)}


@app.get("/api/demo/linkedin/search")
async def search_profiles(email: Optional[str] = None, name: Optional[str] = None):
    """Search profiles by email and/or name (case-insensitive, partial match)"""
    if not email and not name:
        raise HTTPException(status_code=400, detail="Please provide email or name to search")
    conditions = []
    if email:
        conditions.append({"email": {"$regex": email, "$options": "i"}})
    if name:
        conditions.append({"fullName": {"$regex": name, "$options": "i"}})
    query = {"$or": conditions} if len(conditions) > 1 else conditions[0]
    profiles = []
    async for doc in db.collection.find(query).sort("_id", -1):
        doc["id"] = str(doc.pop("_id"))
        profiles.append(doc)
    return {"profiles": profiles, "total": len(profiles)}


@app.get("/api/demo/linkedin/{profile_id}")
async def get_profile(profile_id: str):
    """Get a single profile by ID"""
    doc = await db.collection.find_one({"_id": ObjectId(profile_id)})
    if not doc:
        raise HTTPException(status_code=404, detail="Profile not found")
    doc["id"] = str(doc.pop("_id"))
    return doc


@app.delete("/api/demo/linkedin/{profile_id}", response_model=ApiResponse)
async def delete_profile(profile_id: str):
    """Delete a profile by ID"""
    result = await db.collection.delete_one({"_id": ObjectId(profile_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Profile not found")
    return ApiResponse(message="Deleted", code=200)


# ─── Job Board Routes ─────────────────────────────────────────────────────────

@app.post("/api/demo/jobs", response_model=ApiResponse)
async def post_job(job: JobIn):
    """Post a new job listing"""
    doc = job.model_dump()
    result = await db.jobs_collection.insert_one(doc)
    print(f"📥 Job saved: {result.inserted_id}")
    return ApiResponse(message="Job posted successfully", code=200)


@app.get("/api/demo/jobs/search")
async def search_jobs(
    keyword: Optional[str] = None,
    location: Optional[str] = None,
    category: Optional[str] = None,
    employment_type: Optional[str] = None,
    salary_min: Optional[int] = None,
    is_remote: Optional[bool] = None,
):
    """Search jobs — all params optional, at least one required"""
    conditions = []

    if keyword:
        conditions.append({
            "$or": [
                {"title": {"$regex": keyword, "$options": "i"}},
                {"skills": {"$regex": keyword, "$options": "i"}},
                {"description": {"$regex": keyword, "$options": "i"}},
            ]
        })
    if location:
        conditions.append({"location": {"$regex": location, "$options": "i"}})
    if category:
        conditions.append({"category": category})
    if employment_type:
        conditions.append({"employmentType": employment_type})
    if salary_min is not None:
        conditions.append({"salaryMax": {"$gte": salary_min}})
    if is_remote is not None:
        conditions.append({"isRemote": is_remote})

    if not conditions:
        raise HTTPException(
            status_code=400,
            detail="At least one search filter is required",
        )

    query = {"$and": conditions} if len(conditions) > 1 else conditions[0]
    jobs = []
    async for doc in db.jobs_collection.find(query).sort("_id", -1).limit(50):
        doc["id"] = str(doc.pop("_id"))
        jobs.append(doc)
    return {"jobs": jobs, "total": len(jobs)}


@app.get("/api/demo/jobs")
async def list_jobs():
    """List all job listings"""
    jobs = []
    async for doc in db.jobs_collection.find().sort("_id", -1):
        doc["id"] = str(doc.pop("_id"))
        jobs.append(doc)
    return {"jobs": jobs, "total": len(jobs)}


# ─── Real Estate Schemas ──────────────────────────────────────────────────────

class PropertyIn(BaseModel):
    title: str = Field(..., min_length=5, max_length=150)
    propertyType: Literal["Condo", "House", "Townhouse", "Land", "Commercial"]
    location: str = Field(..., min_length=2, max_length=100)
    district: str = Field(..., min_length=2, max_length=100)
    price: int = Field(..., ge=100_000, le=1_000_000_000)
    bedrooms: Optional[Literal["Studio", "1", "2", "3", "4+"]] = None
    bathrooms: Optional[Literal["1", "2", "3", "4+"]] = None
    areaSqm: float = Field(..., ge=10, le=100_000)
    floor: str = Field(..., min_length=1, max_length=50)
    isFurnished: bool = False
    description: str = Field(..., min_length=20, max_length=5000)
    contactName: str = Field(..., min_length=2, max_length=100)


# ─── Real Estate Routes ───────────────────────────────────────────────────────

@app.post("/api/demo/properties", response_model=ApiResponse)
async def post_property(prop: PropertyIn):
    """Create a new property listing"""
    doc = prop.model_dump()
    result = await db.properties_collection.insert_one(doc)
    print(f"📥 Property saved: {result.inserted_id}")
    return ApiResponse(message="Property listed successfully", code=200)


@app.get("/api/demo/properties/search")
async def search_properties(
    location: Optional[str] = None,
    property_type: Optional[str] = None,
    bedrooms: Optional[str] = None,
    min_price: Optional[int] = None,
    max_price: Optional[int] = None,
    min_area: Optional[float] = None,
    is_furnished: Optional[bool] = None,
):
    """Search property listings — all params optional, at least one required"""
    conditions = []

    if location:
        conditions.append({
            "$or": [
                {"location": {"$regex": location, "$options": "i"}},
                {"district": {"$regex": location, "$options": "i"}},
            ]
        })
    if property_type:
        conditions.append({"propertyType": property_type})
    if bedrooms:
        conditions.append({"bedrooms": bedrooms})
    if min_price is not None:
        conditions.append({"price": {"$gte": min_price}})
    if max_price is not None:
        conditions.append({"price": {"$lte": max_price}})
    if min_area is not None:
        conditions.append({"areaSqm": {"$gte": min_area}})
    if is_furnished is not None:
        conditions.append({"isFurnished": is_furnished})

    if not conditions:
        raise HTTPException(
            status_code=400,
            detail="At least one search filter is required",
        )

    query = {"$and": conditions} if len(conditions) > 1 else conditions[0]
    props = []
    async for doc in db.properties_collection.find(query).sort("_id", -1).limit(50):
        doc["id"] = str(doc.pop("_id"))
        props.append(doc)
    return {"properties": props, "total": len(props)}


@app.get("/api/demo/properties")
async def list_properties():
    """List all property listings"""
    props = []
    async for doc in db.properties_collection.find().sort("_id", -1):
        doc["id"] = str(doc.pop("_id"))
        props.append(doc)
    return {"properties": props, "total": len(props)}


# ─── Clinic Appointment Schemas ───────────────────────────────────────────────

class AppointmentIn(BaseModel):
    patientName: str = Field(..., min_length=2, max_length=100)
    idCard: str = Field(..., min_length=13, max_length=13)
    phone: str = Field(..., min_length=9, max_length=10)
    department: Literal[
        "internal_medicine", "surgery", "pediatrics",
        "obstetrics", "ophthalmology", "ent", "orthopedics"
    ]
    appointmentType: Literal["OPD", "Telemedicine"]
    appointmentDate: str = Field(..., pattern=r"^\d{4}-\d{2}-\d{2}$")
    appointmentTime: str = Field(..., pattern=r"^\d{2}:\d{2}$")
    hasInsurance: bool = False
    note: Optional[str] = Field(default="", max_length=500)

    @field_validator("idCard")
    @classmethod
    def id_card_digits_only(cls, v: str) -> str:
        if not v.isdigit():
            raise ValueError("ID card must contain digits only")
        return v

    @field_validator("phone")
    @classmethod
    def phone_digits_only(cls, v: str) -> str:
        if not v.isdigit():
            raise ValueError("Phone must contain digits only")
        return v

    @field_validator("appointmentDate")
    @classmethod
    def date_must_not_be_past(cls, v: str) -> str:
        from datetime import date
        try:
            appt_date = date.fromisoformat(v)
        except ValueError:
            raise ValueError("Invalid date format, expected YYYY-MM-DD")
        if appt_date < date.today():
            raise ValueError("Appointment date must not be in the past")
        return v

    @field_validator("appointmentTime")
    @classmethod
    def time_must_be_in_range(cls, v: str) -> str:
        hour, minute = int(v[:2]), int(v[3:])
        if not (8 <= hour <= 20):
            raise ValueError("Appointment time must be between 08:00 and 20:00")
        if minute not in (0, 15, 30, 45):
            raise ValueError("Minutes must be 00, 15, 30 or 45")
        return v


# ─── Clinic Appointment Routes ────────────────────────────────────────────────

@app.post("/api/demo/clinic/appointments", response_model=ApiResponse)
async def book_appointment(appt: AppointmentIn):
    """Book a new clinic appointment"""
    doc = appt.model_dump()
    result = await db.appointments_collection.insert_one(doc)
    print(f"📥 Appointment saved: {result.inserted_id}")
    return ApiResponse(message="Appointment booked successfully", code=200)


@app.get("/api/demo/clinic/appointments")
async def list_appointments():
    """List all clinic appointments"""
    items = []
    async for doc in db.appointments_collection.find().sort("_id", -1):
        doc["id"] = str(doc.pop("_id"))
        items.append(doc)
    return {"appointments": items, "total": len(items)}


# ─── Entrypoint ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=settings.port, reload=True)

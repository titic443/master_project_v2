from contextlib import asynccontextmanager
from typing import Literal, Optional
from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel, EmailStr, Field, field_validator
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


db = Database()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    db.client = AsyncIOMotorClient(settings.mongo_uri)
    db.collection = db.client.get_default_database()["profiles"]
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


# ─── Entrypoint ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=settings.port, reload=True)

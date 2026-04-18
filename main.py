from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import contact, chat

app = FastAPI(
    title="Digital Renforcy API",
    description="Backend FastAPI pour digitalrenforcy.com",
    version="1.0.0",
    docs_url="/docs" if settings.environment == "development" else None,
    redoc_url=None,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.frontend_url],
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type", "Authorization"],
)

app.include_router(contact.router)
app.include_router(chat.router)


@app.get("/api/health", tags=["system"])
async def health():
    return {"status": "ok", "service": "digital-renforcy-api"}

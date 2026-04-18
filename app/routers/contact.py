from fastapi import APIRouter, HTTPException
from app.models.lead import LeadCreate, LeadResponse
from app.services.lead_service import save_lead

router = APIRouter(prefix="/api/contact", tags=["contact"])


@router.post("", response_model=LeadResponse, status_code=201)
async def create_lead(lead: LeadCreate):
    try:
        await save_lead(lead)
    except Exception as exc:
        raise HTTPException(status_code=500, detail="Erreur lors de l'enregistrement.") from exc
    return LeadResponse(ok=True)

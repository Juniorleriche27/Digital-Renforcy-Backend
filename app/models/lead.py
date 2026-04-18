from pydantic import BaseModel
from typing import Optional


class LeadCreate(BaseModel):
    name: str = ""
    phone: str = ""
    sector: str = "autre"
    source: str = "form"
    email: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    service: Optional[str] = None
    formule: Optional[str] = None
    company_name: Optional[str] = None
    company_size: Optional[str] = None
    situation: Optional[str] = None
    objectif: Optional[str] = None
    website: Optional[str] = None
    discovery_source: Optional[str] = None
    callback_date: Optional[str] = None
    callback_time: Optional[str] = None
    consent: Optional[bool] = None


class LeadResponse(BaseModel):
    ok: bool
    message: str = "Votre demande a bien été reçue. Nous vous rappelons sous 24h."

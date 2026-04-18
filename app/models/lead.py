from pydantic import BaseModel, field_validator
from typing import Literal


class LeadCreate(BaseModel):
    name: str
    phone: str
    sector: Literal["renovation", "formation", "autre"]
    source: str = "form"

    @field_validator("name", "phone")
    @classmethod
    def not_empty(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Ce champ est obligatoire.")
        return v.strip()


class LeadResponse(BaseModel):
    ok: bool
    message: str = "Votre demande a bien été reçue. Nous vous rappelons sous 24h."

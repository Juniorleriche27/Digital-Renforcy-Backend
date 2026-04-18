from app.database import get_supabase
from app.models.lead import LeadCreate

_RENOVATION = {"renovation", "btp", "artisan", "électricien", "plombier", "peintre",
               "maçon", "menuiserie", "isolation", "carrelage", "chauffage"}
_FORMATION = {"formation", "coach", "consultant", "e-learning"}


def _map_sector(raw: str) -> str:
    lower = raw.lower()
    if any(k in lower for k in _FORMATION):
        return "formation"
    if any(k in lower for k in _RENOVATION):
        return "renovation"
    return "autre"


async def save_lead(lead: LeadCreate) -> dict:
    db = get_supabase()

    name = lead.name
    if not name and (lead.first_name or lead.last_name):
        name = f"{lead.first_name or ''} {lead.last_name or ''}".strip()

    sector = _map_sector(lead.sector) if lead.sector else "autre"

    row: dict = {
        "name": name or "—",
        "phone": lead.phone or "—",
        "sector": sector,
        "source": lead.source,
    }

    extras = (
        "email", "first_name", "last_name", "service", "formule",
        "company_name", "company_size", "situation", "objectif",
        "website", "discovery_source", "callback_date", "callback_time", "consent",
    )
    for field in extras:
        val = getattr(lead, field, None)
        if val is not None:
            row[field] = val

    result = db.table("leads").insert(row).execute()
    return result.data[0] if result.data else {}

from app.database import get_supabase
from app.models.lead import LeadCreate


async def save_lead(lead: LeadCreate) -> dict:
    db = get_supabase()
    result = (
        db.table("leads")
        .insert({
            "name": lead.name,
            "phone": lead.phone,
            "sector": lead.sector,
            "source": lead.source,
        })
        .execute()
    )
    return result.data[0] if result.data else {}

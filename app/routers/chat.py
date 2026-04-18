from fastapi import APIRouter, HTTPException
from app.models.chat import ChatMessage, ChatResponse
from app.services.chatbot import chat

router = APIRouter(prefix="/api/chat", tags=["chat"])


@router.post("", response_model=ChatResponse)
async def chat_endpoint(body: ChatMessage):
    if not body.message.strip():
        raise HTTPException(status_code=400, detail="Le message ne peut pas être vide.")
    try:
        reply, session_id = await chat(body.message, body.session_id)
    except Exception as exc:
        raise HTTPException(status_code=500, detail="Erreur du service chatbot.") from exc
    return ChatResponse(reply=reply, session_id=session_id)

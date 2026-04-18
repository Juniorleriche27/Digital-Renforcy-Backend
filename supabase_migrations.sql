-- Migration: Digital Renforcy Backend
-- Run this in your Supabase SQL Editor

-- Leads table: stores contact form submissions
CREATE TABLE IF NOT EXISTS leads (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL,
    phone       TEXT NOT NULL,
    sector      TEXT NOT NULL CHECK (sector IN ('renovation', 'formation', 'autre')),
    source      TEXT NOT NULL DEFAULT 'form',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for chronological queries
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads (created_at DESC);

-- Chat sessions table: stores conversation history per session
CREATE TABLE IF NOT EXISTS chat_sessions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id  TEXT NOT NULL UNIQUE,
    messages    JSONB NOT NULL DEFAULT '[]',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_session_id ON chat_sessions (session_id);

-- Auto-update updated_at on chat_sessions
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chat_sessions_updated_at
    BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Row Level Security: service role bypasses RLS (used server-side only)
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;

-- Only the service role can read/write (backend uses service key)
CREATE POLICY "service_role_leads" ON leads
    USING (auth.role() = 'service_role');

CREATE POLICY "service_role_chat_sessions" ON chat_sessions
    USING (auth.role() = 'service_role');

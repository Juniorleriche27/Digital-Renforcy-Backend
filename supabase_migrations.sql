-- Migration: Digital Renforcy Backend
-- Rejouable a tout moment sans erreur (IF NOT EXISTS partout)
-- Copiez et executez l'integralite dans le SQL Editor Supabase

-- ── Leads ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS leads (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name             TEXT NOT NULL,
    phone            TEXT NOT NULL,
    sector           TEXT NOT NULL CHECK (sector IN ('renovation', 'formation', 'autre')),
    source           TEXT NOT NULL DEFAULT 'form',
    email            TEXT,
    first_name       TEXT,
    last_name        TEXT,
    service          TEXT,
    formule          TEXT,
    company_name     TEXT,
    company_size     TEXT,
    situation        TEXT,
    objectif         TEXT,
    website          TEXT,
    discovery_source TEXT,
    callback_date    TEXT,
    callback_time    TEXT,
    consent          BOOLEAN DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Colonnes ajoutees apres la creation initiale (sans erreur si deja presentes)
ALTER TABLE leads ADD COLUMN IF NOT EXISTS email            TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS first_name       TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS last_name        TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS service          TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS formule          TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS company_name     TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS company_size     TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS situation        TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS objectif         TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS website          TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS discovery_source TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS callback_date    TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS callback_time    TEXT;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS consent          BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads (created_at DESC);

-- ── Chat sessions ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_sessions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id  TEXT NOT NULL UNIQUE,
    messages    JSONB NOT NULL DEFAULT '[]',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_session_id ON chat_sessions (session_id);

-- ── Trigger updated_at ──────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS chat_sessions_updated_at ON chat_sessions;
CREATE TRIGGER chat_sessions_updated_at
    BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── Row Level Security ──────────────────────────────────────────────────────
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "service_role_leads" ON leads;
CREATE POLICY "service_role_leads" ON leads
    USING (auth.role() = 'service_role');

DROP POLICY IF EXISTS "service_role_chat_sessions" ON chat_sessions;
CREATE POLICY "service_role_chat_sessions" ON chat_sessions
    USING (auth.role() = 'service_role');

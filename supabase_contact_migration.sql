-- Run this in the Supabase SQL Editor to add extended columns for the contact form
ALTER TABLE leads
  ADD COLUMN IF NOT EXISTS email text,
  ADD COLUMN IF NOT EXISTS first_name text,
  ADD COLUMN IF NOT EXISTS last_name text,
  ADD COLUMN IF NOT EXISTS service text,
  ADD COLUMN IF NOT EXISTS formule text,
  ADD COLUMN IF NOT EXISTS company_name text,
  ADD COLUMN IF NOT EXISTS company_size text,
  ADD COLUMN IF NOT EXISTS situation text,
  ADD COLUMN IF NOT EXISTS objectif text,
  ADD COLUMN IF NOT EXISTS website text,
  ADD COLUMN IF NOT EXISTS discovery_source text,
  ADD COLUMN IF NOT EXISTS callback_date text,
  ADD COLUMN IF NOT EXISTS callback_time text,
  ADD COLUMN IF NOT EXISTS consent boolean DEFAULT false;

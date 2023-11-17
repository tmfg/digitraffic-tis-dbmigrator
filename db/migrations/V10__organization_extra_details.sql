CREATE TYPE company_language AS ENUM ('fi', 'sv', 'en');

ALTER TABLE organization
    ADD COLUMN IF NOT EXISTS contact_emails TEXT[] DEFAULT array[]::text[],
    ADD COLUMN IF NOT EXISTS language company_language NOT NULL DEFAULT 'fi';

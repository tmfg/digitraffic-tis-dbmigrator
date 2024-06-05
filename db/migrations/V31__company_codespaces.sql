-- add field for storing NeTEx codespace mappings for companies
ALTER TABLE company
    ADD COLUMN IF NOT EXISTS codespaces TEXT[] DEFAULT array[]::text[];

-- notifications is a list of emails entry related event notifications should be sent to.
-- This is somewhat similar to company.contact_emails
ALTER TABLE entry
    ADD COLUMN notifications TEXT[] DEFAULT ARRAY []::TEXT[];

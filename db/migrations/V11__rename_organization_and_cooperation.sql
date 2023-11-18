-- Organization is a conflicting term with Fintraffic ID's domain model and thus it was  agreed we'll rename it
-- to avoid confusion.
ALTER TABLE organization
    RENAME TO company;

ALTER TABLE entry
    RENAME CONSTRAINT fk_organization_business_id TO fk_entry_company_business_id;

-- Changes publishing to false by default, and enables it only for Fintraffic and TRAFICOM (if they exist) by default
-- this is to avoid flooding downstream data consumers
ALTER TABLE company
    ALTER COLUMN publish SET DEFAULT FALSE;
UPDATE company
   SET publish = FALSE;
UPDATE company
   SET publish = TRUE
 WHERE business_id IN ('2942108-7', '2924753-3');

-- # adding company roles to company
ALTER TABLE company
    ADD COLUMN IF NOT EXISTS roles TEXT[] DEFAULT '{"operator"}';

-- # add authority role to existing authorities
UPDATE company
   SET roles = ARRAY_APPEND(roles, 'authority')
 WHERE id IN (SELECT DISTINCT partner_a_id
                FROM partnership
               WHERE partnership.type = 'authority-provider')
   AND NOT company.roles @> ARRAY ['authority'];

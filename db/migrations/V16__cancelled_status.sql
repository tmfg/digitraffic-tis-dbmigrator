-- add cancelled status as some tasks may be cancelled if their prerequisuites are not executed
ALTER TYPE status ADD VALUE 'cancelled' BEFORE 'errors';

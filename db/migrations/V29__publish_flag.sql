-- company level flag for controlling whether entries should be published to e.g. aggregate database
ALTER TABLE company
  ADD COLUMN publish BOOLEAN DEFAULT TRUE;

-- rename created_at
ALTER TABLE addiction_reset_log
    RENAME COLUMN created_at TO resume_time;
-- remove defaults
ALTER TABLE addiction_reset_log
ALTER COLUMN reset_time
SET DEFAULT NULL;
ALTER TABLE addiction_reset_log
ALTER COLUMN resume_time
SET DEFAULT NULL;
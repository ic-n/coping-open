-- add trigger fail link
ALTER TABLE addiction_reset_log
ADD COLUMN trigger_id bigint NULL;
ALTER TABLE addiction_reset_log
ADD CONSTRAINT addiction_reset_log_trigger_id_key UNIQUE (trigger_id);
ALTER TABLE addiction_reset_log
ADD CONSTRAINT addiction_reset_log_trigger_id_fkey FOREIGN KEY (trigger_id) REFERENCES trigger_logs (id);
CREATE TABLE trigger_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID,
    meta_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX trigger_logs_user_id_idx ON trigger_logs USING BRIN (user_id);
CREATE INDEX trigger_logs_meta_id_idx ON trigger_logs USING BRIN (meta_id);
ALTER TABLE trigger_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authed users" ON "public"."trigger_logs" FOR
SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."trigger_logs" FOR
INSERT WITH CHECK (auth.uid() = user_id);
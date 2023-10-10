CREATE TABLE triggers (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID,
    meta_id TEXT,
    related_addiction TEXT,
    label TEXT
);
CREATE INDEX triggers_user_id_idx ON triggers USING BRIN (user_id);
CREATE INDEX triggers_meta_id_idx ON triggers USING BRIN (meta_id);
ALTER TABLE triggers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authed users" ON "public"."triggers" FOR
SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable update access for authed users" ON "public"."triggers" FOR
UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Enable delete access for authed users" ON "public"."triggers" FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."triggers" FOR
INSERT WITH CHECK (auth.uid() = user_id);
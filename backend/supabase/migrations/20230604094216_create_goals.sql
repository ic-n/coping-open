CREATE TABLE goals (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID,
    meta_id TEXT,
    title TEXT,
    icon_name TEXT,
    related_addiction TEXT,
    author TEXT,
    links TEXT ARRAY,
    descriptions JSONB DEFAULT '{}',
    rate_seconds BIGINT
);
CREATE INDEX goals_user_id_idx ON goals USING BRIN (user_id);
CREATE INDEX goals_meta_id_idx ON goals USING BRIN (meta_id);
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authed users" ON "public"."goals" FOR
SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable update access for authed users" ON "public"."goals" FOR
UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Enable delete access for authed users" ON "public"."goals" FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."goals" FOR
INSERT WITH CHECK (auth.uid() = user_id);
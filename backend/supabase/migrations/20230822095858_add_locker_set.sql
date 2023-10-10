CREATE TABLE locker_sets (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID,
    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX locker_sets_user_id_idx ON locker_sets USING BRIN (user_id);
ALTER TABLE locker_sets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authed users" ON "public"."locker_sets" FOR
SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."locker_sets" FOR
INSERT WITH CHECK (auth.uid() = user_id);
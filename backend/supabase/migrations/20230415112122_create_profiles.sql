CREATE TABLE profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID UNIQUE,
    first_name TEXT,
    second_name TEXT,
    breathing_time REAL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX profile_user_id_idx ON profiles
    USING BRIN (user_id);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for authed users" ON "public"."profiles"
    FOR SELECT
    USING (auth.uid() = user_id);
CREATE POLICY "Enable update access for authed users" ON "public"."profiles"
    FOR UPDATE
    USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."profiles"
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);
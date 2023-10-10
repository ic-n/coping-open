ALTER TABLE profiles ADD no_smoking_time TIMESTAMPTZ DEFAULT NOW();

CREATE TABLE no_smoking_log (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID UNIQUE,
    no_smoking_time TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX no_smoking_log_user_id_idx ON no_smoking_log
    USING BRIN (user_id);

ALTER TABLE no_smoking_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for authed users" ON "public"."no_smoking_log"
    FOR SELECT
    USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."no_smoking_log"
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);
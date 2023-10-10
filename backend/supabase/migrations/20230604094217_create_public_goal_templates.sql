CREATE TABLE public_goal_templates (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID UNIQUE,
    title TEXT,
    icon_name TEXT,
    related_addiction TEXT,
    author TEXT,
    links TEXT ARRAY,
    descriptions JSONB DEFAULT '{}',
    rate_seconds BIGINT
);
CREATE INDEX public_goal_templates_user_id_idx ON public_goal_templates USING BRIN (user_id);
ALTER TABLE public_goal_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable public read access for all users" ON "public"."public_goal_templates" FOR
SELECT USING (TRUE);
CREATE POLICY "Enable update access for authed users" ON "public"."public_goal_templates" FOR
UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Enable delete access for authed users" ON "public"."public_goal_templates" FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Enable write access for public" ON "public"."public_goal_templates" FOR
INSERT WITH CHECK (auth.uid() = user_id);
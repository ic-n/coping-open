CREATE TABLE static_goal_templates (
    id BIGSERIAL PRIMARY KEY,
    title TEXT,
    icon_name TEXT,
    related_addiction TEXT,
    author TEXT,
    links TEXT ARRAY,
    descriptions JSONB DEFAULT '{}',
    rate_seconds BIGINT
);
ALTER TABLE static_goal_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable public read access for all users" ON "public"."static_goal_templates" FOR
SELECT USING (TRUE);
CREATE POLICY "Enable full access for admin users" ON "public"."static_goal_templates" FOR ALL TO dashboard_user;
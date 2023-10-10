CREATE TABLE static_trigger_templates (
    id BIGSERIAL PRIMARY KEY,
    related_addiction TEXT,
    author TEXT,
    label TEXT
);
ALTER TABLE static_trigger_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable public read access for all users" ON "public"."static_trigger_templates" FOR
SELECT USING (TRUE);
CREATE POLICY "Enable full access for admin users" ON "public"."static_trigger_templates" FOR ALL TO dashboard_user;
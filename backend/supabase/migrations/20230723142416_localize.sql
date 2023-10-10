-- (1) goals
-- localize title
ALTER TABLE static_goal_templates
ADD COLUMN v2_titles JSONB;
UPDATE static_goal_templates
SET v2_titles = jsonb_build_object('en', src.title)
FROM static_goal_templates src
WHERE src.id = static_goal_templates.id;
-- localize descriptions
ALTER TABLE static_goal_templates
ADD COLUMN v2_descriptions JSONB;
UPDATE static_goal_templates
SET v2_descriptions = src.descriptions
FROM static_goal_templates src
WHERE src.id = static_goal_templates.id;
---
-- (2) triggers
-- localize title
ALTER TABLE static_trigger_templates
ADD COLUMN v2_labels JSONB;
UPDATE static_trigger_templates
SET v2_labels = jsonb_build_object('en', src.label)
FROM static_trigger_templates src
WHERE src.id = static_trigger_templates.id;
---
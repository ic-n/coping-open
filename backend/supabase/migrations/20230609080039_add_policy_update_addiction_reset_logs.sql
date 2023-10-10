CREATE POLICY "Enable update access for public" ON "public"."addiction_reset_log" FOR
UPDATE USING (auth.uid() = user_id);
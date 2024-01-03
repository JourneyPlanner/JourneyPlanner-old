CREATE
POLICY "allow select for user when member of journey" ON "public"."journey"
AS PERMISSIVE FOR
SELECT
    TO authenticated
    USING (select 1 from user_is_in where user_is_in.pk_journey_uuid = journey.pk_journey_uuid and auth.uid() = pk_user_uuid)

CREATE
POLICY "allow users access to their own journey membership" ON "public"."user_is_in"
AS PERMISSIVE FOR
SELECT
    TO authenticated
    USING (auth.uid() = pk_user_uuid);

CREATE
POLICY "allow users access to their own username" ON "public"."user"
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = pk_uuid)
WITH CHECK (auth.uid() = pk_uuid);

CREATE
POLICY "Enable username read access for all users" ON "public"."user"
AS PERMISSIVE FOR
SELECT
    TO public
    USING (true);

-- Parameters need to be prefixed because the name clashes with `jm`'s columns
CREATE FUNCTION is_member_of(_pk_user_uuid uuid, _pk_journey_uuid uuid) RETURNS bool AS $$
SELECT EXISTS (SELECT 1
               FROM user_is_in uii
               WHERE uii.pk_journey_uuid = _pk_journey_uuid
                 AND uii.pk_user_uuid = _pk_user_uuid);
$$
LANGUAGE sql SECURITY DEFINER;
-- Function is owned by postgres which bypasses RLS

CREATE
POLICY "allow journey membership read access for other members of journ" ON "public"."user_is_in"
AS PERMISSIVE FOR
SELECT
    TO authenticated
    USING (is_member_of(auth.uid(), pk_journey_uuid));

CREATE
POLICY "allow users to create journeys" ON "public"."journey"
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE
POLICY "allow journey members to view activities" ON "public"."activity"
AS PERMISSIVE FOR
SELECT
    TO authenticated
    USING (1 = (select 1 from user_is_in where user_is_in.pk_journey_uuid = activity.fk_journey_uuid and auth.uid() = user_is_in.pk_user_uuid))

CREATE
POLICY "allow group leader full access to activities" ON "public"."activity"
AS PERMISSIVE FOR ALL
TO authenticated
USING (1 = (select 1 from user_is_in where user_is_in.pk_journey_uuid = activity.fk_journey_uuid and auth.uid() = user_is_in.pk_user_uuid and user_is_in.function = 1))
WITH CHECK (1 = (select 1 from user_is_in where user_is_in.pk_journey_uuid = activity.fk_journey_uuid and auth.uid() = user_is_in.pk_user_uuid and user_is_in.function = 1));

CREATE POLICY "delete journey when reiseleiter" ON "public"."journey"
AS PERMISSIVE FOR DELETE
TO authenticated
USING ((1 = ( SELECT 1 FROM user_is_in WHERE ((journey.pk_journey_uuid = user_is_in.pk_journey_uuid) AND (uid() = user_is_in.pk_user_uuid) AND (user_is_in.function = 1)))))

CREATE
    POLICY "allow select for user when member of journey" ON "public"."journey"
    AS PERMISSIVE FOR
    SELECT
    TO authenticated
    USING (1 = (select 1
                from user_is_in
                where user_is_in.pk_journey_uuid = journey.pk_journey_uuid
                  and auth.uid() = pk_user_uuid));

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
CREATE FUNCTION is_member_of(_pk_user_uuid uuid, _pk_journey_uuid uuid) RETURNS bool AS
$$
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
    USING (1 = (select 1
                from user_is_in
                where user_is_in.pk_journey_uuid = activity.fk_journey_uuid
                  and auth.uid() = user_is_in.pk_user_uuid));

CREATE
    POLICY "allow group leader full access to activities" ON "public"."activity"
    AS PERMISSIVE FOR ALL
    TO authenticated
    USING (1 = (select 1
                from user_is_in
                where user_is_in.pk_journey_uuid = activity.fk_journey_uuid
                  and auth.uid() = user_is_in.pk_user_uuid
                  and user_is_in.function = 1))
    WITH CHECK (1 = (select 1
                     from user_is_in
                     where user_is_in.pk_journey_uuid = activity.fk_journey_uuid
                       and auth.uid() = user_is_in.pk_user_uuid
                       and user_is_in.function = 1));

CREATE POLICY "delete journey when reiseleiter" ON "public"."journey"
    AS PERMISSIVE FOR DELETE
    TO authenticated
    USING ((1 = (SELECT 1
                 FROM user_is_in
                 WHERE ((journey.pk_journey_uuid = user_is_in.pk_journey_uuid) AND (uid() = user_is_in.pk_user_uuid) AND
                        (user_is_in.function = 1)))));

CREATE POLICY "allow journey admins to update other journey members" ON "public"."user_is_in"
    AS PERMISSIVE FOR UPDATE
    TO authenticated
    USING ((pk_journey_uuid IN (SELECT user_is_in_1.pk_journey_uuid
                                FROM user_is_in user_is_in_1
                                WHERE ((user_is_in_1.pk_user_uuid = uid()) AND (user_is_in_1.function = 1)))))
    WITH CHECK ((pk_journey_uuid IN (SELECT user_is_in_1.pk_journey_uuid
                                     FROM user_is_in user_is_in_1
                                     WHERE ((user_is_in_1.pk_user_uuid = uid()) AND (user_is_in_1.function = 1)))));

CREATE POLICY "Give users access to media in their journeys 1l5u1vl_0" ON storage.objects FOR SELECT TO authenticated USING ((
    (bucket_id = 'upload'::text) AND is_member_of(uid(), ((storage.foldername(name))[1])::uuid)));

CREATE POLICY "Give users access to media in their journeys 1l5u1vl_1" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((
    (bucket_id = 'upload'::text) AND is_member_of(uid(), ((storage.foldername(name))[1])::uuid)));

CREATE POLICY "full access to media files for journey admins 1l5u1vl_0" ON storage.objects FOR DELETE TO authenticated USING (
    (bucket_id = 'upload') AND (1 = (SELECT 1
                                     FROM user_is_in
                                     WHERE ((((storage.foldername(name))[1])::uuid) = user_is_in.pk_journey_uuid)
                                       AND (uid() = user_is_in.pk_user_uuid)
                                       AND (user_is_in.function = 1))));

CREATE POLICY "full access to media files for journey admins 1l5u1vl_1" ON storage.objects FOR UPDATE TO authenticated USING (
    (bucket_id = 'upload') AND (1 = (SELECT 1
                                     FROM user_is_in
                                     WHERE ((((storage.foldername(name))[1])::uuid) = user_is_in.pk_journey_uuid)
                                       AND (uid() = user_is_in.pk_user_uuid)
                                       AND (user_is_in.function = 1))));

CREATE POLICY "full access to media files for journey admins 1l5u1vl_2" ON storage.objects FOR SELECT TO authenticated USING (
    (bucket_id = 'upload') AND (1 = (SELECT 1
                                     FROM user_is_in
                                     WHERE ((((storage.foldername(name))[1])::uuid) = user_is_in.pk_journey_uuid)
                                       AND (uid() = user_is_in.pk_user_uuid)
                                       AND (user_is_in.function = 1))));

CREATE POLICY "full access to media files for journey admins 1l5u1vl_3" ON storage.objects FOR INSERT TO authenticated WITH CHECK (
    (bucket_id = 'upload') AND (1 = (SELECT 1
                                     FROM user_is_in
                                     WHERE ((((storage.foldername(name))[1])::uuid) = user_is_in.pk_journey_uuid)
                                       AND (uid() = user_is_in.pk_user_uuid)
                                       AND (user_is_in.function = 1))));

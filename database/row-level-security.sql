create policy "Allow select for user when member of journey" on journey
    for select using ((pk_journey_uuid = (select user_is_in.pk_journey_uuid from user_is_in where (user_is_in.pk_journey_uuid = auth.uid()))));

create policy "Allow select for user" on user_is_in
    for select using (auth.uid() = pk_user_uuid);
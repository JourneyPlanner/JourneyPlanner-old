alter table journey
    enable row level security;

create policy "Allow create for authenticated users" on journey
    for insert to authenticated with check (true);

create policy "Allow select for user when member of journey" on journey
    for select using ((pk_journey_uuid = (select user_is_in.pk_journey_uuid from user_is_in where (user_is_in.pk_journey_uuid = auth.uid()))));


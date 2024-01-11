create or replace function public.add_user_to_journey(
    in user_id uuid,
    in invite_code uuid
)
    returns void
    SECURITY DEFINER
as
$$
declare
    journey_id uuid;
begin
    select pk_journey_uuid
    into journey_id
    from journey
    where invite = invite_code;

    if journey_id IS NOT NULL then
        insert into user_is_in (pk_user_uuid, pk_journey_uuid)
        values (user_id, journey_id);
        return;
    else
        raise exception 'Incorrect invite code';
    end if;
end;
$$ language plpgsql;

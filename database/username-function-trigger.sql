/**
function & trigger:
on user sign up, insert the username given as option in our custom user table
**/

create or replace function public.handle_new_user()
    returns trigger as
$$
begin
    if new.raw_user_meta_data ->> 'username' is not null then
        insert into public.user (pk_uuid, username)
        values (new.id, new.raw_user_meta_data ->> 'username');
        return new;
    else
        insert into public.user (pk_uuid, username)
        values (new.id, new.raw_user_meta_data ->> 'name');
        return new;
    end if;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
    after insert
    on auth.users
    for each row
execute procedure public.handle_new_user();


create or replace function public.handle_user_update()
    returns trigger as
$$
begin
    -- delete if exists, then insert
    -- this is a hotfix, the sane way of doing this (update) was somehow broken
    delete from public.user where pk_uuid = old.id;
    if new.raw_user_meta_data ->> 'username' is not null then
        insert into public.user (pk_uuid, username)
        values (new.id, new.raw_user_meta_data ->> 'username');
        return new;
    else
        insert into public.user (pk_uuid, username)
        values (new.id, new.raw_user_meta_data ->> 'name');
        return new;
    end if;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_updated
    after update
    on auth.users
    for each row
execute procedure public.handle_user_update();

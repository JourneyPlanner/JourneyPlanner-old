/**
function & trigger:
on user sign up, insert the username given as option in our custom user table
**/

create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.user (pk_uuid, username)
  values (new.id, new.raw_user_meta_data->>'username');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

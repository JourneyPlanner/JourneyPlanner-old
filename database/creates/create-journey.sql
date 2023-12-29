create table
  public.journey (
    pk_journey_uuid uuid not null default gen_random_uuid (),
    name text null,
    "from" date null,
    "to" date null,
    place text null,
    invite uuid not null default gen_random_uuid (),
    constraint journey_pkey primary key (pk_journey_uuid),
    constraint journey_invite_key unique (invite)
  ) tablespace pg_default;

create trigger insert_user_in_trigger
after insert on journey for each row
execute function insert_user_in_on_journey_insert ();

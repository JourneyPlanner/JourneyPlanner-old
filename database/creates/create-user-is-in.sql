create table
  public.user_is_in (
    pk_user_uuid uuid not null,
    pk_journey_uuid uuid not null,
    function smallint null default '0'::smallint,
    constraint user_is_in_pkey primary key (pk_user_uuid, pk_journey_uuid),
    constraint user_is_in_pk_user_uuid_fkey foreign key (pk_user_uuid) references "user" (pk_uuid) on update cascade on delete cascade,
    constraint user_is_in_pk_journey_uuid_fkey foreign key (pk_journey_uuid) references journey (pk_journey_uuid) on update cascade on delete cascade
  ) tablespace pg_default;

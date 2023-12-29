create table
  public.user (
    pk_uuid uuid not null,
    username text not null,
    constraint user_pkey primary key (pk_uuid),
    constraint user_username_key unique (username),
    constraint user_pk_uuid_fkey foreign key (pk_uuid) references users (id) on update cascade on delete cascade
  ) tablespace pg_default;

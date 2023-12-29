create table
  public.activity (
    pk_activity_uuid uuid not null default gen_random_uuid (),
    contact text null,
    address text null,
    cost text null,
    opening_hours text null,
    google_maps_link text null,
    name text null,
    description text null,
    estimated_duration integer null,
    added_to_calendar boolean null default false,
    cal_date_start date null,
    cal_from time without time zone null,
    cal_to time without time zone null,
    fk_journey_uuid uuid null,
    cal_date_end date null,
    constraint activity_pkey primary key (pk_activity_uuid),
    constraint activity_fk_journey_uuid_fkey foreign key (fk_journey_uuid) references journey (pk_journey_uuid) on update cascade on delete cascade
  ) tablespace pg_default;

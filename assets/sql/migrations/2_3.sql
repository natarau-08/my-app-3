drop table tag_tracking;

create table cars (
    id integer primary key autoincrement,
    brand text not null,
    model text not null,
    `year` integer not null,
    odometer integer not null
);

create table car_revision_types (
    id integer primary key autoincrement,
    `name` text not null unique,
    interval_km integer not null,
    interval_months integer not null
);

create table car_revisions (
    id integer primary key autoincrement,
    car_id integer not null,
    revision_type_id integer not null,
    `date` text not null,
    odometer integer not null,
    foreign key (car_id) references cars (id) on delete cascade,
    foreign key (revision_type_id) references car_revision_type (id) on delete cascade
);

create table car_repairs (
    id integer primary key autoincrement,
    car_id integer not null,
    `date` text not null,
    km integer not null,
    `description` text not null,
    cost real not null,
    foreign key (car_id) references cars (id) on delete cascade
);
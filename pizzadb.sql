DROP TABLE IF EXISTS menu,person,person_order, person_visits, pizzeria, person_discounts CASCADE;

create table person
( id bigint primary key ,
  name varchar not null,
  age integer not null default 10,
  gender varchar default 'female' not null ,
  address varchar
  );

alter table person add constraint ch_gender check ( gender in ('female','male') );

create table pizzeria
(id bigint primary key ,
 name varchar not null ,
 rating numeric not null default 0);

alter table pizzeria add constraint ch_rating check ( rating between 0 and 5);

create table person_visits
(id bigint primary key ,
 person_id bigint not null ,
 pizzeria_id bigint not null ,
 visit_date date not null default current_date,
 constraint uk_person_visits unique (person_id, pizzeria_id, visit_date),
 constraint fk_person_visits_person_id foreign key  (person_id) references person(id),
 constraint fk_person_visits_pizzeria_id foreign key  (pizzeria_id) references pizzeria(id)
 );

create table menu
(id bigint primary key ,
 pizzeria_id bigint not null ,
 pizza_name varchar not null ,
 price numeric not null default 1,
 constraint fk_menu_pizzeria_id foreign key (pizzeria_id) references pizzeria(id));

create table person_order
(
    id bigint primary key ,
    person_id  bigint not null ,
    menu_id bigint not null ,
    order_date date not null default current_date,
    constraint fk_order_person_id foreign key (person_id) references person(id),
    constraint fk_order_menu_id foreign key (menu_id) references menu(id)
);
--

-- isert the full path to the files!!!

COPY person FROM '/Users/martaori/myprojects/PizzaMaddness.SQL/person.csv' WITH CSV HEADER;
COPY pizzeria FROM '/Users/martaori/myprojects/PizzaMaddness.SQL/pizzeria.csv' WITH CSV HEADER;
COPY person_visits FROM '/Users/martaori/myprojects/PizzaMaddness.SQL/person_visits.csv' WITH CSV HEADER;
COPY menu FROM '/Users/martaori/myprojects/PizzaMaddness.SQL/menu.csv' WITH CSV HEADER;
COPY person_order FROM '/Users/martaori/myprojects/PizzaMaddness.SQL/person_order.csv' WITH CSV HEADER;

-- COPY person FROM 'full path to the file/person.csv' WITH CSV HEADER;
-- COPY pizzeria FROM 'full path to the file/pizzeria.csv' WITH CSV HEADER;
-- COPY person_visits FROM 'full path to the file/person_visits.csv' WITH CSV HEADER;
-- COPY menu FROM 'full path to the file/menu.csv' WITH CSV HEADER;
-- COPY person_order FROM 'full path to the file/person_order.csv' WITH CSV HEADER;
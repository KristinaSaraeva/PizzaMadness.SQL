DROP TABLE IF EXISTS person_discounts;
--let us create the table fix those who deserve a discount
CREATE TABLE person_discounts
(
    id          bigint PRIMARY KEY,
    person_id   bigint,
    pizzeria_id bigint,
    discount    numeric,
    CONSTRAINT fk_person_discounts_person_id FOREIGN KEY (person_id) REFERENCES person (id),
    CONSTRAINT fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id) REFERENCES pizzeria (id)
);
ALTER TABLE person_discounts
    ADD CONSTRAINT ch_nn_person_id CHECK (person_id IS NOT NULL),
    ADD CONSTRAINT ch_nn_pizzeria_id CHECK (pizzeria_id IS NOT NULL),
    ADD CONSTRAINT ch_nn_discount CHECK (discount IS NOT NULL),
    ALTER COLUMN discount SET DEFAULT 0,
    ADD CONSTRAINT ch_range_discount CHECK (discount BETWEEN 0 AND 100);

-- now let us fill it

INSERT INTO person_discounts
WITH amount AS (SELECT person_id, me.pizzeria_id AS p_id, COUNT(*) AS orders
                FROM person_order
                         JOIN menu me on me.id = person_order.menu_id
                GROUP BY person_id, me.pizzeria_id)
SELECT ROW_NUMBER() OVER ( )    AS id,
       amount.person_id         AS person_id,
       amount.p_id              AS pizzeria_id,
       (SELECT CASE
                   WHEN amount.orders = 1 THEN 10.5
                   WHEN amount.orders = 2 THEN 22.0
                   ELSE 30 END) AS discount
FROM amount;

-- let us have a look at the price of pizza for each lucky customer
SELECT pr.name AS name,
       m.pizza_name AS pizza_name,
       m.price AS price,
       ROUND((m.price - m.price * (pd.discount/100))::numeric, 2) AS discount_price,
       p.name AS pizzeria_name
FROM person_order po
JOIN person pr ON pr.id=po.person_id
JOIN menu m ON m.id=po.menu_id
JOIN pizzeria p ON m.pizzeria_id = p.id AND m.pizzeria_id=p.id
JOIN person_discounts pd ON p.id = pd.pizzeria_id AND pr.id=pd.person_id
ORDER BY name, pizza_name;
--! Пункт 1
--* Создаём множество A как временное представление (как product_id товаров, которые покупали клиенты в штате MT)
CREATE OR REPLACE TEMPORARY VIEW A AS
SELECT DISTINCT oi.product_id
FROM olist.order_items AS oi
JOIN olist.orders AS o
    ON oi.order_id = o.order_id
JOIN olist.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_state = 'MT';

CREATE OR REPLACE TEMPORARY VIEW B AS
SELECT DISTINCT oi.product_id
FROM olist.order_items AS oi
JOIN olist.orders AS o
    ON oi.order_id = o.order_id
JOIN olist.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_state = 'MS';

--* Count(*) и Count(DISTINCT product_id)
SELECT COUNT(*) AS count_all, COUNT(DISTINCT product_id) AS count_distinct
FROM A

SELECT COUNT(*) AS count_all, COUNT(DISTINCT product_id) AS count_distinct
FROM B

--! Пункт 2
--* Объединение через Union
SELECT * FROM A UNION
SELECT * FROM B

--* Объединение через Union All
SELECT * FROM A UNION ALL
SELECT * FROM B

--* проверка разницы размеров
SELECT (SELECT count(*) FROM (SELECT product_id FROM A UNION ALL SELECT product_id FROM B) x)
     - (SELECT count(*) FROM (SELECT product_id FROM A UNION     SELECT product_id FROM B) y)
       AS removed_duplicates;


--! Далее несколько запросов: intersect, except, проверка коммутативности

SELECT (SELECT COUNT(*) FROM (SELECT * FROM A INTERSECT SELECT * FROM B))

SELECT (SELECT COUNT(*) FROM (SELECT * FROM A EXCEPT SELECT * FROM B))

--* Проверка коммутативности INTERSECT
SELECT (SELECT COUNT(*) FROM (SELECT * FROM A INTERSECT SELECT * FROM B))
     - (SELECT COUNT(*) FROM (SELECT * FROM B INTERSECT SELECT * FROM A)) AS intersect_commutative;

--* Проверка коммутативности EXCEPT
SELECT (SELECT COUNT(*) FROM (SELECT * FROM A EXCEPT SELECT * FROM B))
     - (SELECT COUNT(*) FROM (SELECT * FROM B EXCEPT SELECT * FROM A)) AS except_commutative;

--* intersect через exists
SELECT (SELECT COUNT(*) FROM A AS a WHERE EXISTS (SELECT * FROM B AS b WHERE a.product_id = b.product_id))
AS intersect_exists;

--! Намеренно уберём DISTINCT, чтобы показать появление дубликатов
CREATE OR REPLACE TEMPORARY VIEW A_DOUBLES AS
SELECT oi.product_id
FROM olist.order_items AS oi
JOIN olist.orders AS o
    ON oi.order_id = o.order_id
JOIN olist.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_state = 'MT';

SELECT (SELECT COUNT(*) FROM A_DOUBLES) - (SELECT COUNT(*) FROM A) AS duplicates_count;
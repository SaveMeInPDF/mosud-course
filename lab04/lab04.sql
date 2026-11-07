/*
Тета-соединение можно рассматривать как декартово произведение двух отношений, после которого выполняется
выборка по условию соединения. Эквисоединение использует равенство атрибутов, естественное соединение — одноимённые
атрибуты. Внешние соединения сохраняют строки одной или обеих сторон, даже если соответствие не найдено.

Большая часть ошибок в сложных JOIN связана не с синтаксисом, а с кратностью связей. Например,
заказ может содержать несколько позиций и несколько платежей: прямое одновременное соединение
order_items и order_payments по order_id размножит строки. Перед соединением часто требуется предварительная
агрегация до одной строки на заказ.
*/

--* Вариант:         8
--* Сценарий:       Клиенты без отзывов
--* Мин. Маршрут:   customers -> orders LEFT JOIN reviews; антисоединение.

--! 1. Построить основной запрос варианта минимум из трёх таблиц.
--? Пояснение, что происходит:
/*
Из таблицы customers вытягиваем customer_id;

Таблица orders объединяется с order_reviews так, что остаются только customer_id
с order_id, представленным в order_reviews;

Далее берём customer_id из customers, не представленные в полученной таблице
*/
--? В ходе такой реализации уже применяется антисоединение при помощи NOT IN
SELECT COUNT(*) FROM (SELECT c.customer_id FROM customers AS c
WHERE (
    c.customer_id NOT IN (
        SELECT o.customer_id FROM
        order_reviews AS r
        LEFT JOIN orders as o
        ON o.order_id = r.order_id
    )
)) AS basic_count;

--! 2. Для каждого JOIN письменно определить предполагаемую кратность связи: 1:1,
--! а также 1:N или M:N через промежуточную таблицу.
--? Предполагается связь 1:N. У каждого заказа order может быть несколько отзывов
SELECT
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1;


--! 3. Добавить один LEFT JOIN так, чтобы в результате сохранялись объекты без связанных строк.
/*
Мы это сделаем при помощи перемены мест orders и order_reviews. Так, мы сохраним все строки, 
так как связь идёт поorder_id, которые в равной степени присутствуют в обеих таблицах 
*/
SELECT COUNT(*) FROM (SELECT c.customer_id FROM customers AS c
WHERE (
    c.customer_id IN (SELECT customer_id FROM
        orders AS o
        LEFT JOIN order_reviews AS r
        ON o.order_id = r.order_id
        WHERE review_id IS NULL
    )
)) AS lj_count;


--! 4. Намеренно создать ошибочный JOIN, приводящий к размножению строк; показать,
--! по какой причине изменилась сумма или count.
SELECT COUNT(*)
FROM orders AS o
JOIN order_reviews AS r
    ON TRUE;
--? Код будет выполняться очень долго, так как мы искусственно увеличели количество строк в ответе


--! 5. Исправить ошибку предварительной агрегацией или изменением условия соединения.
SELECT COUNT(*)
FROM orders AS o
JOIN order_reviews AS r
    ON o.order_id = r.order_id;

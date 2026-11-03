/*
Выборка σ оставляет кортежи, удовлетворяющие предикату; проекция π оставляет заданные атрибуты;
переименование ρ меняет имя отношения или атрибутов. Последовательность операций можно изображать
деревом. В SQL выборке в основном соответствует WHERE, проекции — список выражений SELECT, а переименованию — AS.

При преобразовании выражений полезно применять эквивалентности: разбивать сложный предикат на несколько выборок,
выполнять селективную фильтрацию раньше и не протаскивать через промежуточные отношения ненужные столбцы.
Это станет основой оптимизации запросов в конце курса.
*/
--* Вариант 8.
-- Отношение: geolocation;
-- Предикат: state=RJ и latitude находится в выбранном диапазоне;
-- Проекция: zip_prefix, lat, lng, city

--! 1.Реализация в одну выборку
SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
FROM olist.geolocation
WHERE geolocation_state = 'RJ' AND geolocation_lat BETWEEN -23.0 AND -22.0;

--! 2.Разбиение на две последовательные выборки
SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
FROM (
    SELECT *
    FROM olist.geolocation
    WHERE geolocation_state = 'RJ'
) AS filtered_geolocation
WHERE geolocation_lat BETWEEN -23.0 AND -22.0;
--? По сути, мы выполняем ту же операцию, что и в первом запросе,
--? но делаем это в два этапа: сначала фильтруем по штату, а затем по широте.

--! 3.Второй SQL вариант, в котором ненужные столбцы исключаются раньше
SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
FROM (
    SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city
    FROM olist.geolocation
    WHERE geolocation_state = 'RJ'
) AS filtered_geolocation
WHERE geolocation_lat BETWEEN -23.0 AND -22.0;
--? Теперь мы исключаем ненужные столбцы на первом этапе, что может
--? улучшить производительность запроса, особенно если таблица
--? geolocation содержит много столбцов (а она не содержит).


--! 4.Проверка эквивалентности результатов всех трёх запросов
SELECT * FROM (
    SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
    FROM olist.geolocation
    WHERE geolocation_state = 'RJ' AND geolocation_lat BETWEEN -23.0 AND -22.0
) AS query1
EXCEPT
SELECT * FROM (
    SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
    FROM (
        SELECT *
        FROM olist.geolocation
        WHERE geolocation_state = 'RJ'
    ) AS filtered_geolocation
    WHERE geolocation_lat BETWEEN -23.0 AND -22.0
) AS query2;

SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
FROM olist.geolocation
WHERE geolocation_state = 'RJ' AND geolocation_lat BETWEEN -23.0 AND -22.0
EXCEPT
SELECT geolocation_zip_code_prefix AS zip_prefix, geolocation_lat AS lat, geolocation_lng AS lng, geolocation_city AS city
FROM (
    SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city
    FROM olist.geolocation
    WHERE geolocation_state = 'RJ'
) AS filtered_geolocation
WHERE geolocation_lat BETWEEN -23.0 AND -22.0;

--? Ни в одном из двух запросов EXCEPT не было результатов,
--? что подтверждает эквивалентность всех трёх вариантов реализации.


--! 5.Проверка возникновения дубликатов в результатах запросов
WITH sub AS (
    SELECT 
    (
        SELECT COUNT(*)
            FROM geolocation
            WHERE geolocation_lat BETWEEN -23.0 AND -22.0 AND geolocation_state = 'RJ'
    ) AS cnt_select,

    (
        SELECT COUNT(*)
            FROM (
            SELECT DISTINCT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city
            FROM geolocation
            WHERE geolocation_lat BETWEEN -23.0 AND -22.0 AND geolocation_state = 'RJ')
    ) AS cnt_distinct
) SELECT cnt_select, cnt_distinct, cnt_select - cnt_distinct AS cnt_duplicates FROM sub;
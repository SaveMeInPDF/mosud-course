# Практическая работа 3. Вариант 8

**Отношение:** `geolocation`  
**Предикат:** `state=RJ` и ` -23 ≤ lat ≤ -22` 
**Проекция:** `zip_prefix, lat, lng, city`

## 1. Исходное отношение и атрибуты

`geolocation(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)`.
Используются: `geolocation_zip_code_prefix`, `geolocation_lat`, `geolocation_lng`, `geolocation_city`.

## 2. Выражение реляционной алгебры
Обозначим `R = geolocation`
```math
\text{Q} = \rho_{\text{zip\_prefix}, \text{lat}, \text{lng}, \text{city}} (
      \pi_{\text{zip\_prefix}, \text{lat}, \text{lng}, \text{city}} (
        \sigma_{\text{state} = \text{RJ} \land -23 \le \text{lat} \le -22} (R) ) )
```
С двумя выборками
```math
Q' = \rho(\pi_{zip\_prefix, lat, lng, city}(\sigma_{state = RJ} (\sigma_{-23 \le lat \le -22} (R))))
```
С ранней проекцией
```math
Q'' = \rho(\sigma_{state = RJ \land (-23 \le lat \le -22)}(\pi_{zip\_prefix, lat, lng, city}))
```
## 3. Дубликаты и эквивалентность
Запросы `Q`, `Q'` и `Q''` эквивалентны, потому что условия в конъюнкции можно проверять в любом порядке, а проекция, не затрагивающая столбцы предиката, коммутирует с выборкой; запрос в разделе 4 файла `lab03.sql` (`EXCEPT` в обе стороны) вернул 0 строк. Ключом отношения служит `zip_prefix`, а проекция его не содержит. Один заказ может иметь несколько отзывов, поэтому кортежи с одинаковыми `zip_prefix`, `lat`, `lng` и `city` теоретически возможны, и в SQL-результате `SELECT` они останутся. `SELECT DISTINCT` их уберёт, и число строк нужно сравнить запросом 5.1. Поскольку в проекции есть `order_id` и текст комментария, заметных дубликатов ожидается немного, но проверять надо по данным.
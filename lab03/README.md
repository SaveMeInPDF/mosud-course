# Практическая работа № 3. Вариант 8

**Отношение:** `geolocation`  
**Предикат:** `state=RJ` и `-23 <= lat <= -22`  
**Проекция:** `zip_prefix, lat, lng, city`

## 1. Исходное отношение и атрибуты

`geolocation(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)`.
Используются: `geolocation_zip_code_prefix`, `geolocation_lat`, `geolocation_lng`, `geolocation_city`.

## 2. Выражение реляционной алгебры
Обозначим `R = geolocation`
$$
Q = ρ_{zip_prefix, lat, lng, city} (
      π_{zip_prefix, lat, lng, city} (
        σ_{state = RJ \land -23 \le lat \le -22} (R) ) )
$$

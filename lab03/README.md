# Практическая работа № 3. Вариант 8

**Отношение:** `geolocation`  
**Предикат:** `state=RJ` и ```math -23 \le lat \le -22```  
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
Q' = \rho(\pi(\sigma_{state = RJ} (\sigma_{-23 \le lat \le -22} (R))))
```
С ранней проекцией
```math
Q'' = \rho(\sigma_{state = RJ \land (-23 \le lat \le -22)}(\pi_{zip\_prefix, lat, lng, city}))
```
## 3. Дубликаты и эквивалентность

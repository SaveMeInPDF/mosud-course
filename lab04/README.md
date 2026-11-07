# Практическая работа 4. Вариант 8
**Сценарий:**       `Клиенты без отзывов`
**Мин. Маршрут:**   `customers` -> `orders` LEFT JOIN `reviews`; антисоединение.

## Композиция операций для основного запроса
```math
Customers \notin (Reviews \ltimes_{rid=oid} Orders)
```
\copy olist.customers from 'tmp/import_data/olist_customers_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт geolocation.
\copy olist.geolocation from 'tmp/import_data/olist_geolocation_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт orders.
\copy olist.orders from 'tmp/import_data/olist_orders_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт order_items.
\copy olist.order_items from 'tmp/import_data/olist_order_items_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт order_payments.
\copy olist.order_payments from 'tmp/import_data/olist_order_payments_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт order_reviews.
\copy olist.order_reviews from 'tmp/import_data/olist_order_reviews_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт products.
\copy olist.products from 'tmp/import_data/olist_products_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт sellers.
\copy olist.sellers from 'tmp/import_data/olist_sellers_dataset.csv' with (format csv, header true, encoding 'UTF8');
-- Импорт product_category_name_translation.
\copy olist.product_category_name_translation from 'tmp/import_data/olist_product_category_name_translation.csv' with (format csv, header true, encoding 'UTF8');

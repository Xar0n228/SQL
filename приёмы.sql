-- CREATE TABLE IF NOT EXISTS vendors (
-- id serial primary key,
-- --Показывает, что id с каждым запуском будет увеличиваться на один пункт
-- name varchar not null
-- --Констэйнты на уровне колонки, таблицы
-- );
-- 
-- CREATE TABLE IF NOT EXISTS products(
-- id serial primary key,
-- name varchar not null,
-- expiration date not null,
-- vendor_id integer,
-- --Для создание связей. Связывает пколонку из нашей таблицы с колонкой из другой. 
-- --Тут по id
-- FOREIGN KEY (vendor_id) REFERENCES vendors(id));
-- 
-- CREATE TABLE IF NOT EXISTS stores(
-- id serial primary key,
-- name varchar not null);
-- 
-- 
-- CREATE TABLE IF NOT EXISTS stores_products(
-- store_id integer not null,
-- product_id integer not null,
-- FOREIGN KEY(store_id) references stores (id),
-- FOREIGN KEY(product_id) references products (id));
-- 
-- INSERT INTO vendors(name) VALUES
--  ('name1'),
--  ('name2'),
--  ('name3');
-- INSERT INTO products(name, expiration, vendor_id) VALUES
-- ('floor', '2018-06-30', 1),
-- ('second', '2018-10-30', 2),
-- ('third', '2018-11-30', 3);


-- SELECT * FROM products;
-- 
-- SELECT * FROM products WHERE vendor_id = 3;
-- SELECT * FROM products WHERE vendor_id = 3 ORDER by name;

-- SELECT * FROM products ORDER by name;

-- SELECT * FROM products ORDER by name LIMIT 2;
-- SELECT name FROM products;


----------------------------------------------------------
-- DELETE FROM products WHERE id = 3;
-- 
-- UPDATE products SET name = 'new_name1' WHERE id = 2;


----------------------------------------------------------

--SELECT p.name, v.id FROM products p FULL OUTER JOIN vendors v ON p.vendor_id = v.id;
--SELECT * FROM products p NATURAL JOIN vendors v;

----------------------------------------------------------

-- CREATE INDEX CONCURRENTLY name_index ON products USING gist(name);


-- CREATE INDEX name_index ON products (name); B3 - тип индекса

----------------------------------------------------------

-- CREATE VIEW products_exp_view AS SELECT p.name FROM products p
-- WHERE p.expiration < '2018-08-15';


-- SELECT * FROM products_exp_view; Запрос по представлению


------------------------------ТРИГГЕРЫ------------------------------------------------

-- CREATE TABLE IF NOT EXISTS trigger_table(
-- name varchar,
-- vendor_id int,
-- date DATE);

----------------- СОЗДАЁМ ФУНКЦИЮ для триггера
-- , которая создаёт таблицу с записью изменения
-- CREATE OR REPLACE FUNCTION afterinsert()
-- RETURNS trigger AS
-- $$
--  BEGIN
--   INSERT INTO trigger_table(name, vendor_id, date)  VALUES
--    (NEW.name, NEW.vendor_id, current_date);
-- 
--    RETURN NEW;
-- 
--  END;
-- $$
-- LANGUAGE 'plpgsql';

----------------- СОЗДАЁМ ТРИГГЕР
-- CREATE TRIGGER aft_insert
-- AFTER INSERT
-- ON products
-- FOR EACH ROW
-- EXECUTE PROCEDURE afterinsert();

-- INSERT INTO products (name, vendor_id, expiration) VALUES
-- ('lemon', 1, '2018-09-09');


----------------- УДАЛЯЕМ ТРИГГЕР. ЗАТЕМ ФУНКЦИЮ
-- DROP TRIGGER aft_insert ON products;

-- DROP FUNCTION afterinsert();

----------------- СОЗДАЁМ ТРИГГЕР на событие "после обновления"
-- CREATE TABLE IF NOT EXISTS trigger_table2(
-- namr varchar,
-- description VARCHAR);

-- CREATE OR REPLACE FUNCTION afterupdate()
-- RETURNS trigger AS
-- $$
--  BEGIN
--   INSERT INTO trigger_table2(namr, description)VALUES
--   (CONCAT('Update products records', OLD.NAME));
-- 
--   RETURN NEW;
-- 
--  END;
-- $$
-- LANGUAGE 'plpgsql';

-- CREATE TRIGGER updt_price
-- AFTER UPDATE
-- ON products
-- FOR EACH ROW
-- EXECUTE PROCEDURE afterupdate();

-- UPDATE products SET name = ('fuck'); Если бы мы в функции тригера обрабатывали
-- что-то, к чему можно обратиться через NEW, то это бы мы указали здесь

----------------- СОЗДАЁМ ТРИГГЕР на событие "после удаления"
--  CREATE OR REPLACE FUNCTION aftdelete()
--  RETURNS trigger AS
--  $$
--   BEGIN
--    INSERT INTO trigger_table2(namr, description) VALUES (user, CONCAT(
--    'Update product', OLD.name, 'Expiration:', OLD.EXPIRATION, ' -> Delete on',
--    NOW()));
-- -- 
--    RETURN NEW;
--   END;
-- $$
-- LANGUAGE 'plpgsql';

-- CREATE TRIGGER delete_product
-- AFTER DELETE
-- ON products
-- FOR EACH ROW
-- EXECUTE PROCEDURE aftdelete();

-- DELETE FROM products WHERE id = 10;


-----------------------------------ТРАНЗАКЦИИ-----------------------------------------


-- BEGIN;
-- UPDATE products SET price = 200 WHERE id = 1;
-- COMMIT;


-- BEGIN;
-- UPDATE products SET price = 200 WHERE id = 1;
-- ROLLBACK;
-- Если нам надо вернуть изменения. 




 
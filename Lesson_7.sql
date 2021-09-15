

/* Задание 1: Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине */

-- Заполним таблицы users и orders:

USE shop;

INSERT INTO orders VALUES
  (DEFAULT, 1, DEFAULT, DEFAULT),
  (DEFAULT, 1, DEFAULT, DEFAULT),
  (DEFAULT, 2, DEFAULT, DEFAULT),
  (DEFAULT, 3, DEFAULT, DEFAULT)

INSERT INTO users VALUES
  (DEFAULT, 'Marina', '1998-10-08', NOW(), NOW()),
  (DEFAULT, 'Ivan', '2000-05-11', NOW(), NOW()),
  (DEFAULT, 'Klava', '1989-03-01', NOW(), NOW()),
  (DEFAULT, 'Matrena', '2005-12-07', NOW(), NOW())
  
-- Ответ:

SELECT name
	FROM users AS u
	INNER JOIN orders AS o ON (o.user_id = u.id)
	GROUP BY u.name
	HAVING COUNT(o.id) > 0;

/* Задание 2: Выведите список товаров products и разделов catalogs, который соответствует товару */

-- Обновим и заполним таблицы products и catalogs:

USE shop;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название товара',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO products VALUES
  (DEFAULT, 'AMD Ryzen 53600', 'AMD Ryzen 5 3600 – шестиядерный процессор, который устанавливается в геймерские и рабочие компьютеры. Модель отвечает за высокую производительность системы, ее быструю загрузку, а также обеспечивает эффективность многозадачного режима.', 15590, 1, DEFAULT, DEFAULT),
  (DEFAULT, 'INTEL Core i3 10100F', 'Четырехъядерный процессор INTEL Core i3 10100F имеет ядро Comet Lake и обеспечивает работу в 8 потоках. Функционирует с частотой 4.3 ГГц в режиме Turbo, используя L3 кэш объемом 6 Мб.', 6790, 1, DEFAULT, DEFAULT),
  (DEFAULT, 'GIGABYTE H410M S2 V2', '', 5340, 2, DEFAULT, DEFAULT),
  (DEFAULT, 'ASUS NVIDIA GeForce GT 1030', 'Компактная видеокарта ASUS NVIDIA GeForce GT 1030 характеризуется эффективной системой охлаждения. Она способна обеспечить качественное воспроизведение видео благодаря способности процессора работать на частоте 1228 МГц, а в режиме Boost - 1506 МГц, и объему памяти 2 Гб.', 7290, 3, DEFAULT, DEFAULT);
  
INSERT INTO catalogs VALUES
  (DEFAULT, 'Processors'),
  (DEFAULT, 'Mother boards'),
  (DEFAULT, 'Video cards');
  
-- Ответ:

SELECT p.name, c.name
	FROM products AS p
	INNER JOIN catalogs AS c ON (p.catalog_id = c.id)
	GROUP BY p.id;   

/* Задание 3: (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов */

-- Создадим БД air_connection, таблицы рейсов flights и городов cities и заполним таблицы:

DROP DATABASE IF EXISTS air_connection;
CREATE DATABASE air_connection;
USE air_connection;


CREATE TABLE cities (
	label VARCHAR(100) PRIMARY KEY,
	name VARCHAR(100) NOT NULL);

INSERT INTO cities(label, name)
VALUE ('Moscow','Москва'),('Irkutsk','Иркутск'),
	  ('Novgorod','Новгород'),('Kazan','Казань'),
	  ('Omsk','Омск');

CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	`from` VARCHAR(100) NOT NULL,
	`to` VARCHAR(100) NOT NULL);
	
ALTER TABLE flights
ADD CONSTRAINT fk_from
FOREIGN KEY (`from`)
REFERENCES cities (label)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE flights
ADD CONSTRAINT fk_to
FOREIGN KEY (`to`)
REFERENCES cities (label)
ON DELETE CASCADE
ON UPDATE CASCADE;


INSERT INTO flights(`from`, `to`)
VALUE ('Moscow','Omsk'),('Novgorod','Kazan'),
	  ('Irkutsk','Moscow'),('Omsk','Irkutsk'),
	  ('Moscow','Kazan');	
	  
-- Ответ:	

SELECT
	id,
	(SELECT name FROM cities WHERE label = `from`) AS `from`,
	(SELECT name FROM cities WHERE label = `to`) AS `to`
FROM flights
ORDER BY id;

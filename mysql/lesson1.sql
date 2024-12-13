-- show databases;

CREATE database expensetracker;

UsE expensetracker;

SHOW TABLES;

CREATE TABLE t_user (
                        name VARCHAR(100),
                        age INT
);

DESCRIBE t_user;

SHOW CREATE TABLE t_user;

SELECT * FROM t_user;

INSERT INTO t_user
VALUES('John Doe', 32);


SELECT * FROM t_user;

INSERT INTO t_user(age, name)
VALUES(29, 'Jane Doe'),
      (48, 'Ivan Petrenko');

SELECT age, name FROM t_user WHERE name LIKE 'J_n_%';

TRUNCATE t_user;

DROP TABLE t_user;

SHOW TABLES;



CREATE TABLE t_user (
                        id INT PRIMARY KEY AUTO_INCREMENT, -- Postgres: id SERIAL PRIMARY KEY
                        name VARCHAR(100),
                        age INT
);

INSERT INTO t_user(age, name)
VALUES(29, 'Jane Doe'),
      (48, 'Ivan Petrenko'),
      (32, 'John Doe');

SELECT * FROM  t_user;

DESCRIBE  t_user;

SELECT * FROM t_user WHERE id = 1;

INSERT INTO t_user(age, name)
VALUES (-10, 'Bad name');

ALTER TABLE t_user
DROP COLUMN age;

ALTER TABLE t_user
    ADD COLUMN age INT CHECK(age > 0)
        NOT NULL DEFAULT 1;

SELECT * FROM t_user;

UPDATE t_user
SET age = 32 WHERE id = 3;

DELETE FROM t_user
WHERE id = 4;

ALTER TABLE t_user
    ADD COLUMN email VARCHAR(256)
        NOT NULL;

UPDATE t_user
SET email = 'jd@test.com'
WHERE id = 1;

ALTER TABLE t_user
    MODIFY COLUMN email VARCHAR(256)
    NOT NULL UNIQUE;



CREATE TABLE t_user (
                        id INT PRIMARY KEY AUTO_INCREMENT, -- Postgres: id SERIAL PRIMARY KEY
                        first_name VARCHAR(100) DEFAULT '',
                        last_name VARCHAR(100) DEFAULT '',
                        email VARCHAR(256) UNIQUE NOT NULL,
                        birth_date DATE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_expense(
                          id INT PRIMARY KEY AUTO_INCREMENT, -- Postgres: id SERIAL PRIMARY KEY
                          title VARCHAR(360) NOT NULL,
                          amount DOUBLE NOT NULL
)


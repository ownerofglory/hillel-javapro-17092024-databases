-- user
-- category
-- expense
-- budget
-- tag
-- report


CREATE TABLE t_user (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        first_name VARCHAR(100) DEFAULT '',
                        last_name VARCHAR(100) DEFAULT '',
                        email VARCHAR(256) UNIQUE NOT NULL,
                        birth_date DATE NOT NULL DEFAULT '2000-01-01'
);

CREATE TABLE t_category (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            name VARCHAR(100) NOT NULL,
                            user_id INT,
                            FOREIGN KEY(user_id) REFERENCES t_user(id)
);





SHOW CREATE TABLE t_category;

SHOW TABLES;


INSERT INTO t_user (first_name, last_name, email, birth_date)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '1995-05-15'),
    ('Jane', 'Smith', 'jane.smith@example.com', '1988-11-23'),
    ('Michael', 'Johnson', 'michael.johnson@example.com', '1990-03-30'),
    ('Emily', 'Davis', 'emily.davis@example.com', '1992-07-12'),
    ('David', 'Brown', 'david.brown@example.com', '1985-10-05');

INSERT INTO t_category (name, user_id)
VALUES
    ('Food', 1),
    ('Transportation', 1),
    ('Entertainment', 1),
    ('Health', 1),

    ('Food', 2),
    ('Transportation', 2),
    ('Entertainment', 2),
    ('Health', 2),

    ('Food', 3),
    ('Transportation', 3),
    ('Entertainment', 3),
    ('Health', 3),

    ('Food', 4),
    ('Transportation', 4),
    ('Entertainment', 4),
    ('Health', 4),

    ('Food', 5),
    ('Transportation', 5),
    ('Entertainment', 5),
    ('Health', 5);





SELECT * FROM t_user WHERE email = 'john.doe@example.com' ;

CREATE INDEX t__user_email_idx
    ON t_user(email);

SELECT * FROM t_category;

SELECT * FROM t_category WHERE user_id = 1;

SELECT * FROM t_category AS c
                  JOIN t_user AS u
                       ON c.user_id = u.id
WHERE u.id = 1;


SELECT c.name, u.first_name, u.last_name FROM t_category AS c
                                                  JOIN t_user AS u
                                                       ON c.user_id = u.id
WHERE u.id = 1;

-- 1 to 1
CREATE TABLE t_profile (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           avatarUrl VARCHAR(1024),
                           user_id INT UNIQUE,
                           FOREIGN KEY(user_id) REFERENCES t_user(id)
);

-- expense * - 1 category
-- expense * - 1 user
CREATE TABLE t_expense(
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          amount DOUBLE CHECK(amount > 0) NOT NULL,
                          description VARCHAR(200),
                          category_id INT,
                          user_id INT,
                          FOREIGN KEY(category_id) REFERENCES t_category(id)
                              ON DELETE SET NULL,

                          FOREIGN KEY(user_id) REFERENCES t_user(id)
                              ON DELETE CASCADE
);

-- Expenses for User 1
INSERT INTO t_expense (amount, description, category_id, user_id) VALUES
                                                                      (25.50, 'Lunch at restaurant', 1, 1), -- Food
                                                                      (15.00, 'Bus fare', 2, 1), -- Transportation
                                                                      (40.00, 'Movie ticket', 3, 1); -- Entertainment

-- Expenses for User 2
INSERT INTO t_expense (amount, description, category_id, user_id) VALUES
                                                                      (50.75, 'Groceries', 5, 2), -- Food
                                                                      (20.00, 'Gas for car', 6, 2), -- Transportation
                                                                      (75.00, 'Concert ticket', 7, 2); -- Entertainment

-- Expenses for User 3
INSERT INTO t_expense (amount, description, category_id, user_id) VALUES
                                                                      (30.00, 'Dinner at cafe', 9, 3), -- Food
                                                                      (10.50, 'Subway ride', 10, 3), -- Transportation
                                                                      (100.00, 'Theater play', 11, 3); -- Entertainment

INSERT INTO t_expense (amount, description, category_id, user_id) VALUES
    (15.50, 'Lunch at cafe', 1, 1);

SELECT * FROM t_user AS u
                  JOIN t_category AS c
                       ON u.id = c.user_id
WHERE u.id = 1;

SELECT * FROM t_category AS c
                  LEFT JOIN t_expense AS e
                            ON e.category_id = c.id
WHERE c.user_id = 2;

-- aggregate later
SELECT * FROM t_user AS u
                  JOIN t_category AS c
                       ON u.id = c.user_id
                  LEFT JOIN t_expense AS e
                            ON e.category_id = c.id
WHERE u.id = 2;

-- tag * - * expense
CREATE TABLE t_tag (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(20) NOT NULL,
                       user_id INT,
                       FOREIGN KEY (user_id) REFERENCES t_user(id)
-- 	color ENUM('red', 'blue', 'green', 'yellow')
);


CREATE TABLE t_tag_expense (
                               tag_id INT,
                               expense_id INT,
                               FOREIGN KEY (tag_id) REFERENCES t_tag(id)
                                   ON DELETE NO ACTION,
                               FOREIGN KEY (expense_id) REFERENCES t_expense(id)
                                   ON DELETE CASCADE,

                               PRIMARY KEY(tag_id, expense_id)
);


SELECT * FROM t_expense;


INSERT INTO t_tag (name, user_id) VALUES
                                      ('Work', 1),
                                      ('Personal', 1),
                                      ('Groceries', 2),
                                      ('Travel', 2),
                                      ('Entertainment', 3),
                                      ('Commute', 3);

INSERT INTO t_tag_expense (tag_id, expense_id) VALUES
                                                   (1, 1), -- Tag Lunch at restaurant with 'Work'
                                                   (2, 1), -- Tag Lunch at restaurant with 'Personal'
                                                   (1, 2), -- Tag Bus fare with 'Work'
                                                   (2, 3), -- Tag Movie ticket with 'Personal'
                                                   (3, 4), -- Tag Groceries with 'Groceries'
                                                   (4, 5), -- Tag Gas for car with 'Travel'
                                                   (4, 6), -- Tag Concert ticket with 'Travel'
                                                   (5, 7), -- Tag Dinner at cafe with 'Entertainment'
                                                   (6, 8), -- Tag Subway ride with 'Commute'
                                                   (5, 9); -- Tag Theater play with 'Entertainment'


SELECT u.first_name, u.last_name, e.description, e.amount, t.name
FROM t_user AS u
         JOIN t_expense AS e
              ON e.user_id = u.id
         JOIN t_tag_expense AS t2e
              ON t2e.expense_id = e.id
         JOIN t_tag AS t
              ON t.id = t2e.tag_id;


-- begin transaction
BEGIN;
	-- log expense
INSERT INTO  t_expense(amount, description, user_id)
VALUES (29.00, 'Other lunch', 2);

UPDATE t_expense
SET category_id = 5
WHERE id = 11;

SELECT * FROM t_expense
WHERE user_id = 2
ORDER BY description DESC;

-- error

SELECT * FROM t_category WHERE user_id = 2 ;

-- tag expense
SELECT * FROM t_tag WHERE user_id = 2; -- 4

INSERT INTO t_tag_expense(tag_id, expense_id)
VALUES(4, 11);

COMMIT;


SELECT COUNT(*)  FROM t_user;
SELECT * FROM t_user;

SELECT COUNT(*) FROM t_expense
WHERE user_id = 1;

SELECT u.id, CONCAT(u.first_name, ' ',  u.last_name) as full_name, COUNT(e.id)
FROM t_user AS u
         LEFT JOIN t_expense AS e
                   ON e.user_id = u.id
GROUP BY u.id;

SELECT u.id,
       CONCAT(u.first_name, ' ',  u.last_name) as full_name,
       SUM(e.amount) AS EXPENSE_SUM
FROM t_user AS u
         LEFT JOIN t_expense AS e
                   ON e.user_id = u.id
GROUP BY u.id;

SELECT u.id,
       CONCAT(u.first_name, ' ',  u.last_name) as full_name,
       AVG(e.amount) AS AVG_expense
FROM t_user AS u
         LEFT JOIN t_expense AS e
                   ON e.user_id = u.id
GROUP BY u.id;

SELECT u.id,
       CONCAT(u.first_name, ' ',  u.last_name) as full_name,
       MAX(e.amount) AS max_expense
FROM t_user AS u
         LEFT JOIN t_expense AS e
                   ON e.user_id = u.id
WHERE u.id = 1
GROUP BY u.id
HAVING full_name = 'John Doe';


SELECT
    CONCAT(u.first_name, ' ',  u.last_name) full_name,
    c.name,
    SUM(e.amount) sum_amount
FROM t_user AS u
         JOIN t_category AS c
              ON c.user_id = u.id
         LEFT JOIN t_expense AS e
                   ON e.category_id = c.id
GROUP BY c.id;

-- year
-- month
-- week

CREATE TABLE t_report(
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         user_id INT,
                         FOREIGN KEY (user_id) REFERENCES t_user(id)
);

-- categpry * - * report
CREATE TABLE report_category(
                                id INT PRIMARY KEY AUTO_INCREMENT,
                                total_amount DOUBLE,
                                report_id INT,
                                category_id INT,
                                FOREIGN KEY (report_id) REFERENCES t_report(id),
                                FOREIGN KEY (category_id) REFERENCES t_category(id)
);


INSERT INTO t_report(user_id) VALUES(1);

SELECT
    c.id as category_id,
    SUM(e.amount) total_amount,
    1 as report_id
FROM t_user AS u
         JOIN t_category AS c
              ON c.user_id = u.id
         LEFT JOIN t_expense AS e
                   ON e.category_id = c.id
WHERE u.id = 1
GROUP BY c.id;

INSERT INTO report_category(category_id, total_amount, report_id)
SELECT
    c.id as category_id,
    SUM(e.amount) total_amount,
    1 as report_id
FROM t_user AS u
         JOIN t_category AS c
              ON c.user_id = u.id
         LEFT JOIN t_expense AS e
                   ON e.category_id = c.id
WHERE u.id = 1
GROUP BY c.id;

SELECT * FROM t_report as r
                  JOIN report_category as rc
                       ON rc.report_id = r.id;



CREATE VIEW category_report_total AS
SELECT
    c.id as category_id,
    SUM(e.amount) total_amount,
    1 as report_id
FROM t_user AS u
         JOIN t_category AS c
              ON c.user_id = u.id
         LEFT JOIN t_expense AS e
                   ON e.category_id = c.id
WHERE u.id = 1
GROUP BY c.id;


SELECT * FROM category_report_total;




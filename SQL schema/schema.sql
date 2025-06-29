SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS assessment;
DROP TABLE IF EXISTS login_session;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS submission;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE students (
    username VARCHAR(100) PRIMARY KEY,
    password_hash VARCHAR(32)
);

CREATE TABLE login_session (
    session_id VARCHAR(100) PRIMARY KEY,
    username VARCHAR(100),
    started_at DATETIME,
    FOREIGN KEY (username) REFERENCES students(username)
);

CREATE TABLE assessment (
    aid INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    due_date DATETIME
);

CREATE TABLE task (
    tid INT PRIMARY KEY AUTO_INCREMENT,
    aid INT,
    title VARCHAR(200),
    FOREIGN KEY (aid) REFERENCES assessment(aid)
);

CREATE TABLE parts (
    pid INT,
    tid INT,
    PRIMARY KEY (pid, tid),
    model_ans VARCHAR(60000),
    query VARCHAR (60000),
    FOREIGN KEY (tid) REFERENCES task(tid)
);

CREATE TABLE submission (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    aid INT,
    username VARCHAR(100),
    code VARCHAR(1000),
    attempt_no INT,
    score FLOAT(3),
    submitted_at DATETIME,
    FOREIGN KEY (aid) REFERENCES task(aid),
    FOREIGN KEY (username) REFERENCES students(username)
);

INSERT INTO students (username, password_hash)
    VALUES -- default password is username + 1, example: username 'ben', password 'ben1'
    ('ben', '6edfe0531855295c5541d2666d604463'),
    ('benn', 'ea2b11c7e6bc373c628be113847b039d'),
    ('sasi', 'aa6bfe8bcf6eb51f7e158d8e5101fb71'),
    ('tricia', '0b4d4ee0c8e3cda51616f1f6cc64a655'),
    ('zongyu', '6e4a828704323be31656ec168be89920'),
    ('jiang', '7ab645365238e9d6691ba55947269b20');

INSERT INTO assessment (title, due_date) VALUES
('Assessment 1', '2025-06-01 00:00:00'),
('Assessment 2', '2025-06-14 00:00:00'),
('Assessment 3', '2025-06-25 00:00:00'),
('Assessment 4', '2025-07-04 00:00:00'),
('Assessment 5', '2025-07-18 00:00:00'),
('Assessment 6', '2025-07-25 00:00:00'),
('Assessment 7', '2025-07-30 00:00:00'),
('Assessment 8', '2025-08-01 00:00:00');

INSERT INTO task (aid, title) VALUES
(1, 'Select all customers full names.'),
(1, 'List all orders by their order ID.'),

(2, 'Find all items in the inventory with an amount greater than 10.'),
(2, 'Retrieve the titles of all inventory items.'),

(3, 'List all orders along with the name of the customer who placed them.'), 
(3, 'Count how many orders each customer has made.'),

(4, 'Find the total number of items ordered per order.'),   
(4, 'List all customers who have never placed an order.'),  

(5, 'Show the most recent order placed and the customer who placed it.'),   
(5, 'Find the total amount of inventory used across all orders.'),  

(6, 'List the top 3 most frequently ordered inventory items.'), 
(6, 'Find the average number of items per order.'),  

(7, 'Write a query to delete all orders placed before a certain date.'),  
(7, 'Insert and order of 3 Hammers at 2025-06-27 10:00:00 by Alice Smith, then Update the inventory amount after an order is placed.');

INSERT INTO parts (pid, tid, model_ans, query) VALUES
(0, 1, "(('Alice', 'Smith'),('Bob','Johnson'),('Charlie','Lee'),('Diana','Wong'),('Ethan','Brown'))", ""), --SELECT first_name, last_name FROM customers;    
(0, 2, "((1),(2),(3),(4))", ""), --SELECT order_id FROM orders;  

(0, 3, "((1,'Hammer',30),(2,'Screwdriver',50),(3,'Wrench',40),(4,'Drill',20),(5,'Tape Measure',60))", ""), --SELECT * FROM inventory WHERE amount > 10;  
(0, 4, "(('Hammer'),('Screwdriver'),('Wrench'),('Drill'),('Tape Measure'))", ""),--SELECT title FROM inventory;
  
(0, 5, "((1, 'Alice', 'Smith'),(2,'Bob','Johnson'),(3,'Charlie','Lee'),(4,'Alice','Smith'))", ""),
-- SELECT o.order_id, c.first_name, c.last_name
-- FROM orders o
-- JOIN customers c ON o.ordered_by = c.cid; 
(0, 6, "(('Alice','Smith',2),('Bob','Johnson',1),('Charlie','Lee',1),('Diana','Wong',0),('Ethan','Brown',0))", ""),
-- SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
-- FROM customers c
-- LEFT JOIN orders o ON c.cid = o.ordered_by
-- GROUP BY c.cid;

(0, 7, "((1,2)(2,8)(3,7)(4,10))", ""),
-- SELECT order_id, SUM(amount) AS total_items
-- FROM order_items
-- GROUP BY order_id;
(0, 8, "(('Diana','Wong'),('Ethan','Brown'))", ""),
-- SELECT c.first_name, c.last_name
-- FROM customers c
-- LEFT JOIN orders o ON c.cid = o.ordered_by
-- WHERE o.order_id IS NULL;

(0, 9, "(4,'2025-06-28 13:00:00','Alice','Smith')", ""),
-- SELECT o.order_id, o.ordered_at, c.first_name, c.last_name
-- FROM orders o
-- JOIN customers c ON o.ordered_by = c.cid
-- ORDER BY o.ordered_at DESC
-- LIMIT 1;
(0, 10, "((27))", ""),
-- SELECT SUM(amount) AS total_inventory_used
-- FROM order_items;

(0, 11, "(('Screwdriver',4),('Hammer',1),('Wrench',1))", ""),
-- SELECT i.title, COUNT(*) AS times_ordered
-- FROM order_items oi
-- JOIN inventory i ON oi.inventory_id = i.inventory_id
-- GROUP BY i.inventory_id
-- ORDER BY times_ordered DESC
-- LIMIT 3;  
(0, 12, "((2.0000))", ""),
-- SELECT AVG(item_count) AS avg_items_per_order
-- FROM (
--     SELECT order_id, COUNT(*) AS item_count
--     FROM order_items
--     GROUP BY order_id
-- ) AS order_counts;

(0, 13, "((2),(3),(4))", "SELECT order_id FROM orders;"),
-- DELETE FROM orders
-- WHERE ordered_at < '2025-06-28';
(0, 14, "((5))", "SELECT order_id FROM orders WHERE order_id = 5;"),
(1, 14, "((5, 1, 3))", "SELECT order_id, inventory_id, amount FROM order_items WHERE order_id = 5, inventory_id = 1"),
(2, 14, "((27))", "SELECT amount FROM inventory WHERE inventory_id = 1;");
--INSERT INTO orders (ordered_by, ordered_at) VALUES (1, '2025-06-27 10:00:00'),
--INSERT INTO order_items (order_id, inventory_id, amount) VALUES (5, 1, 3),
--UPDATE inventory
-- SET amount = amount - (
--     SELECT amount
--     FROM order_items oi
--     WHERE oi.inventory_id = inventory.inventory_id AND order_id = 5
-- )
-- WHERE order_id = 5 AND inventory_id IN (
--     SELECT inventory_id FROM order_items
-- );



INSERT INTO submission (aid, username, code, attempt_no, score, submitted_at) VALUES
(1, 'ben', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),
(1, 'benn', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),
(1, 'sasi', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),
(1, 'tricia', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),
(1, 'zongyu', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),
(1, 'jiang', "'SELECT first_name, last_name FROM customers;\n\n'SELECT order_id FROM orders;'", 1, 1.0, '2025-05-30 00:00:00'),

(2, 'ben', "", 1, 0.0, '2025-05-31 00:00:00'),
(2, 'benn', "'SELECT * FROM inventory WHERE amount > 10;'\n\n'SELECT title FROM inventory;'", 1, 1.0, '2025-05-31 00:00:00'),
(2, 'sasi', "'SELECT * FROM inventory WHERE amount > 10;'\n\n'SELECT title FROM inventory;'", 1, 1.0, '2025-05-31 00:00:00'),
(2, 'tricia', "'SELECT * FROM inventory WHERE amount > 10;'\n\n'SELECT title FROM inventory;'", 1, 1.0, '2025-05-31 00:00:00'),
(2, 'zongyu', "'SELECT * FROM inventory WHERE amount > 10;'\n\n'SELECT title FROM inventory;'", 1, 1.0, '2025-05-31 00:00:00'),
(2, 'jiang', "", 1, 0.0, '2025-05-31 00:00:00'),

-- this is for demo of leaderboard
(3, 'ben', "", 1, 0.5, '2025-05-31 00:00:00'),
(3, 'benn', "", 1, 1.0, '2025-05-31 00:00:00'),
(3, 'sasi', "", 1, 0.9, '2025-05-31 00:00:00'),
(3, 'tricia', "", 1, 0.8, '2025-05-31 00:00:00'),
(3, 'zongyu', "", 1, 0.7, '2025-05-31 00:00:00'),
(3, 'jiang', "", 1, 0.6, '2025-05-31 00:00:00');




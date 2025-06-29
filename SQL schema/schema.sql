SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS assessment;
DROP TABLE IF EXISTS login_session;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS task;
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
    model_ans VARCHAR(60000),
    query VARCHAR (60000),
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
(1, 'List all orders with their order ID and table number.'),

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
(7, 'Update the inventory amount after an order is placed.'),  

INSERT INTO parts (pid, tid, model_ans, query) VALUES
(0, 1, "(('Alice', 'Smith'),('Bob','Johnson'),('Charlie','Lee'),('Diana','Wong'),('Ethan','Brown'))", ''), --SELECT first_name, last_name FROM customers;    
(1, 1, "((1, 101),(2,102),(3,103),(4,101))", ''), --SELECT order_id, table_no FROM orders;  

(0, 2, "((1,'Hammer',30),(2,'Screwdriver',50),(3,'Wrench',40),(4,'Drill',20),(5,'Tape Measure',60))"), --SELECT * FROM inventory WHERE amount > 10;  
(1, 2, "(('Hammer'),('Screwdriver'),('Wrench'),('Drill'),('Tape Measure'))")--SELECT title FROM inventory;
  
--SELECT o.order_id, c.first_name, c.last_name
--FROM orders o
--JOIN customers c ON o.ordered_by = c.cid; 

-- SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
-- FROM customers c
-- LEFT JOIN orders o ON c.cid = o.ordered_by
-- GROUP BY c.cid;


--SELECT order_id, COUNT(*) AS total_items
-- FROM order_items
-- GROUP BY order_id;

--SELECT c.first_name, c.last_name
-- FROM customers c
-- LEFT JOIN orders o ON c.cid = o.ordered_by
-- WHERE o.order_id IS NULL;


--SELECT o.order_id, o.ordered_at, c.first_name, c.last_name
-- FROM orders o
-- JOIN customers c ON o.ordered_by = c.cid
-- ORDER BY o.ordered_at DESC
-- LIMIT 1;

--SELECT COUNT(*) AS total_inventory_used
-- FROM order_items;


--SELECT i.title, COUNT(*) AS times_ordered
-- FROM order_items oi
-- JOIN inventory i ON oi.inventory_id = i.inventory_id
-- GROUP BY i.inventory_id
-- ORDER BY times_ordered DESC
-- LIMIT 3;  

--SELECT AVG(item_count) AS avg_items_per_order
-- FROM (
--     SELECT order_id, COUNT(*) AS item_count
--     FROM order_items
--     GROUP BY order_id
-- ) AS order_counts;


--DELETE FROM orders
-- WHERE ordered_at < '2025-01-01';  
 
--UPDATE inventory
-- SET amount = amount - (
--     SELECT COUNT(*)
--     FROM order_items oi
--     WHERE oi.inventory_id = inventory.inventory_id
-- )
-- WHERE inventory_id IN (
--     SELECT inventory_id FROM order_items
-- );



INSERT INTO submission (aid, username, code, attempt_no, score, submitted_at) VALUES
(1, 'ben', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),
(1, 'benn', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),
(1, 'sasi', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),
(1, 'tricia', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),
(1, 'zongyu', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),
(1, 'jiang', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),

(1, 'ben', 'SELECT first_name, last_name FROM customers;', 1, 1.0, '2025-05-30 00:00:00'),

(2, 'tricia', 'print("Research complete")', 1, 88.0, '2025-07-04 22:00:00'),
(2, 'ben', 'print("Slides ready")', 1, 92.0, '2025-07-05 20:00:00'),
(3, 'zongyu', 'print("Essay outline")', 1, 80.0, '2025-07-09 15:00:00'),
(3, 'tricia', 'print("Draft written")', 1, 75.0, '2025-07-10 16:00:00'),
(4, 'ben', 'print("Notes revised")', 1, 95.0, '2025-07-14 09:00:00'),
(4, 'zongyu', 'print("Midterm prep")', 1, 89.0, '2025-07-14 10:00:00'),
(5, 'tricia', 'print("Literature selected")', 1, 87.0, '2025-07-19 13:00:00'),
(5, 'ben', 'print("Slides done")', 1, 93.0, '2025-07-19 13:30:00'),
(6, 'zongyu', 'print("Lab experiment")', 1, 78.0, '2025-07-24 11:00:00'),
(6, 'tricia', 'print("Lab report")', 1, 82.0, '2025-07-25 11:30:00'),
(7, 'ben', 'print("Field site visited")', 1, 88.0, '2025-07-29 07:00:00'),
(7, 'zongyu', 'print("Observations documented")', 1, 91.0, '2025-07-30 07:30:00'),



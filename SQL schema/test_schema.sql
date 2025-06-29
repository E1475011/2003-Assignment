SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS inventory;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    cid INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    ordered_by INT,
    table_no INT,
    ordered_at DATETIME,
    FOREIGN KEY (ordered_by) REFERENCES customers(cid) ON DELETE CASCADE
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    amount INT
);

CREATE TABLE order_items (
    order_id INT,
    inventory_id INT,
    amount INT,
    PRIMARY KEY (order_id, inventory_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

-- Customers
INSERT INTO customers (first_name, last_name) VALUES
('Alice', 'Smith'),
('Bob', 'Johnson'),
('Charlie', 'Lee'),
('Diana', 'Wong'),
('Ethan', 'Brown');

-- Inventory (hardware items)
INSERT INTO inventory (title, amount) VALUES
('Hammer', 30),
('Screwdriver', 50),
('Wrench', 40),
('Drill', 20),
('Tape Measure', 60);

-- Orders
INSERT INTO orders (ordered_by, table_no, ordered_at) VALUES
(1, 101, '2025-06-27 10:00:00'),
(2, 102, '2025-06-28 11:00:00'),
(3, 103, '2025-06-28 12:00:00'),
(1, 101, '2025-06-29 13:00:00');

-- Order Items
INSERT INTO order_items (order_id, inventory_id, amount) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 2, 3),
(2, 3, 5),
(3, 2, 1),
(3, 4, 6),
(4, 2, 8),
(4, 5, 2);
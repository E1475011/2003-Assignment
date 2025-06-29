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
    table_no INT,
    ordered_at DATETIME,
    FOREIGN KEY (ordered_by) REFERENCES customers(cid)
);

CREATE TABLE order_items (
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    amount INT
);
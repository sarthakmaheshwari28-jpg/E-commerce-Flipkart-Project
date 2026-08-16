
CREATE DATABASE flipkart_ecommerce;
USE flipkart_ecommerce;
SELECT DATABASE();

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    address_type VARCHAR(20),

    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
);

-- Customer 1 ───────────< Address
CREATE TABLE seller (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    seller_rating DECIMAL(3,2),
    registration_date DATE DEFAULT (CURRENT_DATE),

    CONSTRAINT check_seller_rating
        CHECK (seller_rating BETWEEN 0 AND 5)
);
-- Seller 1 ───────────< Product
CREATE TABLE category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    brand VARCHAR(100),
    rating DECIMAL(3,2),
    created_date DATE DEFAULT (CURRENT_DATE),

    CONSTRAINT fk_product_seller
        FOREIGN KEY (seller_id)
        REFERENCES seller(seller_id),

    CONSTRAINT check_product_price
        CHECK (price >= 0),

    CONSTRAINT check_stock
        CHECK (stock_quantity >= 0),

    CONSTRAINT check_product_rating
        CHECK (rating BETWEEN 0 AND 5)
);
CREATE TABLE product_category (
    product_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (product_id, category_id),

    CONSTRAINT fk_pc_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pc_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON DELETE CASCADE
);
-- Product >──── Product_Category ────< Category
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) DEFAULT 'Pending',
    total_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES address(address_id),

    CONSTRAINT check_order_amount
        CHECK (total_amount >= 0)
);
-- Customer 1 ───────────< Orders
CREATE TABLE order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id),

    CONSTRAINT check_quantity
        CHECK (quantity > 0),

    CONSTRAINT check_unit_price
        CHECK (unit_price >= 0)
);
-- Orders 1 ───────────< Order_Item >─────────── 1 Product
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'Pending',
    amount DECIMAL(12,2) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT check_payment_amount
        CHECK (amount >= 0)
);
CREATE TABLE review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    review_date DATE DEFAULT (CURRENT_DATE),

    CONSTRAINT fk_review_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
        ON DELETE CASCADE,

    CONSTRAINT check_review_rating
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT unique_customer_product_review
        UNIQUE (customer_id, product_id)
);

CREATE TABLE product_category (
    product_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (product_id, category_id),

    CONSTRAINT fk_pc_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pc_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON DELETE CASCADE
);
SHOW TABLES;
INSERT INTO customer
(first_name, last_name, email, phone)
VALUES
('Rahul', 'Sharma', 'rahul@gmail.com', '9876543210'),
('Priya', 'Singh', 'priya@gmail.com', '9876543211'),
('Aman', 'Verma', 'aman@gmail.com', '9876543212'),
('Neha', 'Gupta', 'neha@gmail.com', '9876543213'),
('Rohit', 'Kumar', 'rohit@gmail.com', '9876543214'),
('Anjali', 'Mehta', 'anjali@gmail.com', '9876543215'),
('Vikas', 'Yadav', 'vikas@gmail.com', '9876543216'),
('Pooja', 'Agarwal', 'pooja@gmail.com', '9876543217'),
('Karan', 'Malhotra', 'karan@gmail.com', '9876543218'),
('Simran', 'Kaur', 'simran@gmail.com', '9876543219');

SELECT * FROM customer;

INSERT INTO address
(customer_id, address_line, city, state, pincode, address_type)
VALUES
(1, '12 MG Road', 'Delhi', 'Delhi', '110001', 'Home'),
(2, '45 Park Street', 'Kolkata', 'West Bengal', '700016', 'Home'),
(3, '22 Civil Lines', 'Noida', 'Uttar Pradesh', '201301', 'Office'),
(4, '15 Model Town', 'Chandigarh', 'Chandigarh', '160019', 'Home'),
(5, '33 Mall Road', 'Jaipur', 'Rajasthan', '302001', 'Home'),
(6, '78 Sector 18', 'Noida', 'Uttar Pradesh', '201301', 'Home'),
(7, '10 Nehru Place', 'Delhi', 'Delhi', '110019', 'Office'),
(8, '56 Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010', 'Home'),
(9, '90 Koramangala', 'Bangalore', 'Karnataka', '560034', 'Home'),
(10, '14 Salt Lake', 'Kolkata', 'West Bengal', '700091', 'Home');


INSERT INTO seller
(seller_name, email, phone, seller_rating)
VALUES
('Tech World', 'techworld@gmail.com', '9000000001', 4.50),
('Mobile Hub', 'mobilehub@gmail.com', '9000000002', 4.30),
('Fashion Store', 'fashionstore@gmail.com', '9000000003', 4.10),
('Home Needs', 'homeneeds@gmail.com', '9000000004', 4.20),
('Book House', 'bookhouse@gmail.com', '9000000005', 4.60);

INSERT INTO category
(category_name, description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Mobiles', 'Smartphones and mobile accessories'),
('Fashion', 'Clothing and fashion products'),
('Home Appliances', 'Products for home use'),
('Books', 'Books and educational material');

INSERT INTO product
(seller_id, product_name, description, price, stock_quantity, brand, rating)
VALUES
(1, 'HP Laptop 15', '15 inch laptop with 8GB RAM', 55000, 25, 'HP', 4.40),
(1, 'Dell Laptop Inspiron', 'Business laptop with 16GB RAM', 65000, 15, 'Dell', 4.50),
(2, 'Samsung Galaxy S24', 'Premium Android smartphone', 75000, 20, 'Samsung', 4.60),
(2, 'OnePlus Nord', 'Mid-range smartphone', 30000, 35, 'OnePlus', 4.30),
(3, 'Nike Running Shoes', 'Sports running shoes', 5000, 50, 'Nike', 4.50),
(3, 'Levis Jeans', 'Regular fit denim jeans', 3500, 40, 'Levis', 4.20),
(4, 'LG Refrigerator', 'Double door refrigerator', 45000, 10, 'LG', 4.40),
(4, 'Philips Mixer Grinder', '750 watt mixer grinder', 4000, 30, 'Philips', 4.10),
(5, 'Atomic Habits', 'Self improvement book', 600, 100, 'Penguin', 4.80),
(5, 'Data Analytics Book', 'Introduction to data analytics', 900, 70, 'Pearson', 4.60);


INSERT INTO product_category
(product_id, category_id)
VALUES
(1, 1),
(2, 1),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5);

INSERT INTO orders
(customer_id, address_id, order_status, total_amount)
VALUES
(1, 1, 'Delivered', 55000),
(2, 2, 'Delivered', 75000),
(3, 3, 'Shipped', 5000),
(4, 4, 'Pending', 4000),
(5, 5, 'Delivered', 600),
(6, 6, 'Delivered', 3500),
(7, 7, 'Shipped', 45000),
(8, 8, 'Delivered', 30000),
(9, 9, 'Pending', 900),
(10, 10, 'Delivered', 65000);

INSERT INTO order_item
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 55000),
(2, 3, 1, 75000),
(3, 5, 1, 5000),
(4, 8, 1, 4000),
(5, 9, 1, 600),
(6, 6, 1, 3500),
(7, 7, 1, 45000),
(8, 4, 1, 30000),
(9, 10, 1, 900),
(10, 2, 1, 65000);

INSERT INTO payment
(order_id, payment_method, payment_status, amount, transaction_id)
VALUES
(1, 'UPI', 'Completed', 55000, 'TXN10001'),
(2, 'Credit Card', 'Completed', 75000, 'TXN10002'),
(3, 'Cash on Delivery', 'Completed', 5000, 'TXN10003'),
(4, 'UPI', 'Pending', 4000, 'TXN10004'),
(5, 'UPI', 'Completed', 600, 'TXN10005'),
(6, 'Debit Card', 'Completed', 3500, 'TXN10006'),
(7, 'Credit Card', 'Completed', 45000, 'TXN10007'),
(8, 'UPI', 'Completed', 30000, 'TXN10008'),
(9, 'UPI', 'Pending', 900, 'TXN10009'),
(10, 'Net Banking', 'Completed', 65000, 'TXN10010');
INSERT INTO review
(customer_id, product_id, rating, review_text)
VALUES
(1, 1, 5, 'Excellent laptop and good performance.'),
(2, 3, 5, 'Amazing smartphone with great camera.'),
(3, 5, 4, 'Comfortable shoes for running.'),
(4, 8, 4, 'Good mixer grinder.'),
(5, 9, 5, 'Very useful book.'),
(6, 6, 4, 'Good quality jeans.'),
(7, 7, 5, 'Excellent refrigerator.'),
(8, 4, 4, 'Good phone for the price.'),
(9, 10, 5, 'Very informative book.'),
(10, 2, 5, 'Great laptop for office work.');

SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM seller;
SELECT * FROM category;
SELECT * FROM product;
SELECT * FROM product_category;
SELECT * FROM orders;
SELECT * FROM order_item;
SELECT * FROM payment;
SELECT * FROM review;

-- Query 1 — All customers
SELECT *FROM customer; 

-- Query 2 — Products above ₹50,000
SELECT product_name, price
FROM product
WHERE price > 50000
ORDER BY price DESC;
-- Query 3 — Customer orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_status,
    o.total_amount
FROM customer c
JOIN orders o
    ON c.customer_id = o.customer_id;
    
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS item_total
FROM orders o
JOIN order_item oi
    ON o.order_id = oi.order_id
JOIN product p
    ON oi.product_id = p.product_id;

SELECT
    p.product_name,
    p.price,
    s.seller_name,
    s.seller_rating
FROM product p
JOIN seller s
    ON p.seller_id = s.seller_id;
    
SELECT
    p.product_name,
    c.category_name
FROM product p
JOIN product_category pc
    ON p.product_id = pc.product_id
JOIN category c
    ON pc.category_id = c.category_id
ORDER BY c.category_name;

SELECT
    c.first_name,
    p.product_name,
    r.rating,
    r.review_text
FROM review r
JOIN customer c
    ON r.customer_id = c.customer_id
JOIN product p
    ON r.product_id = p.product_id;

SELECT
    SUM(total_amount) AS total_delivered_sales
FROM orders
WHERE order_status = 'Delivered';

SELECT
    ROUND(AVG(rating), 2) AS average_rating
FROM review;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

SELECT
    s.seller_name,
    COUNT(p.product_id) AS total_products
FROM seller s
LEFT JOIN product p
    ON s.seller_id = p.seller_id
GROUP BY s.seller_id, s.seller_name
ORDER BY total_products DESC;

SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.payment_method,
    p.payment_status,
    p.amount
FROM payment p
JOIN orders o
    ON p.order_id = o.order_id
JOIN customer c
    ON o.customer_id = c.customer_id;

UPDATE product
SET price = 54000
WHERE product_id = 1;

SELECT product_id, product_name, price
FROM product
WHERE product_id = 1;

DELETE FROM review
WHERE review_id = 10;

CREATE INDEX idx_customer_email
ON customer(email);

CREATE INDEX idx_product_name
ON product(product_name);

CREATE INDEX idx_product_seller
ON product(seller_id);

CREATE INDEX idx_order_customer
ON orders(customer_id);

CREATE INDEX idx_order_date
ON orders(order_date);

CREATE INDEX idx_review_product
ON review(product_id);

-- 38 part




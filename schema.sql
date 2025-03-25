-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

DROP DATABASE IF EXISTS `mytechstore`;

-- create the database

CREATE DATABASE IF NOT EXISTS `mytechstore`;

USE `mytechstore`;

CREATE TABLE IF NOT EXISTS `types`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) UNIQUE NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `brands`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) UNIQUE NOT NULL,
    PRIMARY KEY(`id`)
);

-- warranty_period must be in months
-- CHK_quanity prevent inserting zero as product quantity

CREATE TABLE IF NOT EXISTS `products`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `type_id` INT UNSIGNED NOT NULL,
    `brand_id` INT UNSIGNED NOT NULL,
    `name` VARCHAR(32) UNIQUE NOT NULL,
    `model` VARCHAR(32) UNIQUE NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    `stock_quantity` INT NOT NULL,
    `description` TEXT,
    `warranty_period` INT UNSIGNED NOT NULL,
    `deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`type_id`) REFERENCES `types`(`id`),
    FOREIGN KEY(`brand_id`) REFERENCES `brands`(`id`),
    CONSTRAINT CHK_quantity CHECK (`stock_quantity` >= 0)
);

CREATE TABLE IF NOT EXISTS `customers`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `phone_number` VARCHAR(20) NOT NULL,
    `address` VARCHAR(32) NOT NULL,
    `deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`)
);

-- CHK_sale_quantity prevent inserting zero as sale quantity

CREATE TABLE IF NOT EXISTS `sales`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `customer_id` INT UNSIGNED NOT NULL,
    `product_id` INT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `sale_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    CONSTRAINT CHK_sale_quantity CHECK (`quantity` > 0)
);

CREATE TABLE IF NOT EXISTS `suppliers`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `contact_person` VARCHAR(32),
    `phone_number` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `product_suppliers`(
    `product_id` INT UNSIGNED NOT NULL,
    `supplier_id` INT UNSIGNED NOT NULL,
    `supply_price` DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    FOREIGN KEY(`supplier_id`) REFERENCES `suppliers`(`id`)
);

CREATE TABLE IF NOT EXISTS `parts`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `brand_id` INT UNSIGNED NOT NULL,
    `type_id` INT UNSIGNED NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    `stock_quantity` INT NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY (`brand_id`) REFERENCES `brands`(`id`),
    FOREIGN KEY (`type_id`) REFERENCES `types`(`id`),
    CONSTRAINT CHK_part_quantity CHECK (`stock_quantity` >= 0)
);

CREATE TABLE IF NOT EXISTS `part_suppliers`(
    `part_id` INT UNSIGNED NOT NULL,
    `supplier_id` INT UNSIGNED NOT NULL,
    `supply_price` DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(`part_id`) REFERENCES `parts`(`id`),
    FOREIGN KEY(`supplier_id`) REFERENCES `suppliers`(`id`)
);

CREATE TABLE IF NOT EXISTS `part_compatibility`(
    `part_id` INT UNSIGNED NOT NULL,
    `product_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`part_id`,`product_id`),
    FOREIGN KEY(`part_id`) REFERENCES `parts`(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`)
);

CREATE TABLE IF NOT EXISTS `technicians`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `status` enum('Active','On_leave') DEFAULT 'Active',
    `hire_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `repair_requests`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `customer_id` INT UNSIGNED NOT NULL,
    `product_id` INT UNSIGNED NOT NULL,
    `technician_id` INT UNSIGNED NULL,
    `issue_title` VARCHAR(255) NOT NULL,
    `issue_desc` TEXT NOT NULL,
    `request_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('Pending','In_progress','Completed') NOT NULL DEFAULT 'Pending',
    `repair_cost` DECIMAL(10,2),
    `repair_date` TIMESTAMP,
    `deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    FOREIGN KEY(`technician_id`) REFERENCES `technicians`(`id`)
);

-- CHK_part_repair_quantity prevent inserting zero as used parts quantity

CREATE TABLE IF NOT EXISTS `repair_parts`(
    `id` INT AUTO_INCREMENT,
    `repair_id` INT UNSIGNED NOT NULL,
    `part_id` INT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`repair_id`) REFERENCES `repair_requests`(`id`),
    FOREIGN KEY(`part_id`) REFERENCES `parts`(`id`),
    CONSTRAINT CHK_part_repair_quantity CHECK (`quantity` > 0)
);

CREATE TABLE IF NOT EXISTS `warranty_claims`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `product_id` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NOT NULL,
    `claim_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `issue_desc` TEXT NOT NULL,
    `status` ENUM('Pending', 'Approved','Denied') DEFAULT 'Pending',
    `resolution_details` ENUM('Repair','Replacement','Rejected') DEFAULT NULL,
    `resolution_date` TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`)
);

CREATE TABLE IF NOT EXISTS `product_inventory_log`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `product_id` INT UNSIGNED NOT NULL,
    `change_quantity` INT NOT NULL,
    `change_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `reason` ENUM('Sale','Restock','Added'),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    CONSTRAINT CHK_product_inventory_change CHECK (`change_quantity` > 0)
);

CREATE TABLE IF NOT EXISTS `part_inventory_log`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `part_id` INT UNSIGNED NOT NULL,
    `change_quantity` INT NOT NULL,
    `change_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `reason` ENUM('Repair','Restock','Added'),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`part_id`) REFERENCES `parts`(`id`),
    CONSTRAINT CHK_part_inventory_change CHECK (`change_quantity` > 0)
);

-- indexes

CREATE INDEX products_index ON `products`(`type_id`,`brand_id`);
CREATE INDEX parts_index ON `parts`(`type_id`,`brand_id`);
CREATE INDEX repair_request_index ON `repair_requests`(`customer_id`,`status`);
CREATE INDEX warranty_claims_index ON `warranty_claims`(`product_id`,`customer_id`,`status`);
CREATE INDEX technicians_index ON `technicians`(`status`);
CREATE INDEX sales_index ON `sales`(`customer_id`, `product_id`);

-- triggers

--Prevent Selling more products then available stock
--GET current stock
-- Check if enough stock is available
--raise an exception if the requested quantity is not available
-- working
        
DELIMITER //
CREATE TRIGGER before_sale_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock_quantity INTO current_stock FROM products WHERE id = NEW.product_id;

    IF NEW.quantity > current_stock THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available for sale';
    END IF;

END//
DELIMITER ;

-- this trigger updates the product stock after each sale.
-- working

DELIMITER //
CREATE TRIGGER update_products_stock_after_sale
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    SELECT stock_quantity INTO current_stock FROM products WHERE id = NEW.product_id;

    UPDATE products set stock_quantity = ABS(stock_quantity - NEW.quantity) WHERE id = NEW.product_id;

END//
DELIMITER ;

-- Log newly added product to the product_inventory_log table.
-- working

DELIMITER //

CREATE TRIGGER after_product_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO product_inventory_log (`product_id`,`change_quantity`,`reason`)
    VALUES(NEW.id,NEW.stock_quantity,'Added');
END //

DELIMITER ;

-- Log product stock changes to the product_inventory_log table.
-- working

DELIMITER //

CREATE TRIGGER after_product_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity != OLD.stock_quantity THEN
        INSERT INTO product_inventory_log (`product_id`,`change_quantity`,`reason`)
        VALUES(NEW.id, ABS(OLD.stock_quantity - NEW.stock_quantity),
            CASE
                WHEN NEW.stock_quantity < OLD.stock_quantity THEN 'Sale'
                ELSE 'Restock'
            END
        );
    END IF;
END//

DELIMITER ;


--Prevent Selling more products then available stock
--GET current stock
-- Check if enough stock is available
--raise an exception if the requested quantity is not available
-- working
        
DELIMITER //
CREATE TRIGGER before_repair_part_insert
BEFORE INSERT ON repair_parts
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock_quantity INTO current_stock FROM parts WHERE id = NEW.part_id;

    IF NEW.quantity > current_stock THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available for repair';
    END IF;

END//
DELIMITER ;

-- this trigger updates the parts stock after each repair.
-- working

DELIMITER //
CREATE TRIGGER update_parts_stock_after_repair
AFTER INSERT ON repair_parts
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    SELECT stock_quantity INTO current_stock FROM parts WHERE id = NEW.part_id;

    UPDATE parts set stock_quantity = ABS(stock_quantity - NEW.quantity) WHERE id = NEW.part_id;

END//
DELIMITER ;

-- Log newly added part to the part_inventory_log table.
-- working

DELIMITER //

CREATE TRIGGER after_part_insert
AFTER INSERT ON parts
FOR EACH ROW
BEGIN
    INSERT INTO part_inventory_log (`part_id`,`change_quantity`,`reason`)
    VALUES(NEW.id,NEW.stock_quantity,'Added');
END //

DELIMITER ;

-- Log part stock changes to the part_inventory_log table.
-- working

DELIMITER //

CREATE TRIGGER after_part_update
AFTER UPDATE ON parts
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity != OLD.stock_quantity THEN
        INSERT INTO part_inventory_log(`part_id`,`change_quantity`,`reason`)
        VALUES(NEW.id, ABS(OLD.stock_quantity - NEW.stock_quantity),
            CASE
                WHEN NEW.stock_quantity < OLD.stock_quantity THEN 'Repair'
                ELSE 'Restock'
            END
        );
    END IF;
END//

DELIMITER ;

--Automatically Close Repairs When Marked as Completed
-- working

DELIMITER //
CREATE TRIGGER after_repair_complete
BEFORE UPDATE ON repair_requests
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' THEN 
        IF OLD.status = 'In_progress' THEN
            SET NEW.repair_date = CURRENT_TIMESTAMP;
        ELSEIF  OLD.status = 'Pending' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cannot complete a pending repair request';
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'the repair request already completed';
        END IF;
    END IF;

END//
DELIMITER ;

--Automatically set repairrequest to In_progress after assigning a technician
-- working

DELIMITER //

CREATE TRIGGER repair_request_in_progress
BEFORE UPDATE ON repair_requests
FOR EACH ROW
BEGIN
    IF OLD.technician_id IS NULL AND NEW.technician_id IS NOT NULL AND OLD.status = 'Pending' THEN
        SET NEW.status = 'In_progress';
    END IF;
END//
DELIMITER ;

-- Prevent removing customers with sales record or active repairsRequest and warrningClaims
--check if the customer has sales history or active repairsRequest or warranty_claims
--raise an exception if the customer have active warranty_claims or repair_requests
-- working

DELIMITER //
CREATE TRIGGER before_customer_delete
BEFORE UPDATE ON customers
FOR EACH ROW
BEGIN
    IF NEW.deleted = 1 THEN
        IF (SELECT COUNT(*) FROM sales WHERE customer_id = OLD.id) > 0
            OR (SELECT COUNT(*) FROM warranty_claims WHERE customer_id = OLD.id AND status = 'Pending') > 0
            OR (SELECT COUNT(*) FROM repair_requests WHERE customer_id = OLD.id AND status IN ('Pending','In_progress')) > 0
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete customer with active transactions';
        END IF;
    END IF;
END//
DELIMITER;

-- Prevent asigning repair requests to a techicians on leave
-- checks technician work status
-- raises an exception if the technician we want to assign is On_leave
-- working

DELIMITER //
CREATE TRIGGER before_technician_assign_to_repair_request
BEFORE UPDATE ON repair_requests
FOR EACH ROW
BEGIN
    DECLARE technician_status VARCHAR(32);

    IF NEW.technician_id IS NOT NULL THEN
        SELECT status INTO technician_status FROM technicians WHERE id = NEW.technician_id;
        IF technician_status = 'On_leave' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot assgin repair requests to technicians on leave';
        END IF;
    END IF;
END//
DELIMITER ;

-- Prevent Warranty Claims for Products Out of Warranty
-- GET sale date and warranty months of the product
-- calculate the number of months of ownership of a set product then compare it to the warranty_period
-- if months of ownership is greater then the warranty_period the trigger will raise a exception stating that the warranty has expired for that specific product
-- working 

DELIMITER //
CREATE TRIGGER before_warranty_claim_insert
BEFORE INSERT ON warranty_claims
FOR EACH ROW
BEGIN

    DECLARE purchase_date TIMESTAMP;
    DECLARE warranty_months INT;

    
    SELECT s.sale_date, p.warranty_period INTO purchase_date, warranty_months
    FROM sales s JOIN products p ON s.product_id = p.id
    WHERE s.product_id = NEW.product_id AND s.customer_id = NEW.customer_id
    ORDER BY s.sale_date DESC
    LIMIT 1;
    
    
    IF TIMESTAMPDIFF(MONTH,purchase_date,CURRENT_TIMESTAMP) > warranty_months THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warranty period expired for this product';
    END IF;
END//
DELIMITER ;
    
-- this trigger automaticaly sets the status of the warranty_claim
-- addes the resolution date once the warranty_claim is closed

-- status is only updated when resolution_details is changed 
-- Avoids unintended modifications.
-- working

DELIMITER //
CREATE TRIGGER close_warranty_claim
BEFORE UPDATE ON warranty_claims
FOR EACH ROW
BEGIN
    IF OLD.status = 'Pending' THEN
        IF NEW.resolution_details IN ('Repair','Replacement') THEN
            SET NEW.status = 'Approved';

             SET NEW.resolution_date = CURRENT_TIMESTAMP;
        
        ELSEIF NEW.resolution_details = 'Rejected' THEN 
            SET NEW.status = 'Denied';
            SET NEW.resolution_date = CURRENT_TIMESTAMP;
        
        END IF;
    END IF;
END //
DELIMITER ;
    

-- Views

-- This view lists available products in the store

CREATE VIEW `available_products` as
SELECT p.`id`, b.`name` AS 'brand',t.`name` AS 'type', p.`name`, p.`model`, p.`price`, p.`stock_quantity`, p.`warranty_period`
FROM `products` p 
JOIN `brands` b ON p.`brand_id` = b.`id`
JOIN `types` t ON p.`type_id` = t.`id`
WHERE p.`stock_quantity` > 0;

-- This view  presents sales summary per client

CREATE VIEW sales_summary_per_client AS
SELECT c.`id` AS 'customer_id', CONCAT(c.`first_name`,' ',c.`last_name`) AS 'customer_name',
COUNT(s.`id`) AS 'total_purchases', SUM(s.`total_amount`) AS 'total_spent'
FROM customers c 
JOIN sales s on c.`id` = s.`customer_id`
GROUP BY c.`id`
ORDER BY `total_spent` DESC;

-- This lists all sales with additional details such as client_name, product name, product type, product brand, product quantity etc.
CREATE VIEW detailed_sales AS
SELECT s.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'full name', p.name AS 'Product name', 
t.name AS 'product type', b.name AS 'brand', s.quantity, s.total_amount, s.sale_date AS 'sale date'
FROM products p
JOIN types t ON p.type_id = t.id
JOIN brands b ON p.brand_id = b.id
JOIN sales s on p.id = s.product_id
JOIN customers c on s.customer_id = c.id; 

-- This view lists all opened repairRequests

CREATE VIEW open_repair_requests AS
SELECT rr.`id` AS 'repair_id', CONCAT(c.`first_name`,' ',c.`last_name`) AS 'customer_name',
p.`name` AS 'product_name', rr.`issue_title`,rr.`request_date`, rr.`status`
FROM repair_requests rr 
JOIN customers c ON rr.`customer_id` = c.`id`
JOIN products p ON rr.`product_id` = p.`id`
WHERE rr.`status` IN ('Pending','In_progress');

-- This view lists all opened warranty_claims

CREATE VIEW open_warranty_claims AS
SELECT wc.`id` AS 'claim_id', c.`id` AS 'customer_id', 
CONCAT(c.`first_name`,' ',c.`last_name`) AS 'cutomer_name',
p.`name` AS 'product_name', wc.`status`, wc.`claim_date`
FROM warranty_claims wc
JOIN customers c ON wc.`customer_id` = c.`id`
JOIN products p ON wc.`product_id` = p.`id`
WHERE wc.`status` = 'Pending';

-- This view track technicians workload
-- LEFT JOIN is used to compare assigned technician vs technicians whithout assigned work

CREATE VIEW technician_workload AS
SELECT t.`id` AS 'technician_id', CONCAT(t.`first_name`,' ',t.`last_name`) AS 'technician_name',
COUNT(rr.`id`) AS 'active_repairs'
FROM technicians t
LEFT JOIN repair_requests rr ON t.`id` = rr.`technician_id` 
GROUP BY t.`id`
ORDER BY `active_repairs` DESC;

-- This view tracks products with low level of stock

CREATE VIEW low_stock_products AS
SELECT p.`id`, b.`name` AS 'brand', t.`name` AS 'type', p.`name`, p.`model`, sup.`name` AS 'supplier', p.`stock_quantity`
FROM products p
JOIN types t ON p.`type_id` = t.`id`
JOIN brands b ON p.`brand_id` = b.`id`
JOIN product_suppliers ps ON ps.`product_id` = p.`id`
JOIN suppliers sup ON ps.`supplier_id` = sup.`id`
WHERE p.`stock_quantity` < 10;

-- This view lists available parts in the store

CREATE VIEW available_parts AS
SELECT pa.`id`, pa.`name`, b.`name` AS 'brand', t.`name` AS 'type', pa.`price`, pa.`stock_quantity`
FROM parts pa
JOIN types t ON pa.`type_id` = t.`id`
JOIN brands b ON pa.`brand_id` = b.`id`
WHERE pa.`stock_quantity` > 0;

-- This view parts with low level of stock

CREATE VIEW low_stock_parts AS
SELECT pa.`id`,b.`name` AS 'brand', t.`name` AS 'type', pa.`name`, sup.`name` AS 'supplier', pa.`stock_quantity`
FROM parts pa
JOIN brands b ON pa.`brand_id` = b.`id`
JOIN types t ON pa.`type_id` = t.`id`
JOIN part_suppliers ps ON ps.`part_id` = pa.`id`
JOIN suppliers sup ON ps.`supplier_id` = sup.`id`
WHERE pa.`stock_quantity` < 10;

-- This view will list the most sold brands

CREATE VIEW most_sold_brands AS
SELECT b.`id`, b.`name` AS 'brand_name', COUNT(s.id) AS 'number_of_sales', SUM(s.`total_amount`) AS 'total_amount'
FROM sales s 
JOIN products p ON s.`product_id` = p.`id`
JOIN brands b ON p.`brand_id` = b.`id`
GROUP BY b.`id`
ORDER BY `total_amount` DESC, `number_of_sales` DESC;

-- This view will list the most used parts

CREATE VIEW most_used_parts AS
SELECT pa.`id`, b.`name` AS 'brand_name', pa.`name` AS 'name', COUNT(rp.`id`) AS 'number_of_usage'
FROM parts pa
JOIN brands b ON pa.`brand_id` = b.`id`
JOIN repair_parts rp ON rp.`part_id` = pa.`id`
GROUP BY pa.`id`
ORDER BY `number_of_usage`;

-- Insert section

-- insert values to the types table:

INSERT INTO `types` (`name`) VALUES
('Laptop'), ('Smartphone'), ('Tablet'), ('Smartwatch'), ('Desktop PC'),
('Monitor'), ('Printer'), ('Headphones'), ('Keyboard'), ('Mouse'),
('Gaming Console'), ('TV'), ('Router'), ('Smart Speaker'), ('Camera'),
('Drone'), ('Projector'), ('External Hard Drive'), ('VR Headset'), ('Graphics Card'),('Thermal Paste');

-- insert values to the brands table:

INSERT INTO `brands` (`name`) VALUES
('Apple'), ('Samsung'), ('Dell'), ('HP'), ('Lenovo'),
('Sony'), ('Microsoft'), ('ASUS'), ('Acer'), ('LG'),
('Razer'), ('MSI'), ('Bose'), ('Beats'), ('Google'),
('OnePlus'), ('Huawei'), ('Xiaomi'), ('Nvidia'), ('AMD'),('Noctua');

-- insert values to the products table

INSERT INTO `products` (`type_id`, `brand_id`, `name`, `model`, `price`, `stock_quantity`, `description`, `warranty_period`) VALUES
(1, 1, 'MacBook Pro 14', 'MBP14', 1999.99, 30, 'Apple M3 chip laptop', 24),
(1, 3, 'Dell XPS 15', 'XPS159310', 1499.99, 40, 'Dell high-end laptop', 24),
(2, 2, 'Samsung Galaxy S22', 'SGS22', 749.99, 50, 'Samsung smartphone', 12),
(2, 15, 'Google Pixel 6', 'GP6', 599.99, 60, 'Google flagship phone', 12),
(3, 4, 'HP Elite x2', 'HPX2', 1099.99, 20, 'HP business tablet', 24),
(5, 5, 'Lenovo ThinkPad', 'LTP100', 899.99, 35, 'Lenovo business PC', 36),
(6, 10, 'LG UltraFine Monitor', 'LGUFM', 699.99, 25, 'LG high-quality display', 24),
(7, 7, 'Microsoft Surface Studio', 'MSS2', 2999.99, 10, 'Microsoft creative PC', 12),
(8, 13, 'Bose QuietComfort 45', 'BQC45', 329.99, 75, 'Bose premium headphones', 12),
(9, 11, 'Razer Huntsman Mini', 'RHM', 129.99, 50, 'Razer compact gaming keyboard', 24),
(10, 12, 'MSI Clutch GM51', 'MSIGM51', 69.99, 80, 'MSI gaming mouse', 12),
(11, 6, 'PlayStation 4', 'PS4', 299.99, 30, 'Sony gaming console', 24),
(12, 10, 'LG NanoCell TV', 'LGNC65', 1199.99, 25, 'LG Smart TV', 36),
(13, 14, 'Amazon Echo Show', 'AES', 99.99, 100, 'Smart display with Alexa', 12),
(14, 16, 'DJI Phantom 4', 'DJIP4', 999.99, 15, 'Professional drone', 12),
(15, 19, 'Nvidia RTX 3080', 'RTX3080', 899.99, 20, 'Nvidia high-end GPU', 36),
(16, 20, 'AMD Ryzen 7 7800X', 'R7-7800X', 449.99, 40, 'AMD performance CPU', 36),
(4, 8, 'ASUS ROG Smartwatch', 'ASRWS', 499.99, 12, 'Gaming smartwatch', 24),
(17, 17, 'Seagate 2TB HDD', 'SG2TB', 79.99, 60, 'Seagate external hard drive', 24),
(18, 9, 'Acer Predator VR Headset', 'APVR', 599.99, 8, 'VR headset for gaming', 24);

-- insert values to the customers table

INSERT INTO `customers` (`first_name`, `last_name`, `email`, `phone_number`, `address`) VALUES
('John', 'Doe', 'john.doe@email.com', '1234567890', '123 Main St'),
('Jane', 'Smith', 'jane.smith@email.com', '2345678901', '456 Oak St'),
('Alice', 'Brown', 'alice.brown@email.com', '3456789012', '789 Pine St'),
('Bob', 'Johnson', 'bob.johnson@email.com', '4567890123', '159 Maple Ave'),
('Charlie', 'Davis', 'charlie.davis@email.com', '5678901234', '753 Elm St'),
('Eve', 'Miller', 'eve.miller@email.com', '6789012345', '258 Birch Rd'),
('Frank', 'Wilson', 'frank.wilson@email.com', '7890123456', '369 Cedar Ln'),
('Grace', 'Moore', 'grace.moore@email.com', '8901234567', '741 Aspen Ct'),
('Hank', 'Taylor', 'hank.taylor@email.com', '9012345678', '852 Willow Dr'),
('Ivy', 'Anderson', 'ivy.anderson@email.com', '1122334455', '963 Spruce Blvd'),
('Jack', 'Carter', 'jack.carter@email.com', '1230987654', '321 Walnut St'),
('Kara', 'Hill', 'kara.hill@email.com', '2310987654', '654 Redwood St'),
('Leo', 'King', 'leo.king@email.com', '3410987654', '987 Birchwood St'),
('Mia', 'Scott', 'mia.scott@email.com', '4510987654', '543 Magnolia St'),
('Noah', 'Harris', 'noah.harris@email.com', '5610987654', '678 Palm St'),
('Olivia', 'Evans', 'olivia.evans@email.com', '6710987654', '789 Chestnut St'),
('Paul', 'White', 'paul.white@email.com', '7810987654', '890 Oakwood St'),
('Quinn', 'Lee', 'quinn.lee@email.com', '8910987654', '901 Pinewood St'),
('Rachel', 'Adams', 'rachel.adams@email.com', '9019876543', '147 Maplewood St'),
('Steve', 'Brown', 'steve.brown@email.com', '0198765432', '258 Elmwood St');


-- insert values to the sales table

INSERT INTO `sales` (`customer_id`, `product_id`, `quantity`, `total_amount`,`sale_date`) VALUES
(1, 1, 1, 1999.99, CURRENT_TIMESTAMP), (2, 2, 1, 1499.99, CURRENT_TIMESTAMP), (3, 3, 2, 1499.98, CURRENT_TIMESTAMP),
(4, 4, 1, 599.99, CURRENT_TIMESTAMP), (5, 5, 1, 1099.99, CURRENT_TIMESTAMP), (6, 6, 1, 699.99, CURRENT_TIMESTAMP),
(7, 7, 1, 2999.99, CURRENT_TIMESTAMP), (8, 8, 2, 659.98, CURRENT_TIMESTAMP), (9, 9, 1, 329.99, CURRENT_TIMESTAMP),
(10, 10, 3, 389.97, CURRENT_TIMESTAMP), (11, 11, 1, 299.99, CURRENT_TIMESTAMP), (12, 12, 2, 2399.98, CURRENT_TIMESTAMP),
(13, 13, 1, 99.99, CURRENT_TIMESTAMP), (14, 14, 1, 999.99, CURRENT_TIMESTAMP), (15, 15, 1, 899.99, CURRENT_TIMESTAMP),
(16, 16, 1, 449.99, CURRENT_TIMESTAMP), (17, 17, 1, 79.99, CURRENT_TIMESTAMP), (18, 18, 1, 599.99, CURRENT_TIMESTAMP),
(20, 20, 1, 599.99, CURRENT_TIMESTAMP),(19,19,1,599.99,'2022-02-20 23:15:13');

-- isnsert values into the suppliers table

INSERT INTO `suppliers` (`name`, `contact_person`, `phone_number`, `email`, `address`) VALUES
('TechWorld Supplies', 'David Smith', '1234567890', 'contact@techworld.com', '101 Tech Street'),
('Gadget Distributors', 'Laura Brown', '2345678901', 'info@gadgetdistro.com', '202 Electronics Ave'),
('Elite Components', 'Michael Johnson', '3456789012', 'support@elitecomp.com', '303 Parts Road'),
('Digital Supplies', 'Sarah Williams', '4567890123', 'sales@digitalsupplies.com', '404 Silicon Valley'),
('SuperTech', 'Robert Wilson', '5678901234', 'help@supertech.com', '505 Tech Hub'),
('NextGen Electronics', 'Emily Davis', '6789012345', 'info@nextgenelec.com', '606 Future Lane'),
('Quality Parts Inc.', 'Brian Miller', '7890123456', 'contact@qualityparts.com', '707 Component Drive'),
('FastDelivery Tech', 'Jessica Moore', '8901234567', 'order@fastdelivery.com', '808 Supplier Blvd'),
('Prime Electronics', 'Daniel Taylor', '9012345678', 'info@primeelectronics.com', '909 Prime St'),
('Alpha Distributors', 'Sophia White', '1122334455', 'sales@alphadist.com', '1000 Alpha Road'),
('TechZone Suppliers', 'James Lee', '2233445566', 'support@techzone.com', '1100 Innovation St'),
('ElectroParts', 'Megan Thomas', '3344556677', 'info@electroparts.com', '1200 Circuit Ave'),
('HyperGadgets', 'Ethan Harris', '4455667788', 'sales@hypergadgets.com', '1300 Gadget Blvd'),
('SmartParts Ltd.', 'Olivia King', '5566778899', 'contact@smartparts.com', '1400 Parts Park'),
('Vision Electronics', 'William Clark', '6677889900', 'info@visionelectronics.com', '1500 Future Ave'),
('Pioneer Components', 'Ava Scott', '7788990011', 'sales@pioneercomponents.com', '1600 Pioneer Drive'),
('Digital Hub', 'Benjamin Martinez', '8899001122', 'support@digitalhub.com', '1700 Digital Lane'),
('Gizmo Supplies', 'Charlotte Allen', '9900112233', 'order@gizmosupplies.com', '1800 Gizmo St'),
('Infinity Electronics', 'Lucas Hernandez', '1011223344', 'info@infinityelectronics.com', '1900 Infinity Rd'),
('CoreTech Suppliers', 'Amelia Walker', '1122334455', 'sales@coretech.com', '2000 CoreTech Blvd');


-- insert values to the product_suppliers table

INSERT INTO `product_suppliers` (`product_id`, `supplier_id`, `supply_price`) VALUES
(1, 1, 1500.00), (2, 2, 1100.00), (3, 3, 600.00), (4, 4, 450.00),
(5, 5, 900.00), (6, 6, 550.00), (7, 7, 2500.00), (8, 8, 500.00),
(9, 9, 250.00), (10, 10, 100.00), (11, 11, 230.00), (12, 12, 1000.00),
(13, 13, 80.00), (14, 14, 750.00), (15, 15, 750.00), (16, 16, 350.00),
(17, 17, 60.00), (18, 18, 480.00), (19, 19, 1000.00), (20, 20, 450.00);

-- insert values to the parts table

INSERT INTO `parts` (`name`, `brand_id`, `type_id`, `price`, `stock_quantity`) VALUES
('Laptop Battery', 3, 1, 99.99, 50), ('Smartphone Screen', 2, 2, 149.99, 40),
('Tablet Charger', 4, 3, 29.99, 60), ('Graphics Card Fan', 19, 18, 19.99, 100),
('Laptop Keyboard', 5, 9, 59.99, 30), ('Cooling Pad', 6, 5, 39.99, 75),
('Wireless Mouse Sensor', 12, 10, 19.99, 50), ('Smartwatch Strap', 8, 4, 15.99, 100),
('SSD 1TB', 17, 17, 99.99, 40), ('VR Lens Replacement', 9, 18, 49.99, 20),
('Router Antenna', 14, 13, 9.99, 200), ('Headphone Ear Pads', 13, 8, 19.99, 150),
('Projector Bulb', 16, 16, 79.99, 30), ('Laptop Cooling Fan', 7, 1, 49.99, 60),
('Gaming Console Controller', 6, 11, 69.99, 35), ('Smart Speaker Cover', 15, 14, 12.99, 90),
('Monitor Stand', 10, 6, 29.99, 45), ('TV Remote Control', 10, 12, 14.99, 120),
('External HDD Cable', 17, 17, 9.99, 300), ('Camera Lens Cap', 9, 15, 5.99, 200),('NT-H2',21,21,12.59,60);

-- insert values to the part_suppliers table

INSERT INTO `part_suppliers` (`part_id`, `supplier_id`, `supply_price`) VALUES
(1, 1, 80.00), (2, 2, 120.00), (3, 3, 20.00), (4, 4, 15.00),
(5, 5, 40.00), (6, 6, 25.00), (7, 7, 10.00), (8, 8, 8.00),
(9, 9, 70.00), (10, 10, 35.00), (11, 11, 7.00), (12, 12, 10.00),
(13, 13, 60.00), (14, 14, 35.00), (15, 15, 50.00), (16, 16, 9.00),
(17, 17, 20.00), (18, 18, 5.00), (19, 19, 3.00), (20, 20, 2.00),(21,20,9.50);

-- insert values to the part_compatibility table

INSERT INTO `part_compatibility` (`part_id`, `product_id`) VALUES
(1, 1), (2, 3), (3, 5), (4, 7),
(5, 9), (6, 12), (7, 15), (8, 18),
(9, 20), (10, 14);

-- insert values to the technicians table

INSERT INTO `technicians` (`first_name`, `last_name`, `email`, `status`) VALUES
('John', 'Doe', 'john.doe@example.com', 'Active'),
('Jane', 'Smith', 'jane.smith@example.com', 'Active'),
('Robert', 'Johnson', 'robert.johnson@example.com', 'On_leave'),
('Emily', 'Davis', 'emily.davis@example.com', 'Active'),
('Michael', 'Wilson', 'michael.wilson@example.com', 'Active'),
('Sarah', 'Brown', 'sarah.brown@example.com', 'Active'),
('David', 'Jones', 'david.jones@example.com', 'On_leave'),
('Emma', 'Garcia', 'emma.garcia@example.com', 'Active'),
('James', 'Martinez', 'james.martinez@example.com', 'Active'),
('Olivia', 'Anderson', 'olivia.anderson@example.com', 'Active');

-- insert values to the warranty_claims table

INSERT INTO `warranty_claims` (`product_id`, `customer_id`, `issue_desc`, `status`, `resolution_details`, `resolution_date`) VALUES
(1, 1, 'Battery not charging.', 'Pending', NULL, NULL), 
(2, 3, 'Screen has dead pixels.', 'Approved', 'Replacement', CURRENT_TIMESTAMP), 
(3, 5, 'Tablet not booting.', 'Denied', 'Rejected', CURRENT_TIMESTAMP), 
(4, 7, 'Laptop keyboard not working.', 'Pending', NULL, NULL),
(5, 9, 'Headphone jack malfunction.', 'Approved', 'Repair', CURRENT_TIMESTAMP),
(6, 11, 'Smartwatch strap defect.', 'Pending', NULL, NULL),
(7, 13, 'PC power supply failure.', 'Denied', 'Rejected', CURRENT_TIMESTAMP),
(8, 15, 'VR headset display issue.', 'Approved', 'Replacement', CURRENT_TIMESTAMP),
(9, 17, 'Router signal weak.', 'Pending', NULL, NULL),
(10, 19, 'Camera lens scratched.', 'Approved', 'Repair', CURRENT_TIMESTAMP),
(10, 3, 'Camera lens scratched.', 'Pending', NULL, NULL);

-- insert values to the repair_requests table ***

INSERT INTO `repair_requests` 
(`customer_id`, `product_id`, `technician_id`, `issue_title`, `issue_desc`, `status`, `repair_cost`,`repair_date`) 
VALUES 
(1, 1, NULL, 'Battery Issue', 'Laptop battery drains quickly.', 'Pending', NULL, NULL),
(2, 3, 2, 'Screen Cracked', 'Smartphone screen shattered.', 'In_progress', 149.99, NULL),
(3, 5, NULL, 'No Power', 'Tablet not turning on.', 'Pending', NULL, NULL), 
(4, 7, NULL, 'Performance Issue', 'PC running extremely slow.', 'Pending', NULL, NULL),
(5, 9, 5, 'Sound Distortion', 'Headphones have crackling sound.', 'Completed', 39.99, CURRENT_TIMESTAMP),
(6, 12, NULL, 'Display Glitch', 'TV screen flickering.', 'Pending', NULL, NULL), 
(7, 15, 6, 'Overheating', 'GPU overheating frequently.', 'In_progress', 79.99, NULL),
(8, 18, 8, 'VR Malfunction', 'VR headset won’t track movement.', 'In_progress', NULL, NULL),
(9, 20, NULL, 'USB Port Damage', 'Port not detecting devices.', 'Pending', NULL, NULL),
(10, 14, 10, 'Drone Motor Failure', 'Propeller motor stopped working.', 'Completed', 89.99, CURRENT_TIMESTAMP),
(2, 1, 6, 'Computer not working', 'computer not starting up', 'In_progress', NULL, NULL);

-- insert values to the repair_parts table

INSERT INTO `repair_parts` (`repair_id`, `part_id`, `quantity`) VALUES
(1, 1, 1), (2, 2, 1), (3, 3, 1), (4, 4, 1),
(5, 5, 1), (6, 6, 1), (7, 7, 1), (8, 8, 1),
(9, 9, 1), (10, 10, 1),(11,1,1),(11,14,1),(11,21,2);

-- Stored procedures

-- This procedure adds a new product to the products table

DELIMITER //
CREATE PROCEDURE addProduct(
    IN p_type_id INT UNSIGNED,
    IN p_brand_id INT UNSIGNED,
    IN p_name VARCHAR(32),
    IN p_model VARCHAR(32),
    IN p_price DECIMAL(10,2),
    IN p_stock_quantity INT,
    IN p_desc TEXT,
    IN p_warranty INT UNSIGNED
)
BEGIN
    IF p_stock_quantity > 0 THEN
        INSERT INTO products(`type_id`,`brand_id`,`name`,`model`,`price`,`stock_quantity`,`description`,`warranty_period`)
        VALUES (p_type_id, p_brand_id, p_name, p_model, p_price, p_stock_quantity, p_desc, p_warranty);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot add new product with zero stock available";
    END IF;
END //
DELIMITER ;

-- This procedure soft deletes a specific product specified by id

DELIMITER //
CREATE PROCEDURE deleteProduct(
    IN product_id INT UNSIGNED
)
BEGIN
    UPDATE `products` SET `deleted` = 1 WHERE `id` = product_id;
END //
DELIMITER ;

-- This procedure adds stock for a specifc product

DELIMITER //
CREATE PROCEDURE addProductStock(
    IN product_id INT UNSIGNED,
    IN new_quantity INT UNSIGNED
)
BEGIN
    DECLARE check_product INT UNSIGNED;

    -- check if the product id is valid
    SELECT COUNT(*) INTO check_product FROM products WHERE id = product_id;
    IF check_product > 0 THEN
        UPDATE products SET stock_quantity = (stock_quantity + new_quantity) WHERE id = product_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Product not found";
    END IF;
END //
DELIMITER ;

-- This procedure adds a new customer to the customers table

DELIMITER //
CREATE PROCEDURE addCustomer(
    IN c_name VARCHAR(32),
    IN c_last_name VARCHAR(32),
    IN c_email VARCHAR(255),
    IN c_phone_num VARCHAR(20),
    IN c_address VARCHAR(32)
)
BEGIN 
    INSERT INTO `customers`(`first_name`,`last_name`,`email`,`phone_number`,`address`)
    VALUES(c_name, c_last_name, c_email, c_phone_num, c_address);
END //
DELIMITER ;

-- This procedure soft deletes a customer specified by id

DELIMITER //
CREATE PROCEDURE deleteCustomer(
    IN customer_id INT UNSIGNED
)
BEGIN
    UPDATE `customers` SET deleted = 1 WHERE `id` = customer_id;
END //
DELIMITER ;

-- This procedure adds a new sale transaction to the sales table

DELIMITER //
CREATE PROCEDURE addSale(
    IN product_id INT UNSIGNED,
    IN customer_id INT UNSIGNED,
    IN p_quantity INT UNSIGNED
)
BEGIN

    DECLARE num_product INT UNSIGNED;
    DECLARE num_customer INT UNSIGNED;
    DECLARE product_price DECIMAL(10,2);

    -- Check if the product exists in the database
    SELECT COUNT(*) INTO num_product FROM products WHERE id = product_id;
    IF num_product > 0 THEN
        -- Check if customer exists in the database
        SELECT COUNT(*) INTO num_customer FROM customers WHERE id = customer_id;
        IF num_customer > 0 THEN
            -- Check if the specified quantity is greater then zero
            IF p_quantity > 0 THEN
                -- Get the unit price for the specified product
                SELECT price INTO product_price FROM products WHERE id = product_id;

                -- add the transaction to the sales table
                INSERT INTO sales (customer_id, product_id, quantity, total_amount)
                VALUES (customer_id, product_id, p_quantity, (product_price * p_quantity));

                -- update the stock of the product is done after insert inside the sales table using update_products_stock_after_sale trigger
                
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "quantity must be greater then zero";
            END IF;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "customer does not exist";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "product does not exist";
    END IF;

END //
DELIMITER ;

-- This procedure adds a new product/part supplier to the suppliers table

DELIMITER //
CREATE PROCEDURE addSupplier(
    IN sup_name VARCHAR(32),
    IN sup_contact_person VARCHAR(32),
    IN sup_number VARCHAR(20),
    IN sup_email VARCHAR(255),
    IN sup_address VARCHAR(255)
)
BEGIN
    INSERT INTO suppliers (name, contact_person, phone_number, email, address)
    VALUES(sup_name, sup_contact_person, sup_number, sup_email, sup_address);
END //
DELIMITER ;

-- This procedure deletes an existing supplier from suppliers table (soft delete)

DELIMITER //
CREATE PROCEDURE deleteSupplier( 
    IN sup_id INT UNSIGNED
)
BEGIN
    UPDATE suppliers SET deleted = 1 WHERE id = sup_id;
END //
DELIMITER ;

-- This procedure sets the supplier of each product as well their shipping_price

DELIMITER //
CREATE PROCEDURE setProductSupplier(
    IN product_id INT UNSIGNED,
    IN supplier_id INT UNSIGNED,
    IN price DECIMAL(10,2)
)
BEGIN
    DECLARE prod_check INT UNSIGNED;
    DECLARE sup_check INT UNSIGNED;

    -- check if the sepecified product exists in the products table
    SELECT COUNT(*) INTO prod_check FROM products WHERE id = product_id;
    IF prod_check > 0 THEN
        -- check if the specified supplier exists inside the suppliers table
        SELECT COUNT(*) INTO sup_check FROM suppliers WHERE id = supplier_id;
        IF sup_check > 0 THEN
            INSERT INTO product_suppliers (product_id, supplier_id, supply_price)
            VALUES(product_id, supplier_id, price);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "supplier does not exist";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "product does not exist";
    END IF;
END //
DELIMITER ;

-- This procedure adds a new part to the parts table

DELIMITER //
CREATE PROCEDURE addPart(
    IN part_name VARCHAR(32),
    IN part_brand INT UNSIGNED,
    IN part_type INT UNSIGNED,
    IN part_price DECIMAL(10,2),
    IN part_stock INT UNSIGNED
)
BEGIN
    IF part_stock > 0 THEN
        INSERT INTO parts(name, brand_id, type_id, price, stock_quantity)
        VALUES(part_name, part_brand, part_type, part_price, part_stock);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "quantity must be greater then zero";
    END IF;
END // 
DELIMITER ;

-- This procedure deletes an existing part from parts table (soft delete)

DELIMITER //
CREATE PROCEDURE deletePart( 
    IN part_id INT UNSIGNED
)
BEGIN
    UPDATE parts SET deleted = 1 WHERE id = part_id;
END //
DELIMITER ;

-- This procedure adds stock for a specifc part

DELIMITER //
CREATE PROCEDURE addPartStock(
    IN part_id INT UNSIGNED,
    IN new_quantity INT UNSIGNED
)
BEGIN
    DECLARE check_part INT UNSIGNED;

    -- check if the product id is valid
    SELECT COUNT(*) INTO check_part FROM parts WHERE id = part_id;
    IF check_part > 0 THEN
        UPDATE parts SET stock_quantity = (stock_quantity + new_quantity) WHERE id = part_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Part not found";
    END IF;
END //
DELIMITER ;

-- This procedure sets the supplier of each part as well their shipping_price

DELIMITER //
CREATE PROCEDURE setPartSupplier(
    IN part_id INT UNSIGNED,
    IN supplier_id INT UNSIGNED,
    IN price DECIMAL(10,2)
)
BEGIN
    DECLARE part_check INT UNSIGNED;
    DECLARE sup_check INT UNSIGNED;

    -- check if the sepecified product exists in the products table
    SELECT COUNT(*) INTO part_check FROM parts WHERE id = part_id;
    IF part_check > 0 THEN
        -- check if the specified supplier exists inside the suppliers table
        SELECT COUNT(*) INTO sup_check FROM suppliers WHERE id = supplier_id;
        IF sup_check > 0 THEN
            INSERT INTO part_suppliers (part_id, supplier_id, supply_price)
            VALUES(part_id, supplier_id, price);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "supplier not found";

        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "part not found";
    END IF;
END //
DELIMITER ;

--- This procesure sets the compatibility between parts and products

DELIMITER //
CREATE PROCEDURE setPartCompatibility(
    IN part_id INT UNSIGNED,
    IN product_id INT UNSIGNED
)
BEGIN
    DECLARE part_check INT UNSIGNED;
    DECLARE product_check INT UNSIGNED;

    -- Check if the part exists in the parts table
    SELECT COUNT(*) INTO part_check FROM parts WHERE id = part_id;
    IF part_check > 0 THEN
        -- Check if the product exists in the parts table
        SELECT COUNT(*) INTO product_check FROM products WHERE id = product_id;
        IF product_check > 0 THEN 
            INSERT INTO part_compatibility(part_id, product_id)
            VALUES(part_id, product_id);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Product does not exist";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Part does not exist";
    END IF;

END //
DELIMITER ;

-- This procedure adds a new technician to the technicians table

DELIMITER //
CREATE PROCEDURE addTechnician(
    IN first_name VARCHAR(32),
    IN last_name VARCHAR(32),
    IN email VARCHAR(255)
)
BEGIN
    INSERT INTO technicians(first_name, last_name, email)
    VALUES(first_name, last_name, email);
END //
DELIMITER ;

-- This procedure deletes a specified technician from the technicians table (soft delete)

DELIMITER //
CREATE PROCEDURE deleteTechnician(
    IN technician_id INT UNSIGNED
)
BEGIN
    UPDATE technicians SET deleted = 1 WHERE id = technician_id;
END //
DELIMITER ;

-- This procedure set the status of a specified technician to either Active/On_leave

DELIMITER //
CREATE PROCEDURE setTechnicianStatus(
    IN technician_id INT UNSIGNED,
    IN t_status VARCHAR(32)
)
BEGIN
    IF t_status IN ('Active','On_leave') THEN
        UPDATE technicians SET `status` = t_status WHERE id = technician_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Invalid status value";
    END iF;

END //
DELIMITER ;

-- This procedure add a new repair request to the repair_requests table
DELIMITER //
CREATE PROCEDURE addRepairRequest(
    IN customer_id INT UNSIGNED,
    IN product_id INT UNSIGNED,
    IN title VARCHAR(255),
    IN issue_desc TEXT
)
BEGIN
    DECLARE check_customer INT;
    DECLARE check_product INT;

    -- Check if the provided customer_id is valid
    SELECT COUNT(*) INTO check_customer FROM customers WHERE id = customer_id;
    IF check_customer > 0 THEN
    -- Check if the provided product_id is valid
        SELECT COUNT(*) INTO check_product FROM products WHERE id = product_id;
        IF check_product > 0 THEN
            -- add the new repair request to the repair_requests table
            INSERT INTO repair_requests(customer_id, product_id, issue_title,issue_desc)
            VALUES(customer_id, product_id, title, issue_desc);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "product does not exist";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "customer does not exist";
    END IF;
END //
DELIMITER ;

-- This procedure assigns a technician to a specific repair_request
DELIMITER //
CREATE PROCEDURE assignTechnician(
    IN request_id INT UNSIGNED,
    IN tech_id INT UNSIGNED
)
BEGIN
    DECLARE check_request INT UNSIGNED;
    DECLARE check_request_status VARCHAR(32);
    DECLARE check_technician INT UNSIGNED;
    DECLARE check_technician_status VARCHAR(32);

    -- Check if the request id is valid
    SELECT COUNT(*) INTO check_request FROM repair_requests WHERE id = request_id;
    IF check_request > 0 THEN
        -- Check if the repair request status is Pending
        SELECT `status` INTO check_request_status FROM repair_requests WHERE id = request_id;
        IF check_request_status = "Pending" THEN
            -- Check if the technician id is valid
            SELECT COUNT(*) INTO check_technician FROM technicians WHERE id = tech_id;
            IF check_technician > 0 THEN
                -- Check if the technician status is Active
                SELECT `status` INTO check_technician_status FROM technicians WHERE id = tech_id;
                IF check_technician_status = "Active" THEN
                    -- assign the specified technician to the repair request
                    UPDATE repair_requests SET technician_id = tech_id WHERE id = request_id; 
                ELSE
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot assign a repair request to an off duty technician";
                END IF;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "technician does not exist";
            END IF;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot assign a technician to a In_progress/Completed repair requests";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "repair request does not exist";
    END IF;

END //
DELIMITER ;

-- This procedure calculate the total cost of parts used in the repair request
DELIMITER //
CREATE PROCEDURE calculaterepairCost(
    IN request_id INT UNSIGNED,
    OUT cost DECIMAL(10,2)
)
BEGIN
    SELECT SUM(total_cost) INTO cost
    FROM(
        SELECT rp.part_id AS part_id, p.price AS price, rp.quantity AS repair_quantity, ( rp.quantity * p.price) AS 'total_cost'
        FROM repair_parts rp
        JOIN parts p ON rp.part_id = p.id
        WHERE rp.repair_id = request_id
        ) AS repair_cost;
END //
DELIMITER ;


-- This procedure set the repair request to completed
DELIMITER //
CREATE PROCEDURE completeRepairRequest(
    IN request_id INT UNSIGNED
)
BEGIN
    DECLARE check_request INT UNSIGNED;
    DECLARE check_status VARCHAR(32);
    DECLARE cost DECIMAL(10,2);

    -- check if the request id is valid
    SELECT COUNT(*) INTO check_request FROM repair_requests WHERE id = request_id;
    IF check_request > 0 THEN
        -- make sure that the repair request status is In_progress
        SELECT `status` INTO check_status FROM repair_requests WHERE id = request_id;
        IF check_status = "In_progress" then
            -- Call a procedure to calculate the cost of the repair
            CALL calculaterepairCost(request_id, cost);
            -- updating the status of the repair request to Completed and adding the repair cost
            UPDATE repair_requests SET status = 'Completed', repair_cost = cost WHERE id = request_id; 
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot complete a pending/completed repair request";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "repair request does not exist";
    END IF;
END //
DELIMITER ;

-- this procedure adds a new arranty claim to the warranty_claims
DELIMITER //
CREATE PROCEDURE addWarrantyClaim(
    IN sale_id INT UNSIGNED,
    IN issue TEXT
)
BEGIN
    DECLARE product INT UNSIGNED;
    DECLARE customer INT UNSIGNED;
    DECLARE check_sale INT UNSIGNED;

    -- Check if the sale id is valid
    SELECT COUNT(*) INTO check_sale FROM sales WHERE id = sale_id;
        IF check_sale > 0 THEN
         -- get the product_id and customer_id in that sale
            SELECT product_id, customer_id INTO product, customer FROM sales WHERE id = sale_id;
            -- Insert a new warranty claim to the warranty_claims table
            INSERT INTO warranty_claims (product_id, customer_id, issue_desc)
            VALUES (product, customer, issue);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "warranty claims require valid sale record to be processed";
        END IF;

END //
DELIMITER ;

-- This procedure is used to approve a warranty claims
DELIMITER //
CREATE PROCEDURE approveWarrantyClaim(
    IN claim_id INT UNSIGNED,
    IN claim_resolution ENUM('Repair','Replacement')
)
BEGIN
    DECLARE check_claim INT UNSIGNED;
    DECLARE check_status VARCHAR(32);

    -- check if the claim already exists in the system
    SELECT COUNT(*) INTO check_claim FROM warranty_claims WHERE id = claim_id;
    IF check_claim >0 THEN
        -- make sure that the claim is Pending
        SELECT status INTO check_status FROM warranty_claims WHERE id = claim_id;
        IF check_status = "Pending" THEN
            UPDATE warranty_claims SET resolution_details = claim_resolution WHERE id = claim_id;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot handle an already Approved/Denied warranty claim";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "warranty claim does not exist";
    END IF;
END //
DELIMITER ;

-- This procedure is used to deny a warranty claims
DELIMITER //
CREATE PROCEDURE denyWarrantyClaim(
    IN claim_id INT UNSIGNED
)
BEGIN
    DECLARE check_claim INT UNSIGNED;
    DECLARE check_status VARCHAR(32);

    -- check if the claim already exists in the system
    SELECT COUNT(*) INTO check_claim FROM warranty_claims WHERE id = claim_id;
    IF check_claim >0 THEN
        -- make sure that the claim is Pending
        SELECT status INTO check_status FROM warranty_claims WHERE id = claim_id;
        IF check_status = "Pending" THEN
            UPDATE warranty_claims SET resolution_details = 'Rejected' WHERE id = claim_id;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "cannot handle an already Denied/Approved warranty claim";
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "warranty claim does not exist";
    END IF;
END //
DELIMITER ;

/*

next is 
- the repair_requests table (add)
- create a procedure to assign a technician to a repair request (done)
- create a procedure to close a repair request (done)
- rest of the tables (done)
- re-check the procedure (done)
- write the readme.md for github

*/

/*
--- priority problem (resolved) ---
the quantity column value inside the product_suppliers and part_suppliers may differ from the 
quantity_stock in the products table.

-- initial solution:
for the product_suppliers they i will remove the quantity column since it had no value
main because we already have the stock_quantity column in products table that allows us to track the current stock of a certain product
instead this table will list only the id of a supplier for a certain product
along side the supply price and no supply date.

-- what i have already done:
i remove the quantity column, supply date and the constrain that controls the
quantity supplied . 

This can be used to create a query that display top 3 cheapest suppliers
from certain part or product.

----------------------------------
To do list
- recheck current progress *
- triggers (done no need to add more triggers)
    - recheck and revise the triggers : done
    - add a final trigger to automatically close the warranty claim when it's completed : Done
    ==> all trigger tested and they are working =====> done

- views =====> done
- insert statements =====> done
    need to make sure that products quantity changes resulted from the sales
    are track in the product_inventory_log => done same with the part_inventory_log


- possible queries
    - preferablly in prepared statements structure for improved security
*/
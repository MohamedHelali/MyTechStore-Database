-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Basic queries

-- Retrieve all available products in stock
SELECT * FROM `available_products`;

-- Lists the products with low levels of stock
SELECT * FROM `low_stock_products`;

-- Retrieve all available parts in stock
SELECT * FROM `available_parts`;

-- Lists the parts with low levels of stock
SELECT * FROM `low_stock_parts`;

-- list most sold product brands
SELECT * FROM `most_sold_brands`;

-- list most used repair parts
SELECT * FROM `most_used_parts`;

-- Retrieve all customers
SELECT * FROM `customers`;

-- get a sale summary by customer
SELECT * FROM `sales_summary_per_client`;

-- list detailed sale records
SELECT * FROM `detailed_sales`;

-- Retrieve list of all sales transactions
SELECT * FROM `sales`;

-- Retrieve all open Repair Requests
SELECT * FROM `open_repair_requests`;

-- Retrieve all apen warranty claims
SELECT * FROM `open_warranty_claims`;

-- Check technicians workload
SELECT * FROM `technician_workload`;

-- using stored procedures

-- add new product to the products table
CALL addProduct(1,12,"Cyborg 15","A13VE",1199.99,10,"MSI Cyborg 15 A13VE i7 13e Gen 32G RTX 4050",12);

-- soft delete a product from the database (soft delete) (require the previous query)

CALL deleteProduct(21);

-- add more stock to a specific product
CALL addProductStock(1,20);

-- add new customer to the customers table

CALL addCustomer("derrick","jhons","derrick.jhons@gmail.com","1233455697","231 Main St");

-- soft delete a customer from customers table (soft delete)

CALL deleteCustomer(20);

-- add a new sale transaction to the sales table

CALL addSale(1,3,3);

-- add a new part/product supplier to the suppliers table

CALL addSupplier("Mytek","Adam Smith","2055432490","sales@Mytek.com","233 Maple St");

-- soft delete an existing part/product supplier from the suppliers table

CALL deleteSupplier(20);

-- link each product to each supplier

CALL setProductSupplier(20,3,799.99);

-- Add a new part to the parts table
CALL addPart("GeForce RTX 4090 SUPRIM LIQUID X",12,20,1749.99,5);

-- soft delete a part from parts table
CALL deletePart(20);

-- add more stock to a specific part
CALL addPartStock(1,42);

-- set a supplier for a specific part
CALL setPartSupplier(21,1,1399.38);

-- add a new technician to the technicians table
CALL addTechnician("James","White","James.White@example.com");

-- soft delete an exists technician from the technicians table
CALL deleteTechnician(10);

-- Set the status of technician to On_leave
CALL setTechnicianStatus(1,'On_leave');

-- Add a new repair request inside the repair_requests table
CALL addRepairRequest(1,1,"Screen Not working","when i start the computer the screen remains off");

-- Assigns an Active Technician to a specifc Pending repair Request (please execute the previous query)
CALL assignTechnician(11,1);

-- Sets a repair request to Completed
CALL completeRepairRequest(11);

-- Add a new warranty claim to the warranty_claims table
CALL addWarrantyClaim(1,"screen got green line in the middle");

-- Approve a specific warranty claim (product will be replaced)
CALL approveWarrantyClaim(1,'Replacement');

-- Deny a specific warranty claim
CALL denyWarrantyClaim(4);
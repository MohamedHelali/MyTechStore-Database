#  MyTechStore Database

####  Video Demo:

## About the project

**MyTechStore** is a custom database I designed as the final project for CS50's _Introduction to SQL_ course. This project aims to provide users with a structured database to efficiently manage a small electronics shop specializing in selling and repairing various electronic devices.

Project structure:
 * schema.sql
 * queries.sql
 * DESIGN.md (This File)

## Technologies Used
* **Database Management System:** MySQL 8.0.41 or higher
*  **Key SQL Features Used:**
	* **Normalization** (to reduce data redendancy)
	* **Constraints** (to maintain data integrity, accuracy, and reliability).
	* **Views** (to simplify queries and improve security)
	* **Indexes** (to optimize query performance)
	* **Triggers** (to automate tasks inside the database)
	*  **Stored Procedures** (to simplify complex operations)

## Database Schema & Relationships

### Database Schema

This database follows the **relational model**, where the tables are liked using primary keys **(PK)** and foreign keys **(FK)**.  It consists of 16 tables: 12 main tables and 4 junction tables.
this section we will further explain the tables and their relationships.

### Tables & Their Purpose

* **types**: This table stores information about the type of the products or parts sold in the store. It consists of two columns:
	*  **id**: An auto-incrementing integer serving as a unique identifier for each record in the table.
	* **name**: A String representing the type of product or a part such as **computer**, **gpu**, **cpu** etc.
> [!NOTE]
> - When designing the database, we chose to use unsigned integer values for columns that will never contain negative values, such id, stock_quantity, price etc. This optimization reduces memory usage when inserting new records, allowing us to minimize the overall database size.  

* **brands**: This table stores information about the brands of the products or parts sold in the store. it consists of two columns:
	*  **id**:  An auto-incrementing integer serving as a unique identifier for each record in the table.
	*  **name**: A string representing the brand of the product or part, such as Apple, AMD, NVIDIA, Intel etc. 

* **products**: This table stores the information about the products sold in the store. It consists of 10 columns:
	*  **id**: An auto-incrementing integer serving as a unique identifier for each record.
	*  **type_id**: A foreign key referecing the **types** table, indicating the product type.
	* **brand_id**: A foreign key that referencing the **brands** table, indicating the product's brand.
	* **name**:  A string containing the product name.
	*  **model**: A string containing the product's model name.
	* **price**: A decimal value representing product price.
	* **stock_quantity**: An integer indicating the current stock of the product.
	* **description**: A long String containing additional product details.
	* **warranty_period**: An integer representing the product's warranty period.
	* **deleted**: A Boolean flag for **soft deletion**, indicating whether the product's record is marked as deleted.

> [!IMPORTANT]
>  When inserting a new product into the **products** table:  
> - **stock_quantity** must not be left empty and should be set to a value greater then 0.
>  * **warranty_period** must be specified in months.

*  **customers**: This table stores informations about customers who have purchased products from the store. It consists of 7 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **first_name**: A string containing the customer's first name.
	* **last_name**: A string containing the customer's last name.
	* **email**: A string containing the customer's email.
	* **phone_number**: A string containing the customer's phone number.
	* **address**: A string containing the customer's address.
	* **deleted**: A Boolean flag for **soft deletion**, indicating whether the customer's record is marked as deleted.
 
 * **sales**: This table stores information about all sales transactions. It consists of 6 columns:
	 * **id**: An auto-incrementing integer serving as a unique identifier for each record.
	 * **customer_id**: A foreign key referencing the **customers** table, indicating the customer who initialized the transaction.
	 * **product_id**: A foreign key referencing the **products** table, indicating the purchased product.
	 * **quantity**:  An integer representing the quantity of product purchased.
	 * **total_amount**: A decimal value representing the total cost of the purchased products.
	 * **sale_date**: A Timestamp indicating when the transaction occurred.
> [!IMPORTANT]
>  When adding a new sale record into the **sales** table:  
> - **quantity** must not be left empty and should be set to a value greater then 0.

* **suppliers**: This table stores information about the suppliers providing various products and parts sold in the shop. It consists of 7 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **name**: A string containing the supplier company's name.
	*  **contact_person**: A string containing the full name of the company's contact person.
	* **phone_number**: A string containing the supplier's phone number.
	* **email**: A string containing the supplier's contact email.
	* **address**: A string containing the supplier's company full address.
	* **deleted**: A Boolean flag for **soft deletion**, indicating whether the supply's record is marked as deleted.

* **product_suppliers**: This junction table likes the **products** and **suppliers** tables, allowing us to specify  the **supplier** and **supply price** for each product. It consists of 3 columns:
	* **product_id**: A foreign key referencing the **products** table, indicating the a specific product.
	* **supplier_id**: A foreign key referencing the **suppliers** table, indicating the specific product's supplier.
	* **supply_price**: A decimal value representing the price at which the supplier provides the product.

* **parts**: This table stores information about the spare parts that are sold or used by the shop to fix damaged products. It consists of 6 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **name**: A string containing the part's name.
	* **brand_id**: A foreign key that referencing the **brands** table, indicating the part's brand.
	*  **type_id**: A foreign key referecing the **types** table, indicating the part's type.
	* **price**: A decimal value indicating the part's price.
	* **stock_quantity**: An integer indicating the current stock of the part.

> [!IMPORTANT]  
> When inserting a new part into the **parts** table:
> * **stock_quantity** must not be left empty and should be set to a value greater than 0.

* **part_suppliers**: This junction table links the **parts** and **suppliers** tables, allowing us to specify the **supplier** and **supply price** for each part. It consists of 3 columns:
	* **part_id**: A foreign key referencing the **parts** table, indicating a specific part.
	* **supplier_id**: A foreign key referencing the **suppliers** table, indicating the supplier of the part.
	* **supply_price**: A decimal value representing the price at which the supplier provides the part.

* **part_compatibility**: This junction table links the **parts** and **products** table, allowing us to specify which parts are compatible with each product. It consists of 2 columns:
	* **part_id**: A foreign key referencing the **parts** table, indicating a specific part.
	* **product_id**: A foreign key referencing the **products** table, indicating a speecific table.

* **technicians**: This table stores information about store technicians responsible for handling **repair requests** and **warranty claims**. It consists of 7 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **first_name**: A string containing the technician's first name.
	* **last_name**: A string containing the technician's last name.
	* **email**: A string containing the technician's contact email.
	* **status**: A ENUM column with fixed values indicating the technician's availablability:
		* **Available**: The technician is currently available.
		* **on_leave**: The technician is on leave.
	* **hire_date**: A timestamp indicating the technician's hire date.
	* **deleted**: A Boolean flag for **soft deletion**, indicating whether the technician's record is marked as deleted.

> [!IMPORTANT]  
> To maintain **data standardization** across the database and prevent potential **inconsistencies**, the **status** column in the **technicians** table only accepts one of the following predefined values: **Available** or **On_leave**.

* **repair_requests**: This table stores information about **repair_requests** submitted by the customers to fix their damaged products. It consists of 11 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each repair request.
	* **customer_id**: A foreign key referencing the **customers** table, identifying the customer who submitted the request.
	* **product_id**: A foreign key referencing the **products** table, specifying the product to be repaired.
	* **technician_id**: A foreign key referencing the **technicians** table, indicating the technician assigned to handle the repair.
	* **issue_title**: A string describing the primary issue with the product.
	* **issue_desc**: A long text field containing additional details about the product's issue.
	* **request_date**: A timestamp indicating the exact date when the repair request was submitted.
	*  **status**: A ENUM column with predefined values representing the repair request's current status:
		* **Pending**:  No technician has been assigned yet, and the request is awaiting processing.
		* **In_progress**: A technician is activily repairing the device.
		* **Completed**: The device has been successfully repaired.
* **repair_cost**: A decimal value representing the total cost of the repair.
*  **repair_date**: A timestamp indicating the exact date when the repair was completed.
* **deleted**: A Boolean flag for **soft deletion**, indicating whether the repair_request's has been logically removed.

> [!IMPORTANT]  
> Due to limited scope of the project, repair requests are restricted to products sold by the shop. This decision helps simplify the database management, particularly in areas such as spare parts inventory management.

> [!NOTE]
> To maintain **data standardization** and prevent **inconsistencies**, the **status** column in the **repair_requests** table only accepts the following predefined values: **Pending**, **In_progress** or **Completed**.

* **repair_parts**: This junction table links the **repair_requests** and **parts** tables, it allows us to track the **spare parts** used in repairing a device associated with repair request. this table consist of 4 columns:
	*  **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **repair_id**: A foreign key referenceing the **repair_requests** table, indicating the repair request that required the parts.
	* **part_id**: A foreign key referencing the **parts** indicating the specifc part used during the repair.
	* **quantity**: An integer representing the number of units of a specific part used in a repair.

> [!IMPORTANT]
> When adding a new record to the **repair_parts** table, the **quantity** column value **must be strictly greater than zero** to ensure valid tracking of spare parts usage.

* **warranty_claim**: This table stores information about **warranty claims** initiated by the customers for products purchased from the store. It consists of 8 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **product_id**: A foreign key referencing the **products** table, identifying the potentially defective product.
	* **customer_id**: A foreign key referencing the **customers** table, identifying the customer who submitted the warranty claim.
	* **claim_date**: A timestamp indicating the date when the warranty claim was submitted.
	* **issue_desc**: A long text field conatining details about the defective device.
	* **status**: A ENUM column with predefined values representing the current status of the warranty claim:
		*  **Pending**: The claim is awaiting processing
		* **Approved**: The claim has been reviewed, and the store has agreed to handle the defective device.
		* **Denied**: The claim has been reviewed, but the store has refused to handle the defective device.
	* **resolution_details**: A ENUM column with predefined values indicating how the store handled the warranty claim:
		* **Repair**: The store agreed to resolve the claim by repairing the defective device.
		* **Replacement**: The store agreed to resolve the claim by replacing the defective device.
		* **Rejected**: The store denied the claim and refused to repair or replace the device.
		* **resolution_date**: A timestamp indicating when the warranty claim was processed.

* **product_inventory_log**: This table stores a **historical record of changes** made the **products** table. It consists 5 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **product_id**: A foreign key referencing the **products** table indicating the specifc product affected by the change.
	* **change_quantity**: A integer indicating the stock quantity change.
	*  **change_date**: A timestamp indicated when the change occured.
	* **reason**: A ENUM column with predefined values specifying the reason for the change:
		* **Added**: A new product was added to the products table.
		* **Sale**: A sale transaction occured, reducing the stock of a the product.
		* **Restock**:  New units were added to the product's current stock.

* **part_inventory_log**: This table stores **historical record of changes** made to the **parts** table. It consists 5 columns:
	* **id**: An auto-incrementing integer serving as a unique identifier for each record.
	* **part_id**: A foreign key referencing the **parts** table indicating the specifc part affected by the change.
	* **change_quantity**: A integer indicating the stock quantity change.
	* **change_date**: A timestamp indicated when the change occured.
	* **reason**: A ENUM column with predefined values specifying the reason for the change:
		* **Added**: A new part was added to the parts table.
		* **Repair**: The part was used to repair a device, reducing the stock of a the part.
		* **Restock**:  New units were added to the part's current stock.

> [!IMPORTANT]
> The **product_inventory_log** and **part_inventory_log** tables are automatically populated by the database using custom **triggers**. These triggers track and log changes affecting the stock levels of both **products** and **parts**, simplifying inventory management and ensuring accurate record-keeping.

### Database relationships
In this section we will further explain the different relations between the various table inside our database.
To better understand the database, the following image contains an **entity-relationship** diagram (Also known as ER-diagram) detailing the relationships between the differents tables inside the database:

![Entity-relationship diagram!](https://github.com/user-attachments/assets/67090c34-6e84-4409-a6fb-bdf98cff471b "Entity-relationship diagram")

**1. Product & Inventory Relationships**
* **Products** ---> **types **(Many-to-One)
	* A **products** belongs to one Type (e.g., Laptop, CPU, GPU).
* **Products** ---> **brands** (Many-to-One)
	* A **product** is associated with one **Brand** (e.g., Apple, AMD, Dell).
* **products** ---> **product_suppliers** ---> **suppliers** (Many-to-Many via **product_suppliers**)
	* Products are supplied by **multiple suppliers**.
	* A supplier can provide **multiple products**.
* **products** ---> **product_inventory_log** (One-to-Many)
	* Every **stock change** for a product is recorded in the inventory log.

**2. Sales & Customer Relationships**
* **customers** ---> **sales** (One-to-Many)
	*  A customer can place **multiple purschase orders** (each sale record correspond to one product purchase)
* **products** ---> **sales** ( One-to-Many).

	* A **product** can appear in **multiple sales** (since each sale only records a single product).   

**3. Repair & Warranty Management**
* **customers** ---> **repair_requests** (One-to-Many)
	* A customer can request **multiple repairs** for differents products.
* **customers** ---> **warranty_claims** (One-to-Many)
	* A customer can file **multiple warranty claims**.
* **technicians** ---> **repair_requests** (One-to-Many)
	* Each repair request is handled by **one** technician.

**4. Parts & Compatibility Relationships**
* **parts** ---> **types** (Many-to-one)
	* A part belongs to **one** type (e.g., battery, motherboard).
	* A type can group **multiple** parts.
* **parts** ---> **brands** (Many-to-One)
	* A part is associated with one **Brand** (e.g., Asus, Crucial)
* **parts** ---> **part_compatibility** ---> **products** (Many-to-Many via **part_compatibility**)
	* defines which parts are **compatible** with which **products**.
* **parts** ---> **part_suppliers** ---> **suppliers** (Many-to-Many via **part_suppliers**)
	* parts are supplied by multiple **suppliers**.
	* A supplier can provide multiple **parts**.
* **parts** ---> **part_inventory_log** (One-to-Many)
	* Every **stock change** for a part is recorded in the inventory log.
* **repair_request** ---> **repair_parts** ---> **parts** (Many-to-Many via **repair_parts**)
	* tracks which **parts** were used in a **specific repair request**.

**5. Automated Tracking Relationships**
* **product_inventory_log** is automatically filled by custom triggers when:
	* A product is **added**, **sold**, or **restocked**.
* **part_inventory_log** is automatically filled by cutom triggers when:
	* A part is **added**, **used in a repair**, or **restocked**. 

### Database views
#### Views Overview
This section provides a detailed overview of the views implemented in our database. Our project includes 11 views, which serves as **custom virtual tables** that presents important information from one or more tables. By using views, we can **reduce query complexity** and make the database easier to use. 
The primary objectives of using views in a database are:

* **Data abstraction**: Views Simplify complex queries by presenting a subset of the requested data in a structured and easy-to-use format.
* **Simplified querying**: Views allow users to execute queries on a predefined datasets without repeatedly writing complex SQL statements.
* **Data consistancy**: Ensures that multiple users access the same data sources simultaneously, preventing inconsistencies or misunderstandings.
* **Security**: Views restricts access to specific rows or columns, providing controlled access data access without exposing the entire tables.

#### Implemeted Views
In this section, we will provide a detailed explanation of each implemented view, including its purpose, structure, and how it helps simplify database operations.

**1. available_products**

The **available_products** view provides a list of all available products that currently in stock. This view simplifies querying by filtering out products with zero stock, allowing users to retrieve only the **available** items without having to type complex queries.

**Structure and purpose**

This view is build by joining the **products**, **brands**, and **types** table to have a more detailed dataset. It includes:
* **id**: The unique identifier of the product.
* **brand**: The brand name of the product (retrieved from the **brands** table).
* **type**: The category/type of the product (retrieved from the **types** table).
* **name**: The product's name.
*  **model**: The model name of the product.
* **price**: The selling price of the product.
* **stock_quantity**: The number of units currently available in stock.

**Use Case**

This view is particularly useful when retrieveing a list of products that are currently in stock for:
* Display available products on sale on a sales website or an inventory dashboard.
* Ensuring that out-of-stock products are not included in purchase orders.
* Generating reports on **available** inventory without filtering the main **products** table. 

**2. sales_summary_per_client**

The **sales_summary_per_client** view provides a summary of each customer's purchase activity. It helps track the total number of purchases and the total amount spent by each customer, making it easier to analyse the customer spending behavior.

**Structure and purpose**

This view aggregates sales data per customer and includes:
* **customer_id**: The unique identifier of the customer.
* **customer_name**: the full name of the customer (concatinated from **first_name** and **last_name** retrieved from the **customers** table).
* **total_purchases**: the total number of purchases made by the customer.
* **total_amount**: The total amount spent by the customer across all transactions.

**Use Case**
This view is particularly useful for:
* identifying the **top-spending** customers by sorting the generated results based on the **total_amount**.
* Generate a **customer purchase reports** that can be used for business intelligence to gain additional insights and enhance the store's overall marketing strategy.
* Analyzing customer engagement and purchasing trends to improve sales strategies.
* Quickly retrieving key customer metrics without running complex queries on raw tables.

**3. detailed_sales**

The **detailed_sales** view provides a comprehensive breakdown of sales transactions including customer details, product information and purchase details. This view make it easier to analyze sales data without the need to join multiple tables manually.

**Structure and Purpose**

This view combines data from **products**, **customers**, **types**, **brands**, and **sales** to presents a detailed insights into each sale transaction. It includes:
* **customer_id**: The unique identifier of the customer.
* **full_name**: The full name of the customer (concatinated from the **first_name** and **last_name** retrieved from the **customers** table).
* **product_type**: The category/type of the purchased product.
* **brand**: The brand name of the product.
* **quantity**: the number of units purchased by the customer.
* **total_amount**: The total cost of the purchased items in the transaction.
* **sale_date**: The date when the sale was made.

**Use Case**

This view can be useful for:
* Tracking **sales trands** based on product types and brands.
* Providing sales representatives with customer purchase history for better customer relationship management.
* Reducing the need for complex queries when analyzing **transaction-level sales data**.

**4. open_repair_requests**

The **open_repair_request** view provides a list of repair request that are still **pending** or **in progress**. This view helps track active repair requests and simplifies the process of monitoring ongoing repairs.

**Structure and Porpuse**

The view retrieves data from the **repair_requests**, **customers**, and **products** to present key information about the open repair requests. It includes:
* **repair_id**: The unique identifier for the repair request.
* **customer_name**: The full name of the customer who submitted the repair request.
* **product_name**: The name of the product requiring repair.
* **issue_title**: A short description of the reported issue.
* **request_date**: The date when the repair request was submitted.
* **status**: the current status of the repair request (**Pending** or **In_progress**).

**Use Case**

This view can be useful for:
* **tracking open repair request** to ensure **timely** processing.
* **Improving customer service** by quickly identifying pending and in-progress repairs.
* Generate detailed report on active repair cases to allocate resources effectively.
* **Reducing query complexity** by filtering only relevent repair requests.

**5. open_warranty_claims**

The **open_warranty_claims** view provides a list of **pending warranty claims** submitted by customers. The view helps track unsolved warranty claims, ensuring timely processing and better customer support.

**Structure and Purpose**

Theis view retrieves data from the **warranty_claims**, **customers**, and **products** to display key details about active warranty claims. It includes:
* **claim_id**: The unique identifier of the warranty claim.
* **customer_id**: the unique identifier of the customer who submitted the claim.
* **customer_name**: the full name of customer.
* **product_name**: The name of the product for which the claim was submitted.
* **status** The current status of the claim (Only **pending** claims are shown).
* **claim_date**: the date when the warranty claim was submitted.

**Use Case**

This view is useful for:
* **Tracking active warranty claim** to ensure timely resolution.
* Providing customer support seervice with easy access to the pending claims.
* Reducing the query complexity by filtering warranty data (filtering out the processed warranty claims).

**6. technician_workload**

The **technician_workload** view provides an overview of each technician's **current repair workload**. It helps track the number of active repair requests assigned to each technician, ensuring balanced task distribution and efficient resource management.

**Structure and Purpose**

This view retrieves data from the **technicians** and **repair_requests** tables to display key workload metrics for each technician. It includes:
* **technician_id**: The unique identifier of the technician.
* **technician_name**: The full name of the technician.
* **active_repairs**: the toal number of **active repair requests** assigned to the technician.

**Use Case**

This view can be useful for:
* **Monitoring technician workload** to ensure fair task distribution.
* **identifying overburned technicians** and reallocating tasks accordingly.
* **improving repair efficiency** by balancing active repair assignments.
* **Generating reports** on technician performance and workload trends.

**7. low_stock_products**

The **low_stock_products** view provides a **real-time** overview of the products that are **running low** on stock. This helps the store managers identify which products that need to be **restocked** to avoid shortages and maintain availability.

**Structure and Purpose**

This view retrieves data from **products**, **types**, **brands**, **product_suppliers**, and **suppliers** to display details about low stock products. It includes:
* **id**: The unique identifier for the product.
* **brand**: The brand name of the product.
* **type**: The category/type of the product.
* **name**: The name of the product.
* **model**: The model name of the product.
* **supplier**: The name of the supplier providing the product.
* **stock_quantity**: The current available stock of the product (less than 10 units).

**Use Case**

This view can be useful for:
* **Monitoring inventory levels** and detecting products with low stock.
* Helping store manager identify products that need to be restocked.
* **improving supply chain efficiency** by ensuring timely reordering.
* **Preventing shortages** and ensuring product availability for customers.

**8. available_parts**

The **available_parts** view provides a real time list of spare parts that are currently in stock. It helps store managers and technicians quickly identify which parts are available for **sale** or **repair services**, improving inventory management and customer service.

**Structure and Purpose**

This view is built by joining the **parts**, **types**, and **brands** tables to provide more detailed dataset. It includes:
* **id**: The unique identifier of the part.
* **brand**: The brand name of the part.
* **type**: The category/type of the part.
* **price**: The selling price of the product.
* **stock_quantity**: The number of available units in stock.

**Use Case**

This view can be useful for:
* Ensuring **smooth repair operations** by checking part availability.
* **Optimiziing inventory management** by tracking available spare parts.
* Generating report on spare parts availability for better stock planning.

**9. low_stock_parts**

The **low_stock_parts** views helps store managers identify spare parts that are **running low** in stock.
This ensures timely restocking and prevents shortages that could disrupt repair operations.

**Structure and Purpose**

This view retrives data from the **parts**, **brands**, **types**, **part_suppliers**, and **suppliers** to provide an overview on parts with low inventory levels. it includes:
* **id**: The unique identifier of the part.
* **brand**: The brand of the part.
* **type**: The category/type of the part.
* **name**: The name of the part
* **supplier**: The name of the supplier providing the part.
* **stock_quantity**: The number of available units in stock.

**Use Case**

This view can be useful for:
* **Proactive inventory management** by identifying parts that need replenishment.
* **Reducing downtime** in repair services by ensure spare parts are available.
* **Improving customer satisfaction** by preventing out-of-stock situations.

**10. most_sold_brands**

The **most_sold_brands** view provides an overview of the **most popular brands** based on **sales performance**. It helps business owners, managers, and analysts identify which brands are generating the **highest revenue and sales volume**.

**Structure and Purpose**

This view aggregate sales data from the **sales**, **products**, and **brands** tables to display:
* **id**: The unique identifier of the brand.
* **brand_name**: The name of the brand.
* **number_of_sales**: The total number of individual sales involving products from this brand.
* **total_amount**: The total revenue generated by products from this brand.

**Use Case**

* Identifying **top-performing** brands in terms of revenue and sales volume.
* Helping store managers prioritize which brands to stock more of based on customer demand.
* **Supporting marketing strategies** that focuses on promoting high-selling brands.
* **Providing insights for suppliers** on the most popular brands.

**11. most_used_parts**

The **most_used_parts** view provides an overview of the **most frequently used** spare parts in reapirs. This information is essential for **inventory management**, helping the store **track demand** for replacement parts and **optimize stock levels**.

**Structure and Purpose**

This view aggregate data from the **parts**, **brands**, and **repair_parts** tables to display:
* **id**: The unique identifier of the part.
* **brand_name**: The brand associated with the part.
* **name**: The name of the part.
* **number_of_usage**: The total number of times this part has been used in repairs.

**Use Case**

This view is useful for:
* Identifying **high-demand** spare parts, allowing the store to maintain **optimal stock levels**.
* Improving repair service efficiency by reducing delay caused by out-of-stock parts.
* **Analyzing repair trends** to determine which components are most prone to failure.

### Database indexes
In this section we will provide an overview of the various indexes that was implemented in the database. The primary purpose of these indexes is to **optimize query performance**, allowing the database to **locate and fatch data more efficiently**, reducing the need for full table scans and improving the overall speed of operations, especially in **large datasets**. Below  is a breakdown of the indexes used and their purpose:

**1. products_index (type_id, brand_id)**

* **Purpose**: 
Improves the efficiency of queries that filter or join on **type_id** and **brand_id**, such as fetching products by **category** and **brand**.

* **benefit**: 
Prevents full table scans when searching for products of specific type and brand.

**2. parts_index (type_id, brand_id)**

* **Purpose**: 
Similar to **products_index**, this index optimizes queries that filter parts based on their **type** and **brand**.

* **Benefit**: 
Improves part lookup speeds when filtering by type and brand.

**3. repair_request_index (customer_id , status)**

* **Purpose**: 
Speeds up queries retrieving repair requests by customer or request status (e.g., **Pending**, **In_Progress**).

* **Benefit**: 
reduces lookup time for repair requests based on customer and request status.

**4. warranty_claims_index (product_id, customer_id, status)**

* **Purpose**: 
Enhances performance when searching for warranty claims by **product**, **customer**, or **status**.

* **Benefit**:  
Makes it faster to find warranty claims related to specific product and customer.

**5. technicians_index (status)**

* **Purpose**: 
Optimizes queries that filter technicians based on their current status (e.g., **Available**,**On_leave**).

* **Benefit**: 
Reduces search time when filtering technicians by status.

**6. sales_index (customer_id, product_id)**

* **Purpose**: 
Improves queries that retrieve sales records based on customer purchases or specific product sales.

* **Benefit**: 
Enhances performance when analyzing customer purchase history and product sales trends.

### Database triggers
In this section we will focus on the triggers implemented in the databse. A trigger is a special type of stored procedure that automatically executes in response to certain events on designated tables. These triggers help database administrators enforce business rules, maintain data integrity, and automate essential tasks without requiring manual intervention.

#### Purpose of Triggers
Triggers can be used for:

**1. Enforcing Business Rules**
* Ensure that certain conditions are met before or after changes to a table.
* Example: prevent user from ordoring product quantity that is greater then current available stock.

**2. Maintaining Data Integrity**
* Automatically update or validate data when an **insert**, **update**, or **delete** operation occurs.
* Example: When delete a customer, set the **deleted flag** to **True** instead of removing the record.

**3. Automating Logging**
* Keep track of data change by storing historical information in an audit table.
* Example: log any product stock change in a **product_inventory_log** table after updating the **products** table.

In this project, the database contains a total of 14 triggers, each designed to automate essential operations inside the database. Below is a breakdown of the implemented triggers and there purpose:

**1. before_sale_insert**

**Purpose**
This trigger ensures that a sale cannot be recorded if there is insufficient stock for the requested product. It helps maintaining data integrity by preventing negative stock levels in the database.

**How It Works**:
* **Trigger type**: **BEFORE INSERT** ---> Executes before a new sale record is inserted into the **sales** table.
* **Check stock availability**:
	1. Retrieves the current stock quantity of the product being sold.
	2. Compares it with the quantity in the new sale entry (**NEW.quantity**).
	3. If the requested quantity exceeds the available stock, the trigger raises an **error**, preventing the sale from being recorded.
* **Benefit**:
	* Prevents overselling by ensuring that a product cannot be sold if the stock is insufficient.
	* Helps maintain accurate inventory levels without requiring additional manual checks.

**2. update_products_stock_after_sale**

**Purpose**
This trigger is designed to automatically update the stock of a designated product whenever a new sale record is add to the **sales** table.

**How It Works**:
* **Trigger type**: **AFTER INSERT** ---> Executes after a new sale record is inserted into the **sales** table.
* **Stock Update Process**:
	1. The trigger first retrieves the current  stock of the product being sold and store it inside a local variable named **current_stock**;
	2. Update the current stock of the product stored inside the local variable (**current_stock**) by subtracting the quantity sold (**NEW.quantity**).
	3. This trigger uses the SQL **ABS** function to ensure a non-negative update to the **products** table.

**Benefit**:
* Automate inventory management by reducing stock immediately after each sale.
* Ensures consistency between recorded sales and available stock without requiring manual updates.

**3. after_product_insert**

**Purpose**
This trigger log new product entries into the **product_inventory_log** table, keeping track of stock additions when a product is first inserted to the **products** table.

**How It Works**
* **Trigger Type**: **AFTER INSERT** ---> Executes after a new product is added to the **products** table.
* **Logging Process**:
1.	Captures the newly inserted product's ID (**NEW.id**)
2.	Records the initial stock quantity (**NEW.stock_quantity).
3.	Specifies the reason for the inventory change as **added**.

**Benefit**:
* Enhance inventory management by maintaining a detailed history of stock changes.
* Supports business insights by providing data on product additions.

**4. after_product_update**

**Purpose**
This trigger log inventory updates inside the **product_inventory_log** whenever a product's stock quantity is modified in the **products** table.

**How it Works**:
* **Trigger Type**: **AFTER UPDATE** ---> Executes after an update occurs in the **products** table.
* **Stock Change Logging**:
	1. Checks if **stock_quantity** has changed.
	2. Calculates the absolute difference between old and new stock levels.
	3. Determines the reason of the change:
		*	If stock level decreases ---> **Sale** (product was sold).
		*	If stock level increases ---> **Restock** (new stock was added).
	4. Logs the change the **product_inventory_log** table. 

**Benefit**
* Improves inventory tracking by automatically recording stock updates.
* Ensures accuracy in inventory management by distinguishing between sales and restocks.

**5. before_repair_part_insert**

**Purpose**
This trigger ensures that sapre parts used for repairs are available in efficient quantity before inserting a new record inside the **repair_parts** table.

**How It Works**:
* **Trigger Type**: **BEFORE INSERT** ---> Executes before a new repair part record is added.
* **Stock Verification**:
	1. Retrieves the current stock of the part from the parts table and stored inside the local variable named **current_stock**.
	2. Compares the requested quantity with the available stock stored inside the local variable.
	3. If the requested quantity execeeds the stock, an error is raised with a message **Not enough stock available for repair** to prevent the insert.

**Benefit**
* Prevents stock inconsistencies by ensuring parts are not assigned to repairs if they are unavailable.
* Improve customer service by preventing shortages after repair initiation.
* Improves inventory management by enforcing stock constraints inside the database.

**6. update_parts_stock_after_repair**
This trigger ensures that the stock of spare parts is updated automatically when they are used in a repair.

**How It Works**
* **trigger Type**: **AFTER INSERT** ---> Executes after a new record is added to the **repair_parts** table.
* **Stock Update Process**
	1. Retrieves the current stock of the part from the **parts** and store it inside a locale variable called **stock_quantity**
	2. Updates the **stock_quantity** of the part by subtracting the used quantity (**New.quantity**).
	3. Uses **ABS()** to ensure stock updates correctly.

**Benefit**
* Maintains inventory accuracy by reducing stock automatically when parts are used.
* Improves repair tracking by ensuring real-time updates on available parts.
* Prevents manual stock adjustments by handling it automatically.

**7. after_part_insert**

**Purpose**
This trigger log new part entries into the **part_inventory_log** table, keeping track of stock additions when a part is first inserted to the **parts** table.

**How It Works**
* **Trigger Type**: **AFTER INSERT** ---> Executes after a new part is added to the **parts** table.
* **Logging Process**:
1.	Captures the newly inserted part's ID (**NEW.id**)
2.	Records the initial stock quantity (**NEW.stock_quantity**).
3.	Specifies the reason for the inventory change as **added**.

**Benefit**:
* Enhance inventory management by maintaining a detailed history of stock changes.
* Supports business insights by providing data on parts additions.

**8. after_part_update**

**Purpose**
This trigger log inventory updates inside the **part_inventory_log** whenever a part's stock quantity is modified in the **parts** table.

**How it Works**:
* **Trigger Type**: **AFTER UPDATE** ---> Executes after an update occurs in the **parts** table.
* **Stock Change Logging**:
	1. Checks if **stock_quantity** has changed.
	2. Calculates the absolute difference between old and new stock levels.
	3. Determines the reason of the change:
		*	If stock level decreases ---> **Repair** (part was used in a repair).
		*	If stock level increases ---> **Restock** (new stock was added).
	4. Logs the change the **part_inventory_log** table. 

**Benefit**
* Improves inventory tracking by automatically recording stock updates.
* Ensures accuracy in inventory management by distinguishing between Repairs and restocks.

**9. after_repair_complete**

**Purpose**
This trigger ensure that a repair can only marked as **Completed** if it was previously set **In_progress** and records the repair comppletion date.

**How It Works**:
* **Trigger Type**: **BEFORE UPDATE** ---> Runs before the **repair_request** table is updated.
* **Conditions Checked**:
	1. The trigger first check if the new status is updated to **Completed**
	2. Compare the new status (**NEW.status**) to the old status (**OLD.status**) of the repair request:
	* IF **OLD.status**: **In_progress** ---> the **repair_request** status is set to **Completed** and the **repair_date** is set to the current timestamp.
	* IF **OLD.status**: **Pending** ---> the update is blocked with an error message ( **cannot complete a pending repair request**).
	* IF **OLD.status**: **Completed** ---> The update is blocked with an error message ( **the repair request already completed**).

**Benefit**
* Prevents illogical status transitions.
* Ensures accurate Timestamps by automatically recording the repair completion date.
* Prevents errors by avoiding marking unfinished repairs as completed.

**10. repair_request_in_progress**

**Purpose**:
This trigger updates the status of a repair request to "In Progress" when a technician is assigned to it.

**How It Works**:
* **Trigger Type**: **BEFORE UPDATE** ---> Runs before an update occurs in the **repair_request** table.
* **Conditions checked**:
	* The trigger checks The previous (**OLD**) value of the **technician_id** is **NULL** (Meaning no technician was assigned to the repair request).
	* The trigger make sure that the new value of the **technician_id** is not null (meaning a technician is being assigned to the repair request).
	* The previous (**OLD**) status of the repair request is **Pending**.
* **Action taken**:
	* If all conditions are met, the repair request status is **automatically updated** to **In_progress**.
* **Benefits**
	* **Automates workflow**: by automatically updating the status of the repair request once a technician is assigned to it.
	* **Prevents errors**: avoid an potential inconsistencies where a technician is assigned by the repair request remains **Pending**.
	* **Better tracking**: help managers better monitor open repair requests and technician workload.

**11. before_customer_delete**

**Purpose**:
This trigger prevents deleting a customer if they have **active transactions** related to **sales**, **warranty claims**, and **repair requests**. Instead of permently deleting the record, the system uses a **soft delete approach** by updating the **deleted** field.

**How it works**:
* **Trigger Type**: **BEFORE UPDATE** ---> Runs before a customer record is updated.
* **Conditions Checked**:
	1. the **deleted** field is set to 1 ( meaning the administrator is attempting to the delete the customer).
	2. The customer has **at least one** of the following:
		* A recorded sale inside the sales table.
		* A **pending** warranty claim inside the **warranty_claims** table.
		* An **active repair request** inside the **repair_requests** table with the status of **Pending** or **in_progress**.
* **Action taken**:
	* If any of the conditions are met, the trigger will raise an **error** (**SIGNAL SQLSTATE '45000'**), preventing the deletion.
	* If no active transactions exists, the update is allowed, marking the customer as deleted.

**Benefits**:
* Prevents any accidental deletion of clients with active transactions, which could break references in the database.

> [!IMPORTANT]
> Instead of permanently deleting records, the system employs the **Soft Deletion Approach**, a technique where records are not **physically removed** from the databse but are instead **flagged as deleted** (e.g., using a **deleted** column). 
> This method enables administrators to prevents any **accidental** or **unauthorized deletions** by providing them a simple way to recover deleted records when needed.

**12. before_technician_assign_to_repair_request**

**Purpose**:
This trigger check the status of the a technician before assigning him/her to a handle a repair request. This main objective of this trigger is to ensure that only **Active** technicians can be assigned to repair requests.

**How It Works**:
* **Trigger Type**: **BEFORE UPDATE** ---> runs before a repair request is updated.
* When updating a repair request, if a new technician is assigned, the  trigger retrieves the new technician's current from the **technicians** table.
* If the technician is marked **on_leave**, the trigger raises an **error**, preventing the technician's assignment and display the message: "**Cannot assign repair request to technicians on leave**".

**Benefits**:
* This trigger helps ensure work efficiency by ensuring **only available** technicians are assign to the repair tasks. 

**13. before_warranty_claim_insert**

**Purpose**:
This trigger ensures that customers can only submit a warranty claim for products  that are still within their warranty period.

**How It Works**:
* **Trigger Type**: **BEFORE INSERT** ---> The trigger activates before a new record is added to the **warranty_claims** table.

1. The trigger starts by retrieving the **most recent** purchase date and the warranty period for the product from the **sales** and **products** tables.
2. It calculates the difference (in months) between the purchase the date and the current date.
3. If the difference exceeds the warranty period, the trigger raises an **error** with message indicating that the warranty period for the said product has expired.

**Benefits**:
* By using this trigger, the database ensures that only **valid** warranty caims are accepted, preventing **unauthorized** or **expired** claims.

**14. close_warranty_claim**

**Purpose**
This trigger ensures that when a warranty claim is updated with a resolution, its status is automatically adjusted based on the outcome.

**How It Works**:
* **Trigger Type**: **BEFORE UPDATE** ---> The trigger activates before a warranty claim record is updated.
1. The trigger checks if the claim's previous status is **Pending**.
2. If the new resolution is **Repair** or **Replacement**, the status is set to **Approved** and the resolution date is recorded.
3. If the new resolution is **rejected**, the status is set to **Denied**, and the resolution date is recorded.

**Benefits**:
* By implementing this trigger, the system enforces **data consistency** and ensure that every warranty claim is properly categorized.

### Database Stored Procedures
In this section, we will focus on the **Stored Procedues** implemented in this project. These procedure contain **precompiled** SQL routines stored within the database, allowing users to execute complex SQL statements as a **single unit** with a single call.

this project includes a total of **24 stored procedures**, each designed to enhance database performance by reducing execution time and improving security by allowing users to interact with these procedures instead of directly accessing databse tables which can **greatly reduce** the risk of **SQL injection**. 
Below is a breakdown of the implemented procedures and thier respective purposes:

**1. addProduct**

**Description**:
The procedure is used to add new product into the **products** table while enforcing a stock quantity validation. It ensures that no product can be added with zero stock to the database, preventing any potential inconsistencies in inventory management. 

**Parameters**:
* **p_type_id** (INT UNSIGNED): The type/category of the product ( foreign key reference to the **types** table).
* **p_brand_id** (INT UNSIGNED): The brand of the product ( foreign key reeference to the **brands** table).
* **p_name** (VARCHAR(32)): The name of the product.
* **p_model** (VARCHAR(32)): The model name of the product.
* **p_price** (DECIMAL(10,2)): The price of the product.
* **p_stock_quantity** (INT): The initial stock of the product.
* **p_desc** (TEXT): A detailed discription of the product.
* **p_warranty** (INT UNSIGNED): The warranty period of the product (in months).

**Functionality**:
* The procedure checks if the **p_stock_quantity** variable is greater then zero.
* if the inital stock quantity is valid (greater then zero), it inserts the new product to the **products** table with the provided details.
* If the stock quantity is **zero or negative**, the procedure raises an **error** (`SQLSTATE '45000'`), preventing the addition of products with zero stock.

**Useage Example**
To add a new product using this procedure, execute:
`CALL addProduct(
1,
2,
'Gaming Laptop',
'Predator Helios 300',
1299.99,
20,
'A high-performance gaming laptop with RTX 3070',
24);`


**Benefits**
* This procedure Reuces **Manual SQL writing** by wrapping the insert logic into a reusable procedure.
* Improves **database security** by preventing direct table manipulations.

**2. deleteProduct**

**Description**
This procedure is used to **soft delete** a product from the **products** table. Instead of permanently removing the product record, it sets the **deleted** column to 1, indicating that the product is no longer available.

**Parameters**
* **product_id** (INT INSIGNED): The unqiue identifier of the product to be deleted.

**Functionality**
* The procedure updates the **deleted** column of the specified product to 1 marking it as **deleted**.

**Usage Example**
`CALL deleteProduct(5);`

**Benefits**
* Ensures **data consistency** by preventing accidental or unauthorized data loss tha could lead to broken references in related tables.
* Supports data recovery since the deleted product can be restored by updating the **deleted** flag to 0.

**3. addProductStock**

**Description**
The procedure is designed to **increase the stock quantity** of an existsing product inside the **products** table. The main objective of this procedure is to update the current inventory levels when new stocks is received.

**Parameters**
* **product_id** (INT UNSIGNED): The unique identifier of the product whose stock quantity is to be updated.
* **new_quantity** (INT UNSIGNED): The quantity of stock to be added to the existing amount.
 
**Functionality**

1. The procedure first **checks** whether the provided **product_id** exists in the **products** table.
* If the product exists, the procedure **increases** the **stock_quantity** by the quantity specified inside the **new_quantity**
* If the product does not exists, an error with the message "**Product not found**" is triggered.

2. This error handling ensures data integrity and prevents invalid updates to non-existent products. 

**Usage Example**
To add 50 units to the stock of the product with ID 3:
`CALL addProductStock(3, 50);`

**Benefits**
* Helps maintain accurate inventory levels and ensures stock availability.
* The validation step prevents unintended updates to non-existent products.
* Provides clear feedback if the specified product is not found, reducing the risk of data errors.

**4. addCustomer**

**Description**
This procedure is used to add new customers to the **customers** table. It simplifies the process of the customer registration and ensures that customer data are correctly inserted into the database.

**Parameters**:
* **c_name** (VARCHAR(32)): The name of the customer.
* **c_last_name** (VARCHAR(32)): The last name of the customer.
* **c_email** (VARCHAR(225)): The email of the customer.
* **c_phone_num** (VARCHAR(20)): The phone number of customer.
* **c_address** (VARCHAR(32)): The address of customer.

**Functionality**
* When executed, the procedure insert a new record into the **customers** table with the specified details.
* No explicit validation is performed within the procedure mainly because any necessary validation (such as unique email checks) are handled by the **database constraints**.

**Usage Example**
To add new customer:
`CALL addCustomer('John', 'Doe', 'john.doe@example.com', '+1234567890', '123 Main St');`

**Benefits**
* Simplifies the customer registration process by combining complex SQL queries into a single procedure call.
* This procedure can be used is various application modules where customer registration is required.
* This procedure ensure **consistent data entry** into the **customers** table.

**5. deleteCustomer**

**Description**
This procedure is used to **soft delete** a customer from the **customers** table. Instead of permanently removing the customer record, it sets the **deleted** column to 1, indicating that the customer is no longer available.

**Parameters**
* **customer_id** (INT INSIGNED): The unqiue identifier of the customer to be deleted.

**Functionality**
* The procedure updates the **deleted** column of the specified customer to 1 marking it as **deleted**.

**Usage Example**
To soft-delete a customer with the ID 5:
`CALL deleteCustomer(5);`

**Benefits**
* Ensures **data consistency** by preventing accidental or unauthorized data loss tha could lead to broken references in related tables.
* Supports data recovery since the deleted customer can be restored by updating the **deleted** flag to 0.

**6. addSale**

**Description**
This stored procedure is used to register a new sale in the **sales** table. It performs a set of pre-defined validations to ensure data integrity, calculate the total amount of the sale.

**Parameters**
* **product_id** (INT UNSIGNED): The id of the product being sold.
* **customer_id** (INT UNSIGNED): The id of the customer making the purchase.
* **p_quantity** (INT UNSIGNED): The quantity of the product being sold.

**Functionality**

1. **Validation Checks**:
* Check if the specified product already exists in the **products** table.
	* If the product does not exist, the system will raise an **error** with the message:  `product does not exist`

* Check if the specified customer already exists inside the **customer** table.
	* If the customer does not exist, the system will raise an **error** with the message: `customer does not exist`
* Make sure that the sale quantity is greater than zero.
	* If the quantity is less or eaqual to zero, the system will raise an **error** with the message `quantity must be greater than zero`.

2. **Sale Registration**:
* Retrieves the unit price of the specified product.
* Calculates the total sale amount.
* Insert a new record into the **sales** table with specified sale details.

3. **Stock management**:
* The stock adjustment is automatically handled by the **update_products_after_sale** trigger, ensuring accurate inventory management.

**Usage Example**
To register a sale of 5 unit of the product with the ID of 2 to a customer with ID 3:
`CALL addSale(2,3,5);`

**Benefits**
* Ensures that all referenced customers and products exists, maintaining consistency.
* Automates the sales registration process, reducing errors.

**7. addSupplier**

**Description**
This procedure is used to add new parts/products supplier to the **suppliers** table. It simplifies the process of the supplier registration and ensures that supplier data are correctly inserted into the database.

**Parameters**
* **sup_name** (VARCHAR(32)): The supplier name.
* **sup_contact_person** (VARCHAR(32)): The name of supplier designated contact person.
* **sup_number** (VARCHAR(20)): The phone number of the supplier.
* **sup_email** (VARCHAR(225)): The email of the supplier.
* **sup_address** (VARCHAR(225)): The full address of the supplier.

**Functionality**
* When executed, the procedure insert a new record into the **suppliers** table with the specified details.
* No explicit validation is performed within the procedure mainly because any necessary validation (such as unique email checks) are handled by the **database constraints**.

**Usage Example**
To add a new supplier to the **suppliers** table:
`CALL addSupplier('TechWorld Supplies', 'David Smith', '1234567890', 'contact@techworld.com', '101 Tech Street');`

**Benefits**
* Simplifies the supplier registration process by combining complex SQL queries into a single procedure call.
* This procedure can be used is various application modules where supplier registration is required.
* This procedure ensure **consistent data entry** into the **suppliers** table.

**8. deleteSupplier**

**Description**
This procedure is used to **soft delete** a part/product supplier from the **suppliers** table. Instead of permanently removing the supplier record, it sets the **deleted** column to 1, indicating that the supplier is no longer available.

**Parameters**
* **sup_id** (INT INSIGNED): The unqiue identifier of the supplier to be deleted.

**Functionality**
* The procedure updates the **deleted** column of the specified supplier to 1 marking it as **deleted**.

**Usage Example**
To soft-delete a supplier with the ID 3:
`CALL deleteSupplier(3);`

**Benefits**
* Ensures **data consistency** by preventing accidental or unauthorized data loss tha could lead to broken references in related tables.
* Supports data recovery since the deleted supplier can be restored by updating the **deleted** flag to 0.

**9. setProductSupplier**

**Description**
This procedure is used to **associate a product with a corresponding supplier** by adding a record to the **product_suppliers** table. This association also include setting a **supply price** for the product, Ensuring better inventory management.
 
**Parameters**
* **product_id** (INT UNSIGNED): The ID of the product to be linked.
* **supplier_id** (INT UNSIGNED): The ID of the supplier providing the product.
* **price** (DECIMAL(10,2)): The supply price of the product by the supplier.

**Functionality**
1. **Validation Checks**:
* The procedure starts by checking whether the specified product already exists in the **products** table.
	* If the product does not exist, the system will raise an **error** with the message: `product does not exists`
* The procedure ensures that the specified supplier already exists in the **suppliers** table.
	* If the supplier does not exist, the system will raise an **error** with the message: `supplier does not exist`

2. **Supplier Association**:
* If both validations pass, a new entry is added to the **product_suppliers** table, linking the product with the supplier along the specified supply price.

**Usage Example**
To Assign a product with the ID **5** to a supplier with ID **2** and set the supply price to **300,50**:
`CALL setProductSupplier(5, 2, 300,50);`

**Benefits**
* Streamlines the process of associating products with suppliers.
* Ensures that only valid products and suppliers are linked.

**10.addPart**

**Description**
This procedure is used to add a **new part** to the **parts** table. This procedure essure that the part details are properly recorded in the database. This procedure is crucial because it only allows valid parts with positive stock quantity to be added to the database.

**Parameters**
* **part_name** (VARCHAR(32)): The name of the part to be added.
* **part_brand** (INT UNSIGNED): The ID of the part referencing the **brands** table.
* **part_type** (INT UNSIGNED): The ID of the part's category/type referencing the **types** table.
* **part_price** (DECIMAL(10,2)): The price of the part.
* **part_stock** (INT UNSIGNED): The initial stock quantity of the part.

**Functionality**
1. **Stock validation**:
* The procedure ensures that the quantity of the new part is greater then zero. 
	* If the quantity is less or equal to zero, the system will raise an **error** with the message: `quantity must be greater then zero`.

2. **Insertion**:
* If the stock is valid, the part is added to the **parts** table with the provided details.

**Usage Example**
 To add a new part named "Cooling Fan" with brand ID `3`, type ID `2`, a price of `25.50`, and an initial stock of `15` units:
 `CALL addPart('Cooling Fan', 3, 2, 25.50, 15);
`
**benefits**
* prevents adding parts with invalid stock quantities.
* Simplifies the process of adding new parts while maintaining consistent data.
* Reduces the risk of invalid data entry by validating inputs.

**11. deletePart**

**Description**
This procedure is used to **soft delete** a part from the **parts** table. Instead of permanently removing the part record, it sets the **deleted** column to 1, indicating that the part is no longer available.

**Parameters**
* **part_id** (INT INSIGNED): The unqiue identifier of the part to be deleted.

**Functionality**
* The procedure updates the **deleted** column of the specified part to 1 marking it as **deleted**.

**Usage Example**
To soft-delete a part with the ID 3:
`CALL deletePart(3);`

**Benefits**
* Ensures **data consistency** by preventing accidental or unauthorized data loss tha could lead to broken references in related tables.
* Supports data recovery since the deleted part can be restored by updating the **deleted** flag to 0.

**12. addPartStock**

**Description**
The procedure is designed to **increase the stock quantity** of an existsing part inside the **parts** table. The main objective of this procedure is to update the current inventory levels when new stocks is received.

**Parameters**
* **part_id** (INT UNSIGNED): The unique identifier of the part whose stock quantity is to be updated.
* **new_quantity** (INT UNSIGNED): The quantity of stock to be added to the existing amount.
 
**Functionality**

1. The procedure first **checks** whether the provided **part_id** exists in the **parts** table.
* If the part exists, the procedure **increases** the **stock_quantity** by the quantity specified inside the **new_quantity**
* If the part does not exists, an error with the message "**Part not found**" is triggered.

2. This error handling ensures data integrity and prevents invalid updates to non-existent products. 

**Usage Example**
To add 50 units to the stock of the part with ID 4:
`CALL addPartStock(4, 50);`

**Benefits**
* Helps maintain accurate inventory levels and ensures stock availability.
* The validation step prevents unintended updates to non-existent parts.
* Provides clear feedback if the specified part is not found, reducing the risk of data errors.

**13. setPartSupplier**

**Description**
This procedure is used to **associate a part with a corresponding supplier** by adding a record to the **part_suppliers** table. This association also include setting a **supply price** for the part, Ensuring better inventory management.
 
**Parameters**
* **part_id** (INT UNSIGNED): The ID of the part to be linked.
* **supplier_id** (INT UNSIGNED): The ID of the supplier providing the part.
* **price** (DECIMAL(10,2)): The supply price of the part by the supplier.

**Functionality**
1. **Validation Checks**:
* The procedure starts by checking whether the specified part already exists in the **parts** table.
	* If the part does not exist, the system will raise an **error** with the message: `part does not exists`
* The procedure ensures that the specified supplier already exists in the **suppliers** table.
	* If the supplier does not exist, the system will raise an **error** with the message: `supplier does not exist`

2. **Supplier Association**:
* If both validations pass, a new entry is added to the **part_suppliers** table, linking the part with the supplier along the specified supply price.

**Usage Example**
To Assign a part with the ID **4** to a supplier with ID **2** and set the supply price to **50,99**:
`CALL setPartSupplier(4, 2, 50,99);`

**Benefits**
* Streamlines the process of associating parts with suppliers.
* Ensures that only valid parts and suppliers are linked.

**14. setPartCompatibility**

**Description**
This procedure is used to **define compatibility** between a part and a product in the system. By linking parts to products, it helps managers maintain accurate records of which parts are compatible with which products.

**Parameters**
* **part_id** (INT UNSIGNED): The ID of the part to be associated.
* **product_id** (INT UNSIGNED): The ID of the product with which the part is compatible.

**Functionality**:
1. **Validation Checks**:
* The procedure checks whether the provided part ID exists in the **parts** table.
	* If the part does not exist in the table, the system will raise an **error** with the message: `Part does not exist`
* It then checks wether the specified **product_id** already exists in the **products** table.
	* If the product does not exists in the table, the system will raise an **error** with the message: `product does not exist`

2.**Compatibility Registration**
* If both IDs are valid, a new record will be added to the **part_compatibility** table. 

**Usage Example**
To associate a part with ID 5 as compatible with a product of the ID 10:
`CALL setPartCompatibility(5,10);`

**Benefits**
* Ensures that only valid parts and products are linked, preventing invalid references.
* Facilitates future compatibility expansion as new parts and products are added.

**15. addTechnician**

**Description**
This procedure is designed to **add a new technician** to the **technicians** table. This procedure helps streamline the process of expanding the repair teams who handle repair requests and other technical tasks.

**Parameters**
* **first_name** (VARCHAR(32)): The first name of the technician.
* **last_name** (VARCHAR(32)): The last name of the technician.
* **email** (VARCHAR(255)): The email address of the technician.

**Functionality**
* The procedure adds a new record to the **technicians** table using the provided details.

**Usage Example**
To add a new technician with the name "**John Doe**" with the email "jhon.doe@example.com":
`CALL addTechnician('John','Doe','john.doe@example.com')`  

**Benefits**
* Ensures that technicians are added uniformly to the database.
* Minimizes the risk of inconsistent data entry due to manual typing.

**16. deleteTechnician**

**Description**
This procedure is used to **soft delete** a technician from the **technicians** table. Instead of permanently removing the technician record, it sets the **deleted** column to 1, indicating that the technician is no longer available.

**Parameters**
* **technician_id** (INT INSIGNED): The unqiue identifier of the technician to be deleted.

**Functionality**
* The procedure updates the **deleted** column of the specified part to 1 marking it as **deleted**.

**Usage Example**
To soft-delete a technician with the ID 3:
`CALL deleteTechnician(3);`

**Benefits**
* Ensures **data consistency** by preventing accidental or unauthorized data loss tha could lead to broken references in related tables.
* Supports data recovery since the deleted technician can be restored by updating the **deleted** flag to 0.

**17. setTechnicianStatus**

**Description**
This procedure is used to update the **status** of a technician in the **technicians** table. The main objective of this procedure is to ensure that the availability of technicians are correctly tracked by managers, which allow optimal assignments of repair requests.

**parameters**
* **technician_id** (INT UNSIGNED): The unique ID of the technician whose status needs to be updated.
* **t_status** (VARCHAR(32)): The new status to be assigned to the technician. It must be either **Active** or **On_leave**.

**Functionality**
1. **Validation Check**:
* Ensures that the new status is either **Active** or **On_leave**.
* If an invalid status is provided, the procedure raises an **error** with the message: `Invalid status value`.

2. **Status Update**:
* If the status is valid, the technician's status is updated in the **technicians** table.

**Usage Examples**
* To mark a technician as '**On_leave**':
`CALL setTechnicianStatus(5, 'On_leave');`
*  To mark a technician as '**Active**':
`CALL setTechnicianStatus(5, 'Active');`

**Benefits**
* Prevents **invalid status entries** by restricting status update to predefined values.
* **Reduces manual updates**, making the system more efficient and less error-prone. 

**18. addRepairRequest**

**Description**
This procedure is used to create a **new repair request** for a product owned by a customer. This ensures that only valid customers and product are allowed to submit repair requests.

**Paramerters**
* **customer_id** (INT UNSIGNED): The ID of the customer submitting the repair request.
* **product_id** (INT UNSIGNED): The ID of the product that require repair.
* **title** (VARCHAR(255)): A bref title summarizing the issue.
* **issue_desc** (TEXT): A detailed description of the issue the customer is facing.

**Functionality**
1. **Customer Validation**:
* The procedure starts by checking if the provided **customer_id** already exists in the **customers** table.
* If the customer does **not exist**, the procedure will raise an **error** with the message: `customer does not exist`
2. **Product Validation**:
* Checks if the provided **product_id** already exists in the **products** table.
* If the product does **not exist**, the procedure will raise an **error** with the message: `product does not exist`.
3. **Insert Repair Request** 
* If both customer and product exist in the database, a new repair request is added to the **repair_requests** table with the specified details.

**Usage Example**
To create a new repair request:
`CALL addRepairRequest(3, 12, 'Screen not working', 'The laptop screen is flickering and turns off randomly.');`

**benefits**
* Ensures that repair requests are added uniformly to the database.
* Minimizes the risk of inconsistent data entry due to manual typing.
* Prevents invalid repair requests that could reference nonexistent products or customers.

**19. assignTechnician**

**Description**
This procedure is used to **assign a technician to a repair request**. It ensures that only **Active** technicians are assigned to **pending** repair requests.

**Parameters**
* **request_id** (INT UNSIGNED): The unique ID of the repair that requires a technician.
* **tech_id** (INT UNSIGNED): The unique ID of the technician to be assigned.

**Functionality**

1. **Repair request validation**
* The procedure first checks whether the provided **request_id** already exists in the **repair_requests** table.
* If the repair request does not exist, the procedure will raise an **error** with the message: `repair request does not exist`

2. **Check repair request status**
* The procedure checks if the repair request status is **pending**
* If the request is **In_progress** or **Completed**, the procedure will raise an **error** with the message: `cannot assign a technician to a In_progress/Completed repair requests`

3. ** Technician validation**
* The procedure checks whether the provided **tech_id** already exists in the **technicians** table.
*  If the id does not exist, the procedure will raise an **error** with the message: `technician does not exist`

4. **Check technician status**
* The procedure ensure that the technician status is **Active** before assignment.
* If technician status is **On_leave**, the procedure will raise an **error** with the message: `cannot assign a repair request to an off duty technician`

5. **Assign technician to repair Request**
* If all checks pass, the technician is **assigned** to the specified repair request by updating the **repair_requests** table.

**Usage Example**
To assign technician with the ID **5** to the repair request withe the ID **12**:
`CALL assignTechnician(12,5);`

**Benefits**
* Prevents invalid assignment by ensuring both the repair request and technician exist in the database.
* Maintain effective workflow by allowing only **Pending** requests to be assigned.
* Maintain data consistency by ensuring that only **Active** technicians can be assigned.

**20. calculaterepairCost**

**Description**
This procedure is used to calculate the **total cost of a repair request**, by summing the cost of all parts used in the repair.

**parameters**
* **request_id** (INT UNSIGNED): The ID of the repair request.
* **cost** (OUT DECIMAL(10,2)): The total cost of the repair (output parameter).

**Functionality**
1. **Retrieve Parts Used**:
* The procedure queries the **repair_parts** table to get list of all parts that were used in the specified repair request.

2. **Calculate Cost**:
* Calculate the total cost for each used part by multiplying it **unit price** (**p.price**) with the quantity used (**rp.quantity**).

3. **Summarize Total Cost**
* aggregate the total cost of all parts used in the repair and stores it in the **cost** out parameter.

**Usage example**
To calculate the repair cost for repair request with the ID **15**:
`CALL calculateRepairCost(15, @repair_cost);

SELECT @repair_cost;
`
**Benefits**
* Automates the cost calculation, reducing manual effort.

**21. completeRepairRequest**

**Description**
This procedure is used to mark a repair request as **completed** and updating its **total cost**. It ensures that only repair request with **In_progress** status can be marked as completed.

**Parameters**
* **request_id** (INT UNSIGNED): The ID of the repair request that need to be marked as completed.

**Functionality**
1. **Validate repair request**
* The procedure chocks if the specified repair request already exists in the **repair_requests** table.
* If the request does not exist, the procedure will raise an **error** with the message: `repair request does not exist`

2. **Check the repair request status**
* The procedure ensures that the repair request status is **In_progress** before marking as completed.
* If the status is **Pending** or **completed**, the procedure will raise an **error** with the message: `cannot complete a pending/completed repair request`

3. **Calculate repair cost**:
* The procedure calls the **calculateRepairCost** stored procedure to calculate the total cost of the repair, based on the parts used.

4. **Update repair request status and cost**:
* The procedure updates the request status to **Completed**.
* It updates the **repair_cost** field with the calculated total cost.

**Usage Example**
To mark a repair request with the ID 15 as completed, use the following SQL command.
`CALL completeRepairRequest(15);`

**Benefits**
* Automate cost calculation, reducing manual input.
* Maintain data integrity by preventing invalid status updates.

**22. addWarrantyClaim**

**Description**
This procedure allows customers to submit a claim for a product they have purchased. It ensures that the claim is linked to a valid sale record, preventing unvalid claims.

**Parameters**
* **sale_id** (INT UNSIGNED): The ID of the sale to be associated with the warranty claim.
* **issue** (TEXT): A detailed description of the problem the customer is experiencing.

**Functionality**
1. **Validate sale record**
* The procedure ensures that the provided sale ID already exists in the **sales** table.
* If the sale does not exist, the procedure will raise an **error** with the message: `warranty claims require valid sale record to be processed`.

2. **Retrieve product and customer information**
* Once the sale is valid, the procedure will fetch both **product_id** and **customer_id** from the sale record.

3. **insert the warranty claim**
* Once all required details are gathered, a new record is added to the **warranty_claims** table with the specified details.

**Usage Example**
To create a **warranty claim** for a sale with **ID 10**, reporting a defective screen, use the SQL command:
`CALL addWarrantyClaim(10, 'The screen is not functioning properly.');
`
**Benefits**
* Ensure that  stored warranty claims are valid by linking them to existing sales records.
* Automate warranty claims processing, by reducing manual checks.

**23. approveWarrantyClaim**

**Description**
This procedure is used to mark a warranty claim as **Completed** by specifying whether the resolution will be a **Repair** or a **Replacement**.It ensures that only **valid** and **Pending** warranty claims are processed.

**Parameters**
* **claim_id** (INT UNSIGNED): The unique ID of the warranty claim to be marked as completed.
* **claim_resolution** (ENUM('Repair','Replacement')): A string indicating how the warranty claim will be resolved via **repair** or **replacement**.

**Functionality**
1. ** Validate the claim ID**:
* The procedure checks whether the provided warranty claim ID already exists in the **warranty_claims** table.
* If the ID does not exist, the procedure will raise an **error** with the message: `warranty claim does not exist`

2. **Check the claim status**:
* The procedure ensures that the specified warranty claim status is **Pending** before authorizing any update.
* If the warranty claim status is **Approved** or **Denied**, the procedure will raise an **error** with the message: `cannot handle an already Approved/Denied warranty claim`

3. **update the warranty claim**
* The procedure updates the **resolution_details** column of the specified warranty claim with the provided details.

**Usage Example**
To approve a **warranty claim with ID 5** and resolve it via **Replacement**, use:
`CALL approveWarrantyClaim(5, 'Replacement');
`
To approve a **warranty claim with ID 10** and resolve it via **Repair**, use:
`CALL approveWarrantyClaim(10, 'Repair');
`

**Benefits**
* Ensures only pending claims are processed, preventing duplicate handling.  
* Automates the approval workflow, reducing manual intervention.

**24. denyWarrantyClaim**

**Description**
This procedure is used to mark a warranty claim as **Denied**. It ensures that only **valid** and **Pending** warranty claims are processed.

**Parameters**
* **claim_id** (INT UNSIGNED): The unique ID of the warranty claim to be marked as denied.
* 
**Functionality**
1. ** Validate the claim ID**:
* The procedure checks whether the provided warranty claim ID already exists in the **warranty_claims** table.
* If the ID does not exist, the procedure will raise an **error** with the message: `warranty claim does not exist`

2. **Check the claim status**:
* The procedure ensures that the specified warranty claim status is **Pending** before authorizing any update.
* If the warranty claim status is **Approved** or **Denied**, the procedure will raise an **error** with the message: `cannot handle an already Denied/Approved warranty claim`

3. **update the warranty claim**
* The procedure updates the **resolution_details** column of the specified warranty claim, setting its value to **Rejected**.

**Usage Example**
To deny a **warranty claim with ID 5** use:
`CALL denyWarrantyClaim(5, 'Rejected');
`

**Benefits**
* Ensures only pending claims are processed, preventing duplicate handling.  
* Automates warranty claim management, reducing manual processing.


# Author: Mohamed Helali

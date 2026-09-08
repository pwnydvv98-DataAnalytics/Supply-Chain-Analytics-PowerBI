use supply_chain;

--- 1. Upload tables

set global local_infile =1;

truncate table customers_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/customers_raw.csv"
into table supply_chain.customers_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table employees_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/employees_raw.csv"
into table employees_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table inventory_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/inventory_raw.csv"
into table inventory_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table order_items_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/order_items_raw.csv"
into table order_items_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table orders_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/orders_raw.csv"
into table orders_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table products_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/products_raw.csv"
into table products_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table returns_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/returns_raw.csv"
into table returns_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table shipments_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/shipments_raw.csv"
into table shipments_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table suppliers_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/suppliers_raw.csv"
into table suppliers_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

truncate table warehouses_raw;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply chain dataset/warehouses_raw.csv"
into table warehouses_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

--- 2.  Rows check 
select count(*) as total from customers_raw;
select count(*) as total from employees_raw;
select count(*) as total from inventory_raw;
select count(*) as total from order_items_raw;
select count(*) as total from orders_raw;
select count(*) as total from products_raw;
select count(*) as total from returns_raw;
select count(*) as total from shipments_raw;
select count(*) as total from suppliers_raw;
select count(*) as total from warehouses_raw;

----- 3. Data Check ----

--- 3.1 check table structure 
desc customers_raw;
desc employees_raw;
desc inventory_raw;
desc order_items_raw;
desc orders_raw;
desc products_raw;
desc returns_raw;
desc shipments_raw;
desc suppliers_raw;
desc warehouses_raw;
 
--- 3.2 Check Null Values

--- Customers Table
select 
	sum(Customer_ID is null) as Customer_Id_null,
    sum(Customer_Name is null) as Customer_Name_null,
    sum(Gender is null) as Gender_Null,
    sum(City is null) as City_null,
    sum(State is null) as State_null,
    sum(Country is null) as Country_null,
    sum(Email is null) as Email_null,
    sum(Registration_Date is null) as Registration_Date_Null
from customers_raw;

--- Employees table
select 
	sum(Employee_ID is null) as Employee_ID_Null,
    sum(Employee_Name is null) as Employee_Name_null,
    sum(Department is null) as Department_null,
    sum(Job_Title is null) as Job_Title_null,
    sum(Warehouse_ID is null) as Warehouse_ID_null,
    sum(Hire_Date is null) as hire_date_null,
    sum(Salary is null) as Salary_null
from employees_raw;

--- Inventory table
select 
	sum(Inventory_ID is null) as Inventory_null,
    sum(Warehouse_ID is null) as Warehouse_null,
    sum(Product_ID is null) as Product_ID_null,
    sum(Inventory_Date is null) as Inventory_Date_null,
    sum(Stock_Quantity is null) as Stock_qty_NUll,
    sum(Reserved_Quantity is null) as Reserved_qty_null,
    sum(Damaged_Quantity is null) as Damaged_Qty_Null
from inventory_raw;

--- Order_items_raw
select 
	sum(Order_Item_ID is null) as order_null,
    sum(Order_ID is null) as ID_null,
    sum(Product_ID is null) as Product_null,
    sum(Quantity is null) as QTY_null,
    sum(Unit_Price is null) as Unit_null,
    sum(Discount_Percent is null) as Discount_null,
    sum(Line_Total is null) as Line_Total_null
from order_items_raw;

--- orders_raw
select 
	sum(Order_ID is null) as order_null,
    sum(Customer_ID is null) as Customer_null,
    sum(Order_Date is null) as Order_Date_null,
    sum(Order_Status is null) as Status_null,
    sum(Payment_Method is null) as Payment_null,
    sum(Warehouse_ID is null) as Warehouse_Null,
    sum(Shipping_Priority is null) as shipping_null 
from orders_raw;

--- product Table
select 
	sum(Product_ID is null) as ID_Null,
    sum(Product_Name is null) as Name_Null,
    sum(Category is null) as category_null,
    sum(Supplier_ID is null) as Supplier_null,
    sum(Unit_Cost is null) as Unit_Cost_null,
    sum(Selling_Price is null) as Selling_price_null,
    sum(Reorder_Level is null) as record_null,
    sum(Weight_KG is null) As weight_null
from products_raw;

--- returns_raw
select 
	sum(Return_ID is null) as ID_null,
    sum(Return_Date is null) as Return_Date_null,
    sum(Refund_Amount is null) as Refund_null,
    sum(Return_Quantity is null) as Return_QTY_Null,
    sum(Return_Reason is null) as Reason_null,
    sum(Return_Status is null) as Status_null,
    sum(Order_ID is null) as Order_null,
    sum(Product_ID is null) as Product_null
from returns_raw;

--- shipments_raw
select 
	sum(Shipment_ID is null) as Shipment_ID_Null,
    sum(Order_ID is null) as Order_ID_null,
    sum(Shipment_Date is null) ship_Date_Null,
    sum(Expected_Delivery_Date is null) as Expected_Delivery_Date_null,
    sum(Actual_Delivery_Date is null) as Actual_Delivery_Date_null,
    sum(Carrier is null) as Carrier_null,
    sum(Shipment_Status is null) as Shipment_Status_null,
    sum(Shipping_Cost is null) as Shipping_Cost_Null
from shipments_raw;

--- supplier table
select 
	sum(Supplier_ID is null) as Supplier_ID_Null,
    sum(Supplier_Name is null) as Supplier_Name_Null,
    sum(Country is null) as Country_Null,
    sum(Supplier_Type is null) as Supplier_Type_Null,
    sum(Contact_Email is null ) as email_Null,
    sum(Rating is null) as Rating_Null
from suppliers_raw;

--- Warehouse table
select 
	sum(Warehouse_ID is null) as Warehouse_id_null,
    sum(Warehouse_Name is null) as Warehouse_Name_null,
    sum(City is Null) as City_null,
    sum(Capacity_Units is null) as Capacity_unit_Null,
    sum(Warehouse_Type is null) as Warehouse_Type_Null
from warehouses_raw;

--- 3.3 Check Blank Values

--- Customers Table
select 
	sum(trim(Customer_ID) ='') as Customer_Id_Blank,
    sum(trim(Customer_Name)='') as Customer_Name_blank,
    sum(trim(Gender)='') as Gender_blank,
    sum(trim(City) ='') as City_blank,
    sum(trim(State) ='') as State_blank,
    sum(trim(Country) ='') as Country_blank,
    sum(trim(Email) ='') as Email_blank,
    sum(trim(Registration_Date) ='') as Registration_Date_blank
from customers_raw;

--- Employees table
select 
	sum(trim(Employee_ID) ='') as Employee_ID_blank,
    sum(trim(Employee_Name) ='') as Employee_Name_blank,
    sum(trim(Department) ='') as Department_blank,
    sum(trim(Job_Title) ='') as Job_Title_blank,
    sum(trim(Warehouse_ID) ='') as Warehouse_ID_blank,
    sum(trim(Hire_Date) ='') as hire_date_blank,
    sum(trim(Salary) ='') as Salary_blank
from employees_raw;

--- Inventory table
select 
	sum(trim(Inventory_ID) ='') as Inventory_blank,
    sum(trim(Warehouse_ID) ='') as Warehouse_blank,
    sum(trim(Product_ID) ='') as Product_ID_blank,
    sum(trim(Inventory_Date) ='') as Inventory_Date_blank,
    sum(trim(Stock_Quantity) ='') as Stock_qty_blank,
    sum(trim(Reserved_Quantity) ='') as Reserved_qty_blank,
    sum(trim(Damaged_Quantity) ='') as Damaged_Qty_blank
from inventory_raw;

--- Order_items_raw
select 
	sum(trim(Order_Item_ID) ='') as order_blank,
    sum(trim(Order_ID) ='') as ID_blank,
    sum(trim(Product_ID) ='') as Product_blank,
    sum(trim(Quantity) ='') as QTY_blank,
    sum(trim(Unit_Price) ='') as Unit_blank,
    sum(trim(Discount_Percent) ='') as Discount_blank,
    sum(trim(Line_Total) ='') as Line_Total_blank
from order_items_raw;

--- orders_raw
select 
	sum(trim(Order_ID) ='') as order_blank,
    sum(trim(Customer_ID) ='') as Customer_blank,
    sum(trim(Order_Date) ='') as Order_Date_blank,
    sum(trim(Order_Status) ='') as Status_blank,
    sum(trim(Payment_Method) ='') as Payment_blank,
    sum(trim(Warehouse_ID) ='') as Warehouse_blank,
    sum(trim(Shipping_Priority) ='') as shipping_blank 
from orders_raw;

--- product Table
select 
	sum(trim(Product_ID) ='') as ID_blank,
    sum(trim(Product_Name) ='') as Name_blank,
    sum(trim(Category) ='') as category_blank,
    sum(trim(Supplier_ID) ='') as Supplier_blank,
    sum(trim(Unit_Cost) ='') as Unit_Cost_blank,
    sum(trim(Selling_Price) ='') as Selling_price_blank,
    sum(trim(Reorder_Level) ='') as record_blank,
    sum(trim(Weight_KG) ='') As weight_blank
from products_raw;

--- returns_raw
select 
	sum(trim(Return_ID) ='') as ID_blank,
    sum(trim(Return_Date) ='') as Return_Date_blank,
    sum(trim(Refund_Amount) ='') as Refund_blank,
    sum(trim(Return_Quantity) ='') as Return_QTY_blank,
    sum(trim(Return_Reason) ='') as Reason_blank,
    sum(trim(Return_Status) ='') as Status_blank,
    sum(trim(Order_ID) ='') as Order_blank,
    sum(trim(Product_ID) ='') as Product_blank
from returns_raw;

--- shipments_raw
select 
	sum(trim(Shipment_ID) ='') as Shipment_ID_blank,
    sum(trim(Order_ID) ='') as Order_ID_blank,
    sum(trim(Shipment_Date) ='') ship_Date_blank,
    sum(trim(Expected_Delivery_Date) ='') as Expected_Delivery_Date_blank,
    sum(trim(Actual_Delivery_Date) ='') as Actual_Delivery_Date_blank,
    sum(trim(Carrier) ='') as Carrier_blank,
    sum(trim(Shipment_Status) ='') as Shipment_Status_blank,
    sum(trim(Shipping_Cost) ='') as Shipping_Cost_blank
from shipments_raw;

--- supplier table
select 
	sum(trim(Supplier_ID) ='') as Supplier_ID_blank,
    sum(trim(Supplier_Name) ='') as Supplier_Name_blank,
    sum(trim(Country) ='') as Country_blank,
    sum(trim(Supplier_Type) ='') as Supplier_Type_blank,
    sum(trim(Contact_Email) ='') as email_blank,
    sum(trim(Rating) ='') as Rating_blank
from suppliers_raw;

--- Warehouse table
select 
	sum(trim(Warehouse_ID) ='') as Warehouse_id_blank,
    sum(trim(Warehouse_Name) ='') as Warehouse_Name_blank,
    sum(trim(City) ='') as City_blank,
    sum(trim(Capacity_Units) ='') as Capacity_unit_blank,
    sum(trim(Warehouse_Type) ='') as Warehouse_Type_blank
from warehouses_raw;

--- 3.4 check duplicate values

--- * customers table
select 
	Customer_ID,
    count(*) as duplicate_count
from customers_raw group by Customer_ID having count(*)>1;

--- Employees Table
select 
	Employee_ID,
    count(*) as duplicate_count
from employees_raw group by Employee_ID having count(*)>1;

--- Inventory Table
select 
	Inventory_ID,
    count(*) as duplicate_count
from inventory_raw group by Inventory_ID having count(*)>1;

--- Order_items_raw table
select 
	Order_Item_ID,
    count(*) as duplicate_count
from order_items_raw group by Order_Item_ID having count(*)>1;

--- * order table
select 
	Order_ID,
	count(*) as duplicate_count
from orders_raw group by Order_ID having count(*)>1;

--- products table
select 
	Product_ID,
    count(*) as Duplicate_count
from products_raw group by Product_ID having count(*) >1;

--- * returns table
select 
	Return_ID,
    count(*) as Duplicate_count
from returns_raw group by Return_ID having count(*) >1;

--- * shipment table
select 
	Shipment_ID,
    count(*) as duplicate_count
from shipments_raw group by Shipment_ID having count(*)>1;

--- * suppliers table
select 
	Supplier_ID,
    count(*) as duplicate_count
from suppliers_raw group by Supplier_ID having count(*) >1;

--- * warehouses Table
select 
	Warehouse_ID,
    count(*) as duplicate_count
from warehouses_raw group by Warehouse_ID having count(*) >1;


--- 3.5 Inconsistent Text 

--- * customer table
select distinct Gender from customers_raw;
select distinct City from customers_raw;
select distinct State from customers_raw;

--- * Employees table
select distinct Department from employees_raw;
select distinct Job_Title from employees_raw;

--- * order table
select distinct Order_Status from orders_raw;
select distinct Payment_Method from orders_raw;
select distinct Shipping_Priority from orders_raw;

--- * products table
select distinct Category from products_raw;

--- *Return Table
select distinct Return_Reason from returns_raw;
select distinct Return_Status from returns_raw;

--- *shipments table
select distinct Carrier from shipments_raw;
select distinct Shipment_Status from shipments_raw;

--- ** suppliers_raw
select distinct Country from suppliers_raw;
select distinct Supplier_Type from suppliers_raw;

--- ** warehouse Table
select distinct City from warehouses_raw;
select distinct State from warehouses_raw;
select distinct Warehouse_Type from warehouses_raw;

--- 3.6 Invalid Numerical values

--- * employee table
select count(*) as Invalid_Value from employees_raw where Salary <= 0;

--- ** Invemtory table
select count(*) as Invalid_Value from inventory_raw where Stock_Quantity < 0;
select count(*) as Invalid_Value from inventory_raw where Reserved_Quantity < 0;
select count(*) as Invalid_Value from inventory_raw where Damaged_Quantity < 0;

--- ** *order_items table
select count(*) as Invalid_Value from order_items_raw where Quantity <= 0;
select count(*) as Invalid_Value from order_items_raw where Unit_Price <= 0;
select count(*) as Invalid_Value from order_items_raw where Discount_Percent < 0 or Discount_Percent > 100;
select count(*) as Invalid_Value from order_items_raw where Line_Total < 0;

--- **  Products Table
select count(*) as Invalid_Value from products_raw where Unit_Cost <= 0;
select count(*) as Invalid_Value from products_raw where Selling_Price <= 0;
select count(*) as Invalid_Value from products_raw where  Reorder_Level < 0;
select count(*) as Invalid_Value from products_raw where Weight_KG <= 0;

--- *return table
select count(*) as Invalid_Value from returns_raw where Return_Quantity <=0;
select count(*) as Invalid_Value from returns_raw where Refund_Amount <= 0;

--- *shipments_raw
select count(*) as Invalid_Value from shipments_raw where Shipping_Cost <= 0;

--- *Suppliers TAble
select count(*) as Invalid_Value from suppliers_raw where Rating < 0 or Rating < 5;

--- Warehouse Table
select count(*) as Invalid_Value from warehouses_raw where Capacity_Units <= 0;

--- 3.7 Invalid Date check 

--- Customer Table
select count(*) As Blank_Dates from customers_raw where trim(Registration_Date) = '';

--- employee table
select count(*) As Blank_Dates from employees_raw where trim(Hire_Date) ='';

--- inventory table
select count(*) As Blank_Dates from inventory_raw where trim(Inventory_Date) ='';

--- *Order Table
select count(*) As Blank_Dates from orders_raw where trim(Order_Date) ='';

--- Return Table 
select count(*) As Blank_Dates from returns_raw where trim(Return_Date) ='';

--- *shipment date
select count(*) As Blank_Dates from shipments_raw where trim(Shipment_Date) ='';
select count(*) As Blank_Dates from shipments_raw where trim(Expected_Delivery_Date) ='';
select count(*) As Blank_Dates from shipments_raw where trim(Actual_Delivery_Date) ='';

--- 3.8 Email And Data Format Validation

--- customer table
select count(*) as Invalid_Emails from customers_raw where trim(Email) <> '' and Email not like '%@%';

--- suppliers Table
select count(*) as Invalid_phone from suppliers_raw where trim(Contact_Email) <> '' and Contact_Email not like '%@%';

--- 3.9 Relationship check Between Table
--- product - supplier
select count(*) as Unidentify_Product from products_raw p
left join suppliers_raw s 
on p.Supplier_ID = s.Supplier_ID
where s.Supplier_ID is null;

--- orders - customers
select count(*) as unidentify_order_Customer from orders_raw o
left join customers_raw c
on o.Customer_ID = c.Customer_ID
where c.Customer_ID is null;

--- order - warehouse
select count(*) as unidentify_warehouse_orders from orders_raw o 
left join warehouses_raw w
on o.Warehouse_ID = w.Warehouse_ID
where w.Warehouse_ID is null;

--- orders_item - order
select count(*) as unidentify_order_items from order_items_raw oi
left join orders_raw o
on oi.Order_ID = o.Order_ID
where o.Order_ID is null;

--- order items - product
select count(*) as unidentify_item_product from order_items_raw oi
left join products_raw p 
on oi.Product_ID = p.Product_ID
where p.Product_ID is null;

--- shipment - orders
select count(*) as unidentify_shipments from shipments_raw s 
left join orders_raw o
on s.Order_ID = o.Order_ID
where o.Order_ID is null;

--- inventory - product
select count(*) as unidentify_inventory_product from inventory_raw i 
left join products_raw p 
on i.Product_ID = p.Product_ID
where p.Product_ID is null;

--- inventory - warehouse
select count(*) as unidentify_inventory_warehouse from inventory_raw i 
left join warehouses_raw w 
on i.Warehouse_ID = w.Warehouse_ID
where w.Warehouse_ID is null;

--- employee - warehouse
select count(*) as unidentify_employee from employees_raw e 
left join warehouses_raw w 
on e.Warehouse_ID = w.Warehouse_ID
where w.Warehouse_ID is null;

--- return - orders
select count(*) as unidentify_return_order from returns_raw r 
left join orders_raw o 
on r.Order_ID = o.Order_ID
where o.Order_ID is null;

--- return - product
select count(*) as unidentify_return_product from returns_raw r 
left join products_raw p 
on r.Product_ID = p.Product_ID
where p.Product_ID is null;
--------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------- 
--- 4 Data Cleaning 

--- 4.1 Clean Database create

create database supply_chain_clean;
use supply_chain_clean;

---  create table 

--- 4.2 Customer_clean
create table customer_clean as
select 
	Customer_ID,
    trim(Customer_Name) as Customer_Name,
    case
		when lower(trim(Gender)) in ('male','m') then 'Male'
        when lower(trim(Gender)) in ('female','f') then 'Female'
        when lower(trim(Gender)) = 'other' then 'Other'
        else null
	end as Gender,
    trim(City) as City,
    trim(State) as State,
    trim(Country) as Country,
    nullif(lower(trim(Email)),'') as Email,
    nullif(trim(Registration_Date),'') as Registration_Date from (
    select *, row_number() over(partition by Customer_ID order by Customer_ID
    ) as rn
from supply_chain.customers_raw) as x where rn = 1 and Customer_ID is not null;

--- 4.2.1 Null Value check
 select 
	sum(Customer_ID is null) as Customer_null,
    sum(Customer_Name is null) as Name_null,
    sum(Gender is null) as Gender_null,
    sum(City is null ) as City_null,
    sum(State is null) as State_Null,
    sum(Country is null) as Country_null,
    sum(Email is null) as Email_Null,
    sum(Registration_Date is null) as Reg_Date_null
from customer_clean;

--- 4.3 create employees_clean table
create table employees_clean as
select 
	Employee_ID,
    trim(Employee_Name) as Employee_Name,
    case
		when lower(Trim(Department)) = 'warehouse' then 'Warehouse'
        when lower(trim(Department)) = 'procurement' then 'Procurement'
        when lower(trim(Department)) = 'logistics' then 'Logistics'
        when lower(trim(Department)) = 'finance' then 'Finance'
        when lower(trim(Department)) = 'operations' then 'Operations'
        when lower(trim(Department)) = 'sales' then 'Sales'
        else null
	end as Department,
    trim(Job_Title) as Job_Title,
    Warehouse_ID,
    Hire_Date,
    Salary
from( select *,row_number() over(partition by Employee_ID order by Employee_ID) as rn from supply_chain.employees_raw) as x 
where rn = 1 and Employee_ID is not null;

--- 4.3.1 check null values
select 
	sum( Employee_ID is null) as emp_null,
    sum(Employee_Name is null) as name_null,
    sum(Department is null) as department_null,
    sum(Job_Title is null) as job_title_null,
    sum(Warehouse_ID is null) as warehouse_null,
    sum(Hire_Date is null) as hire_date_null,
    sum(Salary is null) as Salary_null
from employees_clean;

--- 4.3.2 Check invalid salary
select count(*) as invalid_salary from employees_clean where Salary <= 0;

--- 4.3.3 check Duplicate Employee_count
select Employee_ID, count(*) as Duplicate_count from employees_clean
group by Employee_ID having count(*) > 1;

--- 4.3.4 Invalid or 0 salary values fill
select 
	Department,
    round(avg(Salary),2) as Avg_Salary
from employees_clean where Salary > 0 group by Department order by Department;

--- 
create temporary table salary_avg as 
select 
	Department,
    avg(Salary) as Avg_Salary
from employees_clean where Salary > 0 group by Department;

--- update salary 
update employees_clean e 
left join salary_avg a 
on e.Department <=> a.Department
set e.Salary = coalesce(a.avg_salary,
(select avg(Salary) from (select Salary from employees_clean where Salary > 0) as Valid_Salary)) where e.Salary <=0;


--- 4.4 create Inventory_clean table
create table inventory_clean as 
select 
	Inventory_ID,
    Warehouse_ID,
    Product_ID,
    nullif(trim(Inventory_Date),'') as Inventory_Date,
    case
		when Stock_Quantity < 0 then 0
        else Stock_Quantity
	end as Stock_Quantity,
    case
		when Reserved_Quantity < 0 then 0
        else Reserved_Quantity
	end as Reserved_Quantity,
    case
		when Damaged_Quantity < 0 then 0
        else Damaged_Quantity
	end as Damaged_Quantity
from ( select *, row_number() over (partition by Inventory_ID order by Inventory_ID) as rn from supply_chain.inventory_raw ) 
as x where rn = 1 and Inventory_ID is not null;

--- 4.4.1 Check Total rows
select count(*) as total_row from inventory_clean;

--- 4.4.2 Check null values
select 
	sum(Inventory_ID is null) as Inventory_null,
    sum(Warehouse_ID is null) as Warehouse_null,
    sum(Product_ID is null) as Product_null,
    sum(Inventory_Date is null) as Inventory_Date_Null,
    sum(Stock_Quantity is null) as Stock_Quantity_null,
    sum(Reserved_Quantity is null) as Reserved_Quantity_null,
    sum(Damaged_Quantity is null) as Damaged_Quantity_null
from inventory_clean;

--- 4.4.3 check invalid quantity
select 
	sum(Stock_Quantity < 0) as invalid_stock,
    sum(Reserved_Quantity < 0) as Reserved_Quantity,
    sum(Damaged_Quantity < 0) as Damaged_Quantity
from inventory_clean;

--- 4.4.4 Check duplicate ID
select
	Inventory_ID,
    count(*) as duplicate_count
from inventory_clean group by Inventory_ID having count(*)>1;

--- 4.5 create order_items table
create table order_items_clean as 
select 
	Order_Item_ID,
    Order_ID,
    Product_ID,
    case
		when Quantity < 0 then 0
        else Quantity
	end as Quantity,
    case
		when Unit_Price < 0 then 0
        else Unit_Price
	end as Unit_Price,
    case
		when Discount_Percent < 0 then 0 
        when Discount_Percent > 100 then 100
        else Discount_Percent
	end as Discount_Percent,
    case
		when Line_Total < 0 then 0
        else Line_Total
	end as Line_Total
from (select *, row_number() over(partition by Order_Item_ID order by Order_Item_ID) as rn from  supply_chain.order_items_raw)
as x where rn = 1 and Order_Item_ID is not null;

--- 4.5.1 Check total row
select count(*) as total_row  from order_items_clean;

--- 4.5.2 check null values
select 
	sum(Order_Item_ID is null ) as order_item_null,
    sum(Order_ID is null) as Order_ID_null,
    sum(Product_ID is null) as Product_null,
    sum(Quantity is null) as Quantity_null,
    sum(Unit_Price is null) as Unit_price_null,
    sum(Discount_Percent is null) as Discount_Price_null,
    sum(Line_Total is null) as Line_Total_null
from order_items_clean;

--- 4.5.3 check invalid values
select 
	sum(Quantity < 0) as invalid_quantity,
    sum(Unit_Price < 0) as invalid_price,
    sum(Discount_Percent < 0 or Discount_Percent > 100) as invalid_discount,
    sum(Line_Total < 0) as invalid_total
from order_items_clean;

--- 4.5.4 Check Duplicate id
select Order_Item_ID, count(*) as Duplicate_count from order_items_clean
group by Order_Item_ID having count(*)>1;

--- 4.6 order table
create table order_clean as 
select 
	Order_ID,
    Customer_ID,
    nullif(trim(Order_Date),'') as Order_Date,
    case
		when lower(trim(Order_Status)) in ('completed','complete') then 'Completed'
        when lower(trim(Order_Status)) = 'pending' then 'Pending'
        when lower(trim(Order_Status)) = 'processing' then 'Processing'
        when lower(trim(Order_Status)) = 'shipped' then 'Shipped'
        when lower(trim(Order_Status)) in ('canceled','cancelled') then 'Cencelled'
        else null 
	end as Order_Status,
    case
		when lower(trim(Payment_Method)) in ('credit card' , 'Credit card','credit Card') then 'Credit Card'
        when lower(trim(Payment_Method)) in ('cash on delivery','cashondelivery') then 'Cash on Delivery'
        when lower(trim(Payment_Method)) in ('debit card','debitcard') then 'Debit Card'
        when lower(trim(Payment_Method)) = 'upi' then 'UPI'
        when lower(trim(Payment_Method)) in ('bank transfer', 'banktransfer') then 'Bank Transfer'
        else null
	end as Payment_Method,
    Warehouse_ID,
    case
		when lower(trim(Shipping_Priority)) = 'urgent' then 'Urgent'
        when lower(trim(Shipping_Priority)) = 'low' then 'Low'
        when lower(trim(Shipping_Priority)) = 'medium' then 'Medium'
        when lower(trim(Shipping_Priority)) = 'high' then 'High'
        else null
	end as Shipping_Priority
from ( select * , row_number() over(partition by Order_ID order by Order_ID) as rn from supply_chain.orders_raw)
as x where rn = 1 and Order_ID is not null;

--- 4.6.1 check row count
select count(*) as Total_row from order_clean;

--- 4.6.2 check null values
select 
	sum(Order_ID is null) as order_ID_null,
    sum(Customer_ID is null) as customer_ID_null,
    sum(Order_Date is null) as order_date_null,
    sum(Order_Status is null) as order_status_null,
    sum(Payment_Method is null) as payment_method_null,
    sum(Warehouse_ID is null) as warehouse_id_null,
    sum(Shipping_Priority is null) as shipping_priority_null
from order_clean;

--- 4.6.3 check duplicate order_ID
select 
	Order_ID,
    count(*) as duplicate_count
from order_clean group by Order_ID having count(*)>1;

--- 4.6.4 check standard values
select distinct Order_Status from order_clean order by Order_Status;
select distinct Payment_Method from order_clean order by Payment_Method;
select distinct Shipping_Priority from order_clean order by Shipping_Priority;

--- 4.7 create product_clean table 
create table product_clean as 
select 
	Product_ID,
    trim(Product_Name) as Product_Name,
    case
		when lower(trim(Category)) = 'electronics' then 'Electronics'
        when lower(trim(Category)) = 'grocery' then 'Grocery'
        when lower(trim(Category)) in ('health care', 'healthcare') then 'Health Care'
        when lower(trim(Category)) = 'automotive' then 'Automotive'
        when lower(trim(Category)) = 'industrial' then 'Industrial'
        when lower(trim(Category)) = 'furniture' then 'Furniture'
        when lower(trim(Category)) = 'apparel' then 'Apparel'
        when lower(trim(Category)) = 'office supplies' then 'Office Supplies'
        else null
	end as Category,
    Supplier_ID,
    case
		when Unit_Cost <= 0 then null
        else Unit_Cost
	end as Unit_Cost,
    case
		when Selling_Price <= 0 then null
        else Selling_Price
	end as Selling_Price,
    case
		 when Reorder_Level < 0 then 0
         else Reorder_Level
	end as Reorder_Level,
    case
		when Weight_KG <= 0 then null
        else Weight_KG
	end as Weight_KG
from ( select *, row_number()over(partition by Product_ID order by Product_ID) as rn from supply_chain.products_raw)
as x where rn = 1 and Product_ID is not null;

--- 4.7.1 check total row
select count(*) as total_row from product_clean;

--- 4.7.2 check null values
select 
	sum(Product_ID is null) as product_id_null,
    sum(Product_Name is null) as product_name_null,
    sum(Category is null) as category_null,
    sum(Selling_Price is null) as selling_price_null,
    sum(Supplier_ID is null) as supplier_id_null,
	sum(Unit_Cost is null) as Unit_Cost_null,
    sum(Reorder_Level is null) as reorder_level_null,
    sum(Weight_KG is null) as weight_null
from product_clean;

--- 4.7.3 check duplicate values
select Product_ID, count(*) as total_duplicate from product_clean group by Product_ID having count(*)>1;

--- 4.7.4 check invalid numerical values
select 
	sum(Unit_Cost <=0) as invalid_cost,
    sum(Selling_Price <=0) as invalid_price,
    sum(Weight_KG <=0) as invalid_weight,
    sum(Reorder_Level < 0) as invalid_reorder
from product_clean;

--- 4.8 create Return_clean table
create table return_clean as
select 
	Return_ID,
    Order_ID,
    Product_ID,
    nullif(trim(Return_Date),'') as Return_Date,
    Return_Quantity,
    case
		when lower(trim(Return_Reason)) = 'damaged' then 'Damaged'
        when lower(trim(Return_Reason)) in ('quality issue','Quality issue','quality Issue') then 'Quality Issue'
        when lower(trim(Return_Reason)) in ('customer changed mind', 'Customer changed mind','Customer Changed mind','Customer changed Mind') then 'Customer Changed Mind'
        when lower(trim(Return_Reason)) in ('missing parts','Missing parts','missing Parts') then 'Missing Parts'
        when lower(trim(Return_Reason)) in ('wrong item','Wrong item','wrong Item') then 'Wrong Item'
        when lower(trim(Return_Reason)) in ('late delivery','Late delivery','late Delivery') then 'Late Delivery'
        else null
	end as Return_Reason,
    case
		when Refund_Amount < 0 then 0
        else Refund_Amount
	end as Refund_Amount,
    case
		when lower(trim(Return_Status)) = 'completed' then 'Completed'
		when lower(trim(Return_Status)) = 'approved' then 'Approved'
        when lower(trim(Return_Status)) = 'rejected' then 'Rejected'
        when lower(trim(Return_Status)) = 'requested' then 'Requested'
        else null
	end as Return_Status
from ( select *, row_number() over(partition by Return_ID order by Return_ID) as rn from supply_chain.returns_raw) 
as x where rn = 1 and Return_ID is not null ;

--- 4.8.1 check total row 
select count(*) as total_row from return_clean;

--- 4.8.2 check null values
select 
	sum(Return_ID is null) as return_null,
    sum(Order_ID is null) as Order_null,
    sum(Product_ID is null) as product_null,
    sum(Return_Date is null) as Date_null,
    sum(Return_Quantity is null) as qunatity_null,
    sum(Return_Reason is null) as reason_null,
    sum(Refund_Amount is null) as refund_null,
    sum(Return_Status is null) as status_null
from return_clean;

--- 4.8.3 check duplicate values
select Return_ID, count(*) as duplicate_values from return_clean group by Return_ID having count(*)>1;

--- 4.8.4 check invalid values
select 
	sum(Return_Quantity<0) as invalid_quantity,
    sum(Refund_Amount<0) as invalid_amount 
from return_clean;

--- 4.9 create shipment_clean table
create table shipment_clean as 
select 
	Shipment_ID,
    Order_ID,
    nullif(trim(Shipment_Date),'') as Shipment_Date,
    nullif(trim(Expected_Delivery_Date),'') as Expected_Delivery_Date,
    nullif(trim(Actual_Delivery_Date),'') as Actual_Delivery_Date,
    case
		when lower(trim(Carrier)) = 'delhivery' then 'Delhivery'
        when lower(trim(Carrier)) = 'dhl' then'DHL'
        when lower(trim(Carrier)) = 'ups' then 'UPS'
        when lower(trim(Carrier)) = 'bluedart' then 'BlueDart'
        when lower(trim(Carrier)) = 'fedex' then 'FedEx'
        when lower(trim(Carrier)) = 'dtdc' then 'DTDC'
        else null
	end as Carrier,
    case
		when lower(trim(Shipment_Status)) = 'delivered' then 'Delivered'
        when lower(trim(Shipment_Status)) = 'returned' then 'Returned'
        when lower(trim(Shipment_Status)) = 'delayed' then 'Delayed'
        when lower(trim(Shipment_Status)) in ('in transit' , 'In transit' , 'in Transit') then 'In Transit'
        when lower(trim(Shipment_Status)) = 'lost' then 'Lost'
        else null
	end as Shipment_Status,
    case
		when Shipping_Cost < 0 then 0 
        else Shipping_Cost
	end as Shipping_Cost
from (select *, row_number() over(partition by Shipment_ID order by Shipment_ID) as rn from supply_chain.shipments_raw) 
as x where rn = 1 and Shipment_ID is not null;

--- 4.9.1 check row count
select count(*) as total_row from shipment_clean;

--- 4.9.2 check null values
select 
	sum(Shipment_ID is null) as shipment_id_null,
    sum(order_id is null) as order_id_null,
    sum(Shipment_Date is null) as null_date,
    sum(Expected_Delivery_Date is null) as expected_date_null,
    sum(Actual_Delivery_Date is null) as actual_date_null,
    sum(Carrier is null) as carrier_null,
    sum(Shipment_Status is null) as shipment_status_null,
    sum(Shipping_Cost is null) as shipping_cost_null
from shipment_clean;

--- 4.9.3 check duplicate 
select Shipment_ID, 
count(*) as duplicate_count from shipment_clean
group by Shipment_ID having count(*) > 1;

--- 4.9.4 check invalid shipping costs
select count(*) as invalid_shipping_cost from shipment_clean where Shipping_Cost < 0;

--- 4.9.5 check carrier values
select
	Carrier,
    count(*) as total
from shipment_clean group by Carrier order by total desc;

--- 4.10 create suppliers_clean table 
create table suppliers_clean as 
select 
	Supplier_ID,
    trim(Supplier_Name) as Supplier_Name,
    case
		when lower(trim(Country)) = 'india' then 'India'
        when lower(trim(Country)) = 'canada' then 'Canada'
        when lower(trim(Country)) = 'uk' then 'UK'
        when lower(trim(Country)) = 'china' then 'China'
        when lower(trim(Country)) = 'usa' then 'USA'
        when lower(trim(Country)) = 'japan' then 'Japan'
        when lower(trim(Country)) =  'australia' then 'Australia'
        when lower(trim(Country)) =  'germany' then 'Germany'
        else  null
	end as Country,
    case
		when lower(trim(Supplier_type)) = 'distributor' then 'Distributor'
        when lower(trim(Supplier_type)) =  'wholesaler' then 'Wholesaler'
        when lower(trim(Supplier_type)) = 'manufacturer' then 'Manufacturer'
        else null
	end as Supplier_Type,
    nullif(lower(trim(Contact_Email)),'') as Contact_Email,
    case
		when Rating < 0 then 0
        when Rating > 5 then 5
        else Rating
	end as Rating
from (select*,row_number()over(partition by Supplier_ID order by Supplier_ID) as rn from supply_chain.suppliers_raw)
as x where rn = 1 and Supplier_ID is not null;

--- 4.10.1 check row count
select count(*) as total_row from suppliers_clean;

--- 4.10.2 check duplicate values
select Supplier_ID, count(*) as duplicate_id from suppliers_clean group by Supplier_ID having count(*)>1;

--- 4.10.3 check invalid rating
select count(*) as invalid_rating from suppliers_clean
where Rating < 0 or Rating > 5;

--- 4.10.4 check null values
select 
	sum(Supplier_ID is null) as supplier_id_null,
    sum(Supplier_Name is null) as name_null,
    sum(Country is null) as Country_null,
    sum(Supplier_Type is null) as type_null,
    sum(Contact_Email is null) as email_null,
    sum(Rating is null) as rating_null
from suppliers_clean;

--- 4.10.5 check supplier type
select 
	Supplier_Type,
    count(*) as total
from suppliers_clean group by Supplier_Type order by total desc;

--- 4.11 create warehouse_clean table
create table warehouses_clean as 
select 
	Warehouse_ID,
    trim(Warehouse_Name) as Warehouse_Name,
    case
		when lower(trim(City)) = 'kolkata' then 'Kolkata'
        when lower(trim(City)) = 'ahmedabad' then 'Ahmedabad'
        when lower(trim(City)) = 'delhi' then 'Delhi'
        when lower(trim(City)) = 'jaipur' then 'Jaipur'
        when lower(trim(City)) = 'pune' then 'Pune'
        when lower(trim(City)) = 'lucknow' then 'Lucknow'
        when lower(trim(City)) = 'bengaluru' then 'Bengaluru'
        when lower(trim(City)) = 'chennai' then 'Chennai'
        when lower(trim(City)) = 'hyderabad' then 'Hyderabad'
        when lower(trim(City)) = 'mumbai' then 'Mumbai'
        else null
	end as City,
    case
		when lower(trim(State)) = 'gujarat' then 'Gujarat' 
        when lower(trim(State)) = 'telangana' then 'Telangana'
        when lower(trim(State)) = 'rajasthan' then 'Rajasthan' 
        when lower(trim(State)) = 'uttar pradesh' then 'Uttar Pradesh' 
        when lower(trim(State)) = 'tamil nadu' then 'Tamil Nadu' 
        when lower(trim(State)) = 'maharashtra' then 'Maharashtra' 
        when lower(trim(State)) = 'karnataka' then 'Karnataka' 
        when lower(trim(State)) = 'west bengal' then 'West Bengal'
        else null
	end as State,
    case
		when Capacity_Units < 0 then 0
        else Capacity_Units
	end as Capacity_Units,
    case
		when lower(trim(Warehouse_Type)) = 'distribution center' then 'Distribution Center'
        when lower(trim(Warehouse_Type)) = 'fulfillment center' then 'Fulfillment Center'
        when lower(trim(Warehouse_Type)) = 'storage' then 'Storage'
        else null
	end as Warehouse_Type
from ( select *, row_number() over(partition by Warehouse_ID order by Warehouse_ID) as rn from supply_chain.warehouses_raw) 
as x where rn = 1 and Warehouse_ID is not null;

--- 4.11.1 check total rows
select count(*) as total_row from warehouses_clean;

--- 4.11.2 check null values
select 
	sum(Warehouse_ID is null) as id_null,
    sum(Warehouse_Name is null) as name_null,
    sum(City is null) as city_null,
    sum(State is null) as State_null,
    sum(Capacity_Units is null) as unit_null,
    sum(Warehouse_Type is null) as type_null
from warehouses_clean;

--- 4.11.3 check duplicate values
select Warehouse_ID,count(*) as duplicate_count from warehouses_clean group by Warehouse_ID having count(*)>1;

--- 4.11.4 check invalid capacity
select count(*) as invalid_capacity from warehouses_clean where Capacity_Units<0;


--- 5 data type conversion 

--- 5.1 Customer table
desc customer_clean; 

select Registration_Date,count(*) as count from customer_clean
where Registration_Date is not null group by Registration_Date limit 20;

alter table customer_clean
modify Customer_ID int not null,
modify Customer_Name varchar(100),
modify Gender varchar(10),
modify City varchar(50),
modify State varchar(50),
modify Country varchar(50),
modify Email varchar(100),
modify Registration_Date date;

desc customer_clean;

--- 5.2 employee table
desc employees_clean;
select Hire_Date,count(*) as count from employees_clean 
where Hire_Date is not null group by Hire_Date limit 20;

alter table employees_clean
modify Employee_ID int not null,
modify Employee_Name varchar(50),
modify Department varchar(50),
modify Job_Title varchar(50),
modify Warehouse_ID int,
modify Hire_Date date,
modify Salary decimal(12,2);

desc employees_clean;

--- 5.3 Inventory table
desc inventory_clean;

select Inventory_Date, count(*) as count from inventory_clean
where Inventory_Date is not null group by Inventory_Date limit 20;

alter table inventory_clean
modify Inventory_Date date;

--- 5.4 order table
desc order_clean;
select Order_Date from order_clean limit 20;

update order_clean
set Order_Date = date_format(str_to_date(trim(Order_Date),'%d-%m-%Y'),'%Y-%m-%d')
where Order_Date is not null and trim(Order_Date)<>'';

select Order_Date from order_clean where Order_Date is not null
and trim(Order_Date)<>'' and str_to_date(trim(Order_Date),'%d-%m-%Y') is null limit 30;

update order_clean
set Order_Date = 
	case
		when Order_Date regexp'^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
        then date_format(str_to_date(trim(Order_Date),'%d-%m-%Y'),'%Y-%m-%d')
        when Order_Date regexp'^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        then trim(Order_Date)
        else null
	end;
    
alter table order_clean
modify Order_Date date;

--- 5.5 order_item_clean table
desc order_items_clean;

alter table order_items_clean
modify Unit_Price decimal(10,2),
modify Discount_Percent decimal(5,2),
modify Line_Total decimal(10,2);

desc order_items_clean;

--- 5.6 product_clean
desc product_clean;

alter table product_clean
modify Product_Name varchar(50);

--- 5.7 return_clean table
desc return_clean;
alter table return_clean
modify Return_Date date,
modify Refund_Amount decimal(10,2);

--- 5.8 shipment_clean
desc shipment_clean;
alter table shipment_clean
modify Shipment_Date date,
modify Expected_Delivery_Date date,
modify Actual_Delivery_Date date,
modify Shipping_Cost decimal(10,2);

--- 5.9 supplier_clean
desc suppliers_clean;
alter table suppliers_clean
modify Supplier_Name varchar(50),
modify Contact_Email varchar(100);

--- 5.10 warehouse_clean
desc warehouses_clean;
alter table warehouses_clean
modify Warehouse_Name varchar(100),
modify City varchar(20),
modify State varchar(20),
modify Warehouse_Type varchar(50); 

--- 5.11 Final data type validation
select table_name, column_name,
data_type from information_schema.columns
where table_schema = 'supply_chain_clean'
and table_name in (
'customer_clean',
'employees_clean',
'inventory_clean',
'order_clean',
'order_items_clean',
'product_clean',
'return_clean',
'shipment_clean',
'suppliers_clean',
'warehouses_clean') order by table_name, ordinal_position; 

--- 6.1 handle with null values

--- customer_clean table
update customer_clean
set Email = 'unknown@abc.com'
where Email is null;

--- employees_clean
update employees_clean
set Department = 'Unknown'
where Department is null;

--- product_clean
update product_clean
set Category = 'Unknown'
where Category is null;

update product_clean
set Unit_Cost = 
(select avg_cost from (select avg(Unit_Cost) as avg_cost from product_clean where Unit_Cost is not null) as temp) 
where Unit_Cost is null;

select avg(Unit_Cost) from supply_chain.products_raw where Unit_Cost is not null;
select avg(Unit_Cost) from product_clean;

select avg(Selling_Price) from product_clean where Selling_Price is not null;
update product_clean
set Selling_Price = 
(select avg_price from(select avg(Selling_Price)
as avg_price from product_clean where Selling_Price is not null)as temp)
where Selling_Price is null;
select avg(Selling_Price) from product_clean;

--- supplier_clean
update suppliers_clean
set Country = 'Unknown'
where Country is null;

update suppliers_clean
set Supplier_Type = 'Unknown'
where Supplier_Type is null;

update suppliers_clean
set Contact_Email = concat('unknown_',Supplier_ID,'@abc.com')
where Contact_Email is null;

--- Warehouse_Clean table
update warehouses_clean
set City = 'Unknown'
where City is null;

update warehouses_clean
set State = 'Unknown'
where State is null;

--- 7 validation check into clean tables

--- 7.1 customer - order
select o.Customer_ID from order_clean o
left join customer_clean c 
on o.Customer_ID = c.Customer_ID
where o.Customer_ID is not null and c.Customer_ID is null;

--- 7.2 warehouse - order
select o.Warehouse_ID from order_clean o
left join warehouses_clean w 
on o.Warehouse_ID = w.Warehouse_ID
where o.Warehouse_ID is not null and w.Warehouse_ID is null;

--- 7.3 order - order_item
select oi.Order_ID from order_items_clean oi
left join order_clean o 
on oi.Order_ID = o.Order_ID
where oi.Order_ID is not null and o.Order_ID is null;

--- 7.4 product - Inventory
select i.Product_ID from inventory_clean i 
left join product_clean p
on i.Product_ID = p.Product_ID
where i.Product_ID is not null and p.Product_ID is null;

--- 7.5 product - order item 
select oi.Product_ID from order_items_clean oi
left join product_clean p 
on oi.Product_ID = p.Product_ID
where oi.Product_ID is not null and p.Product_ID is null;

--- 7.6 warehouse - inventory
select i.Warehouse_ID from inventory_clean i 
left join warehouses_clean w 
on i.Warehouse_ID = w.Warehouse_ID
where i.Warehouse_ID is not null and w.Warehouse_ID is null;

--- 7.7 product - returns
select r.Product_ID from return_clean r 
left join product_clean p 
on r.Product_ID = p.Product_ID
where r.Product_ID is not null and p.Product_ID is null;

--- 7.8 order - return
select r.Order_ID from return_clean r 
left join order_clean o
on r.Order_ID = o.Order_ID
where r.Order_ID is not null and o.Order_ID is null;

--- 7.9 order - shipment
select s.Order_ID from shipment_clean s 
left join order_clean o 
on s.Order_ID = o.Order_ID
where s.Order_ID is not null and o.Order_ID is null;

--- 7.10 employee - warehouse
select e.Warehouse_ID from employees_clean e 
left join warehouses_clean w
on e.Warehouse_ID = w.Warehouse_ID 
where e.Warehouse_ID is not null and w.Warehouse_ID is null;

--- 7.11 product - supplier
select p.Supplier_ID from product_clean p
left join suppliers_clean s 
on p.Supplier_ID = s.Supplier_ID
where p.Supplier_ID is not null and s.Supplier_ID is null; 
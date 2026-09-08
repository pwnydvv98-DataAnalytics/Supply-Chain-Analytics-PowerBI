--- 8. Business Anakysis and KPI Analysis

--- 8.1 Total Customer
select count(Customer_ID) as Total_Customer from customer_clean;

--- 8.2 Total_Employees
select count(Employee_ID) as Total_Employees from employees_clean;

--- 8.3 Total Product 
select count(Product_ID)  as Total_Product from product_clean;

--- 8.4 Total Suppliers
select count(Supplier_ID) as Total_supplier from suppliers_clean;

--- 8.5 Total Warehouse 
select count(*) as Total_Warehouse from warehouses_clean;

--- Order Analysis
--- 8.6 Total Orders
select count(*) as Total_Orders from order_clean;

--- 8.7 orders by status
select Order_Status, count(*) as Total_Orders from order_clean group by Order_Status order by Total_Orders desc;

--- 8.8 Orders by Payment_methods
select Payment_Method, count(*) as Total_Orders from order_clean group by Payment_Method order by Total_Orders desc;

--- 8.9 orders by shipping_priority
select Shipping_Priority, count(*) as Total_Orders from order_clean group by Shipping_Priority order by Total_Orders desc;

--- 8.10 orders by warehouse
select 
	o.Warehouse_ID,
    w.Warehouse_Name,
    count(o.Order_ID) as Total_Orders
from order_clean o
left join warehouses_clean w 
on o.Warehouse_ID = w.Warehouse_ID
group by o.Warehouse_ID,w.Warehouse_Name order by Total_Orders desc;

--- Sales Analysis
--- 8.11 Total_Revenue
select round(sum(Line_Total),2) as Total_Revenue from order_items_clean;

--- 8.12 Average Order Values
select round(sum(Line_Total)/count(Distinct Order_ID),2) as Avg_Order_Value from order_items_clean;

--- 8.13 Total Items Sold
select sum(Quantity) as Total_Sold_Items from order_items_clean;

--- 8.14 Total Discount
select round(sum(Unit_Price*Quantity*Discount_Percent/100),2) as Total_Discount from order_items_clean;

--- 8.15 Revenue by Product
select 
	p.Product_ID,
    p.Product_Name,
    round(sum(oi.Line_Total),2) as Revenue
from order_items_clean oi 
join product_clean p 
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name order by Revenue desc;

--- 8.16 Top 10 Product by Revenue
select 
	p.Product_ID,
    p.Product_Name,
    round(sum(oi.Line_Total),2) as Revenue
from order_items_clean oi 
join product_clean p 
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name order by Revenue desc limit 10;

--- Category Analysis
--- 8.17 Revenue by Category
select 
	p.Category,
    round(sum(oi.Line_Total),2) as Revenue
from order_items_clean oi
join product_clean p
on oi.Product_ID = p.Product_ID
group by p.Category order by Revenue desc;

--- 8.18 Quantity Sold by Category
select 
	p.Category,
    sum(oi.Quantity) as Units_Sold
from order_items_clean oi
join product_clean p 
on oi.Product_ID = p.Product_ID
group by p.Category order by Units_Sold desc;

--- Customer Analysis
--- 8.19 Top 10 Customer by Spending
select 
	c.Customer_ID,
    c.Customer_Name,
    round(sum(oi.Line_Total),2) as Total_Spending
from customer_clean c 
join order_clean o
on c.Customer_ID = o.Customer_ID
join order_items_clean oi
on o.Order_ID = oi.Order_ID
group by c.Customer_ID,c.Customer_Name order by Total_Spending desc limit 10;

--- 8.20 Orders By Customer
select 
	c.Customer_ID,
    c.Customer_Name,
    count(o.Order_ID) as Total_Orders
from customer_clean c
left join order_clean o 
on c.Customer_ID = o.Customer_ID 
group by c.Customer_ID,c.Customer_Name order by Total_Orders desc;

--- Inventory Stock 
--- 8.21 Total_Stock
select sum(Stock_Quantity) as Total_Stock from inventory_clean;

--- 8.22 Total Reserved Stock
select sum(Reserved_Quantity) as Total_Reserved_Stock from inventory_clean;

--- 8.23 Total Damaged Stock
select sum(Damaged_Quantity) as Total_Damaged_Quantity from inventory_clean;

--- 8.24 Warehouse Inventory
select 
	w.Warehouse_ID,
    w.Warehouse_Name,
    sum(i.Damaged_Quantity) as Total_Damaged_Quantity,
    sum(i.Reserved_Quantity) as Total_Reserved_Quantity,
    sum(i.Stock_Quantity) as Total_Stock
from warehouses_clean w 
left join inventory_clean i 
on w.Warehouse_ID = i.Warehouse_ID
group by w.Warehouse_ID,w.Warehouse_Name order by Total_Stock desc;

--- Low Stock Analysis
--- 8.25 Product below Recorder level
select 
	p.Product_ID,
    p.Product_Name,
    p.Reorder_Level,
    sum(i.Stock_Quantity) as Current_Stock
from product_clean p 
join inventory_clean i 
on p.Product_ID = i.Product_ID
group by p.Product_ID,p.Product_Name,p.Reorder_Level having
Current_Stock < p.Reorder_Level order by Current_Stock asc;

--- Shipment Analysis
--- 8.26 Total Shipment
select count(*) as Total_Shipment from shipment_clean;

--- 8.27 Shipment By Status
select Shipment_Status, count(*) as Total_Shipments from shipment_clean
group by Shipment_Status order by Total_Shipments desc;

--- 8.28 Shipments By Carrier
select Carrier,count(*) as Total_Shipments from shipment_clean
group by Carrier order by Total_Shipments desc;


--- Delivery Performance -------------
--- 8.29 Average Delivery Time
select 
	round(avg(Datediff(Actual_Delivery_Date,Expected_Delivery_Date)),2) as Avg_Delivery_Day_Difference
from shipment_clean where Actual_Delivery_Date is not null and Expected_Delivery_Date is not null;

--- 8.30 Late Shipments
select count(*) as Late_Shipments from shipment_clean
where Actual_Delivery_Date > Expected_Delivery_Date;

--- 8.31 ON Time Delivery 
select count(*) as On_Time_Shipments from shipment_clean
where Actual_Delivery_Date = Expected_Delivery_Date;

--- 8.31.1 On Time Delivery Rate
select 
	round(100*sum(Actual_Delivery_Date <= Expected_Delivery_Date)/count(*),2) As On_Time_Delivey_Rate
from shipment_clean
where Actual_Delivery_Date is not null and Expected_Delivery_Date is not null;

--- Return Analysis ------------
--- 8.32 Total Return
select count(*) as Total_Return from return_clean;

--- 8.33 Return By Reason
select Return_Reason, count(*) as Total_Returns from return_clean
group by Return_Reason order by Total_Returns desc;

--- 8.34 Refund Amount
select sum(Refund_Amount) as Total_Refunded_Amount from return_clean;

--- 8.35 Return Quantity by Product
select 
	p.Product_ID,
    p.Product_Name,
    sum(r.Return_Quantity) as Total_Returns_Quantity
from return_clean r 
join product_clean p 
on r.Product_ID = p.Product_ID
group by p.Product_ID,p.Product_Name order by Total_Returns_Quantity desc;


--- Supplier Analysis-----------
--- 8.36 Supplier By type
select Supplier_Type,count(*) as Total_Suppliers from suppliers_clean
group by Supplier_Type order by Total_Suppliers desc;

--- 8.37 Average Supplier Rating
select round(avg(Rating),2) as Avg_Supplier_Rating from suppliers_clean;

--- 8.38 Top Supplier By rating
select 
	Supplier_ID,
    Supplier_Name,
    Supplier_Type,
    Rating
from suppliers_clean order by Rating desc limit 10;

--- Warehouse Analysis
--- 8.39 Warehouse Capacity
select 
	Warehouse_ID,
    Warehouse_Name,
    Capacity_Units,
    Warehouse_Type
from warehouses_clean order by Capacity_Units;

--- 8.40 Warehouse Utilization
select 
	w.Warehouse_ID,
    w.Warehouse_Name,
    w.Capacity_Units,
    coalesce(sum(i.Stock_Quantity),0) as Current_Stock,
    round(100 * coalesce(sum(i.Stock_Quantity),0)/nullif(w.Capacity_Units,0),2) as Utilization_Percent
from warehouses_clean w
left join inventory_clean i 
on w.Warehouse_ID = i.Warehouse_ID
group by w.Warehouse_ID,w.Warehouse_Name,w.Capacity_Units order by Utilization_Percent desc;

--- Employee Analysis----------
--- 8.41 Employees by Department
select Department, count(*) as Total_Employees from employees_clean
group by Department order by Total_Employees desc;

--- 8.42 Average Salary By department
select 
	Department,
    round(avg(Salary),2) as Avg_Salary
from employees_clean
group by Department order by Avg_Salary desc;

--- 8.43 Top 10 Supplier By Total Sales
select 
	s.Supplier_ID,
    s.Supplier_Name,
    round(sum(oi.Line_Total),2) as Total_Sales
from suppliers_clean s 
join product_clean p 
on p.Supplier_ID = s.Supplier_ID
join order_items_clean oi
on oi.Product_ID = p.Product_ID
group by s.Supplier_ID,s.Supplier_Name order by Total_Sales Desc limit 10;

--- 9.1 Customer Revenue Ranking
with customer_revenue as (
select 
	c.Customer_ID,
    c.Customer_Name,
    round(sum(oi.Line_Total),2) as Revenue
from customer_clean c
join order_clean o 
on c.Customer_ID = o.Customer_ID
join order_items_clean oi
on o.Order_ID = oi.Order_ID
group by c.Customer_ID,c.Customer_Name)
select 
	Customer_ID,
    Customer_Name,
    Revenue
from customer_revenue order by Revenue desc;

--- 9.2 Product Profit Analysis
with product_profit as (
select 
	p.Product_ID,
    p.Product_Name,
    round(sum(oi.Quantity * p.Unit_Cost),2) as Cost,
    round(sum(oi.Line_Total),2) as Revenue
from product_clean p 
join order_items_clean oi 
on p.Product_ID = oi.Product_ID 
group by p.Product_ID,p.Product_Name)
select 
	Product_ID,
    Product_Name,
    Revenue,
    Cost,
    round(Revenue - Cost ,2) as Profit
from product_profit order by Profit desc;

--- 9.3 Product Above Average Revenue
select 
	p.Product_ID,
    p.Product_Name,
    round(sum(oi.Line_Total),2) as Revenue
from product_clean p 
join order_items_clean oi 
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name
having sum(oi.Line_Total)>(
select avg(Product_Revenue) from (select sum(Line_Total) as Product_Revenue from order_items_clean
group by Product_ID) as Avg_Table) order by Revenue desc; 

--- 9.4 Product by Revenue
select 
	p.Product_ID,
    p.Product_Name,
    round(sum(oi.Line_Total),2) as Revenue,
    rank() over(order by sum(oi.Line_Total)desc) as Revenue_Rank
from product_clean p 
join order_items_clean oi
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name order by Revenue_Rank;

--- 9.5 product Ranking
select 
	Product_ID,
    Product_Name,
    round(Revenue,2) as Revenue,
    row_number() over(order by Revenue desc) as Product_Rank 
from ( select p.Product_ID,p.Product_Name, sum(oi.Line_Total) as Revenue
from product_clean p 
join order_items_clean oi
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name) as Product_Data
order by Product_Rank;

--- 9.6 Revenue Ranking by Category
select 
	p.Category,
    round(sum(oi.Line_Total),2) as Revenue,
    rank() over(order by sum(Line_Total)desc) as Category_Rank
from product_clean p
join order_items_clean oi
on p.Product_ID = oi.Product_ID
group by p.Category order by Category_Rank;

--- 9.7 Total of Monthly Revenue
with Monthly_Revenue as (
select 
	year(o.Order_Date) as Year,
    month(o.Order_Date) as Month,
    sum(oi.Line_Total) as Revenue
from order_clean o 
join order_items_clean oi
on o.Order_ID = oi.Order_ID
where o.Order_Date is not null
group by year(o.Order_Date),month(o.Order_Date))
select
	year,month,
    round(Revenue,2) as Monthly_Revenue,
    round(sum(Revenue) over(order by year,month),2) as running_revenue
from Monthly_Revenue order by Year,Month;

--- 9.8 Month over Month Revenue Growth
with Monthly_Revenue as (
select 
	year(o.Order_Date) as Year,
    month(o.Order_Date) as Month,
    sum(oi.Line_Total) as Revenue
from order_clean o 
join order_items_clean oi
on o.Order_ID = oi.Order_ID
where o.Order_Date is not null
group by Year(o.Order_Date),Month(o.Order_Date)),
Previous_Month as (
select 
	Year,Month,
    Revenue,
    lag(Revenue) over(order by Year,Month) as Previous_Revenue
from Monthly_Revenue)
select
	Year,Month,
    round(Revenue,2) as Revenue,
    round(Previous_Revenue,2) as Previous_Month_Revenue,
    round((Revenue-Previous_Revenue)*100 / nullif(Previous_Revenue,0),2)
as MOM_Growth_Percent from Previous_Month order by Year,Month;

--- 9.9 Customer Revenue Contribution %
with Customer_Revenue as (
select 
	c.Customer_ID,c.Customer_Name,
    sum(oi.Line_Total) as Revenue
from customer_clean c 
join order_clean o
on c.Customer_ID = o.Customer_ID
join order_items_clean oi
on o.Order_ID = oi.Order_ID
group by c.Customer_ID,c.Customer_Name)
select
	Customer_ID,
    Customer_Name,
    round(Revenue,2) as Revenue,
    round(Revenue * 100.0 / sum(Revenue) over (),2) as Revenue_Contribution_Percent
from Customer_Revenue order by Revenue desc;

--- 9.10 prodcut Revenue Contribution %
with Product_Revenue as (
select 
	p.Product_ID,p.Product_Name,
    sum(oi.Line_Total) as Revenue
from product_clean p 
join order_items_clean oi
on p.Product_ID = oi.Product_ID
group by p.Product_ID,p.Product_Name)
select 
	Product_ID,Product_Name,
    round(Revenue,2) as Revenue,
    round(Revenue * 100.0 / sum(Revenue) over(),2) as Revenue_Contribution_Percent
from Product_Revenue order by Revenue desc;

--- 9.11 Top 3 Product in each category
with Product_Sales as (
select 
    p.Category,p.Product_ID,p.Product_Name,
    sum(oi.Line_Total) as Revenue
from product_clean p 
join order_items_clean oi
on p.Product_ID = oi.Product_ID
group by p.Category,p.Product_ID,p.Product_Name),
Ranked_Product as (
select 
	Category,Product_ID,Product_Name,
    Revenue, row_number() over (partition by Category order by Revenue Desc) as Category_Rank
from Product_Sales)
select 
	Category,Product_ID,Product_Name,
    round(Revenue,2) as Revenue,
    Category_Rank
from Ranked_Product where Category_Rank <= 3 
order by Category, Category_Rank;

--- 9.12 Top 5 Customer by Revenue
with Customer_Revenue as (
select 
	c.Customer_ID,c.Customer_Name,
    sum(oi.Line_Total) as Revenue
from customer_clean c 
join order_clean o 
	on c.Customer_ID = o.Customer_ID
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
group by c.Customer_ID,c.Customer_Name),
Ranked_Customer as (
select 
	Customer_ID,Customer_Name,Revenue,
    rank() over(order by Revenue desc) as Customer_Rank
from Customer_Revenue)
select 
	Customer_ID,Customer_Name,
    round(Revenue,2) as Revenue,
    Customer_Rank
from Ranked_Customer where Customer_Rank <= 5
order by Customer_Rank;

--- 9.13 Customer Order Ranking
select 
	c.Customer_ID,c.Customer_Name,
    count(distinct o.Order_ID) as Order_Count,
    rank() over(Order by count(distinct o.Order_ID) desc) as Order_Rank
from customer_clean c
join order_clean o 
	on c.Customer_ID = o.Customer_ID
group by c.Customer_ID,c.Customer_Name order by Order_Rank;

--- 9.14 Warehouse Revenue Ranking
select 
	w.Warehouse_ID,w.Warehouse_Name,
    round(sum(oi.Line_Total),2) as Revenue,
    rank() over(order by sum(oi.Line_Total) desc) as Warehouse_Rank
from warehouses_clean w
join order_clean o
	 on w.Warehouse_ID = o.Warehouse_ID
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
group by w.Warehouse_ID,w.Warehouse_Name order by Warehouse_Rank;

--- 9.15 order Value Ranking
select 
	o.Order_ID,o.Customer_ID,
    round(sum(oi.Line_Total),2) as Order_Value,
    rank() over(order by sum(oi.Line_Total) desc) as Order_Rank
from order_clean o
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
group by o.Order_ID,o.Customer_ID order by Order_Rank;

--- 9.16 Average Order Values By Customer
with Customer_Orders as (
select 
	o.Customer_ID,o.Order_ID,
    sum(oi.Line_Total) as Order_Value
from order_clean o 
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
group by o.Customer_ID,o.Order_ID)
select 
	Customer_ID,
    count(Order_ID) as Total_Orders,
    round(Avg(Order_Value),2) as Avg_Order_Value
from Customer_Orders
group by Customer_ID order by Avg_Order_Value desc;

--- 9.17 Highest Revenue Category
with Category_Revenue as (
select 
	p.Category,
    sum(oi.Line_Total) as Revenue
from product_clean p 
join order_items_clean oi
	on p.Product_ID = oi.Product_ID
group by p.Category)
select
	Category,
    round(Revenue,2) as Revenue
from Category_Revenue
where Revenue = ( select max(Revenue)from Category_Revenue);

--- 9.18 product with sales but low inventory
with Product_Sales as (
select 
	Product_ID,
    sum(Quantity) as Unit_Sold
from order_items_clean 
group by Product_ID),
Product_Inventory as (
select 
	Product_ID,
    sum(Stock_Quantity) as Stock
from inventory_clean	 
group by Product_ID)
select 
	p.Product_ID,p.Product_Name,
    coalesce(ps.Unit_Sold,0) as Units_Sold,
    coalesce(pi.Stock,0) as Current_Stock,
    p.Reorder_Level
from product_clean p 
left join Product_Sales ps
	on p.Product_ID = ps.Product_ID
left join Product_Inventory pi
	on p.Product_ID = pi.Product_ID
where coalesce(ps.Unit_Sold,0)>0 and coalesce(pi.Stock,0)<p.Reorder_Level
order by Units_Sold;

--- 9.19 Yearly Growth Revenue
with Yearly_Revenue as (
select 
	year(o.Order_Date) as Year,
    sum(oi.Line_Total) as Revenue
from order_clean o 
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
where o.Order_Date is not null group by year(o.Order_Date)),
Growth as (
select 
	Year,
    Revenue,
    lag(Revenue) over(order by Year) as Previous_Year_Revenue
from Yearly_Revenue)
select 
	Year,
    round(Revenue,2) as Revenue,
    round(Previous_Year_Revenue,2) as Previous_Year_Revenue,
    round((Revenue - Previous_Year_Revenue) * 100.0 / nullif(Previous_Year_Revenue,0),2) as `Year Over Year Growth Percent`
from Growth order by Year;

--- 9.20 Customer Segmentation 
with Customer_Seg as (
select 
	c.Customer_ID,c.Customer_Name,
    count(distinct o.Order_ID) as Total_Order,
    sum(oi.Line_Total) as Revenue
from customer_clean c 
join order_clean o 
	on c.Customer_ID = o.Customer_ID
join order_items_clean oi
	on o.Order_ID = oi.Order_ID
group by c.Customer_ID,c.Customer_Name)
select 
	Customer_ID,
    Customer_Name,
    Total_Order,
    round(Revenue,2) as Revenue,
    case
		when Revenue >= 100000 then 'High Value'
        when Revenue >= 50000 then 'Medium Value'
        else 'Low Value'
	end as Customer_Segment
from Customer_Seg order by Revenue desc;


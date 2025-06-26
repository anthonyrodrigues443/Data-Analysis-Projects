-- drop database dmart_sales;
-- create database dmart_sales;
use dmart_sales;

create table SALES(
OrderID varchar(100) primary key,
CustomerName varchar(100),
Category varchar(100),
SubCategory varchar(100),
City varchar(100),
OrderDate date,
Region varchar(100),
Sales int,
Discount float(5),
Profit float,
State varchar(100),
OrderDay int,
OrderMonth varchar(20),
OrderYear int,
OrderQuarter varchar(10),
`10-DayPeriod` varchar(20),
Week_of_the_Month varchar(10),
City_State varchar(50),
DayName	varchar(10),
DayType varchar(10)
);

show tables;

select * from SALES;

drop table if exists CategoryOrders_Summary;
create table CategoryOrders_Summary as 
select category, subcategory, count(OrderID) as Orders_Count, sum(Sales) 
from SALES group by Category, SubCategory;


select *  from CategoryOrders_Summary;
select Category, count(Category) as Products_in_SubCategory,
 sum(Orders_Count) as Total_Orders, sum(Orders_Count)/count(Category)  as Average_Sales_per_SubCategory
 from CategoryOrders_Summary group by Category;

alter table Sales add correct_region varchar(50);

select * from SALES;

update SALES
set correct_region = case
    when City in ('Dharmapuri', 'Krishnagiri', 'Vellore') then 'North'
	when City in ('Ramanadhapuram', 'Nagercoil', 'Tenkasi', 'Kanyakumari', 'Tirunelveli') then 'South'
	when City in ('Viluppuram', 'Chennai') then 'East'
	when City in ('Cumbum', 'Theni', 'Ooty', 'Coimbatore') then 'West'
	when City in ('Trichy', 'Pudukottai', 'Salem', 'Dindigul', 'Virudhunagar', 'Karur', 'Bodi', 'Namakkal', 'Madurai', 'Perambalur') then 'Central'
    else 'Unknown'
end;

select distinct city from SALES where city = 'Unknown';

drop table if exists region_sales_summary;

create table region_sales_summary as  select correct_region, city as Cities, count(OrderID) as TotalOrders, sum(Sales) as TotalSales, 
sum(Profit) as TotalProfit , avg(Discount) as Average_Discount from SALES group by correct_region, city order by correct_region;

select * from region_sales_summary;

select correct_region, Cities from region_sales_summary;

select correct_region, count(correct_region) as cities_in_region, sum(TotalOrders) as TotalOrders, sum(TotalSales) as TotalSales,
 sum(TotalProfit) as TotalProfit,
sum(TotalOrders)/count(correct_region) as Avg_Orders_per_City,
sum(TotalSales)/count(correct_region) as Avg_Sales_per_City, 
sum(TotalProfit)/count(correct_region) as Avg_Profit_per_City, 
sum(Average_Discount)/count(correct_region) as Avg_Discount_per_city
from region_sales_summary group by correct_region order by TotalSales;


select * from region_sales_summary ;

select count(Cities) as Total_Cities, sum(TotalSales) as Total_Sales, sum(TotalOrders) as Total_Orders,
 sum(TotalProfit) as Total_Profit,
sum(TotalSales)/count(Cities)  as Avg_Sales_growth_per_city,  sum(TotalOrders)/count(Cities) as Avg_Orders_growth_per_city,
 sum(TotalProfit)/count(Cities) as Avg_Profit_growth_per_city
from region_sales_summary ;


select * from Sales;

drop table if exists Dayname_Orders_summary;
create table Dayname_Orders_summary as 
select DayName, DayType, count(OrderID) as Orders
from Sales group by dayname, daytype;

select * from Dayname_Orders_summary;

select DayType, count(dayname) as Days, sum(Orders) as Total_Orders,
(sum(Orders)/count(dayname)) as Average_Orders_Per_Day_of_Daytype
 from Dayname_Orders_summary group by daytype ;


create table Discount_Details as select OrderID, round(1-Discount, 2) as Revenue_Retention_Rate, Sales/(1-Discount) as Original_Price,
(Sales/(1-Discount)-Sales) as Discount_Amount  from SALES ;

select * from Discount_Details;

select * from sales;

-- Time Period Analysis
WITH RankedSubCategories AS (
    SELECT 
        SALES.OrderYear, 
        SALES.Category, 
        SALES.SubCategory, 
        COUNT(SALES.OrderID) as Order_Count,
        SUM(SALES.Sales) as Total_Sales, 
        SUM(SALES.Profit) as Total_Profit, 
        SUM(Discount_Details.Discount_Amount) as Total_Discount,
        ROW_NUMBER() OVER (PARTITION BY SALES.OrderYear ORDER BY SUM(SALES.Sales) DESC) as rank_num
    FROM SALES 
    JOIN Discount_Details ON SALES.OrderID = Discount_Details.OrderID
    GROUP BY SALES.OrderYear, SALES.Category, SALES.SubCategory
)
SELECT 
    OrderYear, 
    Category,
    SubCategory, 
    Order_Count,
    Total_Sales, 
    Total_Profit, 
    Total_Discount
FROM RankedSubCategories
WHERE rank_num <= 3
ORDER BY OrderYear, rank_num desc;


Select Category, count(SALES.OrderID) as Orders, sum(Sales) as Total_Sales, sum(Profit) as Total_Profit, sum(Discount_Amount)
from SALES join Discount_Details on SALES.OrderID = Discount_Details.OrderID group by Category order by Orders desc limit 3;

Select Category, SubCategory, count(SALES.OrderID) as Orders, sum(Sales) as Total_Sales, sum(Profit) as Total_Profit, 
sum(Discount_Amount) as Total_Discount
from SALES join Discount_Details on SALES.OrderID = Discount_Details.OrderID group by Category, SubCategory order by Orders desc limit 3;


select * from categoryorders_summary;
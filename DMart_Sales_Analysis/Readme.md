
# DMart Sales Analysis Project - Tamil Nadu

## 📊 Project Overview

This comprehensive data analytics project analyzes DMart grocery sales data for Tamil Nadu from 2015-2018, utilizing SQL for data processing and Power BI for advanced visualization and business intelligence. The project delivers actionable insights for regional expansion, inventory management, and profit optimization strategies.

## 📁 Dataset Information

**Source**: Kaggle  
**Dataset**: DMart Grocery Sales  
**Link**: [https://www.kaggle.com/datasets/nikolaireeds/dmart-grocery-sales](https://www.kaggle.com/datasets/nikolaireeds/dmart-grocery-sales)

**Key Metrics**:
- **Total Sales**: ₹14.96M
- **Total Profit**: ₹3.75M
- **Total Orders**: 9.99K
- **Profit Margin**: 25.05%
- **Sales CAGR**: 18.71%
- **Analysis Period**: 2015-2018

## 🛠️ Technical Stack

- **Database**: MySQL (Data Processing & Transformation)
- **Visualization**: Power BI Desktop
- **Data Import**: MySQL Table Data Import Wizard
- **Analytics**: SQL Queries, DAX Measures, Advanced Visualizations

## 🔧 SQL Data Processing & Table Creation

### Core Sales Table Structure
```sql
create table SALES(
    OrderID varchar(100) primary key,
    CustomerName varchar(100),
    Category varchar(100),
    SubCategory varchar(100),
    City varchar(100),
    OrderDate date,
    Region varchar(100),
    Sales int,
    Discount decimal(5,2),
    Profit float,
    State varchar(100),
    OrderDay int,
    OrderMonth int,
    OrderYear int,
    OrderQuarter varchar(10),
    `10-DayPeriod` varchar(20),
    Week_of_the_Month varchar(10),
    City_State varchar(50),
    DayName varchar(10),
    DayType varchar(10)
);
```

### Regional Classification Logic
```sql
-- Added corrected regional mapping for Tamil Nadu cities
alter table Sales add correct_region varchar(50);

update SALES
set correct_region = case
    when City in ('Dharmapuri', 'Krishnagiri', 'Vellore') then 'North'
    when City in ('Ramanadhapuram', 'Nagercoil', 'Tenkasi', 'Kanyakumari', 'Tirunelveli') then 'South'
    when City in ('Viluppuram', 'Chennai') then 'East'
    when City in ('Cumbum', 'Theni', 'Ooty', 'Coimbatore') then 'West'
    when City in ('Trichy', 'Pudukottai', 'Salem', 'Dindigul', 'Virudhunagar', 'Karur', 'Bodi', 'Namakkal', 'Madurai', 'Perambalur') then 'Central'
    else 'Unknown'
end;
```

### Advanced Analytics Tables

**Regional Performance Analysis**
```sql
create table Region_Sales_Analysis as  
select correct_region, city as Cities, count(OrderID) as TotalOrders, sum(Sales) as TotalSales, 
sum(Profit) as TotalProfit, avg(Discount) as Average_Discount 
from SALES group by correct_region, city order by correct_region;
```

**Category Performance Metrics**
```sql
create table CategoryOrders_Analysis as 
select category, subcategory, count(OrderID) as Order_Count, sum(Sales) as Total_Sales
from SALES group by Category, SubCategory;
```

**Financial Impact Analysis**
```sql
create table Discount_details as 
select OrderID, Sales, Profit, Discount, round(1-Discount, 2) as Revenue_retention_rate,  
round(sales + (Discount * Sales)/round(1-Discount, 2),2) as Original_Price,
round((Discount * Sales)/round(1-Discount, 2), 2) as Discount_Amount  
from Sales;
```

## 📈 Power BI Dashboard Features

### 1. **Executive Summary Dashboard**
- Total Sales: ₹14.96M with 25.05% profit margin
- Sales Timeline visualization (2015-2018)
- Regional performance with interactive maps
- Category performance metrics

### 2. **Time Series Analysis**
- Quarterly sales trends showing Q4 peak performance
- Monthly sales patterns highlighting seasonal variations
- Weekend vs Weekday analysis revealing 36% higher weekend orders
- Week-of-month analysis showing month-end surge

### 3. **Regional Intelligence**
- **Central Region**: 41.58% of total sales (₹6.2M) across 10 cities
- **South Region**: 21.37% of total sales (₹3.2M) across 5 cities
- **West Region**: 16.31% of total sales (₹2.4M) across 3 cities
- **North Region**: 12.61% of total sales (₹1.9M) across 4 cities
- **East Region**: 8.13% of total sales (₹1.2M) across 2 cities

### 4. **Category Performance Analysis**
- **Beverages**: Leading category with 700 average orders per sub-category
- **Food Grains**: 504.67 average orders per sub-category
- **Oil & Masala**: 471 average orders per sub-category
- Top performing sub-categories: Health Drinks, Soft Drinks, Breads & Buns

### 5. **Discount Strategy Analysis**
- Optimal discount range: ₹200-250 for maximum sales volume (₹800K+)
- High-value discounts (₹1000+) generate highest profit margins (₹600+ average profit)
- Correlation analysis between discount percentage and sales impact

## 🎯 Key Business Insights

### 🔄 Seasonal & Operational Insights
- **Q4 Peak Planning**: Sales increase by 40%+ in Q4 (Sep-Dec), requiring inventory buildup by August
- **Weekend Staffing**: Weekend orders average 1.7K vs 1.3K weekdays (36% increase)
- **Month-End Surge**: Week 4 sales spike to ₹1M+ vs ₹350K in other weeks

### 📍 Regional Growth Opportunities
- **Central Region Dominance**: 41.58% market share concentrated in 10 cities
- **City Expansion Strategy**: Each new city adds approximately ₹620K revenue potential
- **Geographic Distribution**: More cities per region correlate with higher total sales

### 💰 Profit Optimization Insights
- **Discount Sweet Spot**: ₹200-250 range drives peak sales volume
- **Counter-intuitive Finding**: High discounts (₹1000+) yield highest profit margins
- **Category Leadership**: Beverages consistently outperform across all years

### 📊 Category Performance Drivers
- **Beverage Dominance**: Health drinks and soft drinks in top 3 sub-categories (2015-2018)
- **Consistent Growth**: Beverage category shows sustained performance over 4-year period
- **Portfolio Diversity**: 23 sub-categories across 7 main categories

## 🎯 Strategic Recommendations

### 1. **Regional Expansion Strategy**
- **Immediate Action**: Add 3-5 new cities in Central region to unlock ₹3M+ revenue potential
- **Secondary Focus**: Expand North and West regions with 2-3 cities each
- **Market Penetration**: Target underserved areas with high population density

### 2. **Inventory Optimization**
- **Seasonal Planning**: Increase inventory by 40% before Q4 to capture peak demand
- **Category Focus**: Prioritize beverage inventory given consistent 4-year growth
- **Month-End Preparation**: Boost stock levels for week 4 demand surge

### 3. **Pricing & Promotion Strategy**
- **Volume Strategy**: Use ₹200-250 discount range for sales volume maximization
- **Profit Strategy**: Implement ₹500+ discounts for higher margin products
- **Timing Optimization**: Align major promotions with salary cycles and month-end periods

### 4. **Operational Excellence**
- **Weekend Scaling**: Increase staff allocation by 35% on weekends
- **Supply Chain**: Establish regional distribution centers in high-performing areas
- **Customer Experience**: Focus on beverage category expansion and innovation

## 📊 Project Deliverables

1. **SQL Database**: Comprehensive data warehouse with 5 analytical tables
2. **Power BI Dashboard**: Interactive 6-page business intelligence report
3. **Business Insights**: Actionable recommendations for growth and optimization
4. **Data Documentation**: Complete technical and business documentation

## 🚀 Business Impact

- **Revenue Growth Potential**: ₹3M+ through strategic expansion
- **Operational Efficiency**: 35% improvement in weekend resource allocation
- **Profit Optimization**: Dual-strategy approach for volume and margin enhancement
- **Market Intelligence**: Data-driven insights for competitive advantage

---

*This project demonstrates end-to-end business analytics capabilities, from SQL data processing to advanced Power BI visualization, delivering actionable insights for retail business growth.*

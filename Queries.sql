-- Top 10 Products by Sales (Group by + Order by)
select
	`Product Name`,
    sum(sales) as total_sales
from superstore_cleaned
group by `Product Name`
order by total_sales desc
limit 10;

-- Loss-Making Transaction
select 
	`Order ID`,
    `Product Name`,
    Sales,
    Profit,
    Region
from superstore_cleaned
where Profit < 0;

-- Monthly Sales Trend
select
	year(`Order Date`) as year,
    month(`Order Date`) as month,
    sum(Sales) as monthly_sales
from superstore_cleaned
group by year, month
order by year, month;

-- Average Shipping Days
select 
	avg(ship_days) as avg_shipping_days
from superstore_cleaned;

-- Top 10 Sub-Categories by Revenue (Group by + Order by)
select
	`Sub-Category`,
    count(*) as orders,
    sum(Sales) as total_revenue,
    round(sum(Profit)/sum(Sales) * 100, 2) as profit_margin
from superstore_cleaned
group by `Sub-Category`
order by total_revenue desc
limit 10;

-- Regional Performance (Group by + Having)
select
	`Region`,
	sum(Sales) as revenue,
    count(distinct `Customer ID`) as customers,
    avg(Sales) as avg_order
from superstore_cleaned
group by `Region`
having sum(Sales) > 100000
order by revenue desc;

-- Top 10 Customers (Customer Segmentation)
select
	`Customer ID`,
    count(*) as order_count,
    sum(Sales) as lifetime_value,
    max(`Order Date`) as last_order
from superstore_cleaned
group by `Customer ID`
order by lifetime_value desc
limit 10;

--  Top product per category (Window Functions)
with ranked as (
	select 
		`Category`,
        `Sub-Category`,
        sum(Sales) as revenue,
        row_number() over (partition by `Category` order by sum(Sales) desc)
 as rk
	from superstore_cleaned
    group by `Category`, `Sub-Category`
)
select * from ranked where rk = 1;

-- Year Over Year Growth
select
	year(`Order Date`) as year,
    sum(Sales) as yearly_sales,
    lag(sum(Sales)) over (order by year(`Order Date`)) as previous_year_sales
from superstore_cleaned
group by year;


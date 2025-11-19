SELECT * FROM zepto_sql_project.zepto;

# Data Exploration

# --- count of rows
select count(*) from zepto;

#-- sample data
select * from zepto
limit 10;

# --Null Values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
discountedsellingprice is null
or
weightingms is null
or
availablequantity is null
or
outofstock is null
or
quantity is null;

-- different product categories
select distinct category
from zepto
order by category;

#--products in stock vs out of stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

# --product names present multiple times
select name , count(sku_id) as "Number of skus"
from zepto 
group by name
having count(sku_id) >1
order by count(sku_id) desc;

#data cleaning

#--products with price = 0
select * from zepto 
where mrp = 0  or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;

DELETE from zepto 
WHERE mrp =0;

#--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp, discountedsellingprice from zepto;

#------ Business Insights Questions -------

#Q1 - Find the top 10 best value products based on the discount percentage

#This is useful for both, customers looking for bargain and the businesses to know which products are heavily promoted

select name,mrp,discountpercent
from zepto
order by discountPercent desc
limit 10;

SELECT distinct name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp>300
ORDER BY mrp DESC;

#Q3.Calculate Estimated Revenue for each category

select category, sum(discountedSellingPrice * availableQuantity) as total_revenue	
from zepto
group by category
order by total_revenue;

#Q4. Find all products where MRP is greater than rs 500 and discount is less than 10%

#this are not premium products so the reason they dont have any discounts because this items are popular enough and they already sell well without any discount

select distinct name, mrp, discountpercent
from zepto
where mrp > 500 and discountpercent <10
order by mrp desc , discountPercent desc;

# Q5 identify the top 5 categories offering the highest average discount percentage

select category, round(avg(discountpercent),2) as avg_discount
from zepto
group by Category
order by avg_discount desc	
limit 5;

#Q6- Find the price per gram for products above 100g and sort by best value

# It is helpful for customers comparing money for products and even for internal pricing strategies

select distinct name, weightInGms, discountedsellingprice,
round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

# Q7- Group the products into categories  like low, medium, bulk(based on their weightingms)

# this kind of segmentation is helpful for packaging, delievery planning and even for bulk order strategy
select distinct name,weightingms,
case when weightingms <1000 then 'Low'
	 when weightingms <5000 then 'Medium'
     else 'Bulk'
	end as weight_category
from zepto;

#Q8 What is the Total Inventory Weight Per Category

#This is great for warehouse planning and indetify bulky products category

select category,sum(weightingms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;
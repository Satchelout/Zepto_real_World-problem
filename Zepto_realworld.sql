drop table if exists store;

create table zepto(
sku_id serial primary key,
Category varchar (120),
name varchar(50) Not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric (8,2),
weightInGms integer,
outOfStock BOOLEAN,
quantity Integer

);


--data exploration--
select count (*) from zepto;

--data view with 10 rows
select * from zepto limit 10;

--check null values
select * from zepto where name is null
Or
Category is null
Or
mrp is null
Or
discountPercent is null
Or
availableQuantity is null
Or
discountedSellingPrice is null
Or
weightInGms is null
Or
outOfStock is null
Or
quantity is null
;


--diff product catogary
select distinct category
from zepto
order by category;

--products in stock vs outof stock
select outOfStock ,count(sku_id)
from zepto
group by outOfStock;

--product names present multiple time
select name,count(sku_id) as "Number of skus"
from zepto
group by name 
having count(sku_id)>1
order by count(sku_id) desc;

-- data cleaning




--products with price ==0
select * from zepto where mrp=0 
or
discountedSellingPrice =0;

delete from zepto where mrp=0;

--convert data
update zepto set mrp=mrp/100.0,
discountedSellingPrice =  discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from Zepto limit 10;

---Buisness Inside Quesries
select distinct name, mrp ,discountPercent
from zepto
order by discountPercent desc
limit 10;

select distinct name,mrp from zepto
where mrp>300 
and outOfStock=True
order by mrp desc;

---total revenue for each category
select Category,
sum(discountedSellingPrice * availableQuantity ) as total_revenue
from zepto
group by category
order by total_revenue;

select distinct name ,mrp,discountPercent 
from zepto
where mrp>500 and discountPercent <10
order by mrp desc,discountPercent desc;

select category,
round(avg(discountPercent),2)as AVG_Discount
from zepto
group by category
order by AVG_Discount desc
limit 5;

select distinct name,weightInGms,discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >=100
order by price_per_gram;

select distinct name,weightInGms,
case when weightInGms <1000 then 'low'
	when weightInGms<5000 then 'medium'
	else 'Bulk'
	end as Weight_category
from zepto;

select category ,
sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;

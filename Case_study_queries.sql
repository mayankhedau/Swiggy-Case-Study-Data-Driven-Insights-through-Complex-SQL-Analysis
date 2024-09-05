--1. Merge the relevant columns in the dataset to form a combined dataset.
--Ans. 
select sr.r_name, so.*, sod.f_id, sf.f_name, sf.type, su.name
from `swiggy-schema — orders` so
join `swiggy-schema — restaurants` sr
on sr.r_id = so.r_id
join `swiggy-schema — order_details` sod on
so.order_id= sod.order_id
join `swiggy-schema — food` sf
on sf.f_id = sod.f_id
right join `swiggy-schema — users` su
on su.user_id = so.user_id;

--2.Which restaurant has got the most number of orders?
--Ans.
SELECT r_name, count(r_name) as RestaurantsCount
from `swiggy_dataset_complete`
where r_name is not null
group by r_name
order by RestaurantsCount desc;
--KFC restaurant has got the most number of orders.

--3. Which restaurant has done the most amount of orders?
--Ans.
SELECT r_name, amount
from `swiggy_dataset_complete`
where r_name is not null
group by r_name
order by amount desc;

--4. Find the customers who have never ordered.
--Ans.
SELECT user_id, name from `swiggy-schema — users` su
where not exists (SELECT * FROM `swiggy-schema — orders` so where su.user_id = so.user_id);
--Among the 7 customers, Anupama and Risabh have never ordered.

--5. Find the month-wise number of orders.
--Ans.
select Month, count(*) as TotalMonths from `swiggy_dataset_complete`
where Month is not null
group by month
order by TotalMonths desc;
--July has got the most number of orders across the three months.

--6. Among all the restaurants, among veg and non-veg types of pizzas which is preferred more?
--Ans.
select type, count(*) as TotalTypes from `swiggy_dataset_complete`
where type is not null
group by type
order by TotalTypes desc;

--7. Which food item has been ordered the most across all restaurants?
--Ans.
select f_name, count(*) as TotalFoodItems from `swiggy_dataset_complete`
where f_name is not null
group by f_name
order by TotalFoodItems desc;
--Choco Lava Cake has been ordered the most among all food items.

--8.Find the food item under each restaurant whose amount is the highest.
--Ans.
SELECT r_name, f_name, amount,
first_value(f_name) over(partition by r_name order by amount desc)
from `swiggy_dataset_complete`;
--box8: Rice Meal
--China Town: Schezwan Noodles
--dominos: Non-veg Pizza
--Dosa Plaza: Schezwan Noodles
--KFC: Choco Lava Cake

--9.  Find a loyal customer for each restaurant.
--Ans.
with temp as
(select r_id,user_id,count(*) as visits from `swiggy-schema — orders` o
group by r_id,user_id
order by r_id,user_id
)
select r_name, name as ‘loyal customer’, visits from temp t1
join `swiggy-schema — restaurants` r
on r.r_id = t1.r_id
join `swiggy-schema — users` u
on u.user_id = t1.user_id
where visits = (select max(visits) from temp t2 where t1.r_id = t2.r_id);

--10. Find the users and the food item they purchased the most.
--Ans.
with temp as
(select user_id,f_id,count(*)as freq from `swiggy-schema — orders` o
join `swiggy-schema — order_details` od
on od.order_id = o.order_id
group by user_id,f_id)
select name,f_name,freq from temp t1
join `swiggy-schema — food` f
on f.f_id = t1.f_id
join `swiggy-schema — users` u
on u.user_id = t1.user_id
where t1.freq = (select max(freq) from temp t2 where t2.user_id = t1.user_id)



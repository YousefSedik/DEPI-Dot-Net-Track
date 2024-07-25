-- List all products with their respective categories and brands
select prod.*, br.brand_name, cat.category_name
from production.products prod
join production.brands br on br.brand_id= prod.brand_id
join production.categories cat on cat.category_id= prod.category_id

-- Find the total quantity of each product sold.
select oi.product_id, sum(oi.quantity +sto.quantity) total_quantity
from sales.order_items oi 
join production.stocks sto on sto.product_id = oi.product_id
group by oi.product_id

-- Get the list of customers who have placed orders along with the store where they
-- placed the order
select cust.*, sto.*
from sales.orders ord
join sales.customers cust on ord.customer_id = cust.customer_id
join sales.stores sto on sto.store_id = ord.store_id

-- Find the total sales amount for each store.
select sto.store_name, sum(ord_ite.quantity*ord_ite.list_price) total_sales 
from sales.stores sto
join sales.orders ord on ord.store_id = sto.store_id
join sales.order_items ord_ite on ord.order_id = ord_ite .order_id 
group by sto.store_name

-- Retrieve the details of orders along with the customer name, store name, and the
-- staff who processed the order

select ord.*, (cust.first_name + ' ' + cust.last_name) as customer_full_name , (staff.first_name + ' ' + staff.last_name) as staff_full_name 
from sales.orders ord 
join sales.customers cust on cust.customer_id = ord.customer_id
join sales.stores stor on stor.store_id = ord.store_id 
join sales.staffs staff on staff.staff_id = ord.staff_id

-- Get the list of products that have never been ordered.
select prod.product_name
from production.products prod 
join sales.order_items oi on oi.product_id = prod.product_id
group by prod.product_name
having count(oi.product_id) = 0

--  Find the average price of products in each category.
select cat.category_id, avg(prod.list_price)
from production.products prod 
join production.categories cat on prod.category_id = cat.category_id
group by cat.category_id

-- List all products along with their current stock quantities
select prod.product_name, sum(store.quantity)
from production.products prod 
join production.stocks store on store.product_id = prod.product_id
group by prod.product_id, prod.product_name 

-- Find the number of orders placed by each customer
select cust.customer_id, count(ord.order_id) as no_orders
from sales.customers cust 
join sales.orders ord on ord.customer_id = cust.customer_id
group by cust.customer_id, cust.first_name, cust.last_name

-- Get the total number of distinct products sold by each store.
select sto.store_id,  count(distinct(pro.product_id))
from sales.stores sto
join sales.orders ord on ord.store_id = sto.store_id
join sales.order_items oi on ord.order_id = oi.product_id 
join production.products pro on oi.product_id = pro.product_id
group by sto.store_id


-- Questions Using LEFT JOIN


-- List all products along with their categories. Include products that do not belong to
-- any category.

select pro.product_name, cat.category_name
from production.products pro
left outer join production.categories cat on cat.category_id = pro.category_id or cat.category_id is null

--2. Find the total quantity of each product sold. Include products that have never been
--sold.

select pro.product_id, coalesce(sum(oi.quantity), 0)
from production.products pro
left outer join sales.order_items oi on pro.product_id = oi.product_id 
group by pro.product_id

--3. Retrieve the details of all orders along with the customer name. Include orders
--placed by customers who are not yet registered.

select  oi.*, cust.* 
from sales.orders ord
left join sales.order_items oi on ord.order_id = oi.order_id 
left join sales.customers cust on ord.customer_id = cust.customer_id


--4. List all staff members along with the store they are assigned to. Include staff
--members who are not currently assigned to any store.

select st.staff_id, sto.store_id as 'Works on store_id' 
from sales.staffs st
left join sales.stores sto 
on sto.store_id = st.store_id


--6. Get the list of all customers along with the total number of orders they have placed.
--Include customers who have not placed any orders.

select cus.customer_id, count(ord.order_id) count_orders 
from sales.customers cus
left join sales.orders ord
on ord.customer_id = cus.customer_id
group by cus.customer_id

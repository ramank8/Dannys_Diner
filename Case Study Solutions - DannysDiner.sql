1. What is the total amount each customer spent at the restaurant?

Select s.customer_id,sum(m.price) as 'Total Amount'
from sales as s
join menu as m
on s.product_id = m.product_id
group by 1;


2. How many days has each customer visited the restaurant?

Select customer_id,count(distinct order_date) as 'Number of Days'
from sales
group by 1;


3. What was the first item from the menu purchased by each customer?
with cte as
(Select *,min(order_date) as 'First Order'
from sales
group by 1)

Select cte.customer_id,m.product_name
from cte 
join menu as m
on cte.product_id = m.product_id


4. What is the most purchased item on the menu and how many times was it purchased by all customers?

Select m.product_name,count(s.product_id) as 'Count of Products'
from sales as s
join menu as m
on s.product_id = m.product_id
group by 1
order by 2 desc
limit 1;

5. Which item was the most popular for each customer?

with cte as
(Select s.customer_id as 'Customer_Id',m.product_name as'Product_Name',
rank() over(partition by customer_id order by count(s.product_id) desc) rank_
from sales as s
join menu as m
on s.product_id = m.product_id
group by 1,2)

Select Customer_Id,Product_Name 
from cte
where rank_ = 1


6. Which item was purchased first by the customer after they became a member?

with cte as
(Select s.customer_id as 'Customer_Id',m.product_name as 'Product_Name',
rank() over(partition by s.customer_id order by s.order_date) as rank_
from members as m1
join sales as s
on m1.customer_id = s.customer_id
join menu as m
on s.product_id = m.product_id
where s.order_date >= m1.join_date)

Select Customer_Id,Product_Name
from cte
where rank_ = 1;


7. Which item was purchased just before the customer became a member?

with cte as
(Select s.customer_id as 'Customer_Id',m.product_name as 'Product_Name',
rank() over(partition by s.customer_id order by s.order_date desc) as rank_
from members as m1
join sales as s
on m1.customer_id = s.customer_id
join menu as m
on s.product_id = m.product_id
where s.order_date < m1.join_date)

Select Customer_Id,Product_Name
from cte
where rank_ = 1;


8. What is the total items and amount spent for each member before they became a member?

Select s.customer_id as 'Customer_Id',
count(s.product_id) as 'Total Items',
sum(m.price) as 'Total Amount'
from members as m1
join sales as s
on m1.customer_id = s.customer_id
join menu as m
on s.product_id = m.product_id
where s.order_date < m1.join_date
group by 1
order by 3;


9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

Select 
s.customer_id as 'Customer Id',
sum(case when m.product_name = 'sushi' then (m.price * 20)
	else (m.price * 10)
end) as 'Total Points'
from sales as s
join menu as m
on s.product_id = m.product_id
group by 1



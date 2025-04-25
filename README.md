# Pizza Runner 

## Overview 
Something caught Danny's eye while scrolling through his Instagram feed.
'80s retro styling and Pizza is the future'.
This interested him but he needed funding to build his empire. 
How would Pizza help build the future he wanted ? He thought about it and came up with this genius idea.
He was going to uberize it - and that's how Pizza Runner came about. By recruiting runners to deliver fresh pizza from the pizza HQ to their houses. He paid developers to build an app that accepts orders from Customers.

### Objectives 
- Pizza Metrics
- Runner and customer experience
- Pricing and ratings
- Ingredient optimization 

## Dataset
The dataset for this project is sourced from [Danny Ma](https://www.linkedin.com/in/datawithdanny)# Pizza_runner_sql

## Tools Used
MYSQL for querying the database

## Database diagram 
Since Danny has a few years of experience as a Data Scientist,he has prepared for us a Database entity relationship diagram;
![Diagram](https://github.com/Ifeoma28/Pizza_runner_sql/blob/bf6ddb24395b437aecd3a54a039f8186225a9683/Screenshot_20250304-111053_Chrome.jpg)

## Business Questions and solutions 
### Pizza Metrics 
- How many pizzas were ordered?
```
SELECT COUNT(*) AS orders
FROM pizza_runner.customer_orders;
```
- How many unique customer orders were made?
```
SELECT COUNT(*) FROM (SELECT DISTINCT (customer_id)
FROM customer_orders) AS distinct_customer_orders;
```

- How many successful orders were delivered by each runner?
```
SELECT runner_orders.runner_id,COUNT(runner_orders.order_id) AS orders
FROM runner_orders
INNER JOIN runners ON
runner_orders.runner_id = runners.runner_id
WHERE cancellation = 'none'
GROUP BY runner_orders.runner_id
ORDER BY runners.runner_id;
```
- How many of each type of pizza was delivered?
```
SELECT pizza_name, COUNT(*) AS category_count FROM
(SELECT pizza_names.pizza_name,runner_orders.order_id,runner_orders.cancellation
FROM runner_orders
INNER JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
INNER JOIN pizza_names ON
(runner_orders.order_id = customer_orders.order_id AND pizza_names.pizza_id = customer_orders.pizza_id)
WHERE cancellation = 'none'
ORDER BY runner_orders.order_id) AS successful_orders
GROUP BY pizza_name;
```
- How many Vegetarian and Meatlovers were ordered by each customer?
For meatlovers, we have :
```
SELECT customer_orders.customer_id,COUNT(customer_orders.order_id) AS meatlover_pizza
FROM customer_orders
 WHERE pizza_id = 1
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;
```
For vegetarian we have :
```
SELECT customer_orders.customer_id,COUNT(customer_orders.order_id) AS vegetarian_pizza
FROM customer_orders
 WHERE pizza_id = 2
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;
```
- What was the maximum number of pizzas delivered in a single order?
```
SELECT MAX(no_of_pizza) FROM 
(SELECT customer_orders.order_id,COUNT(customer_orders.order_id) AS no_of_pizza,runner_orders.pickup_time
FROM customer_orders
INNER JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
WHERE cancellation = 'none'
GROUP BY customer_orders.order_id,runner_orders.pickup_time) AS delivered_orders;
```
- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```
SELECT SUM(orders) AS total_no_of_orders FROM 
(SELECT customer_orders.customer_id,runner_orders.cancellation,COUNT( runner_orders.order_id) AS orders
FROM runner_orders
INNER JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
WHERE cancellation = 'none' 
AND (customer_orders.exclusions >= 1
 OR customer_orders.extras >= 1)
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id) AS atleast_onechange;
```
The orders that had no changes :
```
SELECT SUM(orders) AS no_change_orders FROM
(SELECT customer_orders.customer_id,runner_orders.cancellation,COUNT( runner_orders.order_id) AS orders
FROM runner_orders
LEFT JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
WHERE cancellation = 'none' 
AND (customer_orders.exclusions = ''
AND
 customer_orders.extras = '')
GROUP BY customer_orders.customer_id,runner_orders.cancellation
ORDER BY customer_orders.customer_id) AS no_changes;
```
- How many pizzas were delivered that had both exclusions and extras?
```
SELECT customer_orders.customer_id,runner_orders.cancellation,COUNT( runner_orders.order_id) AS orders
FROM runner_orders
INNER JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
WHERE cancellation = 'none' 
AND (customer_orders.exclusions <> ''
 AND customer_orders.extras <> '')
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;
```

- What was the total volume of pizzas ordered for each hour of the day?
```
SELECT COUNT(*) AS total_orders,HOUR(order_time)
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);
```
- What was the volume of orders for each day of the week?
```
SELECT COUNT(*) AS orders,DAYNAME(order_time) AS Day
FROM customer_orders
GROUP BY DAYNAME(order_time);
```
### Runner and Customer experience 
- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```
SELECT week_no,runners FROM
	(SELECT EXTRACT(week FROM registration_date) AS week_no ,
		COUNT(runner_id) AS runners
			FROM runners 
				GROUP BY week_no) AS week_period
WHERE week_no >= 1 ;
```
- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
first we had to change the datatype
```
SELECT 
 CAST(pickup_time AS datetime)
FROM runner_orders
WHERE pickup_time <> 'null';
```
Then the average time is ;
```
SELECT runner_orders.runner_id, AVG(minute(timediff(pickup_time,order_time))) AS avg_time_diff_mins
FROM runner_orders
INNER JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
WHERE pickup_time <> 'null'
GROUP BY runner_id;
```
- Is there any relationship between the number of pizzas and how long the order takes to prepare?
```
SELECT pizza_no, AVG(max_prep_time)
	FROM
		(SELECT customer_orders.order_id,COUNT(pizza_id) AS pizza_no,MAX(minute(timediff(pickup_time,order_time))) AS max_prep_time
		FROM customer_orders
		INNER JOIN runner_orders ON
		customer_orders.order_id = runner_orders.order_id
        WHERE cancellation = 'none'
		GROUP BY order_id) AS prep_table
        GROUP BY pizza_no;
```
there is a relationship, the more the order, the longer it takes

- What was the average distance travelled for each customer?
```
SELECT customer_orders.customer_id,ROUND(AVG(runner_orders.distance),2) AS average_distance
FROM customer_orders
LEFT JOIN runner_orders ON 
customer_orders.order_id = runner_orders.order_id
GROUP BY customer_orders.customer_id;
```
- What was the difference between the longest and shortest delivery times for all orders?
```
SELECT (MAX(duration) - MIN(duration))
FROM runner_orders
;
```
the longest delivery time is 40mins and shortest is 10mins

- What was the average speed for each runner for each delivery ?
```
SELECT runner_id,order_id,AVG(distance/duration) AS average_speed_km_per_min
FROM runner_orders
WHERE cancellation = 'none'
GROUP BY 1,2
ORDER BY 1;
```

- What is the successful delivery percentage for each runner?
```
SELECT runner_id, SUM(CASE 
	WHEN pickup_time ='null' THEN 0
    ELSE 1
    END )/COUNT(order_id) AS successful_orders_percentge
FROM runner_orders
GROUP BY runner_id;
```
### Pricing and Ratings 
- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
```
SELECT SUM(price) FROM
 (SELECT *,
 CASE 
	WHEN pizza_id = 1 THEN '12'
	WHEN pizza_id = 2 THEN '10'
    ELSE null
    END AS price
FROM customer_orders) AS pizza_price;
```
Therefore, Pizza Runner has made $160 so far.
  
- What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
```
SELECT SUM(price) FROM
	(SELECT 
	CASE 
		WHEN pizza_id = 1 AND first_extra + second_extra = 2 THEN 12+2
		WHEN pizza_id = 2 AND first_extra + second_extra  = 2 THEN 10+2
		WHEN pizza_id = 1 AND first_extra + second_extra = 1 THEN 12+1
		WHEN pizza_id = 2 AND first_extra + second_extra = 1 THEN 10+1
		WHEN pizza_id = 1 AND first_extra + second_extra = 0 THEN 12
		WHEN pizza_id = 2 AND first_extra + second_extra = 0 THEN 10
		END AS price
	FROM (SELECT *,length(substr(extras,1,1)) AS first_extra, length(substr(extras,3,1)) AS second_extra 
				FROM customer_orders) AS extras_price) AS extras_price_table;
```
So it has a total of $166 if it charges $1 for any extra

- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
```
CREATE TABLE ratings(customer_id INT,pizza_rating INT);


INSERT INTO ratings(customer_id,pizza_rating)
VALUES
('101', '1'), 
('102', '3'),
('103', '1'),
('104', '4'),
('105', '3' )
;
SELECT *
FROM ratings;
```
to find a rating, i had to check the order duration for each customer
```
SELECT customer_id,MAX(duration)
FROM customer_orders
INNER JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
WHERE duration IS NOT NULL
GROUP BY customer_id;
```
  
- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas

All the above columns are in ;
```
SELECT customer_orders.customer_id,runner_orders.order_id,runner_orders.runner_id,
ratings.pizza_rating,customer_orders.order_time,runner_orders.pickup_time
FROM customer_orders
LEFT JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
LEFT JOIN ratings ON
customer_orders.customer_id = ratings.customer_id
WHERE runner_orders.cancellation = 'none';
```
 timediff between pickup_time and order_time
 ```
SELECT customer_orders.customer_id,runner_orders.order_id,runner_orders.runner_id,
ratings.pizza_rating,customer_orders.order_time,runner_orders.pickup_time,TIMEDIFF(pickup_time,order_time)
FROM customer_orders
LEFT JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
LEFT JOIN ratings ON
customer_orders.customer_id = ratings.customer_id
WHERE runner_orders.cancellation = 'none';
```
Successful delivery duration
```
SELECT customer_orders.customer_id,runner_orders.order_id,runner_orders.runner_id,
ratings.pizza_rating,customer_orders.order_time,runner_orders.pickup_time,runner_orders.duration
FROM customer_orders
LEFT JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
LEFT JOIN ratings ON
customer_orders.customer_id = ratings.customer_id
WHERE runner_orders.duration IS NOT NULL;
```
Average speed
```
SELECT  customer_orders.customer_id,
ratings.pizza_rating,AVG(distance/duration) AS average_speed
FROM customer_orders
LEFT JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
LEFT JOIN ratings ON
customer_orders.customer_id = ratings.customer_id
WHERE runner_orders.duration IS NOT NULL
GROUP BY customer_id,pizza_rating;
```

- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
```
SELECT order_id,customer_id,price,runner_fee,(price-runner_fee) AS profit,SUM(price-runner_fee) OVER() AS total_profit
FROM 
	(SELECT customer_orders.order_id,customer_orders.customer_id,(0.30*distance) AS runner_fee,
		CASE 
		WHEN pizza_id = 1 THEN '12'
		WHEN pizza_id = 2 THEN '10'
		ELSE null
		END AS price
	FROM customer_orders
	INNER  JOIN runner_orders ON 
	customer_orders.order_id = runner_orders.order_id
	WHERE distance IS NOT NULL) AS price_table;
 ```
 therefore pizza runner made a total of $73.38 for all the orders after deducting the runner fee

### Ingredient optimization 
- What was the commonly added extra ?
```
SELECT *
 FROM customer_orders
 WHERE extras = 1;
```
The commonly added extra is Bacon
- What was the common exclusions ?
```
SELECT COUNT(*) FROM  (SELECT *
 FROM customer_orders
 WHERE exclusions <> '') AS exclusions_table
 WHERE exclusions = 4;
```
The common exclusion is Cheese
- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

## Findings 
- 14 pizzas were ordered and two of the customer orders were canceled.
- The ratio of Meatlovers to Vegetable pizza ordered is 3:1
- The maximum number of pizzas delivered in a single order is 3
- About six orders had at least one change (extras or exclusions)
- About four orders had no changes
- customers ordered the least number of pizza at the 11th and 19th hour of the day
- Fridays and Mondays were the busiest days because they had the highest number of sales
- Only one runner signed up for more than one week period
- Runner 2 took the longest time to pickup its orders from the HQ due to one of the customers making multiple orders
- We noticed the positive correlation between the number of pizza and how long it takes to prepare by checking the average max_prep_time
- Customer 105 had the longest distance from the HQ to his delivery location which is a good reason for having the least number of orders
- Runner 1 has the most successful delivery percentage with the lowest duration of 10mins despite delivering the highest number of successful orders
- The most commonly added extra is Bacon
- The most commonly exclusion is Cheese (it seems a lot of people want to cut down fat)
- 
- 
- 
- 

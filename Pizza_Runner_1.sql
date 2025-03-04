-- PIZZA METRICS

-- how many pizza were ordered
SELECT COUNT(*) AS orders
FROM pizza_runner.customer_orders;

-- how many unique customer orders were made
SELECT COUNT(*) FROM (SELECT DISTINCT (customer_id)
FROM customer_orders) AS distinct_customer_orders;

-- How many successful orders were delivered by each runner
SELECT runner_orders.runner_id,COUNT(runner_orders.order_id) AS orders
FROM runner_orders
INNER JOIN runners ON
runner_orders.runner_id = runners.runner_id
WHERE cancellation = 'none'
GROUP BY runner_orders.runner_id
ORDER BY runners.runner_id;

-- How many of each type of pizza was delivered 
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

-- the number of MeatLovers pizza ordered by each customer
SELECT customer_orders.customer_id,COUNT(customer_orders.order_id) AS meatlover_pizza
FROM customer_orders
 WHERE pizza_id = 1
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;

-- the number of vegetarian pizza ordered by each customer
SELECT customer_orders.customer_id,COUNT(customer_orders.order_id) AS vegetarian_pizza
FROM customer_orders
 WHERE pizza_id = 2
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;

-- what was the maximum number of pizzas delivered in a single order
SELECT MAX(no_of_pizza) FROM 
(SELECT customer_orders.order_id,COUNT(customer_orders.order_id) AS no_of_pizza,runner_orders.pickup_time
FROM customer_orders
INNER JOIN runner_orders ON
customer_orders.order_id = runner_orders.order_id
WHERE cancellation = 'none'
GROUP BY customer_orders.order_id,runner_orders.pickup_time) AS delivered_orders;

-- For each customer, how many delivered pizzas had at least 1 change
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

-- And how many had no changes
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

-- How many pizzas were delivered that had both exclusions and extras
SELECT customer_orders.customer_id,runner_orders.cancellation,COUNT( runner_orders.order_id) AS orders
FROM runner_orders
INNER JOIN customer_orders ON
runner_orders.order_id = customer_orders.order_id
WHERE cancellation = 'none' 
AND (customer_orders.exclusions <> ''
 AND customer_orders.extras <> '')
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;

-- What was the total volume of pizzas ordered for each hour of the day
SELECT COUNT(*) AS total_orders,HOUR(order_time)
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

-- what was the volume of orders for each day of the week
SELECT COUNT(*) AS orders,DAYNAME(order_time) AS Day
FROM customer_orders
GROUP BY DAYNAME(order_time);


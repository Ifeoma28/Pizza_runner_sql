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

## Database diagram 
Since Danny has a few years of experience as a Data Scientist,he has prepared for us a Database entity relationship diagram;
![Diagram](https://github.com/Ifeoma28/Pizza_runner_sql/blob/bf6ddb24395b437aecd3a54a039f8186225a9683/Screenshot_20250304-111053_Chrome.jpg)

## Business Questions and solutions 
### Pizza Metrics 
- How many pizzas were ordered?
  
- How many unique customer orders were made?
- How many successful orders were delivered by each runner?
- How many of each type of pizza was delivered?
- How many Vegetarian and Meatlovers were ordered by each customer?
- What was the maximum number of pizzas delivered in a single order?
- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
- How many pizzas were delivered that had both exclusions and extras?
- What was the total volume of pizzas ordered for each hour of the day?
- What was the volume of orders for each day of the week?

### Runner and Customer experience 
- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
- Is there any relationship between the number of pizzas and how long the order takes to prepare?
- What was the average distance travelled for each customer?
- What was the difference between the longest and shortest delivery times for all orders?
- What was the average speed for each runner for each delivery and do you notice any trend for these values?
- What is the successful delivery percentage for each runner?

### Pricing and Ratings 
- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
  
- What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra

- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
  
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

- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### Ingredient optimization 
- What was the commonly added extra ?
  
- What was the common exclusions ?
  
- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

## Findings 

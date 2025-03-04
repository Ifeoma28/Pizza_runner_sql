-- The process involved in cleaning the data
-- I did a lot of cleaning with the runner_orders table because it had a lot of null and inconsistent values

-- Trimming the distance to remove inconsistency 
-- UPDATE runner_orders
-- SET distance = TRIM(TRAILING 'km' FROM distance);

--   UPDATE runner_orders
--   SET duration = null
--  WHERE pickup_time = 'null';
  
--  UPDATE runner_orders
--   SET distance = null
--  WHERE pickup_time = 'null';
  
 -- UPDATE runner_orders
 --  SET cancellation = 'none'
 --  WHERE cancellation = 'null' OR cancellation = 'NULL';
  
  SELECT *
  FROM runner_orders;
  
  -- SELECT TRIM(TRAILING 'min' FROM duration)
-- FROM runner_orders;
-- trimming the duration column to remove inconsistency
-- UPDATE runner_orders
-- SET duration = TRIM(TRAILING 'mins' FROM duration);

-- UPDATE runner_orders
-- SET duration = TRIM(TRAILING 'minutes' FROM duration);

-- the duration column is in mins so i trimmed it to remove variables so i can 
-- change the data type to INT by setting the null values first to null
-- UPDATE runner_orders
 --  SET duration = null
 -- WHERE pickup_time = 'null';
  
--  UPDATE runner_orders
--   SET distance = null
--  WHERE pickup_time = 'null';

-- ALTER TABLE runner_orders
-- MODIFY COLUMN distance FLOAT;

-- ALTER TABLE runner_orders
-- MODIFY COLUMN duration INT;
 -- the extras and exclusions in the customer_orders had to be cleaned too
 
 -- UPDATE customer_orders
 -- SET extras = ''
 -- WHERE extras = 'null' OR extras ='NULL';
 -- Changing the pickup_time to datetime because we will calculating date differences
 -- UPDATE runner_orders
 -- SET pickup_time = CAST(pickup_time AS Datetime)
-- WHERE pickup_time <> 'null';
 
-- ### LIMIT
SELECT occured_at, account_id, channel
FROM web_events
LIMIT 15;

-- ### ORDER BY
SELECT *
FROM orders
ORDER BY occurred_at DESC
LIMIT 10;

-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- ### WHERE
SELECT *
FROM orders
WHERE account_id = 4251
ORDER BY occurred_at;

-- Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

-- Practice Question Using WHERE with Non-Numeric Data

-- Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-- ### Derived Columns
SELECT account_id, 
        occurred_at, 
        standard_qty, 
        gloss_qty, 
        poster_qty,
        gloss_qty + poster_qty AS nonstandard_qty
FROM orders;

SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

-- Questions using Arithmetic Operations

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.
SELECT  id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. You will learn later in the course how to fully handle this issue. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.
SELECT id, account_id,
        poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS poster_percent
FROM orders
LIMIT 10;

-- ### Introduction to Logical Operators

-- LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
-- IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
-- NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
-- AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
-- OR This allows you to combine operations where at least one of the combined conditions must be true.

SELECT *
From web_events_full
WHERE referrer_url LIKE '%google%';

-- Questions using the LIKE operator
-- Use the accounts table to find

-- All the companies whose names start with 'C'.
SELECT *
FROM accounts
WHERE name LIKE 'C%';

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name LIKE '%one%';

-- All companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%s';

-- ### IN 
SELECT *
FROM accounts
WHERE name IN ('Walmart', 'Apple');

SELECT *
FROM orders
WHERE account_id IN (1001, 1021);

-- Questions using IN operator

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

-- NOT
SELECT sales_rep_id, name
FROM accounts
WHERE sales_rep_id NOT IN (321500, 321570)
ORDER BY sales_rep_id;

SELECT *
From web_events_full
WHERE referrer_url NOT IN '%google%';

-- Questions using the NOT operator
-- We can pull all of the rows that were excluded from the queries in the previous two concepts with our new operator.

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- Use the accounts table to find:

-- All the companies whose names do not start with 'C'.
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

-- All companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

-- All companies whose names do not end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

-- ### AND & BETWEEN
SELECT *
FROM orders
WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01'
ORDER BY occurred_at DESC;

SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-04-01' AND '2016-10-01'
ORDER BY occurred_at DESC;

-- Questions using AND and BETWEEN operators

-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECt name
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

-- When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

-- ### OR
SELECT account_id, 
        occurred_at, 
        standard_qty, 
        gloss_qty, 
        poster_qty
FROM orders
WHERE standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0;

SELECT account_id, 
        occurred_at, 
        standard_qty, 
        gloss_qty, 
        poster_qty
FROM orders
WHERE (standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0)
AND occurred_at >= '2016-10-01';

-- Questions using OR operator

-- Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

-- Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
        AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
        AND primary_poc NOT LIKE '%eana%');


-- Recap
-- Commands
-- You have already learned a lot about writing code in SQL! Let's take a moment to recap all that we have covered before moving on:

-- Statement	How to Use It	                Other Details
-- SELECT	SELECT Col1, Col2, ...	        Provide the columns you want
-- FROM	        FROM Table	                Provide the table where the columns exist
-- LIMIT	LIMIT 10	                Limits based number of rows returned
-- ORDER BY	ORDER BY Col	                Orders table based on the column. Used with DESC.
-- WHERE	WHERE Col > 5	                A conditional statement to filter your results
-- LIKE	        WHERE Col LIKE '%me%'	        Only pulls rows where column has 'me' within the text
-- IN	        WHERE Col IN ('Y', 'N')	        A filter for only rows with column of 'Y' or 'N'
-- NOT	        WHERE Col NOT IN ('Y', 'N')	NOT is frequently used with LIKE and IN
-- AND	        WHERE Col1 > 5 AND Col2 < 3	Filter rows where two or more conditions must be true
-- OR	        WHERE Col1 > 5 OR Col2 < 3	Filter rows where at least one condition must be true
-- BETWEEN	WHERE Col BETWEEN 3 AND 5	Often easier syntax than using an AND
-- Other Tips
-- Though SQL is not case sensitive (it doesn't care if you write your statements as all uppercase or lowercase), we discussed some best practices. The order of the key words does matter! Using what you know so far, you will want to write your statements as:

-- SELECT col1, col2
-- FROM table1
-- WHERE col3  > 5 AND col4 LIKE '%os%'
-- ORDER BY col5
-- LIMIT 10;
-- Notice, you can retrieve different columns than those being used in the ORDER BY and WHERE statements. Assuming all of these column names existed in this way (col1, col2, col3, col4, col5) within a table called table1, this query would run just fine.


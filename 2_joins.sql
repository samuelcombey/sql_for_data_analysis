-- ### Why do we use JOINs?
-- Different types of objects
-- It allows queries to execute quickly

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- As we've learned, the SELECT clause indicates which column(s) of data you'd like to see in the output (For Example, orders.* gives us all the columns in orders table in the output). 
-- The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. 
-- The ON clause specifies the column on which you'd like to merge the two tables together. Try running this query yourself below.

-- For example, if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns, we can do this with the following query:
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- This query only pulls two columns, not all the information in these two tables. Alternatively, the below query pulls all the columns from both the accounts and orders table.
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- And the first query you ran pull all the information from only the orders table:
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Quiz Questions
-- Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT orders.*, accounts.*
FROM accounts
JOIN orders 
ON accounts.id = orders.account_id;

-- Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- The Code
-- If we wanted to join all three of these tables, we could use the same logic. The code below pulls all of the data from all of the joined tables.
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

-- ALIASES
SELECT o.*, a.*
FROM orders o
JOIN accounts a
ON o.account_id = a.id

-- When we JOIN tables together, it is nice to give each table an alias. Frequently an alias is just the first letter of the table name. You actually saw something similar for column names in the Arithmetic Operators concept.

-- Example:
FROM tablename AS t1
JOIN tablename2 AS t2

-- Before, you saw something like:
SELECT col1 + col2 AS total, col3

-- Frequently, you might also see these statements without the AS statement. Each of the above could be written in the following way instead, and they would still produce the exact same results:

FROM tablename t1
JOIN tablename2 t2

-- and

SELECT col1 + col2 total, col3

-- ### Aliases for Columns in Resulting Table
-- While aliasing tables is the most common use case. It can also be used to alias the columns selected to have the resulting table reflect a more readable name.

-- Example:

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

-- The alias name fields will be what shows up in the returned table instead of t1.column1 and t2.column2

-- aliasname	aliasname2
-- example row	example row
-- example row	example row

-- Questions
-- Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

-- ### INNER JOIN / JOIN
-- The INNER JOIN statement is used to join two tables together, but only if both tables have a matching column.
-- Only returns rows that appear in both tables.


-- ### LEFT JOIN / LEFT OUTER JOIN
-- The LEFT JOIN statement is used to join two tables together, but only if one table has a matching column.
-- Only returns rows that appear in the left table.
-- FROM left_table
SELECT a.id, a.name, o.total
FROM accounts a 
LEFT JOIN orders o
ON o.account_id = a.id

-- ### RIGHT JOIN / RIGHT OUTER JOIN
-- The RIGHT JOIN statement is used to join two tables together, but only if one table has a matching column.
-- Only returns rows that appear in the right table.
-- JOIN right_table
SELECT a.id, a.name, o.total
FROM orders o
RIGHT JOIN accounts a
ON o.account_id = a.id

-- ### FULL JOIN / FULL OUTER JOIN / OUTER JOIN
-- The FULL JOIN statement is used to join two tables together, but only if one table has a matching column.
-- Returns all rows from both tables.

-- ### PRO Tip
-- Logic in the ON clause 
-- Reduces the ROWS before
-- Combing the Tables

-- ### PRO Tip
-- Logic in the WHERE clause
-- Occours After the
-- JOIN occurs

-- A simple rule to remember this is that, when the database executes this query, it executes the join and everything in the ON clause first. Think of this as building the new result set. That result set is then filtered using the WHERE clause.

-- The fact that this example is a left join is important. Because inner joins only return the rows for which the two tables match, moving this filter to the ON clause of an inner join will produce the same result as keeping it in the WHERE clause.

-- Questions

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

-- What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

-- Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;


-- ### Recap

-- ### Primary and Foreign Keys
-- You learned a key element for JOINing tables in a database has to do with primary and foreign keys:
-- primary keys - are unique for every row in a table. These are generally the first column in our database (like you saw with the id column for every table in the Parch & Posey database).
-- foreign keys - are the primary key appearing in another table, which allows the rows to be non-unique.

-- Choosing the set up of data in our database is very important, but not usually the job of a data analyst. This process is known as Database Normalization.

-- ### JOINs
-- In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements you are most likely to use are:
-- JOIN - an INNER JOIN that only pulls data that exists in both tables.
-- LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
-- RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement.
-- There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases. UNION and UNION ALL, CROSS JOIN, and the tricky SELF JOIN. These are more advanced than this course will cover, but it is useful to be aware that they exist, as they are useful in special cases.

-- ### Alias
-- You learned that you can alias tables and columns using AS or not using it. This allows you to be more efficient in the number of characters you need to write, while at the same time you can assure that your column headings are informative of the data in your table.
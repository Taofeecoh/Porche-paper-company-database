/* Query the orders' schema of paper company database to generate the following: */

/* sorted by the 10 earliest orders */
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/* sorted by the 10 5 largest orders */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

/* sorted by the 20 smallest orders */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

/* 
Write a query that displays the order ID, account ID, and total dollar amount for all the orders, 
sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
*/
SELECT order_id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

/*
Now write a query that again displays order ID, account ID, and total dollar amount for each order,
but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order)
*/
SELECT order_id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/*
Pulls the first 5 rows and all columns from the orders table 
that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) 
just for the Exxon Mobil company in the accounts table
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

/*
Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
Limit the results to the first 10 orders, and include the id and account_id fields
*/
SELECT standard_amt_usd / standard_qty AS unit_price, id, account_id
FROM orders
LIMIT 10;

/*
Write a query that finds the percentage of revenue that comes from poster paper for each order. 
Display the id and account_id fields also.
*/
SELECT (poster_amt_usd/total_amt_usd)*100 AS revenue_percent, id, account_id
FROM orders
LIMIT 10;

/*
Find all the companies whose names start with 'C'.
*/
SELECT name
FROM accounts
WHERE name LIKE 'C%';

/*
All companies whose names contain the string 'one' somewhere in the name.
*/
SELECT name
FROM accounts
WHERE name LIKE '%one%';

/*
All companies whose names end with 's'
*/
SELECT name
FROM accounts
WHERE name LIKE '%s';

/*
Find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

/*
Find all information regarding individuals who were contacted via the organic or adwords channels, 
and started their account at any point in 2016, sorted from newest to oldest.
*/
SELECT *
FROM web_events
WHERE channel ==IN ('organic','adwords')
AND occurred_at BETWEEN '2016-01-01'AND '2017-01-01'
ORDER BY occurred_at;
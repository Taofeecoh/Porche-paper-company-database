/*
Which account (by name) placed the earliest order?
*/
SELECT a.name account, o.occurred_at date
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

/*
Find the total sales in usd for each account. 
*/
SELECT a.name account, SUM(o.total_amt_usd)total_sales
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY(a.name);

/*
Via what channel did the most recent (latest) web_event occur, 
which account was associated with this web_event? */
SELECT a.name account, w.channel channel, w.occurred_at date
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 3;

/*
Who was the primary contact associated with the earliest web_event?
*/
SELECT a.name account, a.primary_poc, w.occurred_at date
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
ORDER BY w.occurred_at ASC
LIMIT 1;

/*
What was the smallest order placed by each account in terms of total usd.
*/
SELECT a.name account, SUM(o.total_amt_usd) sum_of_orders
FROM accounts a
JOIN orders o
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY sum_of_orders;

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

/*
Number of sales reps in each region.
*/
SELECT r.name region, COUNT(s.id) rep_count
FROM sales_reps s
JOIN region r
	ON r.id = s.region_id
GROUP BY region
ORDER BY rep_count;

/*
Total number of times each type of channel from the web_events was used.
*/
SELECT channel, COUNT(channel) times_used
FROM web_events
GROUP BY channel;

/*
Determine the average amount of each type of paper they purchased across their orders
*/
SELECT a.name account, AVG(o.gloss_qty) avg_gloss,
	AVG(o.standard_qty) avg_std,
    AVG(o.poster_qty) avg_poster
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name;

/*
Determine the number of times a particular channel was used in the web_events table for each sales rep
*/
SELECT s.name rep, w.channel, COUNT(w.*) channel_usage_count
FROM accounts a
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN web_events w
	ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY channel_usage_count DESC;

/*
Determine the number of times a particular channel was used in the web_events table for each region.
*/
SELECT r.name region, w.channel, COUNT(w.*) channel_usage_count
FROM accounts a
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN web_events w
	ON w.account_id = a.id
JOIN region r
	ON r.id = s.region_id
GROUP BY w.channel, r.name
ORDER BY channel_usage_count DESC;

/*
How many of the sales reps have more than 5 accounts that they manage?
*/
SELECT sales_rep_id, COUNT(id) account_count
FROM accounts
GROUP BY sales_rep_id
HAVING COUNT(id)>5
ORDER BY account_count;

/*
How many accounts have more than 20 orders?
*/
SELECT account_id, COUNT(id)
FROM orders
GROUP BY account_id
HAVING COUNT(id)>20
ORDER BY account_id;

/*
Accounts that spent more than 30,000 usd total across all orders
*/
SELECT o.account_id, a.name, SUM(o.total_amt_usd) total_spend_by_account
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY o.account_id, a.name
HAVING SUM(o.total_amt_usd)>30000
ORDER BY total_spend_by_account DESC;

/*
Accounts that used facebook as a channel to contact customers more than 6 times
*/
SELECT a.name, w.account_id, w.channel,
	COUNT(w.channel)count_of_channel_usage
FROM web_events w
JOIN accounts a
 ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY w.account_id, a.name, w.channel
HAVING COUNT(w.channel)>6;

/*
Channel most frequently used by most accounts
*/
SELECT channel, COUNT(account_id) accounts_count
FROM web_events
GROUP BY channel
ORDER BY accounts_count DESC;

/*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/
SELECT DATE_TRUNC('month', occurred_at)monthly_sales, 		
	SUM(gloss_amt_usd)gloss_sales,
    accounts.name
FROM orders
JOIN accounts
	ON accounts.id = orders.account_id
WHERE accounts.name = 'Walmart'
GROUP BY accounts.name, DATE_TRUNC('month', occurred_at)
ORDER BY gloss_sales DESC;

/*
We would like to understand 3 different levels of customers based 
on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) 
greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
*/
SELECT a.name account, SUM(o.total_amt_usd)total_sales,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'High value'
    	WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200001 THEN 'Mid'
    	WHEN SUM(o.total_amt_usd) < 100000 THEN 'Low' END customer_category
FROM orders o
JOIN accounts a
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_sales DESC;

/*
We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders.
 Create a table with the sales rep name, the total number of orders, 
 and a column with top or not depending on if they have more than 200 orders
*/
SELECT s.name rep, COUNT(o.total)rep_order_count,
	CASE WHEN COUNT(o.total) > 200 THEN 'Top'
    	ELSE 'Not' END rep_category
FROM orders o
JOIN accounts a
	ON a.id = o.account_id
JOIN sales_reps s
	ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY rep_order_count DESC;
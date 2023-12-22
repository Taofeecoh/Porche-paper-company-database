/*
Find all the orders that occurred in 2015
*/
SELECT occurred_at, a.name, total_amt_usd, total
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
WHERE occurred_at 
	BETWEEN '01-01-2015'
    AND '01-01-2016'
ORDER BY o.occurred_at;

/*
Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/
SELECT acc.name, acc.primary_poc,
	we.channel, we.occurred_at
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
WHERE acc.name = 'Walmart';

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name
*/
SELECT re.name region_name, 
	sr.name salesrep, acc.name account_name
FROM region re
JOIN sales_reps sr
	ON re.id = sr.region_id
JOIN accounts acc
	ON sr.id = acc.sales_rep_id;
/*
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: region name, account name, and unit price
*/
SELECT r.name region, a.name account, 
	o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
JOIN orders o
	ON a.id = o.account_id;

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for the Midwest region. Your final table should include three columns: 
the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name
*/
SELECT s.name rep, a.name account, r.name region
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN region r
	ON r.id = s.region_id
    AND r.name = 'Midwest'
ORDER BY a.name;

/*
Provide the name for each region for every order, as well as the account name and 
the unit price they paid (total_amt_usd/total) for the order.
 However, you should only provide the results if the standard order quantity exceeds 100. 
 Final table should have 3 columns: region name, account name, and unit price.
*/
SELECT a.name account, 
    r.name region,
    o.total_amt_usd/(total+0.001) unit_price,
    o.standard_qty
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
JOIN sales_reps s
	ON s.id = a.sales_rep_id
JOIN region r
	ON r.id = s.region_id
WHERE o.standard_qty > 100
ORDER BY o.standard_qty;

/*
Provide a table with account name, region name and unit priice for every order where the 
last name of the rep starts with 'K' and the poster quantity exceeds 50 and standard quantity exceeds 100
*/
SELECT *
FROM 
  (SELECT a.name account, 
      r.name region,
      o.total_amt_usd/(total+0.001) unit_price,
      SPLIT_PART(s.name,' ',2) rep
  FROM accounts a
  JOIN orders o
      ON a.id = o.account_id
  JOIN sales_reps s
      ON s.id = a.sales_rep_id
  JOIN region r
      ON r.id = s.region_id
  WHERE o.standard_qty > 100
  AND poster_qty > 50
  ORDER BY unit_price DESC) sub
 WHERE rep LIKE 'K%';




create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);

create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);

/* SIDE NOTE: I would change the create table statement to "CREATE TABLE IF NOT EXIST" to avoid the code from giving an error, but will leave as is because was given this way */


/* BEGINNING OF MY CODE */


/* 1 */
SELECT SUM(impressions), date AS sum_impressions  /* SUM function that returns the total sum of impressions counting each record*/
FROM marketing_data
GROUP BY date /* To get them by day, we must group them and correctly show the output*/
ORDER BY date DESC;
/* GROUP BY is always using with SUM function */
/* ORDER BY DESC so latest record is on top */

/* 2 */
SELECT SUM(revenue), state AS sum_revenue /* SUM function that returns the total sum of the revenue counting each record*/
FROM website_revenue
GROUP BY state /* GROUP BY state to show each state that is available */
ORDER BY sum_revenue DESC /* Must order by the new variable in descending order so the top revenue is 1st */
LIMIT 3; /* Only show the top 3 states */

/* The 3rd best state's revenue was NY with 46398 with provided code to run if desired: 
SELECT SUM(revenue), state AS sum_revenue
FROM website_revenue
GROUP BY state
ORDER BY sum_revenue DESC
LIMIT 2, 1; */

/*3 */
SELECT FORMAT(SUM(cost), 2) AS sum_cost, /* Formatted cost output to where it only shows the necessary 2 decimal places */
	SUM(impressions) AS sum_impressions,
    SUM(clicks) AS sum_clicks,
    SUM(website_revenue.revenue) AS sum_revenue,
    campaign_info.name
    /* Renamed most variables to make the column output look cleaner */
FROM ((marketing_data
INNER JOIN website_revenue ON marketing_data.campaign_id = website_revenue.campaign_id) /*Since no Null values, a regular inner join will work */
INNER JOIN campaign_info ON marketing_data.campaign_id = campaign_info.id)
GROUP BY campaign_info.name
ORDER BY campaign_info.name;
/* Null Values checked with following code:
SELECT * FROM [table name]
WHERE [field name] IS NOT NULL; */

/* 4 */
SELECT SUM(conversions) AS sum_conversions,
	website_revenue.state, campaign_info.name AS state_conversions
FROM ((marketing_data
INNER JOIN website_revenue ON marketing_data.campaign_id = website_revenue.campaign_id) /* Only needs value that match for the triple join */
INNER JOIN campaign_info ON marketing_data.campaign_id = campaign_info.id)
WHERE campaign_info.name = 'Campaign5' /* We only want the Campaign5 results */
GROUP BY website_revenue.state /*Group by the state, so each state is calculated correctly */
ORDER BY state_conversions DESC
LIMIT 1; /* Only get 1 value to only see the top record */
/* The state that generated the most conversions was GA with 3342 */

/* 5 */
/* In my opinion, campaign 4 is the most efficient based on the cost per conversion I calculated using the code below: */
SELECT campaign_info.name,
       FORMAT(SUM(cost), 2) AS sum_cost, /* Keep numbers in regular 2 decimal place like cents */
       SUM(conversions) AS sum_conversions,
       FORMAT(SUM(cost) / SUM(conversions), 2) AS cost_per_conversion /* To find CPC, must divide the cost by the # of conversions */
	   /* Changed names to appear better in output */
FROM ((marketing_data
INNER JOIN website_revenue ON marketing_data.campaign_id = website_revenue.campaign_id) /* Must do triple join to incorporate all fields required */
INNER JOIN campaign_info ON marketing_data.campaign_id = campaign_info.id)
GROUP BY campaign_info.name
ORDER BY cost_per_conversion /* Order ASC by default, so lowest cost is presented on top */
LIMIT 1;


/* BONUS QUESTION */


SELECT DATE_FORMAT(marketing_data.date, '%W') AS Formatted_date, /* Format date to show days of the week */
	FORMAT(AVG(clicks/impressions), 2) AS Average_clicks, /* To find the best day, we must see the average # of clicks from the given impressions */ 
    website_revenue.revenue
FROM marketing_data
INNER JOIN website_revenue ON marketing_data.campaign_id = website_revenue.campaign_id /* This join statement allows for the website_revenue table to only join records with a match */
GROUP BY Formatted_date
ORDER BY Average_clicks DESC /* This puts the record with the highest average on top */
LIMIT 1;
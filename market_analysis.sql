select * from market
----------------------------------------------------
				Basic Overview
----------------------------------------------------
--What is the total number of campaigns?
select count(*) as campaigns from market

--What are the distinct marketing channels used?
select distinct channel from market

----------------------------------------------------
			Campaign Performance
----------------------------------------------------
--Which campaigns generate the highest profit?
select campaign_id,profit from market
order by profit desc
limit 1

--Which campaigns are underperforming in terms of profit?
select campaign_id,profit from market
order by profit 
limit 1

--Which campaigns have the highest conversion rate?
select campaign_id,conversion_rate from market
order by conversion_rate desc
limit 1

--Which campaigns have the lowest CAC?
select campaign_id, cac from market
order by cac
limit 1

--Which campaigns have high CTR but low conversion rate?

select campaign_id, ctr,conversion_rate
from market
where ctr > (select avg(ctr) from market)
and conversion_rate < (select avg(conversion_rate) from market)
----------------------------------------------------
			Channel-Level Analysis
----------------------------------------------------
--Which channel generates the highest total profit?
select channel, sum(profit) total_profit
from market
group by channel
order by total_profit desc
limit 1


--What is the average CTR for each channel?
select channel, avg(ctr) as avg_ctr
from market
group by channel


--Which channel has the best conversion rate?
select channel, avg(conversion_rate) as conversion_rate
from market
group by channel
order by conversion_rate desc
limit 1

--Which channel has the lowest average CAC?
select channel, avg(cac) as avg_cac
from market
group by channel
order by avg_cac 
limit 1

----------------------------------------------------
				Cost & Revenue
----------------------------------------------------
--What is the total cost, revenue, and profit?
select sum(cost) as total_cost, 
		sum(revenue) as total_revenue,
		sum(profit) as total_profit
from market

--Which campaigns are running at a loss?
select campaign_id, profit
from market
where profit<0
order by profit


--Which campaigns are most cost-efficient?
select campaign_id,
(revenue-cost)/cost as roi
from market
order by roi desc

----------------------------------------------------
				Funnel Analysis
----------------------------------------------------
--Where is the biggest drop in the funnel?
SELECT campaign_id,
       CASE 
           WHEN (1 - clicks::float / NULLIF(impressions,0)) >
                (1 - conversions::float / NULLIF(clicks,0))
           THEN 'Impression to Click'
           ELSE 'Click to Conversion'
       END AS biggest_drop_stage
FROM market;

--Which campaigns have strong engagement but weak conversion?
select campaign_id, ctr, conversion_rate
from market
where ctr > (select avg(ctr) from market)
  and conversion_rate < (select avg(conversion_rate) from market);



----------------------------------------------------
				Business Decisions
----------------------------------------------------
--Which campaigns should receive more budget?
select campaign_id, profit,conversion_rate, cac
from market
where
profit>(select avg(profit) from market)
and
conversion_rate>(select avg(conversion_rate) from market)
and
cac<(select avg(cac) from market)
order by profit desc



--Which campaigns should be optimized or stopped?
select campaign_id, profit,conversion_rate, cac
from market
where
profit<0
or
(
conversion_rate<(select avg(conversion_rate) from market)
and
cac>(select avg(cac) from market)
)
order by profit 


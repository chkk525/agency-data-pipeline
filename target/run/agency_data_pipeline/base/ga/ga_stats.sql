create or replace table `agency_data_pipeline`.`ga_stats`
  
  as (
    SELECT  
cast(date as date) date,
b.account,
b.site site,
c.source source,
c.medium medium,
concat(a.source, ' / ', a.medium) source_medium,  
case when c.platform is null then "Unmapped" else c.platform end as platform,
case when c.channel is null then "Unmapped" else c.channel end as channel,
url,
sum(sessions) sessions,
sum(goal_completions) goal_completions
FROM `adp-apprenticeship`.`agency_data_pipeline`.`ga_proc` a
LEFT JOIN `adp-apprenticeship`.`agency_data_pipeline`.`accounts_proc` b 
ON ( a.bigquery_name = b.bigquery_name 
	AND a.lookup_platform = b.platform )
LEFT JOIN `adp-apprenticeship`.`agency_data_pipeline`.`mappings_ga_proc` c
ON ( a.source = c.source
  AND a.medium = c.medium 
  AND a.bigquery_name = c.bigquery_name )
GROUP BY date, account, site, source, medium, source_medium, platform, channel, url
  );

    
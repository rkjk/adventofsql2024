with previous_day as (
	select 
		production_date, 
		toys_produced,
		(production_date - INTERVAL '1 day')::date AS previous_date
	from toy_production)
select pd.production_date, pd.previous_date, pd.toys_produced,
tmp.toys_produced as previous_production,
pd.toys_produced - tmp.toys_produced as diff,
((pd.toys_produced::float - tmp.toys_produced::float) / NULLIF(tmp.toys_produced::float, 0.0)) * 100.0 AS pc
from previous_day pd 
inner join toy_production tmp on tmp.production_date = pd.previous_date
order by pc desc;

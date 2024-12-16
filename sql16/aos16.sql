with tmp as 
	(
		select 
			sl.timestamp,
			ar.place_name,
			ST_CoveredBy(sl.coordinate, ar.polygon) as covered
		from sleigh_locations sl
		cross join areas ar
	),
tmp2 as 
	(
		select t.timestamp, t.place_name from tmp t 
		where t.covered = true
	),
tmp3 as 
	(
		select 
			t2.timestamp,
			t2.place_name,
			coalesce(lag(t2.timestamp, 1) over (order by t2.timestamp desc) - t2.timestamp, '0 seconds')  as diff
			from  tmp2 t2
	)
select t3.place_name, sum(t3.diff) as total_time
from tmp3 t3
group by t3.place_name
order by total_time desc limit 1;

with tmp as 
	(
		select place_name, ST_CoveredBy((select coordinate from sleigh_locations order by timestamp desc limit 1), polygon) as covered
		from areas
	)
select t.place_name from tmp t where t.covered = 'true';

CREATE OR REPLACE FUNCTION next_and_previous_season(
    year INTEGER,
    season TEXT
) RETURNS TABLE (
    next_year INTEGER,
    next_season TEXT,
    previous_year INTEGER,
    previous_season TEXT
) AS
$$
BEGIN
    CASE season
        WHEN 'Spring' THEN
            RETURN QUERY SELECT year, 'Summer', year - 1, 'Winter';
        WHEN 'Summer' THEN
            RETURN QUERY SELECT year, 'Fall', year, 'Spring';
        WHEN 'Fall' THEN
            RETURN QUERY SELECT year, 'Winter', year, 'Summer';
        WHEN 'Winter' THEN
            RETURN QUERY SELECT year + 1, 'Spring', year, 'Fall';
        ELSE
            RAISE EXCEPTION 'Invalid season: %', season;
    END CASE;
END;
$$

LANGUAGE plpgsql;

with next_and_previous as 
	(
		select sd.field_name, sd.harvest_year, sd.season, ns.next_year, ns.next_season, ns.previous_year, ns.previous_season
		FROM TreeHarvests sd
		cross join lateral next_and_previous_season(sd.harvest_year, sd.season) as ns
	),
all_harvests as 
	(
		select np.field_name, np.harvest_year, np.season, 
		coalesce((select trees_harvested from TreeHarvests where field_name = np.field_name and harvest_year = np.next_year and season = np.next_season), 0) as next_harvest,
		coalesce((select trees_harvested from TreeHarvests where field_name = np.field_name and harvest_year = np.previous_year and season = np.previous_season), 0) as previous_harvest,
		coalesce((select trees_harvested from TreeHarvests where field_name = np.field_name and harvest_year = np.harvest_year and season = np.season), 0) as cur_harvest
		from next_and_previous np
	)
select ah.field_name, ah.harvest_year, ah.season,
round((ah.next_harvest + ah.previous_harvest + ah.cur_harvest)/3.0, 2) as moving_avg
from all_harvests ah
order by moving_avg desc;

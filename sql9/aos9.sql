with avg_speeds as (
	select reindeer_id, exercise_name, avg(speed_record) as avg_speed 
	from training_sessions
	group by reindeer_id, exercise_name),
max_avg as (
	select distinct on (reindeer_id)
	reindeer_id, max(avg_speed) as max_avg
	from avg_speeds
	group by reindeer_id
	order by reindeer_id, max_avg desc
)
select r.reindeer_name, round(avs.max_avg, 2)
from reindeers r inner join max_avg avs
on r.reindeer_id = avs.reindeer_id
where r.reindeer_name != 'Rudolph'
order by avs.max_avg desc;

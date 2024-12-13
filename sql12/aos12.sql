with gift_names as 
	(
		select gr.request_id, g.gift_name as gift_name
		from gift_requests gr
		inner join gifts g on g.gift_id = gr.gift_id
	),
ordered_counts as 
	(
		select gn.gift_name, count(gn.gift_name) as c from gift_names gn
		group by gn.gift_name
		order by c desc
	)
select oc.gift_name, oc.c, round((percent_rank() over (order by oc.c))::numeric, 2) as perc
from ordered_counts oc
order by perc desc;

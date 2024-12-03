WITH intermediate as (select 
	wl.child_id as child_id, 
	wl.wishes->>'first_choice' as primary_wish,
	wl.wishes->>'second_choice' as backup_wish,
	wl.wishes -> 'colors' ->> 0 as favorite_color,
	json_array_length(wl.wishes -> 'colors') as color_count
from wish_lists wl),
complexity as (
	select 
		toy_id, 
		toy_name,
		case difficulty_to_make 
			when 1 then 'Simple Gift'
			when 2 then 'Moderate Gift'
			else 'Complex Gift'
		end as gift_complexity,
		case category
			when 'outdoor' then 'Outside Workshop'
			when 'educational' then 'Learning Workshop'
			else 'General Workshop'
		end as workshop_assignment
	from toy_catalogue
)
select 
	c.name, 
	id1.primary_wish,
	id1.backup_wish,
	id1.favorite_color,
	id1.color_count,
	comp.gift_complexity,
	comp.workshop_assignment
from children c
inner join intermediate id1 on c.child_id = id1.child_id
inner join complexity comp on id1.primary_wish = comp.toy_name
order by c.name asc;

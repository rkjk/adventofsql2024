drop function if exists array_intersect(text[], text[]);
create or replace function array_intersect(text[], text[]) returns integer as $$
declare
	out integer := 0;
	i integer;
begin
	if $1 is null or $2 is null then
		return out;
	end if;
	for i in 1..array_length($1, 1) loop 
		if $2 @> array[$1[i]] then
			out := out + 1;
		end if;
	end loop;
	return out;
end;
$$
LANGUAGE PLPGSQL;

drop function if exists array_diff(text[], text[]);
create or replace function array_diff(text[], text[]) returns integer as $$
declare
	out integer := 0;
	i integer;
begin
	if $1 is null or $2 is null then
		return out;
	end if;
	for i in 1..array_length($1, 1) loop 
		if not($2 @> array[$1[i]]) then
			out := out + 1;
		end if;
	end loop;
	return out;
end;
$$
LANGUAGE PLPGSQL;

select toy_id, toy_name, previous_tags, new_tags, 
array_intersect(previous_tags, new_tags) as intact,
array_diff(previous_tags, new_tags) as removed,
array_diff(new_tags, previous_tags) as added
from toy_production
group by toy_id, toy_name, previous_tags, new_tags
order by added desc;

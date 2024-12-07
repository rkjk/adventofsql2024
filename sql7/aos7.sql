with skill_max as (
	select distinct on (primary_skill) 
	elf_id, primary_skill, years_experience
	from workshop_elves
	order by primary_skill, years_experience desc, elf_id),
skill_min as (
	select distinct on (primary_skill) 
	elf_id, primary_skill, years_experience
	from workshop_elves
	order by primary_skill, years_experience, elf_id)
select s1.elf_id as elf_id_1, s2.elf_id as elf_id_2,
s1.primary_skill as shared_skill,
s1.years_experience - s2.years_experience as exp_diff
from skill_max s1 inner join skill_min s2 
on s1.primary_skill = s2.primary_skill
order by shared_skill;

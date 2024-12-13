with  emails as 
	(
		select unnest(email_addresses) as emails from contact_list
	),
domains as 
	(
		select split_part(e.emails, '@', 2) as split
		from emails e
	)
select s.split, count(s.split) as c from domains s
group by s.split
order by c desc;

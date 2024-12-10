with datewise_sums as 
	(
		select drink_name, date, sum(quantity) as quantity
		from drinks
		group by drink_name, date
	),
hotcocoas as
	(
		select date from datewise_sums where drink_name = 'Hot Cocoa' and quantity = 38
	),
peppermintschnapps as
	(
		select date from datewise_sums where drink_name = 'Peppermint Schnapps' and quantity = 298
	),	
eggnogs as
	(
		select date from datewise_sums where drink_name = 'Eggnog' and quantity = 198
	)
select hc.date from hotcocoas hc
inner join peppermintschnapps ps on hc.date = ps.date
inner join eggnogs eg on hc.date = eg.date;

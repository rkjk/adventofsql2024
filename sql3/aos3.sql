with intermediate as (select unnest(xpath('//food_item_id/text()', menu_data))::text AS food_item
FROM christmas_menus 
where (xpath('/*/@version', menu_data))[1]::text in ('1.0', '2.0'))
select food_item, count(*) as c from intermediate
group by food_item
order by c desc;

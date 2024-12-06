select c.name, g.price from children c 
inner join gifts g on g.child_id = c.child_id
where g.price > (select avg(price) as average from gifts)
group by c.name, g.price
order by price asc;

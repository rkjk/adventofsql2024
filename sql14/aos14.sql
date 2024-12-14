with tmp as 
	(
		select record_date, jsonb_array_elements(cleaning_receipts) as recs from SantaRecords 
		where cleaning_receipts @> '[{"color": "green", "garment": "suit"}]'::jsonb
	)
select t.record_date, t.recs->>'drop_off' as dropoff, t.recs->>'pickup' as pickup  from tmp t 
where recs->>'color' = 'green' and recs->>'garment' = 'suit'
order by pickup asc;

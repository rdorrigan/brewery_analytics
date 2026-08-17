
    
    

select
    brewery_id as unique_field,
    count(*) as n_records

from "brewery"."main"."dim_breweries"
where brewery_id is not null
group by brewery_id
having count(*) > 1



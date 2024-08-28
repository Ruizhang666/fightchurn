with
    date_range as (
        select i::timestamp as calc_date
        from generate_series('2019-12-01', '2020-06-01', '1 day'::interval) i
    )
select event_time::date as event_date, count(*) as n_event
from date_range left outer join livebook.event e on calc_date=event_time::date
where event_type ='ReadingOwnedBook'
group by event_date
order by event_date
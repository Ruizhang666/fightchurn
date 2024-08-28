with date_vals AS (
    select i::timestamp as metric_date
    from generate_series('2019-12-01', '2020-06-01', '7 day'::interval) i
)
insert into livebook.metric (account_id,metric_time,metric_name_id,metric_value)

select account_id, metric_date, 1 AS metric_name_id, count(*) AS metric_value
from livebook.event e inner join date_vals d
on e.event_time < metric_date
    and e.event_time >= metric_date - interval '90 day'
where event_type='ReadingOwnedBook'
group by account_id, metric_date
ON CONFLICT DO NOTHING;
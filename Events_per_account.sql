WITH
    date_range AS (
        SELECT  '2019-12-13'::timestamp AS start_date,
                '2020-06-08'::timestamp AS end_date
    ),
    account_count AS (
        SELECT count(distinct account_id) AS n_account
        FROM livebook.event
    )
SELECT e.event_type,
       count(*) AS n_event,
       n_account AS n_account,
       count(*)::float/n_account::float AS events_per_account,
       extract(days FROM end_date - start_date)::float/28 AS n_months,
       (count(*)::float/n_account::float) / (extract(days FROM end_date - start_date)::float/28.0) AS events_per_account_per_month
FROM livebook.event e
         CROSS JOIN account_count
         INNER JOIN date_range ON
    event_time >= start_date
        AND event_time <= end_date
GROUP BY e.event_type, n_account, end_date, start_date
ORDER BY events_per_account_per_month DESC;

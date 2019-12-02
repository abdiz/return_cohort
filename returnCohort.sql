with users_with_first_payments as (
    SELECT user_id,
            min(paid_at) as first_paid
    FROM payments
    GROUP BY user_id
    HAVING min(paid_at) >= '2019-01-01 00:00:00' and min(paid_at) <'2019-07-01 00:00:00'
),
users_cohort_group as (
    SELECT users_with_first_payments.user_id,
           date_trunc('month', first_paid) as cohort_group
    FROM users_with_first_payments
),
user_activity as (
    SELECT users_cohort_group.user_id,
           EXTRACT(MONTH FROM payments.paid_at) as month
    FROM users_cohort_group
    INNER JOIN payments ON users_cohort_group.user_id = payments.user_id
)

SELECT users_cohort_group.cohort_group as "Cohort Group",
       count(distinct user_activity.user_id) as "Size",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 1) * 100) / count(distinct user_activity.user_id) as "Mounth 01",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 2) * 100) / count(distinct user_activity.user_id) as "Mounth 02",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 3) * 100) / count(distinct user_activity.user_id) as "Mounth 03",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 4) * 100) / count(distinct user_activity.user_id) as "Mounth 04",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 5) * 100) / count(distinct user_activity.user_id) as "Mounth 05",
       (count(distinct user_activity.user_id) FILTER ( WHERE user_activity.month = 6) * 100) / count(distinct user_activity.user_id) as "Mounth 06"
FROM user_activity
INNER JOIN users_cohort_group ON user_activity.user_id = users_cohort_group.user_id
GROUP BY users_cohort_group.cohort_group;
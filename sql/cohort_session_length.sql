-- Анализ длительности сессий во время маркетинговой акции
-- Сравниваем когорту пользователей, пришедших в период акции (ноябрь-декабрь 2022), с остальными

SELECT 
    CASE 
        WHEN DATE_TRUNC('month', reg_date) BETWEEN '2022-11-01' AND '2022-12-31' 
        THEN 'cohort_two_month'
        ELSE 'other_cohort' 
    END AS cohort,
    AVG(end_session - start_session) AS avg_session_length
FROM skygame.users t1
LEFT JOIN skygame.game_sessions t2 ON t1.id_user = t2.id_user
WHERE end_session - start_session > INTERVAL '5 minute'  -- исключаем слишком короткие сессии
GROUP BY cohort

-- Расчёт K-factor и прогноз размера будущей когорты
-- K-factor = сумма приглашений / количество уникальных пользователей
-- Future cohort = сумма приглашений / количество месяцев

SELECT 
      SUM(ref_reg) / COUNT(DISTINCT t1.id_user) AS k_factor
    , SUM(ref_reg) / COUNT(DISTINCT DATE_TRUNC('month', reg_date)) AS future_cohort_size
FROM skygame.users t1
LEFT JOIN skygame.referral t2
       ON t1.id_user = t2.id_user


-- Анализ среднемесячной выручки по когортам (ARPU)
-- Задача: понять, какие месячные когорты приносят больше денег в пересчёте на месяц жизни
--
-- Логика:
-- 1. Группируем пользователей по месяцу регистрации (когорты)
-- 2. Считаем для каждой когорты: общую выручку, количество уникальных пользователей, среднюю выручку на пользователя за всё время
-- 3. Определяем возраст когорты в месяцах (от регистрации до последней покупки в данных)
-- 4. Делим среднюю выручку на пользователя на возраст когорты — получаем среднемесячный вклад пользователя

SELECT 
    *
    -- Количество полных месяцев жизни когорты
    , EXTRACT('day' FROM ((SELECT MAX(dtime_pay) FROM skygame.monetary) - mm) / 30) AS interv
    -- Среднемесячная выручка на пользователя в когорте
    , avg_rev / EXTRACT('day' FROM ((SELECT MAX(dtime_pay) FROM skygame.monetary) - mm) / 30) AS avg_rev_per_month

FROM (
    -- Базовая агрегация по когортам (месяцам регистрации)
    SELECT 
        DATE_TRUNC('month', reg_date) AS mm,
        SUM(cnt_buy * price) AS revenue,
        COUNT(DISTINCT m.id_user) AS cnt,
        SUM(cnt_buy * price) / COUNT(DISTINCT m.id_user) AS avg_rev
    FROM skygame.monetary m
    JOIN skygame.log_prices p
        ON m.id_item_buy = p.id_item
        AND m.dtime_pay >= p.valid_from
        AND m.dtime_pay <= COALESCE(valid_to, TO_DATE('01/01/3000', 'DD/MM/YYYY'))
    JOIN skygame.users u
        ON m.id_user = u.id_user
    -- Исключаем последний месяц, чтобы когорты имели равные возможности для покупок
    WHERE reg_date < (SELECT MAX(dtime_pay) - INTERVAL '1 month' FROM skygame.monetary)
    GROUP BY mm
    ORDER BY mm
) t

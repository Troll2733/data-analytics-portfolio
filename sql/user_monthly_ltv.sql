
-- 1. Считаем суммарную выручку по каждому пользователю
-- (сколько денег он потратил за всё время)
with ltr as (
    select
         sm.id_user
       , sum(cnt_buy * price) as revenue  -- общая выручка пользователя
    from skygame.monetary sm
    join skygame.item_list il
        on sm.id_item_buy = il.id_item
    join skygame.log_prices lp
        on sm.id_item_buy = lp.id_item
        and dtime_pay between valid_from and coalesce(valid_to, '2030-01-01')
    group by sm.id_user
),

-- 2. Считаем время жизни пользователя (Lifetime) в месяцах
-- от даты регистрации до последней игровой сессии
lt_mm as (
    select
         su.id_user
       , ceil(extract('day' from max(start_session) - min(reg_date)) / 30) as lt_mm
    from skygame.users su
    join skygame.game_sessions gs
        on su.id_user = gs.id_user
    group by su.id_user
)

-- 3. Соединяем две таблицы и считаем среднемесячную выручку
-- (сколько в среднем пользователь тратит за месяц своей "жизни")
select 
      ltr.id_user
    , revenue / lt_mm as ltr_per_month  -- LTV в пересчёте на месяц
from ltr
join lt_mm
    on ltr.id_user = lt_mm.id_user
order by ltr_per_month desc  -- сначала самые ценные пользователи
limit 100  -- топ-100

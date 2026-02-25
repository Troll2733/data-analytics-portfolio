SELECT 
    -- Количество битых строк
    SUM(CASE WHEN end_session IS NULL THEN 1 ELSE 0 END) AS cnt_problems,
    
    -- % битых строк от всех
    SUM(CASE WHEN end_session IS NULL THEN 1 ELSE 0 END)::float / COUNT(*) * 100 AS share_problem,
    
    -- % битых строк среди iOS
    SUM(CASE WHEN dev_type = 'ios' AND end_session IS NULL THEN 1 ELSE 0 END)::float / 
    SUM(CASE WHEN dev_type = 'ios' THEN 1 ELSE 0 END) * 100 AS share_problem_ios,
    
    -- % битых строк среди Android
    SUM(CASE WHEN dev_type = 'android' AND end_session IS NULL THEN 1 ELSE 0 END)::float / 
    SUM(CASE WHEN dev_type = 'android' THEN 1 ELSE 0 END) * 100 AS share_problem_android,
    
    -- % битых строк iOS среди всех битых
    SUM(CASE WHEN dev_type = 'ios' AND end_session IS NULL THEN 1 ELSE 0 END)::float / 
    SUM(CASE WHEN end_session IS NULL THEN 1 ELSE 0 END) * 100 AS share_ios,
    
    -- % битых строк Android среди всех битых
    SUM(CASE WHEN dev_type = 'android' AND end_session IS NULL THEN 1 ELSE 0 END)::float / 
    SUM(CASE WHEN end_session IS NULL THEN 1 ELSE 0 END) * 100 AS share_android
FROM skygame.game_sessions GS
JOIN skygame.users U ON GS.id_user = U.id_user;	

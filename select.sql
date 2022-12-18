-- первый запрос SELECT

-- если спортсмен выступает минимум на двух соревнованиях,
-- которые прошли под эгидой ISU,
-- и его лучший результат на соревнованиях, прошедших под эгидой ISU,
-- больше, чем 25 баллов
-- то он может выступить на чемпионате мира
-- сформируем таблицу спортсменов, которые будут допущены к ЧМ, отсортированных по убыванию
-- максимального балла

-- примечание автора: с логикой все ок, я поправила insert-ы, чтобы соревнование в Риме
-- было в том же сезоне, что и все остальные соревнования

-- примечание автора 2: сделала побольше выступлений на соревнованиях, добавила insert-ов,
-- чтобы результат запроса был интереснее

-- первый запрос SELECT

SELECT f.fig_name, max(p.prf_points) as season_best, count(c.cmp_isu) as num_isu
FROM figure_skating.figure_skater as f
LEFT JOIN figure_skating.performance as p
ON f.fig_id = p.prf_fig
LEFT JOIN figure_skating.competition as c
ON p.prf_comp = c.cmp_id
WHERE c.cmp_isu = True
GROUP BY f.fig_name
HAVING max(p.prf_points) >= 30 and count(c.cmp_isu) >= 2
ORDER BY max(p.prf_points) DESC;

-- второй запрос SELECT

-- посчитаем, как менялось завоеванное количество медалей каждой страны на протяжении сезона
-- хотим получить таблицу с рейтингом медалей по странам по окончанию каждого соревнования
-- медали бывают золотые, серебряные и бронзовые

-- второй запрос SELECT

SELECT
    cmp_date,
    fdr_country,
    gold,
    bronze,
    silver,
    all_medals,
    row_number() OVER (PARTITION BY cmp_date ORDER BY -all_medals, fdr_country) as pos_rate
    FROM (
    SELECT
           c.cmp_date,
           fed.fdr_country,
           sum(coalesce(sum((p.prf_place = 1)::int), 0)) OVER (PARTITION BY
               fed.fdr_country ORDER BY c.cmp_date) as gold,
           sum(coalesce(sum((p.prf_place = 2)::int), 0)) OVER (PARTITION BY
               fed.fdr_country ORDER BY c.cmp_date) as silver,
           sum(coalesce(sum((p.prf_place = 3)::int), 0)) OVER (PARTITION BY
               fed.fdr_country ORDER BY c.cmp_date) as bronze,
           sum(coalesce(sum((p.prf_place <= 3)::int), 0)) OVER (PARTITION BY
               fed.fdr_country ORDER BY c.cmp_date) as all_medals

    FROM figure_skating.competition as c
    CROSS JOIN figure_skating.federation as fed
    LEFT JOIN figure_skating.figure_skater as f
    ON fed.fdr_id = f.fig_fdr
    LEFT JOIN figure_skating.performance as p
    ON p.prf_comp = c.cmp_id and p.prf_fig = f.fig_id
    GROUP BY (c.cmp_date, fed.fdr_country)) as medals_info;

-- третий запрос select

-- построим таблицу, где для каждого фигуриста посчитаем компоненты, полученные на каждом соревновании
-- компоненты = сумма баллов - стоимость элементов
-- компоненты отображают, насколько красиво катается фигурсит
-- как правило, фанаты не любят, когда компонентов за выступление ставят больше, чем баллов за технику
-- для каждого фигуриста найдем максимальный процент компонентов от общей суммы баллов за все соревнования
-- отсортируем таблицу по возрастанию максимального процента компонентов

-- третий запрос select

SELECT f.fig_name,
       c.cmp_city,
       elm_info.sum_elms as tech_points,
       p.prf_points - elm_info.sum_elms as comp_points,
       p.prf_points,
       (1 - elm_info.sum_elms / p.prf_points) * 100 as percent_comps,
       max((1 - elm_info.sum_elms / p.prf_points) * 100) OVER (PARTITION BY f.fig_name) as max_percent_comps
FROM (
SELECT f.fig_id, c.cmp_id, sum(e.elm_cost) as sum_elms
FROM figure_skating.figure_skater as f
LEFT JOIN figure_skating.performance as p
ON f.fig_id = p.prf_fig
LEFT JOIN figure_skating.competition as c
ON p.prf_comp = c.cmp_id
LEFT JOIN figure_skating.performance_x_element as pe
ON p.prf_id = pe.prf_id
LEFT JOIN figure_skating.element as e
ON pe.elm_id = e.elm_id and pe.elm_st_date = e.elm_st_date
GROUP BY f.fig_id, c.cmp_id) as elm_info
LEFT JOIN figure_skating.figure_skater as f
ON elm_info.fig_id = f.fig_id
LEFT JOIN figure_skating.competition as c
ON elm_info.cmp_id = c.cmp_id
LEFT JOIN figure_skating.performance as p
ON elm_info.fig_id = p.prf_fig and p.prf_comp = elm_info.cmp_id
ORDER BY max_percent_comps;

-- четвертый запрос SELECT

-- для каждого элемента выведем информацию об изменениях его стоимости
-- имя элемента - дата приказа - текущая стоимость - изменение стоимости
-- если изменений стоимости не было,  в таблице данного элемента не будет

-- четвертый запрос SELECT

SELECT  *
FROM
(SELECT e.elm_name, e.elm_st_date,
       e.elm_cost - lag(e.elm_cost, 1) OVER (PARTITION BY e.elm_id ORDER BY e.elm_st_date
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as points_diff
FROM figure_skating.element as e) as result
WHERE result.points_diff IS NOT NULL;

-- пятый запрос SELECT

-- для каждого фигуриста выведем информацию о самом дорогом исполненном им элементе
-- имя фигуриста - название самого дорогого элемента - стоимость - дата исполнения
-- если несколько кандидатов на самый дорогой, выведем все

-- пятый запрос SELECT

SELECT f.fig_name, e.elm_name, e.elm_cost, c.cmp_date
FROM (
SELECT f.fig_id, max(e.elm_cost) as max_elms
FROM figure_skating.figure_skater as f
LEFT JOIN figure_skating.performance as p
ON f.fig_id = p.prf_fig
LEFT JOIN figure_skating.performance_x_element as pe
ON p.prf_id = pe.prf_id
LEFT JOIN figure_skating.element as e
ON pe.elm_id = e.elm_id and pe.elm_st_date = e.elm_st_date
GROUP BY f.fig_id) as elm_info
LEFT JOIN figure_skating.figure_skater as f
ON elm_info.fig_id = f.fig_id
LEFT JOIN figure_skating.performance as p
ON elm_info.fig_id = p.prf_fig
LEFT JOIN figure_skating.performance_x_element as pe
ON p.prf_id = pe.prf_id
INNER JOIN figure_skating.element as e
ON pe.elm_id = e.elm_id and pe.elm_st_date = e.elm_st_date and e.elm_cost = elm_info.max_elms
LEFT JOIN figure_skating.competition as c
ON p.prf_comp = c.cmp_id;

-- шестой запрос SELECT

-- для каждого судьи посчитаем, сколько соревноаний под эгидой ISU
-- и сколько соревноаний не под эгидой ISU он судил в этом сезоне
-- отсортируем по убыванию количества соревнований, которые судил судья

-- шестой запрос SELECT

SELECT jdg_name,
       coalesce(sum((cmp_isu = true)::int), 0) as is_isu_competitions,
       coalesce(sum((cmp_isu = false)::int), 0) as no_isu_competitions,
       coalesce(count(cmp_isu), 0) as all_competitions
FROM figure_skating.judge as j
LEFT JOIN figure_skating.judge_x_competition as jxc
ON j.jdg_id = jxc.jdg_id
LEFT JOIN figure_skating.competition as c
ON jxc.cmp_id = c.cmp_id
GROUP BY j.jdg_id
ORDER BY all_competitions DESC;

-- седьмой запрос SELECT

-- выведем список всех фигуристов, которые старше 20 лет и их возраст
-- мы думаем, надо ли повышать возрастной ценз, поэтому такая информация очень полезна
-- отсортируем фигуристов по возрастанию возраста

-- седьмой запрос SELECT

SELECT f.fig_name, date_part('year', age(NOW()::date, f.fig_date)) as fig_age
FROM figure_skating.figure_skater as f
WHERE date_part('year', age(NOW()::date, f.fig_date)) >= 20
ORDER BY fig_age;


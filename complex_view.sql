-- первое сложное представление
-- статистика выступлений фигуристов на соревнованиях, в которой отображены
-- баллы за технику и за компоненты
-- фигурист - соревнование - техника - компоненты - общая сумма баллов - занятое место

DROP VIEW IF EXISTS view_figure_skating.v_stat_competitions;
CREATE VIEW view_figure_skating.v_stat_competitions AS
    SELECT f.fig_name as "Имя фигуриста",
           c.cmp_city as "Город соревнования",
           round(elm_info.sum_elms::numeric, 2) as "Баллы за технику",
           round((p.prf_points - elm_info.sum_elms)::numeric, 2) as "Баллы за компоненты",
           round(p.prf_points::numeric, 2) as "Сумма баллов",
           p.prf_place as "Занятое место"
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
    ON elm_info.fig_id = p.prf_fig and p.prf_comp = elm_info.cmp_id;

-- второе сложное представление
-- статистика исполнений всех элементов на соревнованиях
-- соревнование - элемент - сколько раз был исполнен за соревнование всеми фигуристами,
-- выступавшими на соревновании

DROP VIEW IF EXISTS view_figure_skating.v_stat_elem_competitions;
CREATE VIEW view_figure_skating.v_stat_elem_competitions AS
    SELECT c.cmp_city as "Город соревнования",
           e.elm_name as "Название элемента",
           count(*) as "Количество исполнений"
    FROM figure_skating.competition as c
    LEFT JOIN figure_skating.performance as p
    ON c.cmp_id = p.prf_comp
    LEFT JOIN figure_skating.performance_x_element as pe
    ON p.prf_id = pe.prf_id
    LEFT JOIN figure_skating.element as e
    ON pe.elm_id = e.elm_id and pe.elm_st_date = e.elm_st_date
    GROUP BY c.cmp_city, e.elm_name
    ORDER BY c.cmp_city, e.elm_name;

-- третье сложное представление
-- для каждой федерации получим информацию о количестве судей, проведенных соревнований
-- и фигуристов этой федерации

DROP VIEW IF EXISTS view_figure_skating.v_stat_federation;
CREATE VIEW view_figure_skating.v_stat_federation AS
    SELECT fed.fdr_country as "Страна федерации",
           coalesce(fig_stat.num_figs, 0) as "Число фигуристов",
           coalesce(jdg_stat.num_judges, 0) as "Число судей",
           coalesce(cmp_stat.num_cmps, 0) as "Число соревнований"
    FROM figure_skating.federation as fed
    LEFT JOIN (SELECT f.fig_fdr, count(*) as num_figs
               FROM figure_skating.figure_skater as f
               GROUP BY f.fig_fdr) as fig_stat
    ON fed.fdr_id = fig_stat.fig_fdr
    LEFT JOIN (SELECT j.jdg_fdr, count(*) as num_judges
               FROM figure_skating.judge as j
               GROUP BY j.jdg_fdr) as jdg_stat
    ON fed.fdr_id = jdg_stat.jdg_fdr
    LEFT JOIN (SELECT c.cmp_fdr, count(*) as num_cmps
               FROM figure_skating.competition as c
               GROUP BY c.cmp_fdr) as cmp_stat
    ON fed.fdr_id = cmp_stat.cmp_fdr;
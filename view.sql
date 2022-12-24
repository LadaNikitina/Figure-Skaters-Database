-- create schema
DROP SCHEMA IF EXISTS view_figure_skating CASCADE;
CREATE SCHEMA view_figure_skating;

-- create views
DROP VIEW IF EXISTS view_figure_skating.v_competition;
CREATE VIEW view_figure_skating.v_competition AS
    SELECT cmp_city as "Город соревнования",
           REGEXP_REPLACE(cmp_date::text, '..-..-.', '**-**-*', 'g') as "Дата соревнования",
           CASE WHEN cmp_isu = true THEN 'Под эгидой ISU' ELSE 'Не под эгидой ISU' END as "Тип соревнования"
    FROM figure_skating.competition;

DROP VIEW IF EXISTS view_figure_skating.v_element;
CREATE VIEW view_figure_skating.v_element AS
    SELECT REGEXP_REPLACE(elm_name, '.*', '*') as "Название элемента",
           elm_cost as "Стоимость элемента",
           elm_level as "Уровень элемента"
    FROM figure_skating.element
    WHERE elm_is_act;

DROP VIEW IF EXISTS view_figure_skating.v_federation;
CREATE VIEW view_figure_skating.v_federation AS
    SELECT fdr_country as "Страна федерации",
           fdr_head as "Президент федерации",
           REGEXP_REPLACE(fdr_date::text, '..-..-.', '**-**-*', 'g') as "Дата основания федерации"
    FROM figure_skating.federation;

DROP VIEW IF EXISTS view_figure_skating.v_figure_skater;
CREATE VIEW view_figure_skating.v_figure_skater AS
    SELECT fig_name as "Имя фигуриста",
           REGEXP_REPLACE(fig_date::text, '..-..-.', '**-**-*', 'g') as "Дата рождения фигуриста",
           fig_rate as "Рейтинг фигуриста"
    FROM figure_skating.figure_skater;

DROP VIEW IF EXISTS view_figure_skating.v_judge;
CREATE VIEW view_figure_skating.v_judge AS
    SELECT REGEXP_REPLACE(jdg_name, '(.*) (.*)', '\1 *****', 'g') as "Имя судьи",
           jdg_cat as "Категория судьи"
    FROM figure_skating.judge;

DROP VIEW IF EXISTS view_figure_skating.v_judge_x_competition;
CREATE VIEW view_figure_skating.v_judge_x_competition AS
    SELECT 'Эта таблица содержит суррогатные ключи' as "Служебная таблица"
    FROM figure_skating.judge_x_competition;

DROP VIEW IF EXISTS view_figure_skating.performance;
CREATE VIEW view_figure_skating.performance AS
    SELECT prf_points as "Сумма баллов",
           CASE WHEN prf_ded = true THEN 'Чистый прокат' ELSE 'Грязный прокат' END as "Чистота проката",
           REGEXP_REPLACE(prf_place::text, '.*', '*') as "Занятое место"
    FROM figure_skating.performance;

DROP VIEW IF EXISTS view_figure_skating.performance_x_element;
CREATE VIEW view_figure_skating.performance_x_element AS
    SELECT 'Эта таблица содержит суррогатные ключи' as "Служебная таблица"
    FROM figure_skating.performance_x_element;
-- запросы для таблицы с элементами
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(7, '2015-11-30', '9999-12-31', True, False, 'Сальхов', 4, 8.34);
DELETE FROM figure_skating.element WHERE elm_id = 7 and elm_st_date = '2015-11-30';
SELECT elm_name, elm_level FROM figure_skating.element WHERE elm_is_act = True;
UPDATE figure_skating.element SET elm_name = 'Сальхов', elm_cost = 8.34 WHERE elm_name = 'Тулуп';

-- запросы для таблицы с выступлениями
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(10, 1, 3, 20.31, True, 4);
DELETE FROM figure_skating.performance WHERE prf_id = 10;
SELECT prf_comp, prf_fig, prf_points FROM figure_skating.performance WHERE prf_points > 40.0;
UPDATE figure_skating.performance SET prf_points = 52.05 WHERE prf_id = 4;

-- заполним таблицу federation
INSERT INTO figure_skating.federation(fdr_id, fdr_country, fdr_head, fdr_date)
                               VALUES(1, 'Россия', 'Александр Коган', '1992-01-01');
INSERT INTO figure_skating.federation(fdr_id, fdr_country, fdr_head, fdr_date)
                               VALUES(2, 'Япония', 'Сэйко Хасимото', '1929-05-24');
INSERT INTO figure_skating.federation(fdr_id, fdr_country, fdr_head, fdr_date)
                               VALUES(3, 'Китай', 'Чжу Юньбин', '2018-03-27');
INSERT INTO figure_skating.federation(fdr_id, fdr_country, fdr_head, fdr_date)
                               VALUES(4, 'США', 'Патриция Сент Питер', '1921-07-02');
INSERT INTO figure_skating.federation(fdr_id, fdr_country, fdr_head, fdr_date)
                               VALUES(5, 'Италия', 'Флавио Рода', '1908-09-01');

-- заполним таблицу figure skater
INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
                                  VALUES(1, 1, 'Анна Щербакова', '2004-03-28', 3);
INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
                                  VALUES(2, 2, 'Юдзуру Ханю', '1994-12-07', 24);
INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
                                  VALUES(3, 2, 'Каори Сакамото', '2000-04-09', 1);
INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
                                  VALUES(4, 4, 'Нэтан Чен', '1999-05-05', 6);
INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
                                  VALUES(5, 5, 'Маттео Риццо', '1998-09-05', 5);

-- заполним таблицу judge
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(1, 1, 'Алла Шеховцова', 5);
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(2, 1, 'Елена Фомина', 4);
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(3, 2, 'Син Сабури', 5);
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(4, 3, 'Хэ Цзюн', 3);
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(5, 4, 'Томас Джефферсон', 5);
INSERT INTO figure_skating.judge(jdg_id, jdg_fdr, jdg_name, jdg_cat)
                          VALUES(6, 5, 'Лаура Антонелли', 4);

-- заполним таблицу competition
INSERT INTO figure_skating.competition(cmp_id, cmp_fdr, cmp_city, cmp_date, cmp_isu)
                                VALUES(1, 3, 'Пекин', '2022-02-18', True);
INSERT INTO figure_skating.competition(cmp_id, cmp_fdr, cmp_city, cmp_date, cmp_isu)
                                VALUES(2, 3, 'Харбин', '2021-10-15', False);
INSERT INTO figure_skating.competition(cmp_id, cmp_fdr, cmp_city, cmp_date, cmp_isu)
                                VALUES(3, 2, 'Токио', '2022-04-03', True);
INSERT INTO figure_skating.competition(cmp_id, cmp_fdr, cmp_city, cmp_date, cmp_isu)
                                VALUES(4, 1, 'Сочи', '2021-12-26', True);
INSERT INTO figure_skating.competition(cmp_id, cmp_fdr, cmp_city, cmp_date, cmp_isu)
                                VALUES(5, 5, 'Рим', '2022-11-12', False);


-- заполним таблицу element
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(1, '2022-09-01', '9999-12-31', True, False, 'Лутц', 4, 10.71);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(1, '2019-05-31', '2022-09-01', False, True, 'Лутц', 4, 11.54);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(2, '2022-01-05', '9999-12-31', True, False, 'Флип', 4, 10.36);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(2, '2017-04-26', '2022-01-05', False, True, 'Флип', 4, 9.89);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(3, '2016-03-11', '9999-12-31', True, False, 'Аксель', 3, 8.12);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(4, '2017-12-09', '9999-12-31', True, False, 'Тулуп', 4, 9.18);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(5, '2019-07-20', '9999-12-31', True, False, 'Вращение', 2, 4.51);
INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
                                   elm_is_del, elm_name, elm_level, elm_cost)
                            VALUES(6, '2011-02-01', '9999-12-31', True, False, 'Дорожка', 1, 1.24);

-- заполним таблицу performance
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(1, 1, 1, 39.56, False, 1);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(2, 2, 2, 52.25, True, 4);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(3, 1, 4, 56.91, False, 1);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(4, 3, 4, 51.88, True, 2);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(5, 4, 1, 36.19, True, 2);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(6, 4, 3, 12.53, True, 7);
INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
                                VALUES(7, 5, 5, 18.58, True, 9);

-- заполним таблицу judge_X_competition
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(5, 1);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(3, 1);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(1, 2);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(6, 2);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(3, 3);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(4, 3);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(1, 3);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(6, 4);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(2, 5);
INSERT INTO figure_skating.judge_x_competition(jdg_id, cmp_id) VALUES(6, 5);

-- заполним таблицу performance_X_element
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(7, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(7, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(6, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(5, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(5, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(5, 4, '2017-12-09');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(4, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(4, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(4, 4, '2017-12-09');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(4, 3, '2016-03-11');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(3, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(3, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(3, 2, '2022-01-05');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(3, 1, '2019-05-31');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(2, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(2, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(2, 2, '2017-04-26');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(2, 3, '2016-03-11');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(1, 5, '2019-07-20');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(1, 6, '2011-02-01');
INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date) VALUES(1, 1, '2019-05-31');
-- на вход процедуре передаются:
-- номер фигуриста
-- номер соревнования
-- сумма баллов за выступление
-- занятое место
-- набор элементов, выполненных в рамках соревнования по id

-- добавляем в таблицу performance и performance_x_element соответствующую информацию
-- ВАЖНО: функция сама определяет, какая версия у элемента

-- если фигуриста с таким номером нет, выход
-- если соревнования с таким номером нет, выход
-- если у такого фигуриста уже есть выступление на этом соревновании, выход
-- коммит выступления
-- если среди выполненных элементов какого-то нет, откат до коммита

CREATE OR REPLACE PROCEDURE insert_performance(figurist_id int,
                                    competition_id int,
                                    points real,
                                    place int,
                                    dedaction bool,
                                    elem_ids int[])
LANGUAGE plpgsql
AS
$$
    DECLARE
        element_id int;
        competition_date date;
        start_date date;
        performance_id int := (SELECT max(prf_id) + 1 FROM figure_skating.performance);
    BEGIN
        IF (SELECT count(*) FROM figure_skating.figure_skater
                            WHERE fig_id = figurist_id) = 0 THEN
            RAISE EXCEPTION 'no figurist';
        END IF;

        IF (SELECT count(*) FROM figure_skating.competition
                            WHERE cmp_id = competition_id) = 0 THEN
            RAISE EXCEPTION 'no competition';
        END IF;

        IF (SELECT count(*) FROM figure_skating.performance
                            WHERE prf_comp = competition_id and
                                  prf_fig = figurist_id) <> 0 THEN
            RAISE EXCEPTION 'performance already exists';
        END IF;

        INSERT INTO figure_skating.performance(prf_id, prf_comp, prf_fig, prf_points, prf_ded, prf_place)
        VALUES (performance_id, competition_id, figurist_id, points, dedaction, place);

        COMMIT;

        competition_date = (SELECT cmp_date FROM figure_skating.competition WHERE cmp_id = competition_id);

        FOREACH element_id IN ARRAY elem_ids
        LOOP
            IF (SELECT count(*) FROM figure_skating.element
                            WHERE element_id = elm_id) = 0 THEN
                ROLLBACK;
                EXIT;
            ELSE
                start_date := (SELECT elm_st_date FROM figure_skating.element
                                                  WHERE elm_id = element_id and
                                                        competition_date <= elm_end_date and
                                                        competition_date >= element.elm_st_date);
                INSERT INTO figure_skating.performance_x_element(prf_id, elm_id, elm_st_date)
                VALUES (performance_id, element_id, start_date);
            END IF;
        END LOOP;
    END
$$;

-- проверка на корректность
-- такого фигуриста нет
-- CALL insert_performance(10, 3, 24.32, 5, true, ARRAY [1, 5, 6]);
-- ничего не изменилось, как и должно было

-- такого соревнования нет
-- CALL insert_performance(3, 12, 24.32, 5, true, ARRAY [1, 5, 6]);
-- ничего не изменилось, как и должно было

-- у фигуриста есть выступление на соревновании
-- CALL insert_performance(3, 4, 24.32, 5, true, ARRAY [1, 5, 6]);
-- ничего не изменилось, как и должно было

-- одного из элементов нет
-- CALL insert_performance(3, 2, 24.32, 5, true, ARRAY [5, 9]);
-- DELETE FROM figure_skating.performance WHERE prf_fig = 3 and prf_comp = 2;
-- в performance появилось выступление, но в performance_x_element - ничего

-- все хорошо
-- CALL insert_performance(3, 2, 24.32, 5, true, ARRAY [4, 5]);
-- DELETE FROM figure_skating.performance_x_element WHERE prf_id = 10;
-- DELETE FROM figure_skating.performance WHERE prf_fig = 3 and prf_comp = 2;

-- все хорошо, проверка корректной версионности
-- есть версионный элемент - флип (2)
-- два соревнования:
-- одно, где у флипа старая стоимость (4 - Сочи)
-- одно, где у флипа новая стоимость (1 - Пекин)
-- CALL insert_performance(2, 4, 47.19, 6, true, ARRAY [1, 2]);
-- CALL insert_performance(2, 1, 50.01, 7, false, ARRAY [1, 2]);



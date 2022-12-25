-- первый триггер

CREATE OR REPLACE FUNCTION trigger_add_in_elements()
    RETURNS TRIGGER
    AS
$$
    BEGIN
        IF NEW.elm_is_act = true THEN
            IF (SELECT count(*) FROM figure_skating.element
            WHERE elm_id = NEW.elm_id and elm_is_act = true) = 1 THEN
                UPDATE figure_skating.element SET elm_is_act = false,
                                                  elm_is_del = true,
                                                  elm_end_date = NEW.elm_st_date - 1
                WHERE elm_id = NEW.elm_id and elm_is_act = true;
            END IF;
        END IF;

        RETURN NEW;

    END
$$  LANGUAGE plpgsql;

-- логика триггера: если добавляем новый элемент в таблицу, заявленный как актуальный
-- проверяем, есть ли актуальный такой же элемент в таблице
-- если есть, делаем его неактуальным

CREATE TRIGGER trigger_element
   BEFORE INSERT
   ON figure_skating.element
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_add_in_elements();

-- проверка на корректность
-- создадим таблицы (запустим скрипт create, запустим код, создающий триггеры, запустим скрипт insert)
-- актуальная запись с лутцом уже есть в таблице, проверим, что изменится, если добавить новую запись с лутцом

-- INSERT INTO figure_skating.element(elm_id, elm_st_date, elm_end_date, elm_is_act,
--                                   elm_is_del, elm_name, elm_level, elm_cost)
--                            VALUES(1, '2022-12-25', '9999-12-31', True, False, 'Лутц', 4, 12.56);
-- в таблице будет 2 неактуальных записи с лутцом и одна актуальная от 25.12.2022

-- второй триггер

CREATE OR REPLACE FUNCTION trigger_add_or_update_skater()
    RETURNS TRIGGER
    AS
$$
    BEGIN
        IF NOT NEW.fig_name ~ '^[А-Я][а-я]+ [А-Я][А-Яа-я]+' THEN
            RAISE EXCEPTION 'wrong name of figurist';
        END IF;

        IF date_part('year', age(NOW()::date, NEW.fig_date)) < 15 THEN
            RAISE EXCEPTION 'too young figurist';
        END IF;

        RETURN NEW;
    END
$$ LANGUAGE plpgsql;

-- логика триггера:
-- если неправильное имя, выдадим соответствующую ошибку
-- если фигурист слишком молодой, выдадим соответствующую ошибку

CREATE TRIGGER trigger_skater
    BEFORE INSERT OR UPDATE
    ON figure_skating.figure_skater
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_add_or_update_skater();

-- проверка на корректность

-- напишем неправильно имя
-- INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
--     VALUES(6, 1, 'абракадабра', '2000-12-01', 8);

-- добавим слишком молодого фигуриста
-- INSERT INTO figure_skating.figure_skater(fig_id, fig_fdr, fig_name, fig_date, fig_rate)
--     VALUES(7, 1, 'Рита Базылюк', '2019-12-01', 8);

-- UPDATE figure_skating.figure_skater SET fig_date = '2019-12-01' WHERE fig_id = 1;


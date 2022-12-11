-- create schema
DROP SCHEMA IF EXISTS figure_skating CASCADE;
CREATE SCHEMA figure_skating;

-- create table federation
DROP TABLE IF EXISTS figure_skating.federation;
CREATE TABLE figure_skating.federation (
 fdr_id        INT,
 fdr_country   TEXT,
 fdr_head      TEXT,
 fdr_date      DATE,
 CONSTRAINT federation_id PRIMARY KEY(fdr_id),
 CONSTRAINT federation_country_unique UNIQUE(fdr_country)
);

-- create table figure skater
DROP TABLE IF EXISTS figure_skating.figure_skater;
CREATE TABLE figure_skating.figure_skater (
 fig_id        INT,
 fig_fdr       INT NOT NULL,
 fig_name      TEXT,
 fig_date      DATE,
 fig_rate      SERIAL,
 CONSTRAINT figure_skater_id PRIMARY KEY(fig_id),
 CONSTRAINT figure_skater_fdr FOREIGN KEY(fig_fdr) REFERENCES figure_skating.federation(fdr_id)
);

-- create table judge
DROP TABLE IF EXISTS figure_skating.judge;
CREATE TABLE figure_skating.judge (
 jdg_id        INT,
 jdg_fdr       INT NOT NULL,
 jdg_name      TEXT,
 jdg_cat       SERIAL NOT NULL,
 CONSTRAINT judge_id PRIMARY KEY(jdg_id),
 CONSTRAINT judge_fdr FOREIGN KEY(jdg_fdr) REFERENCES figure_skating.federation(fdr_id),
 CONSTRAINT judge_category CHECK(jdg_cat < 6)
);

-- create table competition
DROP TABLE IF EXISTS figure_skating.competition;
CREATE TABLE figure_skating.competition (
 cmp_id        INT,
 cmp_fdr       INT NOT NULL,
 cmp_city      TEXT NOT NULL,
 cmp_date      DATE NOT NULL,
 cmp_isu       BOOLEAN DEFAULT False,
 CONSTRAINT competition_id PRIMARY KEY(cmp_id),
 CONSTRAINT competition_fdr FOREIGN KEY(cmp_fdr) REFERENCES figure_skating.federation(fdr_id)
);

-- create table element
DROP TABLE IF EXISTS figure_skating.element;
CREATE TABLE figure_skating.element (
 elm_id        INT,
 elm_st_date   DATE NOT NULL,
 elm_end_date  DATE NOT NULL,
 elm_is_act    BOOLEAN NOT NULL,
 elm_is_del    BOOLEAN NOT NULL,
 elm_name      TEXT NOT NULL,
 elm_level     SERIAL NOT NULL,
 elm_cost      REAL NOT NULL,
 CONSTRAINT element_primary_key PRIMARY KEY(elm_id, elm_st_date),
 CONSTRAINT element_check CHECK(elm_level < 5 and elm_cost > 0),
 CONSTRAINT element_is_act_check CHECK(elm_is_act != elm_is_del),
 CONSTRAINT element_version_check CHECK(elm_is_act = False or (elm_is_act = True and elm_end_date = '9999-12-31'))
);

-- create table performance
DROP TABLE IF EXISTS figure_skating.performance;
CREATE TABLE figure_skating.performance (
 prf_id        INT,
 prf_comp      INt NOT NUll,
 prf_fig       INT NOT NULL,
 prf_points    REAL NOT NULL,
 prf_ded       BOOLEAN DEFAULT True,
 prf_place     SERIAL,
 CONSTRAINT performance_id PRIMARY KEY(prf_id),
 CONSTRAINT performance_comp FOREIGN KEY(prf_comp) REFERENCES figure_skating.competition(cmp_id),
 CONSTRAINT performance_fig FOREIGN KEY(prf_fig) REFERENCES figure_skating.figure_skater(fig_id),
 CONSTRAINT performance_points CHECK(prf_points > 0)
);

-- create table judge_X_competition
DROP TABLE IF EXISTS figure_skating.judge_X_competition;
CREATE TABLE figure_skating.judge_X_competition (
 jdg_id        INT,
 cmp_id        INT,
 CONSTRAINT judge_X_competition_primary_key PRIMARY KEY(jdg_id, cmp_id),
 CONSTRAINT judge_X_competition_judge FOREIGN KEY(jdg_id) REFERENCES figure_skating.judge(jdg_id),
 CONSTRAINT judge_X_competition_competition FOREIGN KEY(cmp_id) REFERENCES figure_skating.competition(cmp_id)
);

-- create table performance_X_element
DROP TABLE IF EXISTS figure_skating.performance_X_element;
CREATE TABLE figure_skating.performance_X_element (
 prf_id        INT,
 elm_id        INT,
 elm_st_date   DATE,
 CONSTRAINT performance_X_element_primary_key PRIMARY KEY(prf_id, elm_id, elm_st_date),
 CONSTRAINT performance_X_element_performance FOREIGN KEY(prf_id) REFERENCES figure_skating.performance(prf_id),
 CONSTRAINT performance_X_element_element FOREIGN KEY(elm_id, elm_st_date)
     REFERENCES figure_skating.element(elm_id, elm_st_date)
);
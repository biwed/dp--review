CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE somet(
    id uuid PRIMARY key, 
    number INTEGER,
    text text
);

INSERT INTO somet
SELECT
     uuid_generate_v1()
    , round(random() * 1000000)
    , round(random() * 1000000)::text 
FROM generate_series(1,1000);

CREATE TABLE public.dim_date as
WITH date_series AS (
    SELECT
        DATE(GENERATE_SERIES(DATE '2018-01-01', DATE '2021-01-10','1 day')) AS date
)
SELECT
      date
    , EXTRACT(DAY FROM date) AS day
    , EXTRACT(MONTH FROM date) AS month
    , EXTRACT(QUARTER FROM date) AS quarter
    , EXTRACT(YEAR FROM date) AS year
    , EXTRACT(WEEK FROM date) AS week
FROM
    date_series;

CREATE TABLE foo (fooid INT, foosubid INT, fooname TEXT);
INSERT INTO foo VALUES (1, 2, 'three');
INSERT INTO foo VALUES (4, 5, 'six');

CREATE OR REPLACE FUNCTION get_all_foo() RETURNS SETOF foo AS
$BODY$
DECLARE
    r foo%rowtype;
BEGIN
    FOR r IN
        SELECT * FROM foo WHERE fooid > 0
    LOOP
        -- здесь возможна обработка данных
        RETURN NEXT r; -- возвращается текущая строка запроса
    END LOOP;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

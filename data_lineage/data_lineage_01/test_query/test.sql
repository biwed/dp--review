
select count(*) from somet AS t where t.number in( 1000, 11000, 120)
select count(*) from somet where number < 1000


EXPLAIN (FORMAT JSON, VERBOSE)
select count(*) from somet where number < 1000

EXPLAIN (FORMAT JSON, VERBOSE)
SELECT *
FROM public.dim_date AS dt
WHERE dt."date" BETWEEN '2019-01-01'::date AND '2019-12-31'::date

EXPLAIN (FORMAT JSON, VERBOSE)
SELECT * FROM get_all_foo();
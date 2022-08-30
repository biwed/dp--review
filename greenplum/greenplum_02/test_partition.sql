CREATE EXTENSION IF NOT EXISTS pxf;
CREATE TABLESPACE warm LOCATION '/data1/warm'

SELECT *
FROM pg_catalog.pg_tablespace;

CREATE TABLE sales(
    id int,
    date date, 
    amt decimal(10,2)
)
DISTRIBUTED BY (id)
PARTITION BY RANGE (date) 
(DEFAULT PARTITION other)

/*
 * Хранится на pg_default
 * Все данные попадаю в партицию по умолчанию.
 */


INSERT INTO sales(id, "date", amt)
WITH test AS(
select
    generate_series('2010-01-01'::date, '2022-01-01'::date, '1 day'::interval) AS date
)
SELECT
    to_char(date, 'YYYYMMDD')::integer AS id
    , date
    , (
        random() * 1000
      )::int + 1 AS amt
FROM
    test;
 
 /*4384*/  
WITH test AS(
    select
        generate_series('2010-01-01'::date, '2022-01-01'::date, '1 day'::interval) AS date
    )
SELECT
    count(*)
FROM
    test;
 
 /*4384*/  
 SELECT 
    COUNT(*)
 FROM sales
 
/*
Проверяем, что таблица партиционирована и имеет партицию по умолчанию.
*/
select 
    *
from pg_catalog.pg_partitions

/*Разбиваем партицию по умолчанию на две партиции default и sales_2010*/
alter table public.sales  
split default partition 
	start ('2010-01-01'::date) inclusive end ('2011-01-01'::date) EXCLUSIVE 
into (partition sales_2010, default partition);


/*Проверяем что партиции разбита на  default и sales_2010 и обе находятся на pg_default*/
 select *
 from pg_catalog.pg_partitions
 
 
 /*4384*/
  SELECT 
    COUNT(*)
 FROM sales
 
/*Видим, что оптимизатор видит из как две партиции*/ 
explain   SELECT 
    COUNT(*)
 FROM sales

/*Обращение к партиции как к таблице*/
select 
    count(*)
from public.sales_1_prt_sales_2010

/*Нарежем еще партиций для укперементов*/
alter table public.sales  
split default partition 
	start ('2011-01-01'::date) inclusive end ('2012-01-01'::date) EXCLUSIVE 
into (partition sales_2011, default partition);

alter table public.sales  
split default partition 
	start ('2012-01-01'::date) inclusive end ('2013-01-01'::date) EXCLUSIVE 
into (partition sales_2012, default partition);


/*Подменим партицию sales_2012, на ROW AO на табличное простанство warm*/

--Migrate partition 2012 on warm RAW AO

create table temp_sales_2012 (like sales)
WITH (appendonly = 'true', compresslevel = '1', orientation = 'row', compresstype = zstd)
TABLESPACE warm; 

insert into temp_sales_2012
select *
from public.sales_1_prt_sales_2012

ALTER TABLE sales EXCHANGE PARTITION sales_2012
with table temp_sales_2012;

drop table temp_sales_2012;

select *
 from pg_catalog.pg_partitions
  
 /*4384*/
  SELECT 
    COUNT(*)
 FROM sales
 
/*--Migrate partition 2011 on warm Column AO*/
create table temp_sales_2011 (like sales)
WITH (appendonly = 'true', compresslevel = '1', orientation = 'column', compresstype = zstd)
TABLESPACE warm; 

insert into temp_sales_2011
select *
from public.sales_1_prt_sales_2011

ALTER TABLE sales EXCHANGE PARTITION sales_2011
with table temp_sales_2011;

drop table temp_sales_2011;

select *
 from pg_catalog.pg_partitions
 
 
 /*4384*/
  SELECT 
    COUNT(*)
 FROM sales

 
 explain   SELECT 
    COUNT(*)
 FROM sales


/*move partition to s3
chown gpadmin:gpadmin minio-site.xml 
*/

CREATE WRITABLE EXTERNAL TABLE sale_ext_text_write
(LIKE sales)
LOCATION ('pxf://test-bucket/sale?PROFILE=s3:text&SERVER=default&COMPRESSION_CODEC=org.apache.hadoop.io.compress.GzipCodec' ) 
ON ALL FORMAT 'TEXT' ( delimiter=',' ) ENCODING 'UTF8';

INSERT INTO sale_ext_text_write
SELECT * FROM sales_1_prt_sales_2010;


-- drop EXTERNAL TABLE temp_sale_ext_text;
CREATE EXTERNAL TABLE temp_sale_ext_text (LIKE sales)
LOCATION ('pxf://test-bucket/sale?PROFILE=s3:text&SERVER=default&COMPRESSION_CODEC=org.apache.hadoop.io.compress.GzipCodec' ) 
ON ALL FORMAT 'TEXT' ( delimiter=',' ) ENCODING 'UTF8';

SELECT id, "date", amt
FROM temp_sale_ext_text;


ALTER TABLE sales EXCHANGE PARTITION sales_2010
with table temp_sale_ext_text 
WITHOUT VALIDATION;

drop EXTERNAL TABLE sale_ext_text_write;


select *
 from pg_catalog.pg_partitions
 
 select count(*)
 from sales

 
 explain
 select count(*)
 from sales

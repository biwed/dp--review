CREATE EXTENSION IF NOT EXISTS pxf;


CREATE TABLE sales_test (
    id int
    , date date
    , amt decimal(10,2)
)
DISTRIBUTED BY (id)

INSERT INTO sales_test (id, "date", amt)
WITH test AS(
select
    generate_series('2016-01-01'::date, '2022-01-01'::date, '1 day'::interval) AS date
)
SELECT
    to_char(date, 'YYYYMMDD')::integer AS id
    , date
    , (
        random() * 1000
      )::int + 1 AS amt
FROM
    test;
 
 SELECT 
    *
 FROM sales_test
 LIMIT 100
 
 --2193
 SELECT 
    COUNT(*)
 FROM sales_test
 LIMIT 100
 
CREATE WRITABLE EXTERNAL TABLE sale_test_ext_text_write
(LIKE sales_test)
LOCATION ('pxf://test-bucket/sale-test?PROFILE=s3:text&SERVER=default&COMPRESSION_CODEC=org.apache.hadoop.io.compress.GzipCodec' ) 
ON ALL FORMAT 'TEXT' ( delimiter=',' ) ENCODING 'UTF8';

INSERT INTO sale_test_ext_text_write
SELECT * FROM sales_test;


CREATE EXTERNAL TABLE sale_test_ext_text_read (LIKE sales_test)
LOCATION ('pxf://test-bucket/sale-test?PROFILE=s3:text&SERVER=default&COMPRESSION_CODEC=org.apache.hadoop.io.compress.GzipCodec' ) 
ON ALL FORMAT 'TEXT' ( delimiter=',' ) ENCODING 'UTF8';

SELECT 
    COUNT(*)
FROM sale_test_ext_text_read

SELECT 
    *
FROM sale_test_ext_text_read
LIMIT 100

DROP EXTERNAL table sale_test_ext_text_write cascade;

DROP EXTERNAL table sale_test_ext_text_read cascade;
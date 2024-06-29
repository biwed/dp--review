create schema marts_check;
CREATE TABLE marts_check.dim_asset (
 id int NOT NULL,
 "domain" text NULL,
 "key" text NULL,
 group1 text NULL,
 group2 text NULL,
 group3 text NULL,
 "name" text NULL,
 "desc" text NULL,
 schema_fields jsonb NULL,
 asset_dicts jsonb NULL,
 "_created_dttm" timestamptz NOT NULL,
 CONSTRAINT pk__dim_asset PRIMARY KEY (id)
);
CREATE INDEX ix__dim_asset_asset_group_asset_key ON marts_check.dim_asset USING btree (domain, key);

CREATE TABLE marts_check.fact_asset_data (
 id serial4 NOT NULL,
 dim_asset_id int4 NULL,
 measure_fields jsonb NULL,
 dim_fields jsonb NULL,
 is_actual bool NULL DEFAULT true,
 date_from timestamptz NOT NULL,
 date_to timestamptz NOT NULL,
 dqp_engine_id int4 NULL,
 "_created_dttm" timestamptz NOT NULL DEFAULT now(),
 "_updated_dttm" timestamptz NOT NULL DEFAULT now(),
 "_delete_after_dttm" timestamptz NULL,
 dqp_engine_try_number int4 NULL,
 CONSTRAINT pk__fact_asset_data PRIMARY KEY (id)
);

ALTER TABLE marts_check.fact_asset_data ADD CONSTRAINT fk__fact_asset_data__dim_asset_id__dim_asset FOREIGN KEY (dim_asset_id) REFERENCES marts_check.dim_asset(id);

INSERT INTO marts_check.dim_asset (id, "domain","key",group1,group2,group3,"name","desc",schema_fields,asset_dicts,"_created_dttm") VALUES
  (1,'demo','afff2a23-22dc-46ae-bc7a-d9048fe2062c','leader','adb','asset gp','leader last week tunover and count','Week asset for leader project','{"dimDate": "opened_date", "measures": {"turnover_gp": {"desc": "Count of object in ADB for objects", "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "pgType": "integer"}}, "dimensions": null}','null','2023-06-15 12:16:13.160'),
  (2,'demo','5a216828-668c-407a-9a80-835242af5800','leader','click house','leader asset click','leader last week tunover and count','Week asset for leader project','{"dimDate": "opened_date", "measures": {"turnover_click": {"desc": "Count of object in clickhouse for objects", "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "pgType": "integer"}}, "dimensions": null}','null','2023-06-15 13:19:50.611'),
  (3,'demo','01dee8a2-d0f8-4dbc-b34b-1c2c777c5020','leader','adb','hi42_conquest','Agg hi42_conquest','Aggregation hi42_conquest','{"dimDate": "dat_vte", "measures": {"sales_taxes_included": {"desc": "Count of object in ADB for objects", "pgType": "Numeric"}}, "dimensions": null}','null','2023-06-15 13:20:14.188');

INSERT INTO marts_check.fact_asset_data (dim_asset_id,measure_fields,dim_fields,is_actual,date_from,date_to,dqp_engine_id,"_created_dttm","_updated_dttm","_delete_after_dttm",dqp_engine_try_number) VALUES
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 100, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1000, "pgType": "integer"}}','null',true,'2023-06-02 00:00:00.000','2023-06-03 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.648',2),
  (1,'{"turnover_gp": {"de.sc": "Count of object in ADB for objects", "value": 101, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1001, "pgType": "integer"}}','null',true,'2023-06-01 00:00:00.000','2023-06-02 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.650',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 102, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1002, "pgType": "integer"}}','null',true,'2023-06-05 00:00:00.000','2023-06-06 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.650',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 103, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1003, "pgType": "integer"}}','null',true,'2023-06-03 00:00:00.000','2023-06-04 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.650',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 104, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1004, "pgType": "integer"}}','null',true,'2023-06-07 00:00:00.000','2023-06-08 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.650',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 105, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1005, "pgType": "integer"}}','null',true,'2023-06-06 00:00:00.000','2023-06-07 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.650',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 106, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1006, "pgType": "integer"}}','null',true,'2023-06-11 00:00:00.000','2023-06-12 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.652',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 107, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1007, "pgType": "integer"}}','null',true,'2023-06-09 00:00:00.000','2023-06-10 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.652',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 108, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1008, "pgType": "integer"}}','null',true,'2023-06-10 00:00:00.000','2023-06-11 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.652',2),
  (1,'{"turnover_gp": {"desc": "Count of object in ADB for objects", "value": 109, "pgType": "Numeric"}, "records_count_gp": {"desc": "Count of object in ADB for objects", "value": 1009, "pgType": "integer"}}','null',true,'2023-06-12 00:00:00.000','2023-06-13 00:00:00.000',1,'2023-06-15 13:19:21.571','2023-06-15 13:19:21.571','2024-06-14 13:19:22.652',2);
INSERT INTO marts_check.fact_asset_data (dim_asset_id,measure_fields,dim_fields,is_actual,date_from,date_to,dqp_engine_id,"_created_dttm","_updated_dttm","_delete_after_dttm",dqp_engine_try_number) VALUES
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 100, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1000, "pgType": "integer"}}','null',true,'2023-06-01 00:00:00.000','2023-06-02 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 101, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1001, "pgType": "integer"}}','null',true,'2023-06-02 00:00:00.000','2023-06-03 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 101, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1002, "pgType": "integer"}}','null',true,'2023-06-03 00:00:00.000','2023-06-04 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 104, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1003, "pgType": "integer"}}','null',true,'2023-06-04 00:00:00.000','2023-06-05 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 104, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1004, "pgType": "integer"}}','null',true,'2023-06-05 00:00:00.000','2023-06-06 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 105, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1005, "pgType": "integer"}}','null',true,'2023-06-06 00:00:00.000','2023-06-07 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 106, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1006, "pgType": "integer"}}','null',true,'2023-06-07 00:00:00.000','2023-06-08 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 107, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 1007, "pgType": "integer"}}','null',true,'2023-06-08 00:00:00.000','2023-06-09 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1),
  (2,'{"turnover_click": {"desc": "Count of object in clickhouse for objects", "value": 108, "pgType": "Numeric"}, "records_count_click": {"desc": "Count of object in clickhouse for objects", "value": 9999, "pgType": "integer"}}','null',true,'2023-06-09 00:00:00.000','2023-06-10 00:00:00.000',2,'2023-06-15 13:19:50.661','2023-06-15 13:19:50.661','2024-06-14 13:19:53.531',1);
INSERT INTO marts_check.fact_asset_data (dim_asset_id,measure_fields,dim_fields,is_actual,date_from,date_to,dqp_engine_id,"_created_dttm","_updated_dttm","_delete_after_dttm",dqp_engine_try_number) VALUES
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 87, "pgType": "Numeric"}}','null',true,'2023-05-31 00:00:00.000','2023-06-01 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.152',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 88, "pgType": "Numeric"}}','null',true,'2023-06-04 00:00:00.000','2023-06-05 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.154',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 89.19, "pgType": "Numeric"}}','null',true,'2023-06-09 00:00:00.000','2023-06-10 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.154',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 90, "pgType": "Numeric"}}','null',true,'2023-06-06 00:00:00.000','2023-06-07 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.154',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 91, "pgType": "Numeric"}}','null',true,'2023-06-13 00:00:00.000','2023-06-14 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.154',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 92, "pgType": "Numeric"}}','null',true,'2023-06-07 00:00:00.000','2023-06-08 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.154',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 93, "pgType": "Numeric"}}','null',true,'2023-06-01 00:00:00.000','2023-06-02 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.156',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 94, "pgType": "Numeric"}}','null',true,'2023-06-02 00:00:00.000','2023-06-03 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.156',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 95, "pgType": "Numeric"}}','null',true,'2023-06-11 00:00:00.000','2023-06-12 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.156',1),
  (3,'{"sales_taxes_included": {"desc": "Count of object in ADB for objects", "value": 96, "pgType": "Numeric"}}','null',true,'2023-06-05 00:00:00.000','2023-06-06 00:00:00.000',3,'2023-06-15 13:20:14.231','2023-06-15 13:20:14.231','2024-06-14 13:20:15.156',1);

/*Сравнение asset 'afff2a23-22dc-46ae-bc7a-d9048fe2062c', '5a216828-668c-407a-9a80-835242af5800', '01dee8a2-d0f8-4dbc-b34b-1c2c777c5020'*/
SELECT 
    fad.date_from AS date_actual,
    max((fad.measure_fields->'turnover_gp'->>'value')::numeric(18,2)) filter(WHERE da."key" = 'afff2a23-22dc-46ae-bc7a-d9048fe2062c') AS turnover_gp,
    max((fad.measure_fields->'turnover_click'->>'value')::numeric(18,2)) filter(WHERE da."key" = '5a216828-668c-407a-9a80-835242af5800') AS turnover_click,
    max((fad.measure_fields->'sales_taxes_included'->>'value')::numeric(18,2)) filter(WHERE da."key" = '01dee8a2-d0f8-4dbc-b34b-1c2c777c5020') AS sales_taxes_included
FROM 
    marts_check.dim_asset da 
INNER JOIN marts_check.fact_asset_data fad 
    ON da.id = fad.dim_asset_id 
WHERE 
    da."key" IN ('afff2a23-22dc-46ae-bc7a-d9048fe2062c', '5a216828-668c-407a-9a80-835242af5800', '01dee8a2-d0f8-4dbc-b34b-1c2c777c5020')
    AND fad.is_actual
GROUP BY date_actual  

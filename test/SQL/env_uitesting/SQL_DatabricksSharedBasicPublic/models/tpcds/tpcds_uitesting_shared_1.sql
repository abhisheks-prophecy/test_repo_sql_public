WITH SQLStatement_1 AS (

  SELECT 
    substr(w_warehouse_name, 1, 20),
    sm_type,
    cc_name,
    sum(CASE
      WHEN (cs_ship_date_sk - cs_sold_date_sk <= 30)
        THEN 1
      ELSE 0
    END) AS days_30,
    sum(CASE
      WHEN (cs_ship_date_sk - cs_sold_date_sk > 30) and 
                       (cs_ship_date_sk - cs_sold_date_sk <= 60)
        THEN 1
      ELSE 0
    END) AS days_31_60,
    sum(CASE
      WHEN (cs_ship_date_sk - cs_sold_date_sk > 60) and 
                       (cs_ship_date_sk - cs_sold_date_sk <= 90)
        THEN 1
      ELSE 0
    END) AS days_61_90,
    sum(CASE
      WHEN (cs_ship_date_sk - cs_sold_date_sk > 90) and
                       (cs_ship_date_sk - cs_sold_date_sk <= 120)
        THEN 1
      ELSE 0
    END) AS days_90_120,
    sum(CASE
      WHEN (cs_ship_date_sk - cs_sold_date_sk > 120)
        THEN 1
      ELSE 0
    END) AS days_more_than_120
  
  FROM spark_catalog.qa_database.catalog_sales, spark_catalog.qa_database.warehouse, spark_catalog.qa_database.ship_mode, spark_catalog.qa_database.call_center, spark_catalog.qa_database.date_dim
  
  WHERE d_month_seq BETWEEN 1200 and 1200 + 11 and cs_ship_date_sk = d_date_sk and cs_warehouse_sk = w_warehouse_sk and cs_ship_mode_sk = sm_ship_mode_sk and cs_call_center_sk = cc_call_center_sk
  
  GROUP BY 
    substr(w_warehouse_name, 1, 20), sm_type, cc_name
  
  ORDER BY substr(w_warehouse_name, 1, 20), sm_type, cc_name
  
  LIMIT 100

),

date_dim AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'date_dim') }}

),

store_sales AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'store_sales') }}

),

item AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'item') }}

),

SQLStatement_2 AS (

  SELECT 
    i_item_id,
    i_item_desc,
    i_category,
    i_class,
    i_current_price,
    sum(ss_ext_sales_price) AS itemrevenue,
    sum(ss_ext_sales_price) * 100 / sum(sum(ss_ext_sales_price)) OVER (PARTITION BY i_class) AS revenueratio
  
  FROM store_sales, item, date_dim
  
  WHERE ss_item_sk = i_item_sk and i_category IN ('Women', 'Electronics', 'Shoes') and ss_sold_date_sk = d_date_sk and d_date BETWEEN CAST('2002-05-27' AS date) and dateadd(DAY, 30, to_date('2002-05-27'))
  
  GROUP BY 
    i_item_id, i_item_desc, i_category, i_class, i_current_price
  
  ORDER BY i_category, i_class, i_item_id, i_item_desc, revenueratio

),

SQLStatement_3 AS (

  SELECT *
  
  FROM (
    SELECT count(*) AS h8_30_to_9
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 8 and time_dim.t_minute >= 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s1, (
    SELECT count(*) AS h9_to_9_30
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 9 and time_dim.t_minute < 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s2, (
    SELECT count(*) AS h9_30_to_10
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 9 and time_dim.t_minute >= 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s3, (
    SELECT count(*) AS h10_to_10_30
    
    FROM store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 10 and time_dim.t_minute < 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s4, (
    SELECT count(*) AS h10_30_to_11
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 10 and time_dim.t_minute >= 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s5, (
    SELECT count(*) AS h11_to_11_30
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 11 and time_dim.t_minute < 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s6, (
    SELECT count(*) AS h11_30_to_12
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 11 and time_dim.t_minute >= 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s7, (
    SELECT count(*) AS h12_to_12_30
    
    FROM spark_catalog.qa_database.store_sales, spark_catalog.qa_database.household_demographics, spark_catalog.qa_database.time_dim, spark_catalog.qa_database.store
    
    WHERE ss_sold_time_sk = time_dim.t_time_sk and ss_hdemo_sk = household_demographics.hd_demo_sk and ss_store_sk = s_store_sk and time_dim.t_hour = 12 and time_dim.t_minute < 30 and ((household_demographics.hd_dep_count = 0 and household_demographics.hd_vehicle_count <= 0 + 2) or
              (household_demographics.hd_dep_count = 1 and household_demographics.hd_vehicle_count <= 1 + 2) or
              (household_demographics.hd_dep_count = -1 and household_demographics.hd_vehicle_count <= -1 + 2)) and store.s_store_name = 'ese'
   ) AS s8

),

Join_1 AS (

  SELECT 
    in0.`substr(w_warehouse_name, 1, 20)` AS substrw_warehouse_name120,
    in0.sm_type AS sm_type,
    in0.cc_name AS cc_name,
    in0.days_30 AS days_30,
    in0.days_31_60 AS days_31_60,
    in0.days_61_90 AS days_61_90,
    in0.days_90_120 AS days_90_120,
    in0.days_more_than_120 AS days_more_than_120,
    in1.i_item_id AS i_item_id,
    in2.h8_30_to_9 AS h8_30_to_9
  
  FROM SQLStatement_1 AS in0
  INNER JOIN SQLStatement_2 AS in1
     ON in0.cc_name != in1.i_item_desc
  INNER JOIN SQLStatement_3 AS in2
     ON in1.i_current_price != in2.h8_30_to_9

)

SELECT *

FROM Join_1

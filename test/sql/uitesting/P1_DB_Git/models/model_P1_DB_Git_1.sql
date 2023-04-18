{{
  config({    
    "materialized": "view"
  })
}}

{% set v_int_p1 = 10 %}

WITH all_type_parquet AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'all_type_parquet') }}

),

Reformat_1 AS (

  SELECT 
    c_tinyint AS c_tinyint,
    c_smallint AS c_smallint,
    c_int AS c_int,
    c_bigint AS c_bigint,
    c_float AS c_float,
    c_double AS c_double,
    c_string AS c_string,
    c_boolean AS c_boolean,
    c_array AS c_array,
    c_struct AS c_struct,
    concat({{ var('v_project_int_p1')}}, {{ P1_DB_Git.qa_concat_p1('c_string', "'test random'") }}) AS c_macro
  
  FROM all_type_parquet AS in0

)

SELECT *

FROM Reformat_1

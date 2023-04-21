WITH all_type_parquet AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'all_type_parquet') }}

),

Reformat_1 AS (

  SELECT * 
  
  FROM all_type_parquet AS in0

),

raw_customers AS (

  SELECT * 
  
  FROM {{ ref('raw_customers')}}

),

Join_1 AS (

  SELECT 
    in1.c_tinyint AS c_tinyint,
    in1.c_smallint AS c_smallint,
    in1.c_int AS c_int,
    in1.c_bigint AS c_bigint,
    in1.c_float AS c_float,
    in1.c_double AS c_double,
    in1.c_string AS c_string,
    in1.c_boolean AS c_boolean,
    in1.c_array AS c_array,
    in1.c_struct AS c_struct
  
  FROM raw_customers AS in0
  INNER JOIN Reformat_1 AS in1
     ON in0.first_name != in1.c_string

)

SELECT *

FROM Join_1

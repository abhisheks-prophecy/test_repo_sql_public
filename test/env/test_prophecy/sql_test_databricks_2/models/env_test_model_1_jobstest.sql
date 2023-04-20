WITH all_type_non_partitioned AS (

  SELECT * 
  
  FROM {{ source('spark_catalog.qa_database', 'all_type_non_partitioned') }}

),

service_classif AS (

  SELECT * 
  
  FROM {{ ref('service_classif')}}

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
  
  FROM service_classif AS in0
  INNER JOIN all_type_non_partitioned AS in1
     ON in0.code_1 != in1.c_string

)

SELECT *

FROM Join_1

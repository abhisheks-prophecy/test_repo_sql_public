WITH all_type_table AS (

  {#kiran comment#}
  SELECT * 
  
  FROM {{ source('alias_prophecy_qa_qa_test_dataset', 'all_type_table') }}

),

raw_payments AS (

  {#kiran comment#}
  SELECT * 
  
  FROM {{ ref('raw_payments')}}

),

Join_1 AS (

  SELECT 
    in0.c_int64 AS c_int64,
    in0.c_bignumeric AS c_bignumeric,
    in0.c_bool AS c_bool,
    in0.c_bytes AS c_bytes,
    in0.c_string AS c_string,
    in0.c_float64 AS c_float64,
    in0.c_numeric_1 AS c_numeric_1,
    in0.c_numeric_2 AS c_numeric_2,
    in0.c_date AS c_date,
    in0.c_interval AS c_interval,
    in0.c_time AS c_time,
    in0.c_timestamp AS c_timestamp,
    in0.c_datetime AS c_datetime,
    in0.c_geography AS c_geography,
    in0.c_json AS c_json,
    in0.c_array_int64 AS c_array_int64,
    in0.c_struct AS c_struct,
    in0.p_date AS p_date
  
  FROM all_type_table AS in0
  INNER JOIN raw_payments AS in1
     ON in0.c_int64 != in1.id

),

Reformat_1 AS (

  SELECT 
    {{ SQL_BaseGitDepProjectAllFinal.qa_concat_macro_base_column('c_string') }} AS c_base_dependency_macro,
    {{ SQL_BigQueryParentProjectMain.qa_boolean_macro('c_int64') }} AS c_boolean_macro,
    concat('{{ dbt_utils.pretty_time() }}', '{{ dbt_utils.pretty_log_format("my pretty message") }}') AS c_dbt_date,
    c_int64 AS c_int64,
    c_bignumeric AS c_bignumeric,
    c_bool AS c_bool,
    c_bytes AS c_bytes,
    c_string AS c_string,
    c_float64 AS c_float64,
    c_numeric_1 AS c_numeric_1,
    c_numeric_2 AS c_numeric_2,
    c_date AS c_date,
    c_interval AS c_interval,
    c_time AS c_time,
    c_timestamp AS c_timestamp,
    c_datetime AS c_datetime,
    c_geography AS c_geography,
    c_json AS c_json,
    c_array_int64 AS c_array_int64,
    c_struct AS c_struct,
    p_date AS p_date
  
  FROM Join_1 AS in0

)

SELECT *

FROM Reformat_1

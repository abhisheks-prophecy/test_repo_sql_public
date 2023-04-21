{{
  config({    
    "materialized": "table"
  })
}}

{% set v_model_int_main = 10 %}
{% set v_model_dict_main = { 'a' : 10, 'b' : 15 } %}
{% set v_model_dict_complex = { 'a' : 2, 'b' : 10, 'c' : [1, 2, 'hello'] } %}
{% set v_model_bool_main = True %}
{% set v_model_expression = 'concat(c_string, c_text)' %}





WITH ALL_TYPE_TABLE_SMALLER AS (

  SELECT * 
  
  FROM {{ source('alias_base_QA_DATABASE_QA_SIMPLE_SCHEMA', 'ALL_TYPE_TABLE_SMALLER') }}

),

Reformat_1 AS (

  SELECT 
    C_NUM AS C_NUM,
    C_NUM10 AS C_NUM10,
    C_DEC AS C_DEC,
    C_NUMERIC AS C_NUMERIC,
    C_INT AS C_INT,
    C_INTEGER AS C_INTEGER,
    C_DOUBLE AS C_DOUBLE,
    C_FLOAT AS C_FLOAT,
    C_COUBLE_PRECISION AS C_COUBLE_PRECISION,
    C_REAL AS C_REAL,
    C_VARCHAR AS C_VARCHAR,
    C_VARCHAR50 AS C_VARCHAR50,
    C_CHAR AS C_CHAR,
    C_CHAR10 AS C_CHAR10,
    C_STRING AS C_STRING,
    C_STRING20 AS C_STRING20,
    C_TEXT AS C_TEXT,
    C_TEXT30 AS C_TEXT30,
    C_BINARY AS C_BINARY,
    C_BINARY100 AS C_BINARY100,
    C_VARBINARY AS C_VARBINARY,
    C_BOOL AS C_BOOL,
    C_TIMESTAMP AS C_TIMESTAMP,
    C_DATE AS C_DATE,
    C_DATETIME AS C_DATETIME,
    C_TIME AS C_TIME,
    C_ARRAY AS C_ARRAY,
    C_OBJECT AS C_OBJECT,
    C_GEOGRAPHY AS C_GEOGRAPHY,
    {{ SQL_SnoflakeMainProject.qa_boolean_macro('c_string') }} AS c_macro1,
    concat({{ SQL_SnoflakeMainProject.qa_concat_macro('c_string') }}, {{ SQL_BaseGitDepProjectAllFinal.qa_concat_macro_base_column('c_string') }}) AS c_macro2,
    {% if v_model_int_main > 10 and                         var('v_project_int_parent') %}
      {{ SQL_SnoflakeMainProject.qa_boolean_macro('c_string') }} AS c_if,
    {% else %}
      {{ SQL_SnoflakeMainProject.qa_concat_macro('c_string20') }} AS c_if,
    {% endif %}
    {{ var('v_project_expression_parent')}} AS c_expression_project_variable,
    {{v_model_expression}} AS c_expression_model_variable,
    {% for c_i in range(1, 4) %}
      concat(C_STRING, {{c_i}}) AS col_{{c_i}},
    {% endfor %}
    
    {{ SQL_BaseGitDepProjectAllFinal.qa_concat_macro_base_column('c_string') }} AS c_base_macro,
    concat('{{ dbt_utils.pretty_time() }}', '{{ dbt_utils.pretty_log_format("my pretty message") }}') AS c_dbutils_macro
  
  FROM ALL_TYPE_TABLE_SMALLER AS in0

),

raw_orders AS (

  SELECT * 
  
  FROM {{ ref('raw_orders')}}

),

Join_1 AS (

  SELECT 
    in0.C_NUM AS C_NUM,
    in0.C_NUM10 AS C_NUM10,
    in0.C_DEC AS C_DEC,
    in0.C_NUMERIC AS C_NUMERIC,
    in0.C_INT AS C_INT,
    in0.C_INTEGER AS C_INTEGER,
    in0.C_DOUBLE AS C_DOUBLE,
    in0.C_FLOAT AS C_FLOAT,
    in0.C_COUBLE_PRECISION AS C_COUBLE_PRECISION,
    in0.C_REAL AS C_REAL,
    in0.C_VARCHAR AS C_VARCHAR,
    in0.C_VARCHAR50 AS C_VARCHAR50,
    in0.C_CHAR AS C_CHAR,
    in0.C_CHAR10 AS C_CHAR10,
    in0.C_STRING AS C_STRING,
    in0.C_STRING20 AS C_STRING20,
    in0.C_TEXT AS C_TEXT,
    in0.C_TEXT30 AS C_TEXT30,
    in0.C_BINARY AS C_BINARY,
    in0.C_BINARY100 AS C_BINARY100,
    in0.C_VARBINARY AS C_VARBINARY,
    in0.C_BOOL AS C_BOOL,
    in0.C_TIMESTAMP AS C_TIMESTAMP,
    in0.C_DATE AS C_DATE,
    in0.C_DATETIME AS C_DATETIME,
    in0.C_TIME AS C_TIME,
    in0.C_ARRAY AS C_ARRAY,
    in0.C_OBJECT AS C_OBJECT,
    in0.C_GEOGRAPHY AS C_GEOGRAPHY
  
  FROM Reformat_1 AS in0
  INNER JOIN raw_orders AS in1
     ON in0.C_STRING != in1.status

)

SELECT *

FROM Join_1

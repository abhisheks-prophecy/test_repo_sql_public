WITH model_P1_Snow_Git_2 AS (

  SELECT * 
  
  FROM {{ ref('model_P1_Snow_Git_2')}}

),

Reformat_1 AS (

  SELECT * 
  
  FROM model_P1_Snow_Git_2 AS in0

)

SELECT *

FROM Reformat_1

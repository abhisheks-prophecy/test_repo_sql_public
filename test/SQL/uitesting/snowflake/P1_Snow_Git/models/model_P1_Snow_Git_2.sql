WITH model_P1_Snow_Git_1 AS (

  SELECT * 
  
  FROM {{ ref('model_P1_Snow_Git_1')}}

),

Reformat_1 AS (

  SELECT * 
  
  FROM model_P1_Snow_Git_1 AS in0

)

SELECT *

FROM Reformat_1

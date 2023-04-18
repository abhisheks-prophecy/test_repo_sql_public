{% macro qa_concat_snow_p1(param_1, param_2='hello') %}
concat({{param_1}}, {{param_2}})
{% endmacro %}

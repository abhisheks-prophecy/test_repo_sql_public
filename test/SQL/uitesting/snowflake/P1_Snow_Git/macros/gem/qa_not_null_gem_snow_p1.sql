{% macro qa_not_null_gem_snow_p1(model, col) %}
select * from {{model}} where {{col}} is not null
{% endmacro %}
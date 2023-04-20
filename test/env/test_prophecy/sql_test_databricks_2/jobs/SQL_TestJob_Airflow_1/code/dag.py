import os
import sys
import pendulum
from datetime import timedelta
import airflow
from airflow.decorators import dag
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))
from tasks import DBT_0, Script_1
PROPHECY_RELEASE_TAG = "__PROJECT_ID_PLACEHOLDER__/__PROJECT_RELEASE_VERSION_PLACEHOLDER__"

@dag(
     dag_id = "test_abhisheks+e2etests_sql_test_databricks_2_SQL_TestJob_Airflow_1", 
     schedule_interval = "0 0 * * *", 
     default_args = {"owner" : "Prophecy", "ignore_first_depends_on_past" : True, "do_xcom_push" : True}, 
     start_date = airflow.utils.dates.days_ago(0), 
     catchup = True
)
def dag():
    DBT_0_op = DBT_0()
    Script_1_op = Script_1()
    DBT_0_op >> Script_1_op

dag()

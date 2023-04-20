def DBT_0():
    settings = {}
    from datetime import timedelta
    from airflow.operators.bash import BashOperator
    envs = {}
    envs["DBT_PROFILES_DIR"] = "/home/airflow/gcs/data"
    envs["DBT_FULL_REFRESH"] = "true"

    return BashOperator(
        task_id = "DBT_0",
        bash_command = "set -euxo pipefail; tmpDir=`mktemp -d`; git clone https://github.com/abhisheks-prophecy/test_repo_sql_public.git --branch main --single-branch $tmpDir; cd $tmpDir/test/env/test_prophecy/sql_test_databricks_2; dbt run --profile run_profile; dbt test --profile run_profile; ",
        env = envs,
        append_env = True,
        **settings
    )

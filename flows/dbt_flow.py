from pathlib import Path

from prefect_dbt_flow import dbt_flow
from prefect_dbt_flow.dbt import DbtDagOptions, DbtProfile, DbtProject
from prefect.task_runners import SequentialTaskRunner

DBT_PATH = Path().absolute().parent / "dbt_project"

my_flow = dbt_flow(
    project=DbtProject(
        name="jaffle_shop",
        project_dir=DBT_PATH,
        profiles_dir=DBT_PATH,
    ),
    profile=DbtProfile(
        target="dev",
        overrides={
            "type": "duckdb",
            "path": str(DBT_PATH / "jaffle_shop.duckdb"),
        },
    ),
    dag_options=DbtDagOptions(install_deps=False),
    flow_kwargs={
        # Ensure only one process has access to the duckdb db
        # file at the same time
        "task_runner": SequentialTaskRunner(),
    },
)

if __name__ == "__main__":
    my_flow()

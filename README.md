# Prefect Restack repository

This is the Prefect repository to get you started for generating preview environments from a custom Preview image with Restack github application.

## Getting started

Add Prefect to your Restack workspace and deploy it instantly on Restack cloud or securely connect your own AWS, GCP or Azure account.

### [Start Prefect on Restack now](https://console.restack.io/onboarding/store/81107573-db18-458e-bd39-21ba72ba638a)

## Generating a preview environment

1. Make sure to fork this repository.
2. Follow steps in the [official Restack documentation](https://www.restack.io/docs/prefect)
3. Once you open a pull request a preview environment will be generated.
4. Once your pull request is merged your initial Prefect image will be provisioned with latest code from the "main" branch.

## Why an own image

If your flow (or flows) require extra dependencies or shared libraries, we recommend building a shared custom image with all the extra dependencies and shared task definitions you need. Your flows can then all rely on the same image, but have their source stored externally. This option can ease development, as the shared image only needs to be rebuilt when dependencies change, not when the flow source changes.

We only served a single flow in this example, but you can extend this setup to serve multiple flows in a single Docker image by updating your Python script to using `flow.to_deployment` and `serve` to [serve multiple flows or the same flow with different configuration](https://docs.prefect.io/concepts/flows#serving-multiple-flows-at-once).

For advanced infrastructure requirements, such as executing each flow run within its own dedicated Docker container, learn more in Prefect's [worker and work pools tutorial page](https://docs.prefect.io/tutorial/workers/).

## Project setup

Useful resources:
* https://github.com/rpeden/prefect-docker-compose/ - Docker Compose implementation for Prefect.

The `docker-compose.yml` file contains five services:

* database - Postgres database for Prefect Server
* minio - MinIO S3-compatible object store, useful for experimenting with remote file storage without needing a cloud storage account.
* server - Prefect Server API and UI
* agent - Prefect Agent
* cli - A container that mounts this repository's flows directory and offers an ideal environment for building and applying deployments and running flows.

### Prefect server
To run Prefect Server, open a terminal, navigate to the directory where you cloned this repository, and run:

```bash
docker-compose --profile server up
```

This will start PostgreSQL and Prefect Server. When the serveris ready, you will see a line that looks like:
```bash
server_1     | INFO:     Uvicorn running on http://0.0.0.0:4200 (Press CTRL+C to quit)
```

The Prefect Server container shares port `4200` with the host machine, so if you open a web browser and navigate to http://localhost:4200 you will see the Prefect UI.


### Prefect UI
Next, open another terminal in the same directory and run:

```bash
docker-compose run cli
```

This runs an interactive Bash session in a container that shares a Docker network with the server you just started. If you run `ls`, you will see that the container shares the `flows` subdirectory of the repository on the host machine:

```bash
flow.py
root@fb032110b1c1:~/flows#
```

To demonstrate the container is connected to the Prefect Server instance you launched earlier, run:

```bash
python flow.py
```

Then, in a web browser on your host machine, navigate to http://localhost:4200/runs and you will see the flow you just ran in your CLI container.

### Prefect Agent

You can run a Prefect Agent by updating `docker-compose.yml` and changing `YOUR_WORK_QUEUE_NAME` to match the name of the Prefect work queue you would like to connect to, and then running the following command:

```bash
docker-compose --profile agent up
```

This will run a Prefect agent and connect to the work queue you provided.

### MinIO Storage

MinIO is an S3-compatible object store that works perfectly as remote storage for Prefect deployments. You can run it inside your corporate network and use it as a private, secure object store, or just run it locally in Docker Compose and use it for testing and experimenting with Prefect deployments.

If you'd like to use MinIO with Prefect in Docker compose, start them both at once by running:

```bash
docker compose --profile server --profile minio up
```

Although Prefect Server won't need to talk to MinIO, Prefect agents and the Prefect CLI will need to talk to both MinIO and Prefect Server to create and run depoyments, so it's best to start them simultaneously.

After the MinIO container starts, you can load the MinIO UI in your web browser by navigating to http://localhost:9000. Sign in by entering `minioadmin` as both the username and password.

Create a bucket named `prefect-flows` to store your Prefect flows, and then click Identity->Service Accounts to create a service account. This will give you an access key and a secret you can enter in a Prefect block to let the Prefect CLI and agents write to and read from your MinIO storage bucket.

After you create a MinIO service account, open the Prefect UI at http://localhost:4200. Click Blocks, then add a Remote File System block. Give the block any name you'd like, but remember what name you choose because you will need it when creating a deployment.

In the Basepath field, enter `s3://prefect-flows`.

Finally, the Settings JSON field should look like this:

```
{
  "key": "YOUR_MINIO_KEY",
  "secret": "YOUR_MINIO_SECRET",
  "client_kwargs": {
    "endpoint_url": "http://minio:9000"
  }
}
```

Replace the placeholders with the key and secret MinIO generated when you created the service account. You are now ready to deploy a flow to a MinIO storage bucket! If you want to try it, open a new terminal and run:

```bash
docker compose run cli
```

Then, when the CLI container starts and gives you a Bash prompt, run:

```bash
prefect deployment build -sb "remote-file-system/your-storage-block-name" -n "Awesome MinIO deployment" -q "awesome" "flow.py:greetings"
```

Now, if you open http://localhost:9001/buckets/prefect-flows/browse in a web browser, you will see that flow.py has been copied into your MinIO bucket.

## Workaround to run DBT workflows

Useful resources:
* https://www.prefect.io/blog/dbt-and-prefect - A blog post about DBT integration to Prefect.
* https://github.com/datarootsio/prefect-dbt-flow/- Repository about a library that integrates DBT to Prefect.


Once you have the CLI service up, just run the following command:

```bash
python dbt_flow.py
```

It will run all the models (and tests) defined in the DBT project. It is possible to see this flow in http://localhost:4200/flows/

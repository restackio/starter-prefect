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

## GreenFlux Assignment

The Repo consists of a github workflow that will do the complete deployment of the all the resouces required in the assignment.

The workflow has 3 stages

1) DockerImageBuild : This creates the DNSMASQ docker image with the required configuartion and saves it on the Docker hub Repository.

2) build-and-deploy : This logs in to the azure subscriptions using the credentials provided in the workflow secret and runs the deployment script with is in the repo. The script in turn deploys all the resources.

3) delete: This stage is just to do a clean up of the entire subscription deleting all the resources that were created in the above step (step2).

The secrets that are required are
* DOCKERHUB_USERNAME - Username of your docker repo
* DOCKERHUB_TOKEN - Password of your docker repo
* AZURE_CREDENTIALS - Azure credentials that would be needed for authentication & authorization (Check this link to get more details on how to get the credentials https://docs.microsoft.com/en-us/azure-stack/user/ci-cd-github-action-login-cli?view=azs-2108)
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



## Security Improvements

* Use a private repository for the artifacts and docker images rather than using the public repo. The images can have vulnerability which can compromise the system. eg: JFROG is one such artifacory which also has a feature called XRAY that scans the docker images for vulnerability.
* Instead of using Azcli or powershell for resource creation it would be better to use a IAC tool like terraform which would preserve you statefile and it eases the provide of infrastuctre creation.
* The resources should be divided into private and public subnets so that they are properly segregated from the outside world.
* Make use of private endpoints wherever possible for communication between internal resources.
* Hardened images should be used for the VM creation which should be in our shared image gallery instead of using the images from marketplace.
* VMs should not have Password authentication and should be created with ssh-keys.
* NSG rules should be deny all and then access should be granted on case to case basis.
* In case of private subnets NAT gatways can be used for outbound connections.
* Instead of using container instance would recommend using AKS for the microservice approach.

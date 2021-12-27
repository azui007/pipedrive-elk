# pipedrive-elk
POC for Pipedrive ELK stack assignement

### Directories in play
#### For provisiong in google kubernetes engine with terraform
* tf-gke-cluster
* k8s-eck-stalk

## For provisiong in google kubernetes engine

### Pre-requisites:

  ##### 1. terraform
  ##### 2. GCP account
  ##### 3. configured gcloud sdk
  ##### 4. kubectl
  ##### 5. A Project created in GCP dashboard console for terraform access.

### Steps to execute:

#### Clone this repo
```
git clone git@github.com:yogeshbhoopathy/dummy.git
```
#### Change to terraform gke directory
```
cd tf-gke-cluster
```
#### Modify variables as needed
   The project ID is passed as project_id variable in terraform.tfvars file. And the region and machine_type variables can be updated as required.

#### Provision a kubernetes cluster with
```
terraform init
terraform plan
terraform apply
```
> a 3 node cluster should be provisioned in GKE
#### Change to k8s eck stack directory
```
cd ../k8s-eck-stack
```
#### Run deploy script to deploy ECK stack. (chmod for executable permission)
```
./deploy.sh 
```
#### Retrieve credentials kibana dashboard login with 
```
kubectl get secret -n elastic-system eck-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```
#### Run purge script to delete elk stack. (chmod for executable permission)
```
./purge.sh
```
#### Destroy the gke cluster with
```
cd ../tf-gke-cluster
terraform destroy
```

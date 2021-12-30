# Pipedrive - ELK Stack
POC for Pipedrive ELK stack assignment
### Directories in play
#### For provisiong in google kubernetes engine with terraform
* tf-gke-cluster
* k8s-eck-stalk
#### For provisiong in local with docker-compose
* docker-elk-stack
### Pre-requisites:
  - terraform
  - GCP account
  - configured gcloud sdk
  - kubectl
  - A Project created in GCP dashboard console for terraform access.
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

#### Copy gke kubeconfig for local kubectl access
```
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```
#### Change to k8s eck stack directory
```
cd ../k8s-eck-stack
```
#### Run deploy script to deploy ECK stack. (chmod for executable permission)
```
./deploy.sh 
```
#### Retrieve kibana dashboard login credentials with 
```
NAME=eckelastic
kubectl get secret -n elastic-system $NAME-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```
#### Access kibana dashboard with loadbalancer IP
Retrieve the kibana public facing IP with the below commands and access dashboard at http://$KB_IP:5601
```
KB_IP=$(kubectl get svc -n elastic-system "$NAME-kb-http" -o jsonpath='{.status.loadBalancer.ingress[].ip}')
echo $KB_IP
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
## For provisiong in local with docker-compose (tested in macOS Monterey)
### Pre-requisites:
  - docker-desktop for mac
### Steps to execute:
#### Change directory to docker-elk-stack after cloning the repo
```
cd ../docker-elk-stack
```
#### Build docker images and run containers using docker-compose 
Commands to build elasticsearch image and run the container from docker-elk-stack directory
```
# change to elasticsearch directory
cd elasticsearch

# build elasticsearch image with docker-es tag in local
docker build . -t docker-es

# start the container with docker-compose (elasticsearch should be started first for overlay network)
docker-compose up -d
```
Commands to build logstash image and run the container from docker-elk-stack directory
```
# change to logstash directory
cd logstash

# build logstash image with docker-logstash tag in local
docker build . -t docker-logstash

# start the container with docker-compose
docker-compose up -d
```
Commands to build filebeat image and run the container from docker-elk-stack directory
```
# change to filebeat directory
cd filebeat

# build filebeat image with docker-filebeat tag in local
docker build . -t docker-filebeat

# start the container with docker-compose
docker-compose up -d
```
Commands to build kibana image and run the container from docker-elk-stack directory
```
# change to kibana directory
cd kibana

# build kibana image with docker-kibana tag in local
docker build . -t docker-kibana

# start the container with docker-compose
docker-compose up -d
```
#### Access kibana dashboard and verify log streaming
kibana is exposed in local ep with http://localhost:5601 
click on discover tab to view the logstash stream 
#### Bring down the containers using docker-compose
```
# Run on respective directories (elasticsearch should be destroyed at the end to clear up overlay network)
docker-compose down 
```
> run docker-compose up from respective directories to avoid volume mounts errors

> docker build time depends on the bandwidth
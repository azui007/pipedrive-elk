#!/bin/bash

<< c
 1. Install eck operator
 2. Deploy eck elasticsearch
  2.1. Set storage-class default
 3. Deploy logstash pod
 4. Deploy eck DaemonSet
 5. Deploy eck Kibana
c

#  1. Install eck operator (ignore errors for rerun)
echo "Safe to ignore \"already exists\" eck operator errors during rerun of the script"
kubectl create -f https://download.elastic.co/downloads/eck/1.9.1/crds.yaml || true 
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.1/operator.yaml || true

# 2. Deploy eck stack elasticsearch
kubectl apply -f elasticsearch.yaml
  
# 2.1 Remove standard storage-class default
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

# 3. Deploy logstash pod
kubectl apply -f logstash.yaml

# 4. Deploy filebeat DaemonSet
kubectl apply -f filebeat.yaml

# 5. Deploy eck Kibana
kubectl apply -f kibana.yaml
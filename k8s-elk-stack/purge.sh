#!/bin/bash

<< c
 1. Delete eck Kibana
 2. Delete filebeat DaemonSet
 3. Delete logstash pod
 4. Delte eck elasticsearch
  4.1. Set standard storage-class default
 5. Delete eck operator
c

set -x
# 1. Delete eck Kibana
kubectl delete -f kibana.yaml

# 2. Delete filebeat DaemonSet
kubectl delete -f filebeat.yaml

# 3. Delete logstash pod
kubectl delete -f logstash.yaml

# 4. Delte eck elasticsearch
kubectl delete -f elasticsearch.yaml

# 4.1. Set standard storage-class default
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# 5. Delete eck operator
kubectl delete -f https://download.elastic.co/downloads/eck/1.9.1/crds.yaml 
kubectl delete -f https://download.elastic.co/downloads/eck/1.9.1/operator.yaml

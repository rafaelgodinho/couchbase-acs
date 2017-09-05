#!/bin/bash
cd /mnt/c/Projects/Couchbase/CouchbaseACS/helm-chart/incubator/couchbase

helm install --name couchbasesb --namespace couchbasesb ./
watch -n 5 kubectl get all --namespace couchbasesb
#helm delete couchbasesb --purge

#kubectl exec couchbasesb-couchbase-worker-0 --namespace couchbasesb -i -t -- bash -il
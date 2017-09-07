#!/bin/bash
cd /mnt/c/Projects/Couchbase/CouchbaseACS/helm-chart/incubator/couchbase-enterprise

#helm install --dry-run --name couchbase --namespace couchbase ./
helm install --name couchbase-enterprise --namespace couchbase-enterprise ./
watch -n 5 kubectl get all --namespace couchbase-enterprise
#helm delete couchbase-enterprise --purge

#kubectl exec couchbase-couchbase-0 --namespace couchbase-enterprise -i -t -- bash -il
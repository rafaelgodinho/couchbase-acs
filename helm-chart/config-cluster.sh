#!/bin/bash

#All nodes
hostname=$(hostname)
domainName=$(hostname -d)
namespace=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)
nodeNameRegex='(.*-)'
[[ $hostname =~ $nodeNameRegex ]] &&
node0HostName=${BASH_REMATCH[1]}0 #Expected output: helmRelease-couchbase-0
#Couchbase requires a "." on the name, so we need to use FQDN
hostFQDN=$hostname.$domainName
clusterFQDN=$node0HostName.$domainName
#TODO: Use Kubernetes Secrets
adminUsername="admin"
adminPassword="SuperP@ssw0rd"

couchbase-cli node-init \
  --cluster=$hostFQDN \
  --node-init-hostname=$hostFQDN \
  --user=$adminUsername \
  --pass=$adminPassword

#just on node == 0
if [[ "$hostname" == *-0 ]]
then
    totalRAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    dataRAM=$((50 * $totalRAM / 100000))
    indexRAM=$((15 * $totalRAM / 100000))

    couchbase-cli cluster-init \
        --cluster=$clusterFQDN \
        --cluster-ramsize=$dataRAM \
        --cluster-index-ramsize=$indexRAM \
        --cluster-username=$adminUsername \
        --cluster-password=$adminPassword \
        --services=data,index,query,fts
else #nodes > 0
    output=""
    
    while [[ $output != "Server $hostFQDN:8091 added" && ! $output =~ "Node is already part of cluster." ]]
    do    
        output=`couchbase-cli server-add \
            --cluster=$clusterFQDN \
            --user=$adminUsername \
            --pass=$adminPassword \
            --server-add=$hostFQDN \
            --server-add-username=$adminUsername \
            --server-add-password=$adminPassword \
            --services=data,index,query,fts`

        echo server-add output \'$output\'
        sleep 10
    done

    echo "Running couchbase-cli rebalance"
    output=""
    while [[ ! $output =~ "SUCCESS" ]]
    do
        output=`couchbase-cli rebalance \
            --cluster=$clusterFQDN \
            --user=$adminUsername \
            --pass=$adminPassword`

        echo rebalance output \'$output\'
        sleep 10
    done
fi
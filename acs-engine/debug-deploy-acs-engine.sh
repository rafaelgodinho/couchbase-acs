#!/bin/bash
subscriptionId=f1766062-4c0b-4112-b926-2508fecc5bdf
location=westus2
dnsPrefix=rg-cb-acs-engine-k8
resourceGroup=rg-cb-acs-engine-k8

./deploy-acs-engine.sh -d $dnsPrefix -l $location -r $resourceGroup -s $subscriptionId
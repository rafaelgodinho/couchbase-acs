#!/bin/bash
#creates the resource group
az group create --name rg-cb-acs-k8 --location westus2

#creates Kubernetes cluster on ACS
az acs create --orchestrator-type kubernetes --resource-group rg-cb-acs-k8 --name kube --generate-ssh-keys

#get cluster credential
#there is an issue with the command "az acs kubernetes get-credentials" on Ubuntu Bash on Windows
#more details here: https://github.com/Azure/azure-cli/issues/4106#issuecomment-320795635
az acs kubernetes get-credentials --resource-group rg-cb-acs-k8 --name kube

#Julien commands
#az acs create --name jcoacsuk1 --resource-group acsuk-rg --admin-username jcorioland --agent-profiles "[{'name':'linuxpool','count':2,'vmSize':'Standard_D2_v2', 'storageProfile':'ManagedDisks','osType':'Linux'},{'name':'windowspool','osType':'Windows','vmSize':'Standard_D2_v2','count':2}]" --orchestrator-type 'Kubernetes' –admin-password P@ssw0rd! --windows --ssh-key-value /home/jcorioland/.ssh/uktest_rsa.pub
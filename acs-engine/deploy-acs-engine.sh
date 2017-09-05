#!/bin/bash
declare subscriptionId=""
declare location=""
declare dnsPrefix=""
declare resourceGroup=""

while getopts ":d:l:r:s:" arg; do
	case "${arg}" in
		d)
			dnsPrefix=${OPTARG}
			;;
		l)
			location=${OPTARG}
			;;
		r)
			resourceGroup=${OPTARG}
			;;
		s)
			subscriptionId=${OPTARG}
			;;
		esac
done
shift $((OPTIND-1))

acs-engine deploy --subscription-id $subscriptionId \
    --resource-group $resourceGroup \
    --dns-prefix $dnsPrefix \
	--auto-suffix \
    --location $location \
    ./kubernetes-vmas.json

kubeconfig=$(ls -d ./_output/* -t -1 | head -1)/kubeconfig/kubeconfig.$location.json
kubeconfigFullPath=$(readlink -f $kubeconfig)

mv ~/.kube/config ~/.kube/config.$(date +%Y%m%d%H%M%s).bkp
cp $kubeconfigFullPath ~/.kube/config
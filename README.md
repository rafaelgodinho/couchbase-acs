# Introduction 
This project focus on deploying Couchbase on top of Azure Container Services (ACS) and Kubernetes

# How To
## Deploy Kubernetes 1.7.2 with ACS-Engine

Since the out of the box ACS does not support managed disks and premium storage, we need to use ACS Engine to generate an Azure Resource Manager (ARM) template to deploy a Docker enabled cluster with Kubernetes as the orchestrator.

### Requirements
- Download the [v0.5.0 release](https://github.com/Azure/acs-engine/releases/tag/v0.5.0) of ACS Engine for your system
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for your system
- Install [helm](https://github.com/kubernetes/helm/blob/master/docs/install.md) for your system

### Optional
- Update the [kubernetes-vmas.json](acs-engine/kubernetes-vmas.json) file with your SSH Public Key and Azure Service Principal information.
    - If the information is not provided, acs-engine will generate a SSH key and an Azure Service Principal on Azure Active Directory.
- Create a resource group.
    - If the resource group does not exist, it will be created for you.

### Deploying the Kubernetes cluster on Azure

Execute:
```
.\deploy-acs-engine.sh -d <DNS Prefix> -l <Location> -r <Resource Group> -s <Subscription ID>
```

This will generate an ARM template, under [acs-engine/_output/](acs-engine/_output/) folder, and deploy the template to Azure.
After the deployment, it will backup your current kubectl config (~/.kube/config) and copy the new config to connect to the cluster.

You can validate the connectivity running:

```
kubectl get nodes
```

## Deploying Couchbase with Helm

### Sandbox

Go to the couchbase chart template directory ([helm-chart/incubator/couchbase](helm-chart/incubator/couchbase)).

Execute the following command:

```
helm install --namespace couchbase --name couchbase ./
```

Then, wait for the deployment to be completed. It may take some time to pull the Docker image.

```
watch kubectl get pods --namespace couchbase
```

### Enterprise

Go to the couchbase-enterprise chart template directory ([helm-chart/incubator/couchbase-enterprise](helm-chart/incubator/couchbase-enterprise)).

Execute the following command:

```
helm install --namespace couchbase-enterprise --name couchbase ./
```

Then, wait for the deployment to be completed. It may take some time to pull the Docker image.

```
watch kubectl get pods --namespace couchbase-enterprise
```

# TODO
- Automate Couchbase configuration when the pod starts.
    -   This may be achievable using [postStart lifecycle handle](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/).
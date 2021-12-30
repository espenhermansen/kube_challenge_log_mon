# kube_challenge_log_mon

## Challenge text: 
Deploy a log monitoring system

So your applications produce logs. Lots of logs. How are you supposed to analyze them? A common solution is to aggregate and analyze them using the ELK stack, alongside fluentd or fluentbit.


## Requirements
dotctl - For accessing Digital Oceans API <br /> 
kubectl - To install Kubernetes CLI <br /> 
helm - To install Helm Charts on Kubernetes Cluster <br /> 

### Steps (on MAC)
You can install all necessary tools using [homebrew](https://brew.sh) 
```
Brew install kubectl
Brew install helm
Brew install doctl
```

## Install Kubernetes in Digital Ocean
I decided to use Terraform for getting the Kubernetes cluster up and running fast. <br /> 
Terraform Code is located [Here](https://github.com/espenhermansen/kube_challenge_log_mon/tree/main/terraform) <br /> 
<br /> <br /> 
You need to set up the Digital Ocean API Key as enviroment_variable. Use:
```
export TF_VAR_do_token="Your API Key"`
```

When cluster is installed add Kubernetes cluster to your kubeconfig
```
doctl kubernetes cluster kubeconfig save do-kubernetes
```

You can now run Kubectl commands against Kubernetes Cluster and we are ready to install ELK stack
<br /> 
## Install Elastic

Install CRDs and operator with RBAC rules
```
kubectl create -f https://download.elastic.co/downloads/eck/1.9.1/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.1/operator.yaml
```

Use helm to install operators
```
helm repo add elastic https://helm.elastic.co
helm repo 
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
```

## Deploy the Elastic Search Cluster
Create the Elasticsearch cluster


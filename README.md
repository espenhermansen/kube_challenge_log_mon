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
## Install Elastic CRDs and Operator
```
kubectl create -f https://download.elastic.co/downloads/eck/1.9.1/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.1/operator.yaml
```

## Deploy the Elastic Search Cluster
Create the Elasticsearch cluster by deploying yaml file
```
kubectl apply -f ./manifests/elasticsearch.yaml
```

Verify the cluster
```
kubectl get elasticsearch -w
```
Wait until Health is green and Phase is Ready
![image](https://user-images.githubusercontent.com/22987121/147752896-df1636e1-f3be-4602-8bb7-5e74d7e369af.png)

Get the password by using the command
```
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
echo $PASSWORD
```

Portforward so you can reach by https:
```
kubectl port-forward service/quickstart-es-http 9200
```

Go to a browser and go to https://localhost:9200  - verify that you get this:
![image](https://user-images.githubusercontent.com/22987121/147753101-97ef7c2b-f14c-4780-b51c-b881a5c7675e.png)
The cluster is ready

## Install Kibana

# kube_challenge_log_mon

## Challenge text: 
Deploy a log monitoring system

So your applications produce logs. Lots of logs. How are you supposed to analyze them? A common solution is to aggregate and analyze them using the ELK stack, alongside fluentd or fluentbit.

## Requirements
doctl - For accessing Digital Oceans API <br /> 
kubectl - To install Kubernetes CLI <br /> 
terraform - To spin up Kubernets Cluster in Digital Ocean

### Steps (on MAC)
You can install all necessary tools using [homebrew](https://brew.sh) 
```
Brew install doctl
Brew install kubectl
Brew install terraform
```

## Install Kubernetes in Digital Ocean
I decided to use Terraform for getting the Kubernetes cluster up and running fast. <br /> 
Terraform Code is located [Here](https://github.com/espenhermansen/kube_challenge_log_mon/tree/main/terraform) <br /> 
<br /> <br /> 
You need to set up the Digital Ocean API Key as enviroment_variable. See [Here](https://docs.digitalocean.com/reference/api/create-personal-access-token/) on how to create it. 

```
export TF_VAR_do_token="Your API Key"`
```

When cluster is installed add the new Kubernetes cluster to your kubeconfig
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
Verify the elastic cluster, use -w to auto update status
```
kubectl get elasticsearch -w
```
Wait until Health is green and Phase is Ready
![image](https://user-images.githubusercontent.com/22987121/147752896-df1636e1-f3be-4602-8bb7-5e74d7e369af.png)

Get the password for Elastic by using the command
```
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
echo $PASSWORD
```
Remember this password it will also be used by Kibana

Then portforward so you can reach by https:
```
kubectl port-forward service/quickstart-es-http 9200
```

Go to a browser and go to https://localhost:9200  - verify that you get this:
![image](https://user-images.githubusercontent.com/22987121/147753101-97ef7c2b-f14c-4780-b51c-b881a5c7675e.png)
The cluster is ready

## Install Kibana

Create Kibana from manifest:
```
kubectl apply -f ./manifests/kibana.yaml
```

Portforward so you can reach Kibana
```
kubectl port-forward service/quickstart-kb-http 5601
```
The password is the same as ElasticSearch and the username is Elastic
Go to https://localhost:5601 and login 

## Install Filebeats
Install filebeats as daemonset on Kubernetes Nodes
```
kubectl apply -f ./manifests/filebeats.yaml
```
Create a busybox to generate some logs:
```
kubectl run counter --image=busybox --dry-run=client -o yaml -- /bin/sh, -c, 'i=0; while true; do echo "hello world: $i: $(date)"; i=$((i+1)); sleep 3; done
```

## Go back to Kibana and verify

Log into Kibana and verify logs
You can go to discover and create index pattern based on filebeats


![image](https://user-images.githubusercontent.com/22987121/147785446-853afee0-7681-45e4-864f-033f909d5ecf.png)


## Experience

### The good
Its very easy to get going on Digital Ocean. With Terraform you can easily spin up and down Kubernetes Clusters to test with.
I tested some of the 1-click apps and that also worked good.
You get some start credit that you can learn alot with for a couple of months.

### Some issues I had:
The first API key I created endet with a empty space - that gave me alot of issues because I did not see it when copying password.
<br />
I had to increase size of nodes in Kubernetes Cluster as I had some issues to get Elastic up and running with 1 cpu / 2 gb ram
Increased to 2 cpu / 4gb ram and 5 nodes and it worked fine.

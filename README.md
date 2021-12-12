# kube_challenge_log_mon
Deploy a log monitoring system

So your applications produce logs. Lots of logs. How are you supposed to analyze them? A common solution is to aggregate and analyze them using the ELK stack, alongside fluentd or fluentbit.

# Requirements
kubectl - To install Kubernetes CLI
helm - To install Helm Charts on Kubernetes Cluster
dotctl - For accessing Digital Oceans API
Access to Digital Ocean Kubernetes Cluster on AKS

# Steps (on MAC)
Install necessary tools using homebrew. (https://brew.sh/)
`
Brew install kubectl
Brew install helm
Brew install doctl
`

# Install Kubernetes for Digital Ocean
I decided to use Terraform for installing the Kubernetes Cluster for this compettion. Code is located [Here](https://github.com/espenhermansen/kube_challenge_log_mon/tree/main/terraform)


You need to set up the Digital Ocean API Key as enviroment_variable.
Use: `export TF_VAR_do_token="Your API Key"`

When cluster is installed add Kubernetes cluster to your kubeconfig
doctl kubernetes cluster kubeconfig save do-kubernetes

You can now run Kubectl commands against Kubernetes Cluster and we are ready to install ELK stack

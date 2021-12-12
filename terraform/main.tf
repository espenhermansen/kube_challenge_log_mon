resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "do-kubernetes"
  region  = "ams3"
  version = "1.21.5-do.0"

  node_pool {
    name       = "do-kube-nodes"
    size       = "s-1vcpu-2gb"
    node_count = "2"
  }
}

variable "do_token" {
  description = "The token to access DigitalOcean API"
}
variable "cluster_count" {}
variable "worker_count" {}
variable "k8s_version" {}
variable "node_pool_name" {}
variable "node_size" {}
variable "region" {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  count = var.cluster_count

  name   = "k8s-cluster-${count.index}"
  region = var.region
  version = var.k8s_version

  node_pool {
    name       = var.node_pool_name
    size       = var.node_size
    node_count = var.worker_count
  }

  lifecycle {
    ignore_changes = [node_pool] # Ignore changes in node pool configuration
  }
}

resource "local_file" "kubeconfig" {
  count    = var.cluster_count
  filename = "${digitalocean_kubernetes_cluster.cluster[count.index].name}-kubeconfig.yaml"
  content  = digitalocean_kubernetes_cluster.cluster[count.index].kube_config[0].raw_config
}
# K8s cluster conf
cluster_count   = 3
worker_count    = 2
k8s_version     = "1.27.4-do.0" # doctl kubernetes options versions     
node_pool_name  = "worker-pool"

# DO conf
region          = "fra1"
node_size       = "s-2vcpu-2gb"
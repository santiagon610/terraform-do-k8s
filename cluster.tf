data "digitalocean_kubernetes_versions" "k8s_cluster" {
  version_prefix = "1.19."
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name         = var.DO_K8S_CLUSTER_NAME
  region       = "nyc1"
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.k8s_cluster.latest_version

  node_pool {
    name       = "${var.DO_K8S_CLUSTER_NAME}-nodepool01"
    size       = "s-1vcpu-2gb"
    auto_scale = false
    node_count = 2
    labels = {
      "managed_by" = "terraform"
    }
  }
}

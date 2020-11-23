# Add K8s cluster to access IWCG GitLab container registry
resource "kubernetes_secret" "iwcg_registry" {
  metadata {
    name      = "git.iwcg.io-registry"
    namespace = "hlv-apps"
  }
  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${var.GITLAB_REGISTRY}": {
      "auth": "${base64encode("${var.GITLAB_REGISTRY_USER}:${var.GITLAB_REGISTRY_PASSWORD}")}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

# Allow K8s cluster to access internal DO container registry
resource "digitalocean_container_registry_docker_credentials" "personal_registry" {
  registry_name = var.DO_CONTAINER_REGISTRY_NAME
}

resource "kubernetes_secret" "do-container-registry" {
  metadata {
    name = "registry.digitalocean.com.personal"
  }
  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.personal_registry.docker_credentials
  }
  type = "kubernetes.io/dockerconfigjson"
}

# Container Registry
variable DO_CONTAINER_REGISTRY_NAME {
  type = string
  default = "my-registry"
}

variable DO_CONTAINER_REGISTRY_SUBSCRIPTION_TIER {
  type = string
  default = "basic"
}

# DNS Domain
variable DO_K8S_CLUSTER_NAME {
  type    = string
  default = "github-test-k8s-cluster"
}
variable DO_K8S_DNS_DOMAIN {
  type    = string
  default = "k8s.santiago.wtf"
}

# Gitlab Docker Registry
variable "GITLAB_REGISTRY" {
  type    = string
}
variable "GITLAB_REGISTRY_USER" {
  type    = string
}
variable "GITLAB_REGISTRY_PASSWORD" {
  type    = string
}

# Traefik Config
variable "TRAEFIK_API_KEY" {
  type    = string
  default = "changeme123!"
}
variable "TRAEFIK_EMAIL" {
  type    = string
  default = "replaceme@example.com"
}
variable "TRAEFIK_BASE_DOMAIN" {
  type    = string
  default = "k8s.santiago.wtf"
}

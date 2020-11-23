resource "digitalocean_container_registry" "personal_registry" {
  name                   = var.DO_CONTAINER_REGISTRY_NAME
  subscription_tier_slug = var.DO_CONTAINER_REGISTRY_SUBSCRIPTION_TIER
}

resource "kubernetes_namespace" "apps" {
  metadata {
    labels = {
      managed_by = "terraform"
    }
    name = "apps"
  }
}

resource "helm_release" "traefik" {
  chart         = "traefik"
  force_update  = true
  repository    = "https://helm.traefik.io/traefik"
  name          = "traefik"
  namespace     = "kube-system"
  recreate_pods = true
  reuse_values  = true
  values        = [file("traefik-values.yml")]

  set {
    name  = "managed_by"
    value = "terraform"
  }
  set {
    name  = "defaultBackend.service.omitClusterIP"
    value = "true"
  }
  set {
    name  = "controller.service.omitClusterIP"
    value = "true"
  }
}

# Traefik HPA
resource "kubernetes_horizontal_pod_autoscaler" "traefik" {
  metadata {
    name      = helm_release.traefik.metadata.0.name
    namespace = helm_release.traefik.metadata.0.namespace
    labels = {
      app        = "traefik"
      release    = "traefik"
      managed_by = "terraform"
    }
  }
  spec {
    max_replicas                      = 10
    min_replicas                      = 2
    target_cpu_utilization_percentage = 50
    scale_target_ref {
      api_version = "extensions/v1beta1"
      kind        = "Deployment"
      name        = helm_release.traefik.name
    }
  }
}

# Data source for Traefik Helm chart
data "kubernetes_service" "traefik" {
  depends_on = [helm_release.traefik]
  metadata {
    name      = helm_release.traefik.metadata.0.name
    namespace = helm_release.traefik.metadata.0.namespace
  }
}

# Traefik Web UI Service
resource "kubernetes_service" "traefik-web-ui" {
  metadata {
    name      = "traefik-web-ui"
    namespace = "kube-system"
  }
  spec {
    selector = {
      app     = helm_release.traefik.metadata.0.name
      k8s-app = helm_release.traefik.metadata.0.name
    }
    port {
      name        = "web"
      port        = 80
      target_port = 9000
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}

# Traefik Web UI Ingress
resource "kubernetes_ingress" "traefik-web-ui" {
  metadata {
    name      = "traefik-web-ui"
    namespace = helm_release.traefik.metadata.0.namespace
    annotations = {
      "pizza" = "pepperoni"
    }
  }

  spec {
    backend {
      service_name = helm_release.traefik.metadata.0.name
      service_port = "web"
    }
    rule {
      host = "traefik-ui.${var.TRAEFIK_BASE_DOMAIN}"
      http {
        path {
          backend {
            service_name = kubernetes_service.traefik-web-ui.metadata.0.name
            service_port = kubernetes_service.traefik-web-ui.spec.0.port[0].target_port
          }
          path = "/"
        }
      }
    }
    tls {
      secret_name = "tls-secret"
    }
  }
}

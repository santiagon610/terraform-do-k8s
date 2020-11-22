# Load Balancer
resource "digitalocean_loadbalancer" "k8s_lb" {
  algorithm                = "round_robin"
  droplet_ids              = digitalocean_kubernetes_cluster.k8s_cluster.node_pool.0.nodes.*.droplet_id
  enable_backend_keepalive = false
  enable_proxy_protocol    = false
  name                     = "${var.DO_K8S_CLUSTER_NAME}-lb"
  redirect_http_to_https   = true
  region                   = "nyc1"
  depends_on               = [kubernetes_ingress.traefik-web-ui]
  # id                       = "${kubernetes_service.traefik-web-ui.metadata.annotations[*]}"
  forwarding_rule {
    entry_port      = data.kubernetes_service.traefik.spec.0.port.1.port
    entry_protocol  = "https"
    target_port     = data.kubernetes_service.traefik.spec.0.port.1.node_port
    target_protocol = "https"
    tls_passthrough = true
  }
  forwarding_rule {
    entry_port      = data.kubernetes_service.traefik.spec.0.port.0.port
    entry_protocol  = "tcp"
    target_port     = data.kubernetes_service.traefik.spec.0.port.0.node_port
    target_protocol = "tcp"
    tls_passthrough = false
  }
  healthcheck {
    check_interval_seconds   = 3
    healthy_threshold        = 5
    port                     = data.kubernetes_service.traefik.spec.0.port.0.node_port
    protocol                 = "tcp"
    response_timeout_seconds = 5
    unhealthy_threshold      = 3
  }
  sticky_sessions {
    type = "none"
  }
}

# DNS for Load Balancer
resource "digitalocean_domain" "k8s_lb" {
  name       = var.DO_K8S_DNS_DOMAIN
  ip_address = digitalocean_loadbalancer.k8s_lb.ip
}

resource "digitalocean_record" "k8s_lb_basedomain" {
  domain = var.TRAEFIK_BASE_DOMAIN
  type   = "A"
  name   = "@"
  ttl    = 120
  value  = digitalocean_loadbalancer.k8s_lb.ip
  depends_on = [
    digitalocean_domain.k8s_lb
  ]
}

resource "digitalocean_record" "k8s_lb_wildcard" {
  domain = var.TRAEFIK_BASE_DOMAIN
  type   = "A"
  name   = "*"
  value  = digitalocean_loadbalancer.k8s_lb.ip
  ttl    = 120
  depends_on = [
    digitalocean_domain.k8s_lb,
    digitalocean_record.k8s_lb_basedomain
  ]
}

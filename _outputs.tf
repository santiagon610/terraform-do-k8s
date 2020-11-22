output "loadbalancer_ip" {
  value = digitalocean_loadbalancer.k8s_lb.ip
}

output "k8s_base_domain" {
  value = var.DO_K8S_DNS_DOMAIN
}

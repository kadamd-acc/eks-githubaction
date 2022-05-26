
/*
# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
   value = kubernetes_ingress.game-app-ingress.hostname
}


# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
output "load_balancer_ip" {
  value = kubernetes_ingress.game-app-ingress.status.0.load_balancer.0.ingress.0.ip
}
*/


output "master-node-ip" {
  value = module.master-node.master-node-ip
}

output "worker-node-ip" {
  value = module.worker-node.Worker-node-ip
}


output "bastion-ip" {
  value = module.bastion.bastion-ip
}

output "Haproxy_private_ip" {
  value = module.haProxy.ha-proxy1-ip
}

output "Haproxybkup_private_ip" {
  value = module.haProxy.ha-proxy2-ip
}

output "Ansible" {
  value = module.ansible.ansible-ip
}

# output "route53-server" {
#   value = module.route53.route53-dns-name
# }

output "stage-lb" {
  value = module.environment-lb.prod-dns-name
}

output "prod-lb" {
  value = module.environment-lb.prod-dns-name
}

output "grafana-lb" {
  value = module.monitoring-lb.grafana_lb_dns_name
}

output "prometheus-lb" {
  value = module.monitoring-lb.prometheus_lb_dns_name
}
output "ha-proxy1-ip" {
  value = aws_instance.ha-proxy1.private_ip
}

output "ha-proxy2-ip" {
  value = aws_instance.ha-proxy2.private_ip
}
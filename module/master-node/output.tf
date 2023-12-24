output "master-node-ip" {
  value = aws_instance.master-node.*.private_ip
}
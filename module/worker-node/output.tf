output "Worker-node-ip" {
    value = aws_instance.worker-node.*.private_ip
}

output "worker-node-id" {
  value = aws_instance.worker-node.*.id
}
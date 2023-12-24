output "ansible-sg-id" {
  value = aws_security_group.Ansible_SG.id
}

output "bastion-sg-id" {
  value = aws_security_group.Bastion_SG.id
}

output "master-node-sg" {
  value = aws_security_group.Nodes_SG.id
}

output "worker-node-sg" {
  value = aws_security_group.Nodes_SG.id
}
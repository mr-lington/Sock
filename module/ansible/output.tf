output "ansible-ip" {
  value = aws_instance.ansible.public_ip
}
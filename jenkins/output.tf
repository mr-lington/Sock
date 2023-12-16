output "vpc" {
  value = aws_vpc.vpc.id
}

output "pubsub1" {
  value = aws_subnet.pubsub1.id
}

output "pubsub2" {
  value = aws_subnet.pubsub2.id
}

output "pubsub3" {
  value = aws_subnet.pubsub3.id
}

output "prvsub1" {
  value = aws_subnet.prvsub1.id
}

output "prvsub2" {
  value = aws_subnet.prvsub2.id
}

output "prvsub3" {
  value = aws_subnet.prvsub3.id
}

output "jenkins-server-ip" {
  value = aws_instance.jenkins-server.public_ip
}
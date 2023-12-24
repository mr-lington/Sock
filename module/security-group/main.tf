# CREATE ANSIBLE SECURITY GROUP
resource "aws_security_group" "Ansible_SG" {
  name        = "Ansible-SG"
  description = "Ansible traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansible-SG"
  }
}

# CREATE SECURITY GROUP FOR BASTION HOST
resource "aws_security_group" "Bastion_SG" {
  name        = "Bastion_SG"
  description = "Bastion traffic"
  vpc_id      = var.vpc_id

 ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion_SG"
  }
}


# CREATE SECURITY GROUP FOR MASTER NODES AND WORKER NODES
#Nodes (Master and Worker) Security Group
resource "aws_security_group" "Nodes_SG" {
  name        = "Nodes_SG"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ssh access"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Nodes_SG"
  }
}
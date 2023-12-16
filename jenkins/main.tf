locals {
  name = "sock"
}

# Create keypair with Terraform
resource "tls_private_key" "Keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "Keypair_priv" {
  filename        = "jenkins_key.pem"
  content         = tls_private_key.Keypair.private_key_pem
  file_permission = "600"
}

resource "aws_key_pair" "Keypair_pub" {
  key_name   = "jenkins_key"
  public_key = tls_private_key.Keypair.public_key_openssh
}

# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.name}-vpc"
  }
}

# create pub subnet 1
resource "aws_subnet" "pubsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
}

# create pub subnet 2
resource "aws_subnet" "pubsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b"
}

# create pub subnet 3
resource "aws_subnet" "pubsub3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-3c"
}

# create private subnet 1
resource "aws_subnet" "prvsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-3a"
}
# create private subnet 2
resource "aws_subnet" "prvsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-3b"
}
# create private subnet 3
resource "aws_subnet" "prvsub3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-west-3c"
}

# Creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.name}-igw"
  }
}
# Creating Elastic IP for Natgateway
resource "aws_eip" "eip" {
  domain = "vpc"
}
# Create Natgateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pubsub1.id
  tags = {
    Name = "${local.name}-nat-gateway"
  }
}
# Creating public route table
resource "aws_route_table" "PUB-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.name}-pub-rt"
  }
}
# Creating private route table
resource "aws_route_table" "PRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${local.name}-prv-rt"
  }
}
# Attaching public subnet 01 to public route table
resource "aws_route_table_association" "PUB-RT1-associated" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.PUB-RT.id
}
# Attaching public subnet 02 to public route table
resource "aws_route_table_association" "PUB-RT2-associated" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.PUB-RT.id
}
# Attaching public subnet 02 to public route table
resource "aws_route_table_association" "PUB-RT3-associated" {
  subnet_id      = aws_subnet.pubsub3.id
  route_table_id = aws_route_table.PUB-RT.id
}
# Associate private subnet 01 to my private route table
resource "aws_route_table_association" "PRT1-associated" {
  subnet_id      = aws_subnet.prvsub1.id
  route_table_id = aws_route_table.PRT.id
}
# Associating private subnet 02 to my private route table
resource "aws_route_table_association" "PRT2-associated" {
  subnet_id      = aws_subnet.prvsub2.id
  route_table_id = aws_route_table.PRT.id
}
# Associating private subnet 03 to my private route table
resource "aws_route_table_association" "PRT3-associated" {
  subnet_id      = aws_subnet.prvsub3.id
  route_table_id = aws_route_table.PRT.id
}

#Creating Bastion Host and Ansible security group
resource "aws_security_group" "Bastion-SG" {
  name        = "${local.name}-Bastion"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow proxy access"
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
    Name = "${local.name}Bastion-Ansible-sg"
  }
}


#Creating Jenkins security group
resource "aws_security_group" "Jenkins_SG" {
  name        = "${local.name}-Jenkins"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow proxy access"
    from_port   = 443
    to_port     = 443
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
    Name = "${local.name}-Jenkins-sg"
  }
}

# CREATE SECURITY GROUP FOR MASTER NODES AND WORKER NODES
#Nodes (Master and Worker) Security Group
resource "aws_security_group" "Nodes-SG" {
  name        = "${local.name}-Nodes"
  description = "Allow Inbound traffic"
  vpc_id      = aws_vpc.vpc.id

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
    Name = "${local.name}-Nodes-SG"
  }
}

resource "aws_instance" "jenkins-server" {
  ami                    = "ami-05b457b541faec0ca"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.Keypair_pub.key_name
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  subnet_id              = aws_subnet.pubsub1.id
  user_data              = local.jenkins_user_data
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
  associate_public_ip_address = true
  tags = {
    Name = "${local.name}-jenkins-server"
  }
}
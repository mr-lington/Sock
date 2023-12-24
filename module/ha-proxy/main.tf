# Create haproxy Frontend server 
resource "aws_instance" "ha-proxy1" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.haProxy-SG]
  instance_type             = var.instance_type
  key_name                  = var.keypair
  subnet_id                 = var.subnetid-01
  user_data                 = templatefile("./module/ha-proxy/ha1.sh",{
        master1= var.master1
        master2= var.master2
        master3= var.master3

  })
  tags = {
    Name = var.tag-ha-proxy1
  }
}

# Create haproxy Backend server 
resource "aws_instance" "ha-proxy2" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.haProxy-SG]
  instance_type             = var.instance_type
  key_name                  = var.keypair
  subnet_id                 = var.subnetid-02
  user_data                 = templatefile("./module/ha-proxy/ha2.sh",{
        master1= var.master1
        master2= var.master2
        master3= var.master3

  })
  tags = {
    Name = var.tag-ha-proxy2
  }
}
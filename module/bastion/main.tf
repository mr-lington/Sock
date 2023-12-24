# creating Bastian Host 
resource "aws_instance" "bastion-host" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.bastion-SG]
  instance_type             = var.instance_type
  key_name                  = var.keypair
  subnet_id                 = var.subnetid
  associate_public_ip_address = true
  user_data                 = templatefile("./module/bastion/bastion.sh",{
    private_keypair_path = var.prv-keypair

  })
  tags = {
    Name = var.tag-bastion
  }
}
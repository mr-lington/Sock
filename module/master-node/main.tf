#PROVISIONING MASTER NODE
resource "aws_instance" "master-node" {
  ami                         = var.AMI-ubuntu
  instance_type               = var.instanceType-t2-medium
  key_name                    = var.pub-key
  subnet_id                   = element(var.prvsub-id, count.index)
  vpc_security_group_ids      = [var.master-node-sg]
  count = var.instance-count
 

  tags = {
    Name = var.tag-master
  }
}
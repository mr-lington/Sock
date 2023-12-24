#PROVISIONING WORKER NODE
resource "aws_instance" "worker-node" {
  ami                    = var.AMI-ubuntu
  key_name               = var.pub-key
  instance_type          = var.instanceType-t2-medium
  subnet_id              = element(var.prvsub-id, count.index)
  vpc_security_group_ids = [var.worker-node-sg]
  count                  = var.instance-count


  tags = {
    Name = var.worker-node
  }
}
# creating ansible
resource "aws_instance" "ansible" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnetid
  vpc_security_group_ids      = [var.ansible-SG]
  key_name                    = var.keypair
  associate_public_ip_address = true
  user_data                 = templatefile("./module/ansible/userdata.sh",{
    prv-key = var.prv-keypair
    haproxy1-IP =var.haproxy1-Ip
    haproxy2-IP =var.haproxy2-Ip
    main-masterIP =var.main-masterIP
    member-masterIP1 =var.member-masterIP1
    member-masterIP2 =var.member-masterIP2
    worker-node1 =var.worker-node1
    worker-node2 =var.worker-node2
    worker-node3 =var.worker-node3
  })
  tags = {
    Name = var.tag-ansible
  }
}

resource "null_resource" "copy-playbooks" {
    connection {
        type = "ssh"
        host =  aws_instance.ansible.public_ip
        user = "ubuntu"
        private_key = var.prv-keypair
        bastion_host = var.bastion-host
        bastion_user = "ubuntu"
        bastion_private_key = var.prv-keypair
    }
    provisioner "file" {
        source = "./module/ansible/playbook"
        destination = "/home/ubuntu/playbook"
    }
}
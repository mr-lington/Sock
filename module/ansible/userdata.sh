#!/bin/bash

# Update instance and install ansible
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible python3-pip -y
sudo bash -c ' echo "strictHostKeyChecking No" >> /etc/ssh/ssh_config'

# Copying Private Key into Ansible Server and chaning its permission
echo "${prv-key}" >> /home/ubuntu/Key.Pem
sudo chmod 400 /home/ubuntu/Key.Pem
sudo chown ubuntu:ubuntu /home/ubuntu/Key.Pem 

# Giving the right permission to Ansible Directory
sudo chown -R ubuntu:ubuntu /etc/ansible && chmod +x /etc/ansible
sudo chmod 777 /etc/ansible/hosts
sudo chown -R ubuntu:ubuntu /etc/ansible

# Copying the 1st HAproxy into our ha-ip.yml
sudo echo ha_prv_ip: "${haproxy1-IP}" >> /home/ubuntu/ha-ip.yml

# Copying the 2st HAproxy into our ha-ip.yml
sudo echo ha_Backup_haIP: "${haproxy2-IP}" >> /home/ubuntu/ha-ip.yml

#updating host inventory file by creating groups for servers
sudo echo "[haproxy]" > /etc/ansible/hosts
sudo echo "${haproxy1-IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "[haproxy-backup]" >> /etc/ansible/hosts
sudo echo "${haproxy2-IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "[main-master]" >> /etc/ansible/hosts
sudo echo "${main-masterIP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "[member-master]" >> /etc/ansible/hosts
sudo echo "${member-masterIP1} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "${member-masterIP2} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "[worker-node]" >> /etc/ansible/hosts
sudo echo "${worker-node1} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "${worker-node2} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts
sudo echo "${worker-node3} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Key.Pem" >> /etc/ansible/hosts

#commands to trigger playbook
sudo su -c "ansible-playbook /home/ubuntu/playbooks/installation.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/MastKeepalived.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/main-master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/member-master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/worker-node.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/haproxy.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/stage.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/prod.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/monitoring.yml" ubuntu

sudo hostnamectl set-hostname ansible



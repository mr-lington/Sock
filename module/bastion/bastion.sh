#!/bin/bash
  echo "pubkeyAcceptedkeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
  systemctl reload sshd
  echo "${private_keypair_path}" >> /home/ubuntu/.ssh/id_rsa
  chown ubuntu /home/ubuntu/.ssh/id_rsa
  chgrp ubuntu /home/ubuntu/.ssh/id_rsa
  chmod 600 /home/ubuntu/.ssh/id_rsa
  sudo hostnamectl set-hostname Bastion
  EOF 
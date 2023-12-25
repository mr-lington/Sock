locals {
name = "sock"
prvsub1 = "subnet-0e28d5e9403c6d4d1"
prvsub2 = "subnet-0d6fb12cafd6c754c"
prvsub3 = "subnet-0d2c5d4ddb511dd02"
pubsub1 = "subnet-0875d72a53a2dd818"
pubsub2 = "subnet-023897b4077dc95d8"
pubsub3 = "subnet-0b40fafd682a57058"
vpc = "vpc-03440b3eb68398597"
}

data "aws_vpc" "vpc" {
  id = local.vpc
}

data "aws_subnet" "pubsub1" {
  id = local.pubsub1
}

data "aws_subnet" "pubsub2" {
  id = local.pubsub2
}

data "aws_subnet" "pubsub3" {
  id = local.pubsub3
}

data "aws_subnet" "prvsub1" {
  id = local.prvsub1
}

data "aws_subnet" "prvsub2" {
  id = local.prvsub2
}

data "aws_subnet" "prvsub3" {
  id = local.prvsub3
}

module "keypair" {
  source = "./module/keypair"
}

module "security-group" {
  source = "./module/security-group"
  vpc_id = data.aws_vpc.vpc.id
}

module "bastion" {
  source = "./module/bastion"
  ami = var.ami-ubuntu
  bastion-SG = module.security-group.bastion-sg-id
  instance_type = var.instance_type
  keypair= module.keypair.out-pub-key
  subnetid= data.aws_subnet.pubsub1.id
  prv-keypair= module.keypair.out-priv-key
  tag-bastion= "${local.name}-bastion-server"
}

module "haProxy" {
  source = "./module/ha-proxy"
  ami = var.ami-ubuntu
  haProxy-SG = module.security-group.master-node-sg
  instance_type = var.instance_type2
  keypair= module.keypair.out-pub-key
  subnetid-01= data.aws_subnet.prvsub1.id
  subnetid-02= data.aws_subnet.prvsub2.id
  master1= module.master-node.master-node-ip[0]
  master2= module.master-node.master-node-ip[1]
  master3= module.master-node.master-node-ip[2]
  tag-ha-proxy1= "${local.name}-ha-proxy1-server"
  tag-ha-proxy2= "${local.name}-ha-proxy2-server"
}

module "ansible" {
  source = "./module/ansible"
  ami = var.ami-ubuntu
  ansible-SG = module.security-group.ansible-sg-id
  instance_type = var.instance_type2
  keypair= module.keypair.out-pub-key
  subnetid= data.aws_subnet.pubsub2.id
  tag-ansible = "${local.name}-ansible-server"
  prv-keypair = module.keypair.out-priv-key
  haproxy1-Ip= module.haProxy.ha-proxy1-ip
  haproxy2-Ip= module.haProxy.ha-proxy2-ip
  main-masterIP = module.master-node.master-node-ip[0]
  member-masterIP1= module.master-node.master-node-ip[1]
  member-masterIP2= module.master-node.master-node-ip[2]
  worker-node1= module.worker-node.Worker-node-ip[0]
  worker-node2= module.worker-node.Worker-node-ip[1]
  worker-node3= module.worker-node.Worker-node-ip[2]
  bastion-host= module.bastion.bastion-ip
}

module "worker-node" {
  source                 = "./module/worker-node"
  AMI-ubuntu             = var.ami-ubuntu
  instanceType-t2-medium = var.instance_type2
  pub-key                = module.keypair.out-pub-key
  prvsub-id              = [data.aws_subnet.prvsub1.id, data.aws_subnet.prvsub2.id, data.aws_subnet.prvsub3.id]
  worker-node-sg         = module.security-group.worker-node-sg
  instance-count         = var.instance-count
  worker-node            = "${local.name}-worker-node"
}

module "master-node" {
  source                 = "./module/master-node"
  AMI-ubuntu             = var.ami-ubuntu
  instanceType-t2-medium = var.instance_type2
  pub-key                = module.keypair.out-pub-key
  prvsub-id              = [data.aws_subnet.prvsub1.id, data.aws_subnet.prvsub2.id, data.aws_subnet.prvsub3.id]
  master-node-sg         = module.security-group.master-node-sg
  instance-count         = var.instance-count
  tag-master             = "${local.name}-master-node"
}

module "monitoring-lb" {
  source          = "./module/monitoring-lb"
  prometheus-SG = module.security-group.worker-node-sg
  subnets         = [data.aws_subnet.pubsub1.id, data.aws_subnet.pubsub2.id, data.aws_subnet.pubsub3.id,]
  certificate-arn = module.route53.sock-cert
  vpc_id          = data.aws_vpc.vpc.id
  instance        = module.worker-node.worker-node-id
  tag-prometheus = "${local.name}-prometheus-alb"
  tag-grafana = "${local.name}-prometheus-alb"
  grafana-SG = module.security-group.worker-node-sg
}

module "environment-lb" {
  source          = "./module/environment-lb"
  stage-SG = module.security-group.worker-node-sg
  subnets         = [data.aws_subnet.pubsub1.id, data.aws_subnet.pubsub2.id, data.aws_subnet.pubsub3.id,]
  vpc_id          = data.aws_vpc.vpc.id
  instance        = module.worker-node.worker-node-id
  certificate-arn = module.route53.sock-cert
  prod-SG = module.security-group.master-node-sg
}

module "route53" {
  source                 = "./module/route53"
  prod_lb_dns_name       = module.environment-lb.prod-dns-name
  prod_lb_zone_id        = module.environment-lb.prod-zoneid
  stage_lb_dns_name      = module.environment-lb.stage-dns-name
  stage_lb_zone_id       = module.environment-lb.stage-zoneid
  prometheus_lb_dns_name = module.monitoring-lb.prometheus_lb_dns_name
  prometheus_lb_zone_id  = module.monitoring-lb.prometheus_lb_zone_id
  grafana_lb_dns_name    = module.monitoring-lb.grafana_lb_dns_name
  grafana_lb_zone_id     = module.monitoring-lb.grafana_lb_zone_id
  domain = var.domain
  stage-domain = var.domain-stage
  prod-domain = var.domain-prod
  prometheus-domain = var.domain-prometheus
  grafana-domain = var.domain-grafana
  domain2 = var.domain2
}

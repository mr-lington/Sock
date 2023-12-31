locals {
name    = "sock-shop"
prvsub1 = "subnet-06fa4ef623538fede"
prvsub2 = "subnet-016e9c41b97bc7d96"
prvsub3 = "subnet-00bb5776e2db524c1"
pubsub1 = "subnet-0405e46b291c3eb5f"
pubsub2 = "subnet-0e22b37e366e8460e"
pubsub3 = "subnet-03ac0ead8afa567bd"
vpc = "vpc-0dc57b14983f7b1bd"
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
  source        = "./module/bastion"
  ami           = "ami-05b457b541faec0ca"
  bastion-SG    = module.security-group.bastion-sg-id
  instance_type = "t2.micro"
  keypair       = module.keypair.out-pub-key
  subnetid      = data.aws_subnet.pubsub1.id
  prv-keypair   = module.keypair.out-priv-key
  tag-bastion   = "${local.name}-bastion-server"
}

module "haProxy" {
  source        = "./module/ha-proxy"
  ami           = "ami-05b457b541faec0ca"
  haProxy-SG    = module.security-group.master-node-sg
  instance_type = "t2.medium"
  keypair       = module.keypair.out-pub-key
  subnetid-01   = data.aws_subnet.prvsub1.id
  subnetid-02   = data.aws_subnet.prvsub2.id
  master1       = module.master-node.master-node-ip[0]
  master2       = module.master-node.master-node-ip[1]
  master3       = module.master-node.master-node-ip[2]
  tag-ha-proxy1 = "${local.name}-ha-proxy1-server"
  tag-ha-proxy2 = "${local.name}-ha-proxy2-server"
}

module "ansible" {
  source           = "./module/ansible"
  ami              = "ami-05b457b541faec0ca"
  ansible-SG       = module.security-group.ansible-sg-id
  instance_type    = "t2.medium"
  keypair          = module.keypair.out-pub-key
  subnetid         = data.aws_subnet.pubsub2.id
  tag-ansible      = "${local.name}-ansible-server"
  prv-keypair      = module.keypair.out-priv-key
  haproxy1-Ip      = module.haProxy.ha-proxy1-ip
  haproxy2-Ip      = module.haProxy.ha-proxy2-ip
  main-masterIP    = module.master-node.master-node-ip[0]
  member-masterIP1 = module.master-node.master-node-ip[1]
  member-masterIP2 = module.master-node.master-node-ip[2]
  worker-node1     = module.worker-node.Worker-node-ip[0]
  worker-node2     = module.worker-node.Worker-node-ip[1]
  worker-node3     = module.worker-node.Worker-node-ip[2]
  bastion-host     = module.bastion.bastion-ip
}

module "worker-node" {
  source                 = "./module/worker-node"
  AMI-ubuntu             = "ami-05b457b541faec0ca"
  instanceType-t2-medium = "t2.medium"
  pub-key                = module.keypair.out-pub-key
  prvsub-id              = [data.aws_subnet.prvsub1.id, data.aws_subnet.prvsub2.id, data.aws_subnet.prvsub3.id]
  worker-node-sg         = module.security-group.worker-node-sg
  instance-count         = 3
  worker-node            = "${local.name}-worker-node"
}

module "master-node" {
  source                 = "./module/master-node"
  AMI-ubuntu             = "ami-05b457b541faec0ca"
  instanceType-t2-medium = "t2.medium"
  pub-key                = module.keypair.out-pub-key
  prvsub-id              = [data.aws_subnet.prvsub1.id, data.aws_subnet.prvsub2.id, data.aws_subnet.prvsub3.id]
  master-node-sg         = module.security-group.master-node-sg
  instance-count         = 3
  tag-master             = "${local.name}-master-node"
}

module "monitoring-lb" {
  source          = "./module/monitoring-lb"
  prometheus-SG   = module.security-group.worker-node-sg
  subnets         = [data.aws_subnet.pubsub1.id, data.aws_subnet.pubsub2.id, data.aws_subnet.pubsub3.id, ]
  certificate-arn = module.route53.sock-cert
  vpc_id          = data.aws_vpc.vpc.id
  instance        = module.worker-node.worker-node-id
  tag-prometheus  = "${local.name}-prometheus-alb"
  tag-grafana     = "${local.name}-prometheus-alb"
  grafana-SG      = module.security-group.worker-node-sg
}

module "environment-lb" {
  source          = "./module/environment-lb"
  stage-SG        = module.security-group.worker-node-sg
  subnets         = [data.aws_subnet.pubsub1.id, data.aws_subnet.pubsub2.id, data.aws_subnet.pubsub3.id, ]
  vpc_id          = data.aws_vpc.vpc.id
  instance        = module.worker-node.worker-node-id
  certificate-arn = module.route53.sock-cert
  prod-SG         = module.security-group.worker-node-sg
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
  domain                 = "greatestshalomventures.com"
  stage-domain           = "stage.greatestshalomventures.com"
  prod-domain            = "prod.greatestshalomventures.com"
  prometheus-domain      = "prometheus.greatestshalomventures.com"
  grafana-domain         = "grafana.greatestshalomventures.com"
  domain2                = "*.greatestshalomventures.com"
}

#prometheus
#prometheus ALB
# Creating prometheus Application Load balancer
resource "aws_lb" "prometheus-alb" {
  name               = "prometheus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.prometheus-SG]
  subnets            = var.subnets
  tags = {
  Name = var.tag-prometheus
  }
}

# Creating prometheus Load balancer Listener for http
resource "aws_lb_listener" "prometheus-http-listener" {
  load_balancer_arn      = aws_lb.prometheus-alb.arn
  port                   = "80"
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.prometheus-target.arn
   }
}

# Creating prometheus Load balancer Listener for https access
resource "aws_lb_listener" "prometheus-https-listener" {
  load_balancer_arn      = aws_lb.prometheus-alb.arn
  port                   = "443"
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn          = var.certificate-arn
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.prometheus-target.arn
  }
}

# Creating Target Group
resource "aws_lb_target_group" "prometheus-target" {
  name             = "prometheus-target"
  port             = 31090
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
    path                = "/graph"
  }
}

#target group attachment for prometheus
resource "aws_lb_target_group_attachment" "prometheus_alb_attach" {
  target_group_arn = aws_lb_target_group.prometheus-target.arn
  target_id        = element(var.instance, count.index)
  port             = 31090
  count = 3
}

###############################################################################

#grafana
#grafana ALB
# Creating grafana Application Load balancer
resource "aws_lb" "grafana-alb" {
  name               = "grafana-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.grafana-SG]
  subnets            = var.subnets
  tags = {
  Name = var.tag-grafana
  }
}

# Creating grafana Load balancer Listener for http
resource "aws_lb_listener" "grafana-http-listener" {
  load_balancer_arn      = aws_lb.grafana-alb.arn
  port                   = "80"
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.grafana-target.arn
    }
  }

# Creating grafana Load balancer Listener for https access
resource "aws_lb_listener" "grafana-https-listener" {
  load_balancer_arn      = aws_lb.grafana-alb.arn
  port                   = "443"
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn        = var.certificate-arn
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.grafana-target.arn
  }
}

# Creating Target Group
resource "aws_lb_target_group" "grafana-target" {
  name             = "grafana-target"
  port             = 31300
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
    path                = "/login"
  }
}

#target group attachment for grafana
resource "aws_lb_target_group_attachment" "grafana_alb_attach" {
  target_group_arn = aws_lb_target_group.grafana-target.arn
  target_id        = element(var.instance, count.index)
  port             = 31300
  count = 3
}
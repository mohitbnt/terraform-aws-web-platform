# Target Group Configuration
###############################################################
resource "aws_lb_target_group" "web_tg" {
  name                 = "${var.environment}-${var.project_name}-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = 30

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-tg"
    }
  )
}
# ALB Configuration
###############################################################
resource "aws_lb" "web_lb" {
  name                       = "${var.environment}-${var.project_name}-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids[*]
  security_groups            = [var.alb_security_group_id]
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-lb"
    }
  )
}
resource "aws_lb_listener" "https_main" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

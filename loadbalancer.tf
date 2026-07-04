# Target Group Configuration
###############################################################
resource "aws_lb_target_group" "web_tg" {
  name                 = "${local.environment}-${local.common_tags.Project}-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.main_vpc.id
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

  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-tg"
  }
}
# ALB Configuration
###############################################################
resource "aws_lb" "web_lb" {
  name                       = "${local.environment}-${local.common_tags.Project}-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public_subnet[*].id
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60

  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-lb"
  }
}
resource "aws_lb_listener" "https_main" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.web_certificate_validation.certificate_arn
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

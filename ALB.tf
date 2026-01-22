
resource "aws_lb" "alb" {
  name               = "public-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = aws_subnet.public_subnet[*].id

  enable_deletion_protection = false

  tags = merge(local.common_tags, {
    Name = "alb-${var.env}"
  })
}


resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = "app-tg-${var.env}"
  })
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

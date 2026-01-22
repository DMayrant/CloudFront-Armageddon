resource "aws_autoscaling_group" "ec2_asg" {
  max_size         = 25
  min_size         = 2
  desired_capacity = 2
  name_prefix      = "webserver-${var.env}-"

  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  vpc_zone_identifier = aws_subnet.private_subnet[*].id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120

  lifecycle {
    create_before_destroy = true
  }
}



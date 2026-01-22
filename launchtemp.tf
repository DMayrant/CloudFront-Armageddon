resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-"
  image_id      = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  # EC2 should live in private subnets behind the ALB
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "ASG"
    })
  }
}
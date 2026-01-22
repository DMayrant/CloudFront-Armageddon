resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile-${var.env}"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_iam_policy" "ssm_logging_policy" {
  name = "ssm-session-logging-policy-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.ssm_sessions.arn}:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_logging_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_logging_policy.arn
}

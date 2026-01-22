resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Application tier security group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Outbound to DB and AWS services"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "ALB - public entrypoint for CloudFront"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTPS from CloudFront / Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP (optional, if redirecting)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "aurora_sg" {
  name        = "postgres-db-sg"
  description = "Aurora PostgreSQL security group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Postgres from application tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Outbound (patching, monitoring)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-db-sg"
  }
}

resource "aws_security_group" "ssm_endpoints_sg" {
  name   = "ssm-endpoints-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow EC2 in VPC to access SSM endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssm-endpoints-sg"
  }
}




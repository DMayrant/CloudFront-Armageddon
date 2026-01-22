resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = { 
    Name = "ssm-endpoint" 
    
    }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = { 
    Name = "ec2 messages-endpoint" 
    
    }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = { 
    Name = "ssm messages-endpoint" 
    }
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.29.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(local.common_tags, {
    Name = "Main_VPC"
  })
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "public_Subnet"
  })
}


resource "aws_subnet" "private_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "private_Subnet"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(local.common_tags, {
    Name = "Internet_gateway"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id

}

resource "aws_eip" "NAT" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NAT.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_flow_log" "vpc_flow_log_to_s3" {
  log_destination      = aws_s3_bucket.vpc_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL" # Can be ACCEPT, REJECT, or ALL
  vpc_id               = aws_vpc.main_vpc.id

}
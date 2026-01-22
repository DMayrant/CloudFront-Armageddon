variable "private_subnet_count" {
  type    = number
  default = 6

}

variable "public_subnet_count" {
  type    = number
  default = 3

}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.29.0.0/24",
    "10.29.1.0/24",
    "10.29.2.0/24",
    "10.29.3.0/24",
    "10.29.4.0/24",
    "10.29.5.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.29.100.0/24",
    "10.29.105.0/24",
    "10.29.110.0/24",
    "10.29.115.0/24",
    "10.29.120.0/24",
    "10.29.125.0/24"
  ]
}

variable "aurora_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.29.200.0/24",
    "10.29.210.0/24",
    "10.29.220.0/24",
    "10.29.230.0/24",
    "10.29.240.0/24",
    "10.29.250.0/24"
  ]
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "domain_name" {
  default = "dev.example.com"
}

variable "engine" {
  type        = string
  default     = "aurora-postgresql"
  description = "The engine of the Aurora DB cluster"

  validation {
    condition     = contains(["aurora-postgresql"], var.engine)
    error_message = <<-EOT
        This engine must contain: 'aurora-postgresql'
        EOT
  }
}

variable "db_username" {
  description = "The database username for IAM authentication."
  type        = string
  sensitive   = true
  default     = "DMay12345"
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
  default     = "admin1234$"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for CloudFront (must be in us-east-1)"
  type        = string
}

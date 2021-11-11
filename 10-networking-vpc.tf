# VPC Definition

resource "aws_vpc" "vpc01" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
      Name = "vpc01"
  }
}
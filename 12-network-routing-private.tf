# EIP for use with NAT GW
resource "aws_eip" "nat_gw_eip" {
    vpc = true
}

# natgw has to be in a public subnet to route out via an igw. Otherwise it no work.
resource "aws_nat_gateway" "nat_gateway_01" {
  subnet_id     = aws_subnet.private_subnet_01.id
  allocation_id = aws_eip.nat_gw_eip.id
}

# Route table for internal -> internet
resource "aws_route_table" "route_table_for_natgw" {
    vpc_id           = aws_vpc.vpc01.id
}

resource "aws_route" "subnet_to_natgw" {
    route_table_id = aws_route_table.route_table_for_natgw.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_01.id

    # Attempted fix: https://github.com/terraform-providers/terraform-provider-aws/issues/13138
    # We didn't experience. This is some shared industry knowledge I'm including.
    timeouts {
        create = "10m"
    }
}

resource "aws_route_table_association" "private_subnet_01_rta" {
    subnet_id = aws_subnet.private_subnet_01.id
    route_table_id = aws_route_table.route_table_for_natgw.id
}

resource "aws_route_table_association" "private_subnet_02_rta" {
    subnet_id = aws_subnet.private_subnet_02.id
    route_table_id = aws_route_table.route_table_for_natgw.id
}

resource "aws_route_table_association" "private_subnet_03_rta" {
    subnet_id = aws_subnet.private_subnet_03.id
    route_table_id = aws_route_table.route_table_for_natgw.id
}


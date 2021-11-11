# Internet Gateway for internal -> internet

resource "aws_internet_gateway" "internet_gateway_01" {
    vpc_id = aws_vpc.vpc01.id
}

# Route table for internal -> internet
resource "aws_route_table" "igrt" {
    vpc_id           = aws_vpc.vpc01.id
}

resource "aws_route_table_association" "public_subnet_01_rta" {
    subnet_id = aws_subnet.public_subnet_01.id
    route_table_id = aws_route_table.igrt.id
}

resource "aws_route_table_association" "public_subnet_02_rta" {
    subnet_id = aws_subnet.public_subnet_02.id
    route_table_id = aws_route_table.igrt.id
}

resource "aws_route_table_association" "public_subnet_03_rta" {
    subnet_id = aws_subnet.public_subnet_03.id
    route_table_id = aws_route_table.igrt.id
}

resource "aws_route" "awsr_subnet_to_internet" {
    route_table_id = aws_route_table.igrt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_01.id

    # Attempted fix: https://github.com/terraform-providers/terraform-provider-aws/issues/13138
    # We didn't experience. This is some shared industry knowledge I'm including.
    timeouts {
        create = "10m"
    }
}
resource "aws_subnet" "public_subnet_01" {
    vpc_id = aws_vpc.vpc01.id
    availability_zone_id = data.aws_availability_zone.ap_southeast_2a.shortcode
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_02" {
    vpc_id = aws_vpc.vpc01.id
    availability_zone_id = data.aws_availability_zone.ap_southeast_2b.shortcode
    cidr_block = "10.10.20.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_03" {
    vpc_id = aws_vpc.vpc01.id
    availability_zone_id = data.aws_availability_zone.ap_southeast_2c.shortcode
    cidr_block = "10.10.30.0/24"
    map_public_ip_on_launch = true
}
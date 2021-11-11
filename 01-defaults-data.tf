data "aws_ami" "al2" {
        provider = aws
        most_recent = true

        filter {
                name = "name"
                values = ["amzn2-ami-hvm-*x86_64*"]
        }

        filter {
                name = "virtualization-type"
                values = ["hvm"]
        }

        owners = ["137112412989"]
}

data "aws_availability_zone" "ap_southeast_2a" {
  name = "ap-southeast-2a"
  shortcode = "apse2-az1"
}

data "aws_availability_zone" "ap_southeast_2b" {
  name = "ap-southeast-2b"
  shortcode = "apse2-az3"
}

data "aws_availability_zone" "ap_southeast_2c" {
  name = "ap-southeast-2c"
  shortcode = "apse2-az2"
}
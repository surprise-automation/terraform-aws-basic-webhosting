variable "eingress" {
    description = "Dirty hack to avoid multiple lines of ingress/egress rules"
    type = list(string)
    default = ["ingress","egress"]
}

resource "aws_security_group" "web_02" {
    name = "web-02"
    description = "Allows port 80/443 communications"
    vpc_id = aws_vpc.vpc01.id
}

resource "aws_security_group" "me_02" {
    name = "me-02"
    description = "Allow full me access"
    vpc_id = aws_vpc.vpc01.id
    # https://www.reddit.com/r/Terraform/comments/psaajq/3_minutes_later_terraform_apply_still_running/
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "intra_02" {
    name = "intra-02"
    description = "Allow full intra-sg access"
    vpc_id = aws_vpc.vpc01.id
    # https://www.reddit.com/r/Terraform/comments/psaajq/3_minutes_later_terraform_apply_still_running/
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "allow_80" {
    count = length(var.eingress)
    type = var.eingress[count.index]
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.web_02.id
}

resource "aws_security_group_rule" "allow_443" {
    count = length(var.eingress)
    type = var.eingress[count.index]
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.web_02.id
}

resource "aws_security_group_rule" "allow_me" {
    count = length(var.eingress)
    type = var.eingress[count.index]
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "59.154.140.0/28" ]
    security_group_id = aws_security_group.me_02.id
}

resource "aws_security_group_rule" "allow_intra" {
    count = length(var.eingress)
    type = var.eingress[count.index]
    from_port = 0
    to_port = 0
    protocol = "-1"
    source_security_group_id = aws_security_group.intra_02.id
    security_group_id = aws_security_group.intra_02.id
}

resource "aws_security_group_rule" "allow_intra_to_world_80" {
    count = length(var.eingress)
    type = "egress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.intra_02.id
}

resource "aws_security_group_rule" "allow_intra_to_world_443" {
    count = length(var.eingress)
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.intra_02.id
}
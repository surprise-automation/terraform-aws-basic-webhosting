resource "aws_lb" "awlb_azt_01" {
    name = "awlb-azt-01"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_02.id, aws_security_group.intra_02.id]
    subnets = [aws_subnet.awsn_azdp2a_01.id, aws_subnet.awsn_azdp2b_01.id, aws_subnet.awsn_azdp2c_01.id]
    enable_deletion_protection = false
}

resource "aws_lb_target_group" "awtg_azt_01" {
    name = "awtg-azt-01"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc01.id
}

resource "aws_lb_target_group_attachment" "aztga_azt_01" {
    target_group_arn = aws_lb_target_group.awtg_azt_01.arn
    target_id = aws_instance.my_dev_01.id
    port = 80
}

resource "aws_lb_target_group_attachment" "aztga_azt_02" {
    target_group_arn = aws_lb_target_group.awtg_azt_01.arn
    target_id = aws_instance.my_dev_02.id
    port = 80
}

resource "aws_lb_listener" "awlbl-azt80-01" {
    load_balancer_arn = aws_lb.awlb_azt_01.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "redirect"

        redirect {
          port = "443"
          protocol = "HTTPS"
          status_code = "HTTP_301"
        }
    }
}

resource "aws_lb_listener" "awlbl-azt443-01" {
  load_balancer_arn = aws_lb.awlb_azt_01.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = "arn:aws:acm:ap-southeast-2:632795730146:certificate/ff17e8a5-8789-4c11-ad8e-a215be1f9bf5"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.awtg_azt_01.arn
  }
}
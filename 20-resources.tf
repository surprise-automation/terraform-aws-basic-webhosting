resource "aws_eip" "jump_02_eip" {
    instance = aws_instance.jump_02.id
    vpc = true

    depends_on = [aws_instance.jump_02]

    tags = {
        Name = "for_jump_02"
    }
}

resource "aws_eip_association" "jump_02_eip_assoc" {
  instance_id   = aws_instance.jump_02.id
  allocation_id = aws_eip.jump_02_eip.id
}

resource "aws_instance" "jump_02" {
    ami                                  = data.aws_ami.al2.id
    availability_zone                    = data.aws_availability_zone.ap_southeast_2b.id
    instance_type                        = "t3.nano"
    key_name                             = "aws-it"
    subnet_id                            = aws_subnet.public_subnet_01.id
    tags                                 = {
        "Name" = "jump-02"
    }
    vpc_security_group_ids               = [aws_security_group.me_02.id, aws_security_group.intra_02.id]

    disable_api_termination = "true"

    root_block_device {
        delete_on_termination = "true"
        volume_size = 30
    }
}

resource "aws_instance" "mydev_01" {
    ami                                  = data.aws_ami.al2.id
    availability_zone                    = data.aws_availability_zone.ap_southeast_2a.id
    #instance_type                        = "m5.large"
    instance_type                        = "t3.small"
    key_name                             = "aws-it"
    subnet_id                            = aws_subnet.private_subnet_01.id
    tags                                 = {
        "Name" = "mydev-01"
    }
    vpc_security_group_ids               = [aws_security_group.intra_02.id]

    root_block_device {
        delete_on_termination = "true"
        volume_size = 30
    }
}

resource "aws_instance" "mydev_02" {
    ami                                  = data.aws_ami.al2.id
    availability_zone                    = data.aws_availability_zone.ap_southeast_2b.id
    #instance_type                        = "m5.large"
    instance_type                        = "t3.small"
    key_name                             = "aws-it"
    subnet_id                            = aws_subnet.private_subnet_01.id
    tags                                 = {
        "Name" = "mydev-02"
    }
    vpc_security_group_ids               = [aws_security_group.intra_02.id]

    root_block_device {
        delete_on_termination = "true"
        volume_size = 30
    }
}

resource "aws_s3_bucket" "my-code_01" {
  bucket = "my-code-01"
  acl    = "private"

  tags = {
    Name        = "my-code-01"
  }
}

resource "aws_s3_bucket" "my-form_01" {
  bucket = "my-form-01"
  acl    = "private"

  tags = {
    Name        = "my-form-01"
  }
}

resource "aws_s3_bucket" "my-uploads_01" {
  bucket = "my-uploads-01"
  acl    = "public-read"

  tags = {
    Name        = "my-uploads-01"
  }
}

resource "aws_s3_bucket_policy" "my-uploads_01" {
    bucket = aws_s3_bucket.my-uploads_01.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid         = "PublicReadGetObject"
                Effect      = "Allow"
                Principal   = "*"
                Action      = "s3:GetObject"
                Resource    = [
                    aws_s3_bucket.my-uploads_01.arn,
                    "${aws_s3_bucket.my-uploads_01.arn}/*",
                ]
            }
        ]
    })
}
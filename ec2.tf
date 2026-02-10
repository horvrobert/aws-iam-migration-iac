# Amazon Linux 2023 (x86_64), EBS-backed, HVM
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_1.id
  iam_instance_profile        = aws_iam_instance_profile.migration-ec2_ssm_profile.name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  user_data                   = file("user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name    = "Migration-EC2-App-Server"
    Project = "Migration-IaC"
  }
}

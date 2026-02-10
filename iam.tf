resource "aws_iam_role" "migration-ec2_ssm_role" {
  name = "migration-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "Migration-EC2-SSM-Role"
    Project = "Migration-IaC"
  }
}

resource "aws_iam_role_policy_attachment" "migration-ec2_ssm_policy_attachment" {
  role       = aws_iam_role.migration-ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "migration-ec2_ssm_profile" {
  name = "migration-ec2-ssm-profile"
  role = aws_iam_role.migration-ec2_ssm_role.name

  tags = {
    Name    = "Migration-EC2-SSM-Profile"
    Project = "Migration-IaC"
  }
}

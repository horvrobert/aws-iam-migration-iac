resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.migration_vpc.id

  tags = {
    Name    = "Migration-EC2-SG"
    Project = "Migration-IaC"
  }
}

# Allow outbound HTTPS so the instance can reach AWS APIs (including SSM)
resource "aws_vpc_security_group_egress_rule" "ec2_https_egress" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Allow outbound HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow EC2 to initiate MySQL connections to RDS (outbound 3306)
resource "aws_vpc_security_group_egress_rule" "ec2_to_rds_mysql_egress" {
  security_group_id            = aws_security_group.ec2_sg.id
  description                  = "Allow outbound MySQL to RDS security group"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.migration_vpc.id

  tags = {
    Name    = "Migration-RDS-SG"
    Project = "Migration-IaC"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_mysql_ingress" {
  security_group_id            = aws_security_group.rds_sg.id
  description                  = "Allow MySQL from EC2 security group"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_sg.id
}

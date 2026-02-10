
resource "aws_db_subnet_group" "db_subnets" {
  name        = "migration-db-subnet-group"
  description = "DB subnet group for RDS in private subnets"
  subnet_ids  = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name    = "Migration-DB-Subnet-Group"
    Project = "Migration-IaC"
  }
}

resource "aws_db_instance" "mysql" {
  multi_az                    = false
  identifier                  = "migration-mysql"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  storage_type                = "gp3"
  db_subnet_group_name        = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  manage_master_user_password = true
  username                    = var.db_username
  publicly_accessible         = false

  # For a learning project, keep deletion simple (no final snapshot)
  skip_final_snapshot = true
  deletion_protection = false

  storage_encrypted = true

  tags = {
    Name    = "Migration-RDS-MySQL"
    Project = "Migration-IaC"
  }
}

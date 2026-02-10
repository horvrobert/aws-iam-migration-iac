resource "aws_vpc" "migration_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "Migration-VPC"
    Project = "Migration-IaC"
  }
}


# AZs are selected dynamically; subnet-to-AZ mapping may differ across accounts
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.migration_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-1"
    Project = "Migration-IaC"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.migration_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-2"
    Project = "Migration-IaC"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.migration_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "Private-1"
    Project = "Migration-IaC"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.migration_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name    = "Private-2"
    Project = "Migration-IaC"
  }
}

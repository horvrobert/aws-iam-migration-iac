# Public subnets require direct internet access for inbound/outbound connectivity
# IGW route enabled connectivity to the public internet, while inbound is controlled by security groups
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.migration_vpc.id

  tags = {
    Name    = "Migration-IGW"
    Project = "Migration-IaC"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.migration_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Migration-Public-RT"
    Project = "Migration-IaC"
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = {
    public_1 = aws_subnet.public_1.id
    public_2 = aws_subnet.public_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

# Private subnets intentionally have no default internet route to keep the database tier isolated and reduce costs (no NAT Gateway)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.migration_vpc.id

  tags = {
    Name    = "Migration-Private-RT"
    Project = "Migration-IaC"
  }
}

resource "aws_route_table_association" "private_subnets" {
  for_each = {
    private_1 = aws_subnet.private_1.id
    private_2 = aws_subnet.private_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}


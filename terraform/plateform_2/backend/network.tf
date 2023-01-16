resource "aws_vpc" "backend_vpc" {
  cidr_block           = "10.10.20.0/26"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_backend_az_1" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = "10.10.20.0/28"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_backend_az_2" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = "10.10.20.16/28"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_backend_az_3" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = "10.10.20.32/28"
  availability_zone       = "eu-west-3c"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "route_table_backend" {
  vpc_id = aws_vpc.backend_vpc.id
}

resource "aws_route_table_association" "private-2a" {
  subnet_id      = aws_subnet.subnet_backend_az_1.id
  route_table_id = aws_route_table.route_table_backend.id
}

resource "aws_route_table_association" "private-2b" {
  subnet_id      = aws_subnet.subnet_backend_az_2.id
  route_table_id = aws_route_table.route_table_backend.id
}

resource "aws_route_table_association" "private-2c" {
  subnet_id      = aws_subnet.subnet_backend_az_3.id
  route_table_id = aws_route_table.route_table_backend.id
}

resource "aws_internet_gateway" "internet_gateway_backend" {
  vpc_id = aws_vpc.backend_vpc.id
}

resource "aws_route" "internet_route_backend" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.route_table_backend.id
  gateway_id             = aws_internet_gateway.internet_gateway_backend.id
}
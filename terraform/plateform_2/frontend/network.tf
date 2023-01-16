resource "aws_vpc" "frontend_vpc" {
  cidr_block           = "10.20.20.0/26"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_frontend_az_1" {
  vpc_id                  = aws_vpc.frontend_vpc.id
  cidr_block              = "10.20.20.0/28"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_frontend_az_2" {
  vpc_id                  = aws_vpc.frontend_vpc.id
  cidr_block              = "10.20.20.16/28"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_frontend_az_3" {
  vpc_id                  = aws_vpc.frontend_vpc.id
  cidr_block              = "10.20.20.32/28"
  availability_zone       = "eu-west-3c"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "route_table_frontend" {
  vpc_id = aws_vpc.frontend_vpc.id
}

resource "aws_route_table_association" "private-2a" {
  subnet_id      = aws_subnet.subnet_frontend_az_1.id
  route_table_id = aws_route_table.route_table_frontend.id
}

resource "aws_route_table_association" "private-2b" {
  subnet_id      = aws_subnet.subnet_frontend_az_2.id
  route_table_id = aws_route_table.route_table_frontend.id
}

resource "aws_route_table_association" "private-2c" {
  subnet_id      = aws_subnet.subnet_frontend_az_3.id
  route_table_id = aws_route_table.route_table_frontend.id
}

resource "aws_internet_gateway" "internet_gateway_frontend" {
  vpc_id = aws_vpc.frontend_vpc.id
}

resource "aws_route" "internet_route_frontend" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.route_table_frontend.id
  gateway_id             = aws_internet_gateway.internet_gateway_frontend.id
}
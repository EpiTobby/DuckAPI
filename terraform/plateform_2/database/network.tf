resource "aws_vpc" "mongo_vpc" {
  cidr_block           = "10.30.20.0/26"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_mongo_az_1" {
  vpc_id                  = aws_vpc.mongo_vpc.id
  cidr_block              = "10.30.20.0/28"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_mongo_az_2" {
  vpc_id                  = aws_vpc.mongo_vpc.id
  cidr_block              = "10.30.20.16/28"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_mongo_az_3" {
  vpc_id                  = aws_vpc.mongo_vpc.id
  cidr_block              = "10.30.20.32/28"
  availability_zone       = "eu-west-3c"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "route_table_mongo" {
  vpc_id = aws_vpc.mongo_vpc.id
}

resource "aws_route_table_association" "private-2a" {
  subnet_id      = aws_subnet.subnet_mongo_az_1.id
  route_table_id = aws_route_table.route_table_mongo.id
}

resource "aws_route_table_association" "private-2b" {
  subnet_id      = aws_subnet.subnet_mongo_az_2.id
  route_table_id = aws_route_table.route_table_mongo.id
}

resource "aws_route_table_association" "private-2c" {
  subnet_id      = aws_subnet.subnet_mongo_az_3.id
  route_table_id = aws_route_table.route_table_mongo.id
}

resource "aws_internet_gateway" "internet_gateway_mongo" {
  vpc_id = aws_vpc.mongo_vpc.id
}

resource "aws_route" "internet_route_mongo" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.route_table_mongo.id
  gateway_id             = aws_internet_gateway.internet_gateway_mongo.id
}

resource "aws_security_group" "mongo" {
  name        = "mongo"
  description = "Controls access to the mongo instances"
  vpc_id      = aws_vpc.mongo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27019
    to_port     = 27019
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
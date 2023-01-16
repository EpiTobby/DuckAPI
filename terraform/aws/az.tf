# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# e.g., Create subnets in the first two available availability zones

resource "aws_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]

  # ...
  cidr_block = ""
  vpc_id = ""
}

resource "aws_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]

  # ...
  cidr_block = ""
  vpc_id = ""
}
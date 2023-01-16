provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}

module "frontend" {
  source      = "./frontend"
  amazon_ami  = data.aws_ami.amazon_ami.id
  key_name    = aws_key_pair.generated_key.key_name
  backend_url = module.backend.backend-server
}

module "backend" {
  source       = "./backend"
  amazon_ami   = data.aws_ami.amazon_ami.id
  key_name     = aws_key_pair.generated_key.key_name
  database_url = module.database.database_public_url
  frontend_url = module.frontend.frontend-server
}

module "database" {
  source                 = "./database"
  amazon_ami             = data.aws_ami.amazon_ami.id
  key_name               = aws_key_pair.generated_key.key_name
  backend-vpc-cidr-block = module.backend.backend-vpc-cidr-block
}
provider "aws" {
  region = var.region
}

module "frontend" {
  source = "./frontend"

  key_name = aws_key_pair.generated_key.key_name
}
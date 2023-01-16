resource "aws_instance" "mongo_server_primary" {
  ami             = var.amazon_ami
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.mongo.name]

  associate_public_ip_address = true

  user_data = filebase64("${path.root}/user_data/mongo.sh")
}


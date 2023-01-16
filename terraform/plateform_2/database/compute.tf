resource "aws_instance" "mongo_server_primary" {
  ami                         = var.amazon_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_mongo_az_1.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.mongo.id]
  associate_public_ip_address = true

  user_data = filebase64("${path.root}/user_data/mongo.sh")
}


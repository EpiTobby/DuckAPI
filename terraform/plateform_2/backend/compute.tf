resource "aws_launch_template" "backend" {
  name                   = "backend-template"
  image_id               = var.amazon_ami
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.backend.id,
  ]

  user_data = base64encode(templatefile("${path.root}/user_data/backend.tpl", {
    mongo_url    = var.database_url,
    frontend_url = var.frontend_url,
  }))
}
resource "aws_launch_template" "frontend" {
  name                   = "frontend-template"
  image_id               = var.amazon_ami
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.frontend.id,
  ]

  user_data = base64encode(templatefile("${path.root}/user_data/frontend.tpl", {
    api_url = var.backend_url
  }))
}
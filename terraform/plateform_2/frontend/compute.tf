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

resource "aws_launch_template" "frontend" {
  name                   = "frontend-template"
  image_id               = data.aws_ami.amazon_ami.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [
    aws_security_group.frontend.id,
  ]

  user_data = base64encode(templatefile("${path.root}/user_data/frontend.tpl", {
    api_url = aws_lb.front.dns_name
  }))
}
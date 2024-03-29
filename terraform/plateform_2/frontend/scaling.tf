resource "aws_autoscaling_group" "frontend" {
  name       = "frontend-asg"
  depends_on = [
    aws_launch_template.frontend,
  ]
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  min_size            = 1
  max_size            = 5
  desired_capacity    = 3
  vpc_zone_identifier = [
    aws_subnet.subnet_frontend_az_1.id, aws_subnet.subnet_frontend_az_2.id,
    aws_subnet.subnet_frontend_az_3.id
  ]
  target_group_arns = [
    aws_lb_target_group.front_80.arn,
    aws_lb_target_group.front_3000.arn
  ]
}

resource "aws_security_group" "frontend" {
  name        = "frontend"
  description = "Controls access to the frontend instances"
  vpc_id      = aws_vpc.frontend_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
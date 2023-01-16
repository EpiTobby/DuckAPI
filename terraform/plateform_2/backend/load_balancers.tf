resource "aws_lb" "back" {
  name               = "backend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend.id]
  subnets            = [
    aws_subnet.subnet_backend_az_1.id, aws_subnet.subnet_backend_az_2.id,
    aws_subnet.subnet_backend_az_3.id
  ]
  enable_cross_zone_load_balancing = "true"

  tags = {
    Environment = "back"
  }
}

resource "aws_lb_target_group" "backend_lb_target_group" {
  name     = "application-back"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.backend_vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 20
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.back.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
  }
}
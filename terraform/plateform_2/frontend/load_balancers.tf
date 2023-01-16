resource "aws_lb" "front" {
  name               = "frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend.id]
  subnets            = [
    aws_subnet.subnet_frontend_az_1.id, aws_subnet.subnet_frontend_az_2.id,
    aws_subnet.subnet_frontend_az_3.id
  ]
  enable_cross_zone_load_balancing = "true"

  tags = {
    Environment = "front"
  }
}

resource "aws_lb_target_group" "front_80" {
  name     = "application-front-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.frontend_vpc.id
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

resource "aws_lb_target_group" "front_3000" {
  name     = "application-front-3000"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.frontend_vpc.id
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

resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.front.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_80.arn
  }
}

resource "aws_lb_listener" "front_end_3000" {
  load_balancer_arn = aws_lb.front.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_3000.arn
  }
}
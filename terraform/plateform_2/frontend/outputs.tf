output "frontend-server" {
  value = aws_lb.front.dns_name
}
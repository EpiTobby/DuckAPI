output "backend-server" {
  value = aws_lb.back.dns_name
}

output "backend-vpc-cidr-block" {
  value = aws_vpc.backend_vpc.cidr_block
}
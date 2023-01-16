output "database_private_url" {
  value = aws_instance.mongo_server_primary.private_dns
}

output "database_public_url" {
  value = aws_instance.mongo_server_primary.public_dns
}
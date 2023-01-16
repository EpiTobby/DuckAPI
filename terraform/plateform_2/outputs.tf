output "frontend-server" {
  value = module.frontend.frontend-server
}

output "backend-server" {
  value = module.backend.backend-server
}


output "database-server" {
  value = module.database.database_public_url
}

output "private_key" {
  value     = tls_private_key.dev_key.private_key_pem
  sensitive = true
}
output "frontend-server" {
  value = module.frontend.frontend-server
}

output "private_key" {
  value     = tls_private_key.dev_key.private_key_pem
  sensitive = true
}
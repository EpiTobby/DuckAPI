output "gateway_url" {
  value = aws_api_gateway_deployment.api.invoke_url
}

output "gateway_stage_url" {
  value = aws_api_gateway_stage.api.invoke_url
}

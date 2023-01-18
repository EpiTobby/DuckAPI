output "gateway_stage_url" {
  value = aws_api_gateway_stage.api.invoke_url
}

output "front_url" {
  value = aws_s3_bucket_website_configuration.front.website_endpoint
}

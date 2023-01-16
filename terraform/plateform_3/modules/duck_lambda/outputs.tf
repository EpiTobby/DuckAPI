output "arn" {
  value = aws_lambda_function.create_duck.arn
}

output "function_name" {
  value = aws_lambda_function.create_duck.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.create_duck.invoke_arn
}
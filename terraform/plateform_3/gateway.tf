resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "duck-test-stage"
}

# Used to deploy the rest api
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# Rest API Gateway specifications
resource "aws_api_gateway_rest_api" "api" {

  name = "duck-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

##### Get all ducks
resource "aws_api_gateway_resource" "get_all" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "duck"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "get_all" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.get_all.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "get_all" {
  http_method             = aws_api_gateway_method.get_all.http_method
  resource_id             = aws_api_gateway_resource.get_all.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_get_all.invoke_arn
}

resource "aws_lambda_permission" "perm" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_get_all.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_all.http_method}${aws_api_gateway_resource.get_all.path}"
}

##### Create duck
resource "aws_api_gateway_resource" "create" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "duck"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "create" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.create.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "create" {
  http_method             = aws_api_gateway_method.create.http_method
  resource_id             = aws_api_gateway_resource.create.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_create.invoke_arn
}

resource "aws_lambda_permission" "create_duck" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_create.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.create.http_method}${aws_api_gateway_resource.create.path}"
}
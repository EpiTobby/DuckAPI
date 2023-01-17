resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "duck-test-stage"
}

# Used to deploy the rest api
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.create,
    aws_api_gateway_integration.delete,
    aws_api_gateway_integration.get_all,
    aws_api_gateway_integration.get_by_id,
    aws_api_gateway_integration.cors,
  ]
}

# Rest API Gateway specifications
resource "aws_api_gateway_rest_api" "api" {

  name = "duck-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

##### Get all ducks

resource "aws_api_gateway_method" "get_all" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.ducks.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "get_all" {
  http_method             = aws_api_gateway_method.get_all.http_method
  resource_id             = aws_api_gateway_resource.ducks.id
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
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_all.http_method}${aws_api_gateway_resource.ducks.path}"
}

resource "aws_api_gateway_resource" "ducks" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "ducks"
  rest_api_id = aws_api_gateway_rest_api.api.id
}


##### Create duck

resource "aws_api_gateway_method" "create" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.ducks.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "create" {
  http_method             = aws_api_gateway_method.create.http_method
  resource_id             = aws_api_gateway_resource.ducks.id
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
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.create.http_method}${aws_api_gateway_resource.ducks.path}"
}

##### Delete duck
resource "aws_api_gateway_resource" "uuid" {
  parent_id   = aws_api_gateway_resource.ducks.id
  path_part   = "{uuid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "delete" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.uuid.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "delete" {
  http_method             = aws_api_gateway_method.delete.http_method
  resource_id             = aws_api_gateway_resource.uuid.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_delete.invoke_arn
}

resource "aws_lambda_permission" "delete_duck" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_delete.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.delete.http_method}${aws_api_gateway_resource.uuid.path}"
}


##### Get duck by id
resource "aws_api_gateway_method" "get_by_id" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.uuid.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "get_by_id" {
  http_method             = aws_api_gateway_method.get_by_id.http_method
  resource_id             = aws_api_gateway_resource.uuid.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_get_by_id.invoke_arn
}

resource "aws_lambda_permission" "get_duck_by_id" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_get_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_by_id.http_method}${aws_api_gateway_resource.uuid.path}"
}


resource "aws_api_gateway_method_response" "get_all" {
  http_method = aws_api_gateway_method.get_all.http_method
  resource_id = aws_api_gateway_method.get_all.resource_id
  rest_api_id = aws_api_gateway_method.get_all.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "create" {
  http_method = aws_api_gateway_method.create.http_method
  resource_id = aws_api_gateway_method.create.resource_id
  rest_api_id = aws_api_gateway_method.create.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "get_all" {
  http_method = aws_api_gateway_method.get_all.http_method
  resource_id = aws_api_gateway_method.get_all.resource_id
  rest_api_id = aws_api_gateway_method.get_all.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,PATCH'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "create" {
  http_method = aws_api_gateway_method.create.http_method
  resource_id = aws_api_gateway_method.create.resource_id
  rest_api_id = aws_api_gateway_method.create.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,PATCH'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

##### Update duck by id
resource "aws_api_gateway_method" "update" {
  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.uuid.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "update" {
  http_method             = aws_api_gateway_method.update.http_method
  resource_id             = aws_api_gateway_resource.uuid.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_update.invoke_arn
}

resource "aws_lambda_permission" "update" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_update.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.update.http_method}${aws_api_gateway_resource.uuid.path}"
}


resource "aws_api_gateway_method_response" "update" {
  http_method = aws_api_gateway_method.update.http_method
  resource_id = aws_api_gateway_method.update.resource_id
  rest_api_id = aws_api_gateway_method.update.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "update" {
  http_method = aws_api_gateway_method.update.http_method
  resource_id = aws_api_gateway_method.update.resource_id
  rest_api_id = aws_api_gateway_method.update.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,PATCH'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

### CORS

resource "aws_api_gateway_method" "cors" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.ducks.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "cors" {
  http_method             = aws_api_gateway_method.cors.http_method
  resource_id             = aws_api_gateway_resource.ducks.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.lambda_cors.invoke_arn
}

resource "aws_api_gateway_method_response" "cors" {
  http_method = aws_api_gateway_method.cors.http_method
  resource_id = aws_api_gateway_method.cors.resource_id
  rest_api_id = aws_api_gateway_method.cors.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "cors" {
  http_method = aws_api_gateway_method.cors.http_method
  resource_id = aws_api_gateway_method.cors.resource_id
  rest_api_id = aws_api_gateway_method.cors.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,PATCH'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_lambda_permission" "cors" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_cors.function_name
  principal     = "apigateway.amazonaws.com"
  # source_arn    = "${aws_api_gateway_deployment.api.execution_arn}/*/*/*"
  source_arn    = "arn:aws:execute-api:eu-west-3:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.cors.http_method}${aws_api_gateway_resource.ducks.path}"
}
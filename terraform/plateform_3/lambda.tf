locals {
  lambda_payload_output_dir = "output/"
}

data "archive_file" "create_duck_payload" {
  source_file = "lambda/create_duck.py"
  output_path = "${local.lambda_payload_output_dir}create.zip"
  type = "zip"
}

resource "aws_lambda_function" "create_duck" {

  function_name = "create_duck"
  role          = aws_iam_role.lambdas.arn

  filename = "${local.lambda_payload_output_dir}create.zip"

  handler       = "create_duck.lambda_handler"

  runtime = "python3.9"
  source_code_hash = data.archive_file.create_duck_payload.output_path
}
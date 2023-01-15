locals {
  lambda_payload_output_dir = "output/"
}

data "archive_file" "payload" {
  source_file = "lambda/${var.name}.py"
  output_path = "${local.lambda_payload_output_dir}${var.name}.zip"
  type = "zip"
}

resource "aws_lambda_function" "create_duck" {

  function_name = var.name
  role          = var.iam_role_arn

  filename = "${local.lambda_payload_output_dir}${var.name}.zip"

  handler       = "${var.name}.lambda_handler"

  runtime = "python3.9"
  source_code_hash = data.archive_file.payload.output_path
}
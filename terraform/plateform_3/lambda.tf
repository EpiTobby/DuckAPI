module "lambda_create" {
  source = "./modules/duck_lambda"

  iam_role_arn = aws_iam_role.lambdas.arn
  name         = "create_duck"
}
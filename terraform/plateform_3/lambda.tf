module "lambda_create" {
  source = "./modules/duck_lambda"

  iam_role_arn = aws_iam_role.lambdas.arn
  name         = "create_duck"
}

module "lambda_get_all" {
  source = "./modules/duck_lambda"

  iam_role_arn = aws_iam_role.lambdas.arn
  name         = "get_all_ducks"
}

module "lambda_get_by_id" {
  source = "./modules/duck_lambda"

  iam_role_arn = aws_iam_role.lambdas.arn
  name         = "get_duck_by_uuid"
}
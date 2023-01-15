# IAM role to give to lambda functions
resource "aws_iam_role" "lambdas" {
  name = "lambdas_dynamo"

  managed_policy_arns = [
    aws_iam_policy.lambdas.arn
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "sts:AssumeRole",
          "sts:AssumeRoleWithWebIdentity"
        ],
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
          "Federated": "cognito-identity.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambdas" {
  name = "iam_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "lambda:InvokeFunctionUrl",
          "lambda:InvokeFunction",
          "lambda:InvokeAsync",
          "s3:ReplicateObject",
          "s3:PutObject",
          "s3:GetObject",
          "s3:RestoreObject",
          "s3:InitiateReplication",
          "s3:DeleteObject",
          "s3:GetBucketPolicy",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan"
        ],
        "Effect" : "Allow",
        "Sid" : "",
        "Resource" : [
          aws_dynamodb_table.ducks.arn,
          "${aws_dynamodb_table.ducks.arn}/*",
        ]
      }
    ]
  })
}
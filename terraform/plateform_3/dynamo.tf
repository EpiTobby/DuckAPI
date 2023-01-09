resource "aws_dynamodb_table" "ducks" {

  hash_key = "uuid"
  name     = "ducks"

  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "uuid"
    type = "S"
  }

  #  attribute {
  #    name = "name"
  #    type = "S"
  #  }
  #
  #  attribute {
  #    name = "age"
  #    type = "N"
  #  }
  #
  #  attribute {
  #    name = "color"
  #    type = "S"
  #  }
  #
  #  global_secondary_index {
  #    name            = "DucksColor"
  #    hash_key        = "uuid"
  #    range_key = "name"
  #    projection_type = "INCLUDE"
  #  }
}
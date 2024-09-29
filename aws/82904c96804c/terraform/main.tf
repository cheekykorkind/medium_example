resource "aws_dynamodb_table" "dynamo" {
  name         = "${var.app_name}-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "PK"
    type = "S"
  }
  attribute {
    name = "SK"
    type = "N"
  }
}

resource "aws_s3_bucket" "dynamo_export" {
  bucket = "${var.app_name}-dynamo-export" # 유니크한 이름이 되도록 변경추천합니다.
}

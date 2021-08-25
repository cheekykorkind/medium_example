resource "aws_lambda_function" "test_lambda" {
  filename      = var.lambda_zip_path
  function_name = "hello_lambda"
  role          = "whatever"
  handler       = "app.handler"

  source_code_hash = "${filebase64sha256(var.lambda_zip_path)}"

  runtime = "python3.8"
}
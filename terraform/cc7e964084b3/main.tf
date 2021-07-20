# secrets manager는 삭제에 시간이 필요합니다. 실험용으로 만들었다가 지웠다가 할때는 name을 조심합니다
resource "aws_secretsmanager_secret" "main" {
  name = "${var.app_name}_1"
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = jsonencode( {"db_password" = var.db_password} )

  # 최초 create할때만 실행하고, secrets manager가 만들어져있으면 Terraform에서는 값을 갱신하지 않음
  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

# db_password를 참조하려면
# jsondecode(aws_secretsmanager_secret_version.main.secret_string)["db_password"]
locals {
  container_type = [ "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10" ]
}

resource "null_resource" "install_dependencies" {
  for_each    = toset(local.container_type)

  # path.cwd는 terraform apply실행하는곳
  provisioner "local-exec" {
    working_dir = "${path.cwd}/../testing/lambda/${each.key}"
    command = <<-EOT
      docker run --rm -v $PWD:/local -w /local python:3.9.13-slim-bullseye /bin/bash -c '
        apt update && apt install -y zip wget git
        mkdir -p tmp
        cp app.py ./tmp
        cd tmp
        pip install requests -t .
        zip -r9 app.zip .
        mv app.zip ../app.zip
      '
    EOT
  }

  triggers = {
    dependencies_versions = filemd5("./lambda/${each.key}/app.py")
  }
}
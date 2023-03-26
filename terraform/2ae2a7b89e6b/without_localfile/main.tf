resource "null_resource" "install_package" {
  # path.cwd는 terraform apply실행하는곳
  provisioner "local-exec" {
    working_dir = "${path.cwd}/zip_dir"
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
    package_versions = filemd5("${path.cwd}/zip_dir/app.py")
  }
}

output "package_zip_path" {
  value = "${path.cwd}/zip_dir/app.zip"
}

output "package_zip_md5" {
  value = filemd5("${path.cwd}/zip_dir/app.zip")
}
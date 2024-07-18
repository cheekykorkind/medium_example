#!/bin/bash

apt install -y wget

wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip -o terraform_${TF_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
terraform --version
FROM python:3.13.4-slim-bookworm

RUN apt update && apt install -y sudo vim unzip wget zip curl git

# AWS CLI2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# terraform 1.12.2
ENV TF_VERSION 1.12.2

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

WORKDIR /workspace/myapp
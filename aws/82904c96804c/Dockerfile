FROM python:3.12.3-slim-bookworm

RUN apt update && apt install -y zip unzip sudo wget curl less && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# terraform 1.9.2
ENV TF_VERSION 1.9.2
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /workspace/terraform
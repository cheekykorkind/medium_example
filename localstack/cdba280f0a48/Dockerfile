# Lambda를 python3.8버전 사용할 예정이라, docker의 베이스를 python버전에 맞춰두면 편합니다
FROM python:3.8.11-slim-bullseye

RUN apt update && apt upgrade -y && apt install -y zip unzip sudo wget curl less

ARG UID=1001
ARG GID=1001
ARG UNAME=my-ec2-user

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root $UNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# terraform_1.0.2
ENV TF_VERSION 1.0.2

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

# AWS CLI인스톨
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# AWS SAM CLI인스톨
RUN wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
RUN unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
RUN ./sam-installation/install
RUN sam --version

# Localstack용 aws-sam-cli-local인스톨
USER $UNAME
RUN pip install aws-sam-cli-local
RUN echo "export PATH=\$PATH:\$HOME/.local/bin" >> $HOME/.bashrc
RUN . $HOME/.bashrc

USER root
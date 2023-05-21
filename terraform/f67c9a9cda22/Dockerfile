FROM python:3.9.13-slim-bullseye

RUN apt update && apt upgrade -y && apt install -y zip unzip sudo wget curl git

ARG UID=1001
ARG GID=1001
ARG UNAME=my-ec2-user

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

# nopass란 그룹을 만들고, sudo설정 파일에는 nopass그룹은 패스워드 요구하지 말도록 설정
RUN groupadd -g $GID nopass

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root,nopass ${UNAME}
RUN echo '%nopass ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# terraform 1.3.6
ENV TF_VERSION 1.3.6

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
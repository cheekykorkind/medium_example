FROM python:3.12.2-slim-bookworm

RUN apt update -y && apt install -y zip unzip sudo wget curl git

ARG UID=1001
ARG GID=1001
ARG UNAME=tf-user

RUN useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root ${UNAME}
RUN UNAME=${UNAME}
RUN echo "%${UNAME} ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

# terraform 1.7.5
ENV TF_VERSION 1.7.5

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
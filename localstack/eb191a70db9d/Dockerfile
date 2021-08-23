FROM python:3.9.6-slim-buster

RUN apt update && apt upgrade -y && apt install -y zip unzip sudo wget curl

ARG UID=1001
ARG GID=1001
ARG UNAME=my-ec2-user

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root $UNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
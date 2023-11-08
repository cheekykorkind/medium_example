FROM ruby:3.2.2-slim

RUN apt update && apt install -y curl sudo git make vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG UID=1001
ARG GID=1001
RUN useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root d-ec2-user
RUN echo "%d-ec2-user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

WORKDIR /workspace/myapp
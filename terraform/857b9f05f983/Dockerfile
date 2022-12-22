ARG ECR_PY_URI=python:3.9.13-slim-bullseye

FROM $ECR_PY_URI

RUN apt update && apt upgrade -y && apt install -y sudo curl gnupg vim unzip less wget zip

RUN apt -y install gnupg2 apt-transport-https software-properties-common ca-certificates && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt update && apt -y install docker-ce docker-ce-cli containerd.io

ARG USER_UID=1001
ARG DOCKER_GID
ARG UNAME

ENV USER_UID ${USER_UID}
ENV DOCKER_GID ${DOCKER_GID}
ENV UNAME ${UNAME}

RUN useradd --uid ${USER_UID} --create-home --shell /bin/bash -G sudo,root ${UNAME}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN groupmod -g $DOCKER_GID docker
RUN usermod -aG docker $UNAME

# AWS CLI2 인스톨
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# terraform_1.2.6
ENV TF_VERSION 1.2.6

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version
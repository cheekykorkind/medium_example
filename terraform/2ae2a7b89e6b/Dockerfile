FROM python:3.9.13-slim-bullseye

RUN apt update && apt upgrade -y && apt install -y sudo curl gnupg vim unzip less wget zip

RUN apt -y install gnupg2 apt-transport-https software-properties-common ca-certificates && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt update && apt -y install docker-ce docker-ce-cli containerd.io

ARG USER_UID
ARG DOCKER_GID
ARG UNAME

ENV USER_UID ${USER_UID}
ENV DOCKER_GID ${DOCKER_GID}
ENV UNAME ${UNAME}

# docker in docker를 위해 도커 그룹 설정. 호스트 머신의 도커 그룹 아이디와 동일한 그룹 아이디로 함.
RUN groupmod -g $DOCKER_GID docker

RUN useradd --uid ${USER_UID} --gid ${DOCKER_GID} --create-home --shell /bin/bash -G sudo,root ${UNAME}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN usermod -aG docker $UNAME

RUN curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# terraform_1.3.6
ENV TF_VERSION 1.3.6

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version
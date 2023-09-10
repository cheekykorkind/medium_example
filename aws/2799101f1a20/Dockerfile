FROM python:3.10.11-slim-bullseye

RUN apt update && apt install -y sudo

ARG UID=1001
ARG GID=1001
ARG UNAME

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

# nopass란 그룹을 만들고, sudo설정 파일에는 nopass그룹은 패스워드 요구하지 말도록 설정
RUN groupadd -g $GID nopass

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root,nopass ${UNAME}
RUN echo '%nopass ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
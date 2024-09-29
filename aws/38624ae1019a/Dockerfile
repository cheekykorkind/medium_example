FROM python:3.12.3-slim-bookworm

RUN apt update && apt install -y sudo curl vim tcpdump && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install paho-mqtt==2.1.0

WORKDIR /workspace/myapp
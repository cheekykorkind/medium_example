FROM python:3.12.3-slim-bookworm

RUN apt update && apt install -y sudo curl vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/myapp
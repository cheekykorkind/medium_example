FROM ruby:3.4.2-slim

RUN apt update && apt install -y sudo unzip vim libcurl4-openssl-dev build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/myapp
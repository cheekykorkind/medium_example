#!/usr/bin/env bash

IMAGE="s-t-j1-repo"
PROFILE="create_training_job"
MY_ACCOUNT=$(aws sts get-caller-identity --query Account --output text --profile ${PROFILE})
REGION=$(aws configure get region --profile ${PROFILE})
ECR_REPO="${MY_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE}"

aws ecr get-login-password --region "${REGION}" --profile ${PROFILE} | docker login --username AWS --password-stdin "${MY_ACCOUNT}".dkr.ecr."${REGION}".amazonaws.com

docker build -t $IMAGE -f DockerfileTrainingJob .
docker tag "${IMAGE}:latest" "${ECR_REPO}:latest"
docker push "${ECR_REPO}:latest"
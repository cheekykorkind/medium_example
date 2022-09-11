#!/bin/bash

AWS_PROFILE_NAME=two-ecs-deploy-tf
AWS_APP_NAME=two-ecs-deploy

git archive -o build.zip HEAD

aws s3 cp ./build.zip s3://$AWS_APP_NAME-pipeline-src/build.zip --profile $AWS_PROFILE_NAME
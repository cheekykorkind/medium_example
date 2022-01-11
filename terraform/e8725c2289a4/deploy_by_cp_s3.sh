#!/bin/bash

AWS_PROFILE_NAME=codepipeline_src_s3
AWS_APP_NAME=codepipeline-src-s3

git archive -o build.zip HEAD

aws s3 cp ./build.zip s3://$AWS_APP_NAME-pipeline-src/build.zip --profile $AWS_PROFILE_NAME
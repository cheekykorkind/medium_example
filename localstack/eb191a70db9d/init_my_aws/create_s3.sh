#!/bin/bash

# $LOCALSTACK_HOSTNAME은 Localstack이 디폴트로 설정한 환경변수들 중에 하나
aws s3 mb s3://mybucket --endpoint-url http://$LOCALSTACK_HOSTNAME:4566

echo "s3 bucket is created"
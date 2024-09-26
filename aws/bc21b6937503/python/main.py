import os
import sys

sys.path.append(os.path.join(os.path.abspath(os.path.dirname(__file__)), "packages"))

import boto3

dynamodb_client = boto3.client(
    "dynamodb",
    region_name="us-east-1",
    endpoint_url="http://boto3-pi:4566",
)
table_name = "user"

param = {
    "TableName": table_name,
    "ScanIndexForward": False,
    "KeyConditionExpression": "PK = :PK",
    "ExpressionAttributeValues": {":PK": {"S": f"u#1"}},
}
dynamodb_client.query(**param)
print("main.py end")
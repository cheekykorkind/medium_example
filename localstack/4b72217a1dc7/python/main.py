import boto3
from boto3.dynamodb.types import TypeSerializer


dynamodb_client = boto3.client(
    "dynamodb",
    region_name="us-east-1",
    endpoint_url="http://localstack350:4566",
)
table_name = "user"

# Amazon DynamoDB의 table에 값을 put합니다
item = {
    "PK": f"u#1",
    "SK": "count",
    "name": "user1",
}
payload = {
    "TableName": table_name,
    "Item": {k: TypeSerializer().serialize(v) for k, v in item.items()},
    "ReturnConsumedCapacity": 'TOTAL'
}
dynamodb_client.put_item(**payload)


# Amazon DynamoDB의 table을 스캔해서 put이 성공했는지 확인합니다.
response = dynamodb_client.scan(
    TableName=table_name
)
items = response.get('Items', [])
for item in items:
    print(item)

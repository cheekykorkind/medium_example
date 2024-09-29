import boto3
import gzip
import json
from io import BytesIO

# S3 설정
session = boto3.Session(
    profile_name="dxs", region_name="ap-northeast-1"
)
s3 = session.client("s3")
bucket_name = "dxs-dynamo-export" # main.tf에서 설정한 S3 bucket이름입니다
prefix = "AWSDynamoDB/xx/data/" # AWS콘솔에서 Export details의 Manifest file path의 S3경로에서 ExportId값을 확인해서 xx를 작성하시면 됩니다.


# gz파일의 데이터를 모을 list
all_data = []

# S3에서 파일 이름을 list로 정리
response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
files = [obj["Key"] for obj in response.get("Contents", [])]

# 하나하나 json
for file_key in files:
    print(f"Processing {file_key}...")
    response = s3.get_object(Bucket=bucket_name, Key=file_key)
    with gzip.GzipFile(fileobj=BytesIO(response["Body"].read())) as gz_file:
        for line in gz_file:
            all_data.append(json.loads(line))

# 모든 JSON 데이터를 하나의 JSON 파일로 저장
with open('combined_gzs.json', 'w') as f:
    json.dump(all_data, f, indent=2)

print("Done.")
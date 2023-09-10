import os

from s3_client import S3Client


def handler(event, context):
    expires_in = event["arguments"]["expiresIn"] # from AppSync
    bucket_name = os.environ.get("STORAGE_MYDATA_BUCKETNAME")
    env = os.environ.get("ENV")
    s3_key = f"{env}/data.json"

    # Check expires_in
    if expires_in > 30:
        message = "no. too long!!!!"
        return {"message": message}

    c = S3Client()
    result_url = c.presigned_url(bucket_name, s3_key, expires_in)
    return {"message": result_url}
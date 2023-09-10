import boto3


class S3Client:
    def __init__(self):
        self.client = boto3.client("s3")

    def presigned_url(self, bucket_name: str, s3_key: str, expires_in: int) -> str:
        url = self.client.generate_presigned_url(
            ClientMethod="put_object",
            Params={"Bucket": bucket_name, "Key": s3_key},
            ExpiresIn=expires_in,
            HttpMethod="PUT",
        )
        return url
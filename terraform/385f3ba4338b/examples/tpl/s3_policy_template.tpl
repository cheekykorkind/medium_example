{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${my-value}",
                "arn:aws:s3:::${my-value}/*"
            ]
        }
    ]
}
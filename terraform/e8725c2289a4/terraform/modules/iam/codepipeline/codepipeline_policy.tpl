{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Sid": "CodeBuildPolicy",
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${s3_pipeline_artifact_id}",
                "arn:aws:s3:::${s3_pipeline_artifact_id}/*",
                "arn:aws:s3:::${s3_codebuild_buildspec_id}",
                "arn:aws:s3:::${s3_codebuild_buildspec_id}/*"
            ]
        },
        {
            "Action": [
                "elasticloadbalancing:*",
                "cloudwatch:*",
                "sns:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
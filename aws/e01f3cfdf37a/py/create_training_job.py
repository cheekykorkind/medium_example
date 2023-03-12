import boto3
from datetime import datetime

aws_session = boto3.Session(
    profile_name='create_training_job', region_name='ap-northeast-1'
)
client = aws_session.client('sagemaker')
account_id = aws_session.client('sts').get_caller_identity().get('Account')

terraform_varibale_app_name = 's-t-j1'
unixtime = int(datetime.timestamp(datetime.today()))
train_job_name = f'{terraform_varibale_app_name}-{unixtime}'
ecr_registry_name = f'{terraform_varibale_app_name}-repo'
iam_role_name = f'{terraform_varibale_app_name}-role'
s3_name = f'{terraform_varibale_app_name}-bucket'

ecr_path = f'{account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/{ecr_registry_name}:latest'
iam_role_arn = f'arn:aws:iam::{account_id}:role/{iam_role_name}'
s3_output_path = f's3://{s3_name}/output'

training_params = {
    'TrainingJobName': train_job_name,
    'AlgorithmSpecification': {
        'TrainingImage': ecr_path,
        'TrainingInputMode': 'File'
    },
    'RoleArn': iam_role_arn,
    'OutputDataConfig': {
        'S3OutputPath': s3_output_path
    },
    'ResourceConfig': {
        'InstanceType': 'ml.m4.xlarge',
        'InstanceCount': 1,
        'VolumeSizeInGB': 10
    },
    'StoppingCondition': {
        'MaxRuntimeInSeconds': 60*5
    }
    # 'VpcConfig': {
    #     'SecurityGroupIds': [
    #         'sg-xxxxxxxxxxx',
    #     ],
    #     'Subnets': ['subnet-yyyyyyyyyy'],
    # }
}

response = client.create_training_job(**training_params)
print(response)
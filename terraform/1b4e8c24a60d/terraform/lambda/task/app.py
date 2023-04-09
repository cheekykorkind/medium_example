import json

def lambda_handler(event, context):
    print("Lambda Request ID:", context.aws_request_id)
    print("Lambda event:", event)
    return event

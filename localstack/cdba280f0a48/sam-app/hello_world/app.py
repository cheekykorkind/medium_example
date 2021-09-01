import os
import sys
import json
import logging
import requests as rqs

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        ip = rqs.get("http://checkip.amazonaws.com/")
        logging.info(ip)
    except rqs.RequestException as e:
        logging.info('erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr')

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello worldddddddddd",
        }),
    }
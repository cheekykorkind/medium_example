import os
import sys
sys.path.append(os.path.join(sys.path[0], "packages"))

import json
import logging
import packages.requests as rqs

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
  try:
    ip = rqs.get("http://checkip.amazonaws.com/")
    logging.info(ip)
  except rqs.RequestException as e:
    logging.info('erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr')

  return {
    "statusCode": 200,
    "body": json.dumps({
      "message": "hello world",
    }),
  }
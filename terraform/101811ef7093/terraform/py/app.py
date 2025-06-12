import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    batch_item_failures = []
    for record in event["Records"]:
        try:
            process_message(record)
        except Exception:
            batch_item_failures.append({"itemIdentifier": record["messageId"]})
    return {"batchItemFailures": batch_item_failures}


def process_message(record):
    message_id = record["messageId"]
    message_body = record["body"]

    logger.info(f"Processing message : {message_id}")
    

    try:
        data = json.loads(message_body)
        logger.info(f"message body : {data}")

        if data.get("action") == "fail":
            raise ValueError("Designed failure")

        logger.info(f"Message processing successful : {message_id}")

    except Exception as e:
        logger.error(f"Message processing failed: {e}")
        raise e

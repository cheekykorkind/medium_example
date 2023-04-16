import json
import os

SFN_BUCKET = os.environ.get("SFN_BUCKET")
SFN_BUCKET_ITEM_READER_KEY = os.environ.get("SFN_BUCKET_ITEM_READER_KEY")

def lambda_handler(event, context):
    print("1. Download original data file.")
    print("2. Preprocess original data file into a CSV file.")
    print(f"3. Upload the CSV file to S3({SFN_BUCKET}/{SFN_BUCKET_ITEM_READER_KEY}).")

    return {"sfn_bucket": SFN_BUCKET, "sfn_bucket_item_reader_key": SFN_BUCKET_ITEM_READER_KEY}

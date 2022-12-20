import requests

def handler(event, context):
    response = requests.get("https://실험하고싶은곳/")
    print(response.status_code)
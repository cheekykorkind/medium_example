import pytest
import os
import sys
from pytest import MonkeyPatch
from unittest.mock import patch

# ./amplify/backend
backend_dir = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
sys.path.append(backend_dir) # For "from function.myFunction.src.index import *"
sys.path.append(os.path.join(backend_dir, "function/myLambdaLayer/lib/python")) # For "from s3_client import S3Client" in ./amplify/backend/function/myFunction/src/index.py

from function.myFunction.src.index import *


@pytest.mark.parametrize(
    "event, envs, result_url, expected",
    [
        (
            {
                "arguments": {"expiresIn": 20}
            },
            {
                "STORAGE_MYDATA_BUCKETNAME": ""
            },
            "stuburl",
            {"message": "stuburl"},
        ),
        (
            {
                "arguments": {"expiresIn": 60}
            },
            {
                "STORAGE_MYDATA_BUCKETNAME": ""
            },
            "stuburl",
            {"message": "no. too long!!!!"},
        )
    ],
)
def test_handler(event, envs, result_url, expected):
    Set the environment variable in index.py to test.
    mp = pytest.MonkeyPatch()
    for key, value in envs.items():
        mp.setenv(key, value)

    index_py_path = "function.myFunction.src.index"
    p1 = patch(f"{index_py_path}.S3Client") # Mock S3Client() in index.py to make the code run to the end.
    with p1 as m1:
        m1.return_value.presigned_url.return_value = result_url # Stub the return value of c.presigned_url in index.py to make the code run to the end.
        result = handler(event, {})

    assert expected == result
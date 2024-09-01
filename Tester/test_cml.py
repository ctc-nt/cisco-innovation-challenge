import requests
import os
import pytest

def test_get_request_root():
    url = f"http://cml:8000/"
    response = requests.get(url)
    assert response.status_code == 200
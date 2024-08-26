import requests
import os

def test_get_request_cardAction():
    url = f"https://{os.environ.get("NGROK_DOMAIN")}/cardAction"
    response = requests.get(url)
    assert response.status_code == 405

def test_get_request_message():
    url = f"https://{os.environ.get("NGROK_DOMAIN")}/message"
    response = requests.get(url)
    assert response.status_code == 405

def test_get_webex_hook():
    url = "https://webexapis.com/v1/webhooks"

    headers = {
        'authorization': f"Bearer {os.environ.get('webex_token')}",
        'content-type': "application/json"
        }

    response = requests.request("GET", url, headers=headers)
    assert response.json().get("items")[0].get("targetUrl") == f"https://{os.environ.get("NGROK_DOMAIN")}/cardAction"
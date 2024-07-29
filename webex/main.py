from fastapi import FastAPI
from typing import Dict
import requests
import json
import os

app = FastAPI()

headers = {
    'authorization': f"Bearer {os.environ.get('webex_token')}",
    'content-type': "application/json"
}


def get_message(id:Dict):
    url = f"https://webexapis.com/v1/messages/{id}"
    response = requests.get(url, headers=headers)
    return response.json().get("text")


def post_message(room_id,message:Dict):
    url = f"https://webexapis.com/v1/messages/"
    payload = {
        "roomId": room_id,
        "text": message,
    }
    response = requests.post(url,headers=headers,data=json.dumps(payload))
    print(response.text)

@app.post("/message")
async def message(message:Dict):
    # print(message)
    print(headers)
    message_id = message.get("data").get("id")
    room_id = message.get("data").get("roomId")
    print(message_id,room_id)
    post_message(room_id,"hoge")



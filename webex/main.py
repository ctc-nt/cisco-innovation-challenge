from fastapi import FastAPI
from typing import Dict
import requests
import json
import os

app = FastAPI()

headers = {
    "authorization": f"Bearer {os.environ.get('webex_token')}",
    "content-type": "application/json",
}


def get_message(id: Dict):
    url = f"https://webexapis.com/v1/messages/{id}"
    response = requests.get(url, headers=headers)
    return response.json().get("text")


def post_message(room_id, message: Dict):
    url = f"https://webexapis.com/v1/messages/"
    payload = {
        "roomId": room_id,
        "text": message,
    }
    response = requests.post(url, headers=headers, data=json.dumps(payload))


def post_card(room_id):
    url = f"https://webexapis.com/v1/messages/"
    payload = {
        "roomId": room_id,
        "markdown": "[Tell us about yourself](https://www.example.com/form/book-vacation). We just need a few more details to get you booked for the trip of a lifetime!",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "content": {
                    "type": "AdaptiveCard",
                    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                    "version": "1.3",
                    "body": [
                        {
                            "type": "TextBlock",
                            "text": "Network AI Assistant",
                            "wrap": True,
                            "fontType": "Monospace",
                            "size": "ExtraLarge",
                            "weight": "Bolder",
                            "color": "Dark",
                        },
                        {
                            "type": "Input.ChoiceSet",
                            "choices": [
                                {"title": "Deploy Network", "value": "deploy"},
                                {
                                    "title": "Troubleshoot Network",
                                    "value": "troubleshoot",
                                },
                            ],
                            "placeholder": "Choose Operation",
                            "style": "expanded",
                            "id": "type",
                        },
                        {
                            "type": "Input.Text",
                            "placeholder": "Placeholder text",
                            "id": "input",
                            "value": "input your question",
                        },
                    ],
                    "actions": [
                        {
                            "type": "Action.Submit",
                            "title": "Submit",
                            "associatedInputs": "auto",
                            "id": "submit",
                        }
                    ],
                },
            }
        ],
    }
    response = requests.post(url, headers=headers, data=json.dumps(payload))


def get_attachment(id: Dict):
    url = f"https://webexapis.com/v1/attachment/actions/{id}"
    response = requests.get(url, headers=headers)
    return response.json().get("inputs")


@app.post("/message")
async def message(message: Dict):
    if message.get("data").get("personEmail") != "ai-ctc@webex.bot":
        room_id = message.get("data").get("roomId")
        print(json.dumps(message, indent=2))
        post_card(room_id)
        # Backendは根本になると思う


@app.post("/cardAction")
async def cardAction(message: Dict):
    if message.get("data").get("personEmail") != "ai-ctc@webex.bot":
        room_id = message.get("data").get("roomId")
        print(json.dumps(message, indent=2))
        response = get_attachment(message.get("data").get("id"))
        post_message(room_id, f"Type is {response.get('type')}, Input is {response.get('input')}")

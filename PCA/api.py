from fastapi import FastAPI
from typing import Dict
import requests
import json
import os
from urllib.parse import urlencode

app = FastAPI()

analytics_url = os.environ.get("analytics_url")


@app.get("/login")
def login():
    url = f"https://{analytics_url}/api/v1/auth/login?{urlencode({'username': os.environ.get('accedian_user'), 'password': os.environ.get('accedian_password')})}"
    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
    }
    data = {
        "username": os.environ.get("accedian_user"),
        "password": os.environ.get("accedian_password"),
    }
    response = requests.post(url, headers=headers)
    return response.headers["Authorization"]


@app.post("/get_sessions")
def get_sessions(token: str):
    url = f"https://{analytics_url}/api/orchestrate/v3/agents/sessions"
    headers = {
        "Cookie": f"skylight-aaa={token.split()[1]}",
    }
    response = requests.get(url, headers=headers)

    return response.json()


@app.post("/get_session")
def get_session(token: str, session_id: str):
    url = (
        f"https://{analytics_url}/api/orchestrate/v3/agents/sessionstatus/{session_id}"
    )

    headers = {
        "Cookie": f"skylight-aaa={token.split()[1]}",
    }
    response = requests.get(url, headers=headers)
    print(response.request.url)
    print(response.status_code)

    return response.json()

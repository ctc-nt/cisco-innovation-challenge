from fastapi import FastAPI
from fastapi import HTTPException
import requests
import os
from urllib.parse import urlencode
from datetime import datetime

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


@app.post("/get_monitored_objects")
def get_monitored_objects(token: str):
    url = f"https://{analytics_url}/api/v2/monitored-objects"

    headers = {
        "Cookie": f"skylight-aaa={token.split()[1]}",
    }
    response = requests.get(url, headers=headers)

    return response.json()


@app.post("/get_metrics")
def get_metrics(token: str, object_id: str, start: int, end: int):
    url = f"https://{analytics_url}/api/v3/metrics/aggregate"

    headers = {
        "Cookie": f"skylight-aaa={token.split()[1]}",
    }
    try:
        start = datetime.fromtimestamp(start).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]
        end   = datetime.fromtimestamp(end).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid timestamp")

    body = {
        "data": {
            "type": "aggregates",
            "attributes": {
                "interval": f"{start}Z/{end}Z",
                "aggregation": "avg",
                "granularity": "PT1M",
                "metrics": [
                    {
                        "direction": ["2"],
                        "objectType": ["twamp-sl"],
                        "metric": "packetsLostPct",
                    },
                    {
                        "direction": ["0"],
                        "objectType": ["twamp-sl"],
                        "metric": "delayP95",
                    },
                ],
                "globalMetricFilterContext": {
                    "monitoredObjectId": [object_id]
                },
            },
        }
    }
    try:
        response = requests.post(url, headers=headers, json=body)
        response.raise_for_status()
    except Exception as e:
        print(e.args)
        raise HTTPException(status_code=500, detail="Failed to retrieve metrics")

    return response.json()

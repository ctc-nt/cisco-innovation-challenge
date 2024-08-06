# before run application

## CreateBot and Setup Bot

You need to create your bot via webexdevelopers web.
https://gblogs.cisco.com/jp/2021/08/make-meeting-reservation-system-by-webex-api-3/

Don't forget to send DirectMessage to your bot to initialize.
After that, you can invite your bot to your space.

Set your Environment Variable as below:
export webex_token = BotToken
export bot_email = BotEmail

## Setup Webex webhook and establish ngrok tunnel
You have to configure two webhooks via webexAPI

First webhook to be used for receiving message to invoke AI chatbot.
Second one is, to be used for receiving card action to communicate with LangChain

For Detail, See webex.rest and ngrok-startup.sh

# Python Environment

Python 3.12.4 with poetry

# run FastAPI

uvicorn api:app --reload --port=8000 --host=0.0.0.0
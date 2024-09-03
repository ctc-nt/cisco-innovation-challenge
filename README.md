# Partner Innovation Challenge 2024

This Repository is made for Cisco Partner Innovation Challenge 2024.

# Concepts

Combination of AIOpS/GitOpS/ChatOpS mainly with Cisco Solutions.

We developed prototype software for  Proof of Concept.

# Rule

- Only Permit English
- Need design document with Markdown in GitHub for every function
- Need test code for every function
- Every environment should be in Cloud

# Components

Should be updated

## Webex Gateway

## LangChain

## CML

## PCA Gat

# Architecture

This repository is managed with Mono-Repository and designed as mircoservice for using Container.
We put compose.yaml to orchastrate all services easily and quickly to reduce development and maitenance cost.

# How to run

## CreateWebexBot and SetupWebexBot

You need to create your bot via webexdevelopers web.
https://gblogs.cisco.com/jp/2021/08/make-meeting-reservation-system-by-webex-api-3/

Don't forget to send DirectMessage to your bot to initialize.
After that, you can invite your bot to your space.

## Setup Webex webhook and establish ngrok tunnel
You have to configure two webhooks via webexAPI

First webhook to be used for receiving message to invoke AI chatbot.
Second one is, to be used for receiving card action to communicate with LangChain

For Detail, See webex/webex.rest and webex/ngrok-startup.sh

Make .env file with following example

```
webex_token = your_token
bot_email = your_email
analytics_url=your_url
accedian_user=your_user
accedian_password=your_password
TF_VAR_cml_address=your_address
TF_VAR_cml_password=your_password
TF_VAR_cml_user=your_user
OPENAI_API_KEY=your_API_KEY
NGROK_AUTHTOKEN=your_token
NGROK_DOMAIN=your_domain : hoge.fuga.app, you don't need http:// and last /
```

Run docker compose

```
docker compose up -d
```


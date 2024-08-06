from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI

import os
import logging
import datetime
import logging

from fastapi import FastAPI
from typing import Dict

lc_logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)



app = FastAPI()

def answer(query, dir_path, model):
    llm = ChatOpenAI(model_name=model, temperature=0.2)

    embedding = OpenAIEmbeddings()

    loaders = [TextLoader(f"{dir_path}/{file}") for file in os.listdir(dir_path)]

    lc_logger.info(f"START: {datetime.datetime.now()}")

    vsi = VectorstoreIndexCreator(
        vectorstore_cls=Chroma,
        embedding=embedding,
    ).from_loaders(loaders)

    lc_logger.info(f"END: {datetime.datetime.now()}")

    answer = vsi.query(query, llm=llm)

    print(answer)
    return {"answer":answer}

@app.post("/query")
def query(body:Dict):
    print(body)
    return answer(body.get("input"), "base-knowledge", "gpt-4-turbo-preview")    
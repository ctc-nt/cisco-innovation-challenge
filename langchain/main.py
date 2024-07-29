from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI

import os
import argparse
import logging
import datetime
import logging

lc_logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def main(dir_path, model):
    llm = ChatOpenAI(model_name=model, temperature=0.2)

    embedding = OpenAIEmbeddings()

    loaders = [TextLoader(f"{dir_path}/{file}") for file in os.listdir(dir_path)]

    lc_logger.info(f"START: {datetime.datetime.now()}")

    vsi = VectorstoreIndexCreator(
        vectorstore_cls=Chroma,
        embedding=embedding,
    ).from_loaders(loaders)

    lc_logger.info(f"END: {datetime.datetime.now()}")

    continue_query = True

    while continue_query:
        質問 = input("質問は？")

        ans = vsi.query(質問, llm=llm)

        print(ans)

        if 質問 == "なし":
            continue_query = False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="与えられた path 内の情報を事前情報として、インタラクティブに質問に回答します"
    )
    parser.add_argument(
        "-m", "--model", default="gpt-4-turbo-preview", choices=["gpt-4-turbo-preview"]
    )
    parser.add_argument(
        "-d",
        "--dir",
        help="事前情報が格納されたディレクトリ",
        required=True,
    )

    args = parser.parse_args()

    main(model=args.model, dir_path=args.dir)

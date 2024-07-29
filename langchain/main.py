import os
import datetime
import logging
import argparse

from langchain_community.document_loaders import GitLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI

lc_logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def create_vectorstore_from_git(url, branch, embedding, filter_func=None):

    loaders = [
        GitLoader(
            clone_url=url,
            branch=branch,
            repo_path=os.path.join("git-dir", os.path.basename(url)),
            file_filter=filter_func,
        ),
    ]

    lc_logger.info(f"START: {datetime.datetime.now()}")

    vectorstoreindex = VectorstoreIndexCreator(
        vectorstore_cls=Chroma,
        embedding=embedding,
        vectorstore_kwargs={
            "persist_directory": "git-dir/{}.db".format(os.path.basename(url))
        },
    ).from_loaders(loaders)

    lc_logger.info(f"END: {datetime.datetime.now()}")

    return vectorstoreindex


def main(url, branch, gpt_model, query):
    embedding = OpenAIEmbeddings()
    vsi = create_vectorstore_from_git(url=url, branch=branch, embedding=embedding)
    llm = ChatOpenAI(model=gpt_model)

    answer = vsi.query(query, llm=llm)

    print(answer)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="与えられた Git URL から clone し、\nその内容についての質問に OpenAI LLM が回答します"
    )
    parser.add_argument(
        "--model", default="gpt-4-turbo-preview", choices=["gpt-4-turbo-preview"]
    )
    parser.add_argument(
        "--git-url",
        help="インターネットから到達可能な public なリポジトリ",
        required=True,
    )
    parser.add_argument("--git-branch", help="git branch", required=True)
    parser.add_argument("--query", help="LLM への質問文", required=True)

    args = parser.parse_args()

    main(
        gpt_model=args.model,
        url=args.git_url,
        branch=args.git_branch,
        query=args.query,
    )

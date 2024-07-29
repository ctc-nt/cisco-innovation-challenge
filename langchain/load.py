import logging

from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain.chains.retrieval_qa.base import RetrievalQA

lc_logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

embedding = OpenAIEmbeddings()

db = Chroma(persist_directory="./git-dir/nvw.db", embedding_function=OpenAIEmbeddings())

retriever = db.as_retriever()

llm = ChatOpenAI(model="gpt-4-turbo-preview")

qa = RetrievalQA.from_llm(llm=llm, retriever=retriever)

print(qa.run("nvw を要約して"))

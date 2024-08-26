FROM python:3.12.4-slim-bullseye

WORKDIR /app
RUN apt update && apt install -y curl git gcc make tcl && \
git clone --depth=1 -b version-3.38.1 https://github.com/sqlite/sqlite.git && \
cd sqlite && \
./configure && make -j$(nproc) && make install && \
sqlite3 --version
COPY pyproject.toml poetry.lock /app/
RUN pip install poetry
RUN poetry install --no-cache

ENTRYPOINT [ "poetry", "run" ]
CMD ["uvicorn", "api:app","--reload","--host", "0.0.0.0", "--port", "8000"]
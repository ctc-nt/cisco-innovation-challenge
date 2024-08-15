FROM python:3.12.4-slim-bullseye

WORKDIR /app
COPY pyproject.toml poetry.lock /app/
RUN pip install poetry
RUN poetry install --no-cache

ENTRYPOINT [ "poetry", "run" ]
CMD ["uvicorn", "api:app","--reload","--host", "0.0.0.0", "--port", "8000"]
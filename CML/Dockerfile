FROM hashicorp/terraform:1.9.5 AS builder

WORKDIR /app
RUN which terraform
RUN terraform output -json > terraform_output.json

FROM python:3.12.4-slim-bullseye


COPY --from=builder /bin/terraform /bin/terraform

WORKDIR /app
RUN apt update && apt install curl -y
COPY pyproject.toml poetry.lock /app/
RUN pip install poetry
RUN poetry install --no-cache

ENTRYPOINT [ "poetry", "run" ]
CMD ["uvicorn", "api:app","--reload","--host", "0.0.0.0", "--port", "8000"]
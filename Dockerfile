# syntax=docker/dockerfile:1

FROM python:3.10-bullseye AS compile-image

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc rustc

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --upgrade pip && pip install wheel && pip install -r requirements.txt

FROM python:3.10-slim-bullseye

COPY --from=compile-image /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY main.py .

ENTRYPOINT ["/opt/venv/bin/python3", "-u", "main.py"]

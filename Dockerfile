FROM python:3.8-slim-buster

WORKDIR /app

COPY main.py main.py
COPY requirements.txt requirements.txt
COPY Dockerfile Dockerfile

RUN pip3 install -r requirements.txt

CMD ["python", "main.py", "--host=0.0.0.0"]
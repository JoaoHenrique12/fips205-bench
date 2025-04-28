FROM python:3.9-slim-buster

WORKDIR /app

COPY git-repository/ /app
COPY main.py /app
COPY entrypoint.sh /app

# Install dependencies specified in requirements.txt
# If a requirements.txt do not exists, this step will be skipped
RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi


CMD ["./entrypoint.sh"]

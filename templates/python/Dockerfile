FROM python:3.9-slim-buster

WORKDIR /app

COPY git-repository/ /app
COPY main.py /app
COPY entrypoint.sh /app

# Install dependencies specified in requirements.txt
# If a requirements.txt do not exists, this step will be skipped
RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi


# this avoid run as root. without this, files created inside
# the container have messed permissions when linked to local volumes.
# use uid 1000 solve the problem to bind volumes from 'my machine' and
# container volume
RUN adduser --system --uid 1000 --group testuser

RUN chown -R testuser:testuser /app

USER testuser

CMD ["./entrypoint.sh"]

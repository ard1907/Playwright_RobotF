FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Browser Library installieren
RUN rfbrowser init

COPY . .

CMD ["robot", "tests/"]
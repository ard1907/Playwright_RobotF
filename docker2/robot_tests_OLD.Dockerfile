# 1️⃣ Basis-Image mit Python und Playwright
FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

# 2️⃣ Arbeitsverzeichnis im Container
WORKDIR /app

# 3️⃣ Python-Abhängigkeiten installieren
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

RUN apt-get update && apt-get install -y nodejs npm

# 4️⃣ Playwright Browser installieren
RUN rfbrowser init

# 5️⃣ Restliche Projektdateien kopieren
COPY . .

# 6️⃣ Robot Framework Tests ausführen, wenn Container startet
# CMD ["robot", "tests/"]
# CMD ["robot", "-v", "CI:True", "-v", "CI_SELF_HOSTED:True", "-v", "HEADLESS:True", "-v", "BASE_URL:https://qs-datenschutzcockpit.dsc.govkg.de/spa/", "-v", "BROWSER:chromium", "--outputdir", "/app/results2", "tests/"]
CMD ["robot", \
     "-v", "CI:True", \
     "-v", "CI_SELF_HOSTED:True", \
     "-v", "HEADLESS:True", \
     "-v", "BASE_URL:https://qs-datenschutzcockpit.dsc.govkg.de/spa/", \
     "-v", "BROWSER:chromium", \
     "--outputdir", "/app/results2", \
     "tests/"]
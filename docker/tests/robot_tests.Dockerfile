# =========================
# 1️⃣ Builder Stage
# =========================
FROM python:3.11-slim AS builder

WORKDIR /app

# Use non-interactive frontend to avoid prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Security patch: use distro-provided Node.js/npm instead of piping a remote bootstrap script into bash.
# System-Abhängigkeiten + Node.js
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         curl \
#         gnupg \
#         ca-certificates \
#     && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
#     && apt-get install -y --no-install-recommends nodejs \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python Dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Robot Framework Browser installieren (ohne Browser-Download hier!)
RUN pip install --no-cache-dir robotframework-browser

# =========================
# 2️⃣ Final Stage
# =========================
FROM python:3.11-slim

WORKDIR /app

# Use non-interactive frontend in final stage as well
ENV DEBIAN_FRONTEND=noninteractive

# Security patch: remove the remote browser download path and keep only the runtime libraries needed by Chromium.
# Notwendige Systemlibs für Chromium
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         curl \
#         gnupg \
#         ca-certificates \
#         libnss3 \
#         libatk1.0-0 \
#         libatk-bridge2.0-0 \
#         libcups2 \
#         libxkbcommon0 \
#         libxcomposite1 \
#         libxdamage1 \
#         libxrandr2 \
#         libgbm1 \
#         libasound2 \
#         libpango-1.0-0 \
#         libcairo2 \
#         fonts-liberation \
#         libappindicator3-1 \
#         libxshmfence1 \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        chromium \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxkbcommon0 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libgbm1 \
        libasound2 \
        libpango-1.0-0 \
        libcairo2 \
        fonts-liberation \
        libappindicator3-1 \
        libxshmfence1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Sicherheit: non-root user anlegen (wird vor COPY genutzt für --chown)
RUN groupadd -r robot \
    && useradd -r -g robot -d /home/robot -m -s /bin/bash robot


# Security patch: install Node.js/npm from distro packages instead of a remote bootstrap script.
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python Pakete übernehmen (alles unter /usr/local, wie im Builder installiert)
COPY --from=builder /usr/local /usr/local

# Security patch: install only Browser Library node dependencies; use the OS Chromium package at runtime.
# 👉 WICHTIG: Browser HIER installieren (nicht kopieren!)
# RUN rfbrowser init chromium
RUN rfbrowser init --skip-browsers

ENV CHROMIUM_EXECUTABLE=/usr/bin/chromium

# App kopieren und Berechtigungen setzen
COPY --chown=robot:robot . .

RUN mkdir -p /app/results2 \
    && chown -R robot:robot /app /home/robot

USER robot

# QS-Umgebung: https://qs-datenschutzcockpit.dsc.govkg.de/spa/
# QS-Stable-Umgebung: https://qs-datenschutzcockpit.dsc.govkg.de/spa/
CMD ["robot", \
     "-v", "CI:True", \
     "-v", "CI_SELF_HOSTED:True", \
     "-v", "HEADLESS:True", \
     "-v", "BASE_URL:https://qs-datenschutzcockpit.dsc.govkg.de/spa/", \
     "-v", "BROWSER:chromium", \
     "--outputdir", "/app/results2", \
    "--report", "/app/results2/report.html", \
    "--log", "/app/results2/log.html", \
    "--xunit", "/app/results2/xunit.xml", \
     "tests/"]
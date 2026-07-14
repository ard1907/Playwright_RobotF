# =========================
# 1) Builder Stage
# =========================
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir robotframework-browser

# =========================
# 2) Runtime Stage
# =========================
FROM python:3.11-slim-bookworm

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
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
        nodejs \
        npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r robot \
    && useradd -r -g robot -d /home/robot -m -s /bin/bash robot

COPY --from=builder /usr/local /usr/local

RUN rfbrowser init --skip-browsers

ENV CHROMIUM_EXECUTABLE=/usr/bin/chromium

COPY --chown=robot:robot . .
COPY --chown=robot:robot docker/test-runtime/entrypoint.sh /usr/local/bin/run-robot-runtime

RUN mkdir -p /app/runtime-results \
    && chmod +x /usr/local/bin/run-robot-runtime \
    && chown -R robot:robot /app /home/robot

USER robot

ENTRYPOINT ["/usr/local/bin/run-robot-runtime"]

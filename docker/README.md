# AusweisApp SDK — Simulator-Stack fuer Testautomatisierung

Eigenstaendiges, portables Paket fuer den AusweisApp2 SDK-Container mit eingebetteter
Testkarte im **Automatic Mode** (TR-03124-1).

Geeignet fuer Testautomatisierung (z. B. Robot Framework, Playwright, Selenium):
Der Container simuliert eine echte eID-Karte und authentifiziert vollautomatisch,
ohne dass echte Hardware oder ein PIN-Dialog benoetigt wird.

---

## Inhalt

| Datei | Zweck |
|---|---|
| `ausweisapp-sdk.Dockerfile` | Baut das SDK-Image mit eingebetteter Karte |
| `docker-compose.yml` | Startet den Container, Port `127.0.0.1:24727` |
| `Emma_Mustermann.json` | Testkarte im SDK-Simulator-Format |

---

## Voraussetzungen

- Docker Desktop (oder Docker Engine) laufend
- Kein weiterer Prozess auf Port 24727 des Hosts

---

## Starten

```bash
docker compose up --build
```

---

## Testen (Browser oder Testautomatisierung)

Der Container ist einsatzbereit, sobald die Logs `Automatic Mode` oder `start listening` zeigen.

**Ablauf:**

1. Browser oder Test-Framework navigiert zum Login z.b. von `https://qs-datenschutzcockpit.dsc.govkg.de/spa/`
2. SDK holt den TC-Token selbst, fuehrt das eID-Protokoll durch
3. Authentifizierung laeuft vollautomatisch als **Emma Mustermann** (PIN `123456`)
4. SDK leitet den Browser zum Refresh-URL weiter — Login abgeschlossen

Kein zusaetzliches Python-Skript, kein Proxy noetig.

### Robot Framework — Beispiel

```robotframework
*** Settings ***
Library    Browser    # robotframework-browser (Playwright)

*** Test Cases ***
eID Login DSC
    New Browser    chromium    headless=True
    New Page     https://qs-datenschutzcockpit.dsc.govkg.de/spa/
    # Zum Login Button navigieren und clicken
    Click          id=login-button
    # SDK uebernimmt automatisch, wartet auf Redirect
    Wait For URL   https://qs-datenschutzcockpit.dsc.govkg.de/spa/**   timeout=30s
```

### Playwright (Python) — Beispiel

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto("https://qs-datenschutzcockpit.dsc.govkg.de/spa/")
    page.click("#eid-login-button")          # Selektor anpassen
    page.wait_for_url("**/spa/**", timeout=30_000)
    print("Eingeloggt:", page.url)
    browser.close()
```

---

## WS-Smoke-Test (optional)

```bash
pip install websockets
python - <<'EOF'
import asyncio, json
import websockets

async def smoke():
    async with websockets.connect("ws://localhost:24727/eID-Kernel") as ws:
        while True:
            msg = json.loads(await ws.recv())
            if msg.get("msg") == "READER":
                reader = msg.get("reader", {})
                assert reader.get("name") == "Simulator", f"Unexpected: {reader}"
                assert reader.get("attached") is True, f"Not attached: {reader}"
                print("OK — Simulator attached:", reader)
                return

asyncio.run(smoke())
EOF
```

---

## Als Image-Datei weitergeben

Der gesamte Stack laesst sich ohne Registry oder Quellcode weitergeben:

```bash
# Einmalig bauen und exportieren
docker compose build
docker save autoflow-ausweisapp-sdk | gzip > ausweisapp-sdk.tar.gz
```

```bash
# Auf dem Zielrechner laden und starten
docker load < ausweisapp-sdk.tar.gz
docker compose up
```

Den exakten Imagenamen nach dem Build mit `docker image ls` ermitteln.

---

## Portbelegung

| Port (Host) | Beschreibung |
|---|---|
| `127.0.0.1:24727` | AusweisApp SDK — TR-03124-1-Endpunkt fuer Browser und Testframeworks |

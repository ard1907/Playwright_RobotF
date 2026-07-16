# Quickstart: Docker Runtime (einfach)

Diese kurze Anleitung erklärt in einfacher Sprache, wie du die Docker‑Runtime für die Robot‑Tests startest.

Voraussetzungen
- Docker Desktop / Docker Engine installiert
- Zugriff auf die Test‑URL (`BASE_URL`)
- Ein freier lokaler Port 24727

1) `.env` anlegen
- Kopiere die Beispieldatei in den Runtime‑Ordner:

PowerShell:
```powershell
Copy-Item docker\test-runtime\.env.example docker\test-runtime\.env
```

Linux/macOS:
```bash
cp docker/test-runtime/.env.example docker/test-runtime/.env
```

- Öffne `docker/test-runtime/.env` und prüfe mindestens `BASE_URL` und `RESULTS_DIR`.

2) Images bauen (lokal)
- Baut beide Container direkt aus dem Repository:

```bash
docker compose -f docker/test-runtime/docker-compose.yml build
```

3) Oder fertige Images laden (portable)
- Wenn du eine TAR mit vorgefertigten Images hast, lade sie:

PowerShell:
```powershell
.\docker\test-runtime\load-runtime-images.ps1
# oder manuell:
docker load --input docker/test-runtime/test-runtime-images.tar
```

4) Runtime starten
- Starte die Runtime; sie beendet sich, wenn die Container fertig sind:

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
# oder die portable Variante (nutzt bereits gebaute Images):
docker compose -f docker/test-runtime/docker-compose.portable.yml up --abort-on-container-exit
```

5) Ergebnisse ansehen
- Standard‑Ergebnisordner ist `results2/` (oder wie in `.env` gesetzt). Öffne im Browser:

```
results2/log.html
results2/report.html
```

Kurz erklärt wie es funktioniert
- `ausweisapp-sdk` startet einen Simulator und bindet Port `127.0.0.1:24727`.
- `robot-runtime` verwendet dasselbe Netzwerk wie der SDK‑Container, daher kann `AUSWEISAPP_URL=http://127.0.0.1:24727` benutzt werden.
- Das Startskript im `robot-runtime` baut aus Umgebungsvariablen den Robot‑CLI‑Befehl und schreibt Reports nach `RESULTS_DIR`.

Kurze Fehlerhilfe
- Keine Ergebnisse im `results2/`: Prüfe `RESULTS_DIR` in `.env` und `docker compose -f docker/test-runtime/docker-compose.yml ps -a`.
- Port 24727 belegt: Stoppe den Prozess, der den Port nutzt.
- Chromium startet nicht: Baue das Image neu ohne Cache:

```bash
docker compose -f docker/test-runtime/docker-compose.yml build --no-cache robot-runtime
```

Weitergeben an Kollegen
- Bilder exportieren:

PowerShell:
```powershell
.\docker\test-runtime\export-runtime-images.ps1
```

Das war's — bei Bedarf kann ich diese Cheat‑Sheet noch kürzer oder mit Bildern machen.

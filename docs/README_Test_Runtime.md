# Test Runtime fuer Kollegen

Diese Runtime stellt die vorhandenen Robot-Framework-Tests als Docker-Stack bereit.
Kollegen brauchen damit keine lokale Python-, Robot- oder Playwright-Installation.

Wichtig fuer die Einordnung: `docker/tests` bleibt der CI/CD-orientierte Docker-Stack fuer die Pipeline-Workflows.
`docker/test-runtime` ist die getrennte Runtime fuer lokale Testlaeufe, portable Nutzung und die Weitergabe an Kollegen.

Die Runtime besteht aus zwei Containern:

- `robot-runtime`: fuehrt die Tests mit `robotcode` aus.
- `ausweisapp-sdk`: startet den benoetigten AusweisApp2-Simulator im Automatic Mode.

## Zielbild

- Tests gegen unterschiedliche DSC-Umgebungen per `BASE_URL`
- Profilauswahl ueber die bestehenden RobotCode-Profile aus `robot.toml`
- Ergebnisablage im vorhandenen Repo-Ordner `results2/`
- lauffaehig auf Windows, Linux und macOS mit Docker und Linux-Containern

## Enthaltene Dateien

- `docker/test-runtime/docker-compose.yml`
- `docker/test-runtime/Dockerfile`
- `docker/test-runtime/ausweisapp.Dockerfile`
- `docker/test-runtime/entrypoint.sh`
- `docker/test-runtime/.env.example`
- `docker/test-runtime/export-runtime-images.ps1`
- `docker/test-runtime/load-runtime-images.ps1`

## Voraussetzungen

- Docker Desktop oder Docker Engine mit Compose-Unterstuetzung
- Zugriff auf eine DSC-Zielumgebung
- Freier lokaler Port `24727` fuer den AusweisApp2-Simulator

## Plattformen

Die Runtime ist fuer diese Zielplattformen gedacht:

- Windows mit Docker Desktop
- Linux auf x86_64 mit Docker Engine oder Docker Desktop
- macOS mit Docker Desktop, sofern Linux-Container genutzt werden

Die Host-Skripte in PowerShell sind optional. Die Runtime selbst ist der Docker-Compose-Stack.
Wer keine PowerShell installiert hat, kann die Images direkt mit `docker image save` und `docker load` weitergeben.

## Schnellstart

1. In den Ordner `docker/test-runtime` wechseln.
2. `.env.example` nach `.env` kopieren und bei Bedarf anpassen.
3. Den Stack bauen und ausfuehren:

```bash
docker compose up --build --abort-on-container-exit
```

Die Standardkonfiguration startet den Test-Runner mit:

```bash
robotcode --profile default --profile ci-selfhosted --profile smoke robot
```

Die Artefakte werden nach `results2/` im Repository geschrieben.

## Parameter

Diese Parameter sind fuer Kollegen relevant:

| Parameter | Pflicht | Zweck |
| --- | --- | --- |
| `BASE_URL` | ja | Zielumgebung, z. B. QS, QS-Stable oder Prod |
| `ROBOT_PROFILES` | ja | Komma- oder leerzeichengetrennte Profile aus `robot.toml` |
| `ROBOT_BY_LONGNAME` | nein | Fuehrt genau eine Suite oder einen einzelnen Test per Longname aus |
| `ROBOT_INCLUDE` | nein | Tag-Filter fuer `-i` |
| `ROBOT_EXCLUDE` | nein | Tag-Filter fuer `-e` |
| `ROBOT_EXTRA_ARGS` | nein | Zusaetzliche rohe Robot/RobotCode-Argumente |
| `HEADLESS` | nein | Standard ist `True` |
| `BROWSER` | nein | Standard ist `chromium` |

Diese Parameter setzt die Runtime selbst und sollten normalerweise nicht ueberschrieben werden:

- `CI=True`
- `CI_SELF_HOSTED=True`
- `AUSWEISAPP_URL=http://127.0.0.1:24727`
- `CHROMIUM_EXECUTABLE=/usr/bin/chromium`

## Typische Aufrufe

### Smoke-Run gegen QS

`.env`:

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted,smoke
```

Start:

```bash
docker compose up --build --abort-on-container-exit
```

### Vollstart aller UI-Suiten

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted
```

### Nur generische YAML-Suite

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted
ROBOT_BY_LONGNAME=Ui.Ts 06 Register Cards Generic Dom Test
```

### First-Run fuer YAML-Fixtures

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted,first-run
ROBOT_BY_LONGNAME=Ui.Ts 06 Register Cards Generic Dom Test
```

### First-Run fuer API-Fixtures

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted,first-run-api
ROBOT_BY_LONGNAME=Ui.Ts 07 Register Cards Generic Api Test
```

## Direkter RobotCode-Aufruf

Wenn statt der Umgebungsvariablen ein kompletter `robotcode`-Aufruf gewuenscht ist, kann der Runner direkt mit Argumenten gestartet werden:

```bash
docker compose run --rm robot-runtime --profile default --profile ci-selfhosted --profile smoke robot
```

In diesem Modus ruft der Entrypoint direkt `robotcode <argumente>` auf.
Wenn dabei Ausgabepfade angepasst werden sollen, muessen die gewuenschten Output-Argumente explizit mitgegeben werden.

## Netzwerkmodell

Die CI/CD-nahe Test-Compose unter `docker/tests` nutzt `network_mode: host`.
Das ist fuer eine portable Kollegen-Runtime unguenstig, besonders mit Docker Desktop.

Die Kollegen-Runtime unter `docker/test-runtime` bildet stattdessen das Verhalten der funktionierenden selfhosted-Pipeline nach:

- `ausweisapp-sdk` veroeffentlicht den Port `24727` lokal auf dem Host.
- `robot-runtime` nutzt `network_mode: "service:ausweisapp-sdk"`.
- Dadurch teilen sich beide Container denselben Netzwerk-Namespace.
- Aus Sicht des Browsers im `robot-runtime` zeigt `http://127.0.0.1:24727` dadurch direkt auf den AusweisApp-SDK-Endpunkt.

Genau diese Annahme nutzt auch der bestehende Login-Flow der Tests. Deshalb war hier keine generelle Anpassung der Robot-Suiten noetig.

## Ergebnisse

Standardpfad fuer Reports und Artefakte:

- `results2/log.html`
- `results2/report.html`
- `results2/xunit.xml`
- `results2/output.xml`

Falls ein Lauf vorzeitig beendet wurde oder der Mount lokal Probleme macht, koennen Ergebnisse alternativ mit `docker cp` aus dem Container geholt werden.

## Weitergabe an Kollegen

Die einfachste Bereitstellung ohne sichtbaren Quellcode ist:

1. Images lokal oder in CI bauen.
2. Images als TAR-Dateien exportieren.
3. Nur `docker/test-runtime/`, eine `.env`-Datei und eine kurze Startanleitung weitergeben.

Beispiel:

```bash
docker compose -f docker/test-runtime/docker-compose.yml build
docker image save -o docker/test-runtime/test-runtime-images.tar test-runtime-robot-runtime:latest test-runtime-ausweisapp-sdk:latest
```

Auf dem Zielrechner:

```bash
docker load -i docker/test-runtime/test-runtime-images.tar
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

Alternativ eignet sich eine interne Container-Registry noch besser, wenn mehrere Kollegen dieselbe Runtime regelmaessig nutzen sollen.

## Troubleshooting

- Wenn Login-nahe Suiten sofort skippen, ist meist `CI_SELF_HOSTED` nicht korrekt gesetzt oder der SDK-Container laeuft nicht.
- Wenn Login-nahe Suiten scheitern, zuerst pruefen, ob `robot-runtime` und `ausweisapp-sdk` mit dem validierten Netzwerkmodell laufen und `127.0.0.1:24727` im Runner erreichbar ist.
- Wenn Chromium nicht startet, zuerst pruefen, ob der Runner-Container mit `/usr/bin/chromium` gebaut wurde.
- Wenn eine andere Zielumgebung verwendet wird, `BASE_URL` inklusive abschliessendem `/spa/` setzen.
- Wenn nur Teilmengen laufen sollen, `ROBOT_BY_LONGNAME`, `ROBOT_INCLUDE` oder `ROBOT_EXCLUDE` nutzen.

Diese Punkte decken die haeufigsten Probleme der Runtime ab.

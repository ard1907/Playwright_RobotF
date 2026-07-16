# Docker Runtime fuer Kollegen - einfache Anleitung

Dieses Dokument erklaert die Docker-Runtime in einfacher Sprache.
Die Anleitung ist bewusst genauer und Schritt fuer Schritt geschrieben.

## Worum geht es

Mit dieser Runtime kann ein Kollege die Robot-Framework-Tests starten,
ohne Python, Robot Framework oder Playwright lokal zu installieren.

Wichtig fuer die Abgrenzung:

- `docker/tests` bleibt fuer die CI/CD-Pipeline-Workflows relevant.
- `docker/test-runtime` ist die lokale und portable Runtime fuer Kollegen.

Es gibt zwei Container:

- `ausweisapp-sdk`
- `robot-runtime`

Der erste Container kuemmert sich um die AusweisApp.
Der zweite Container fuehrt die Tests aus.

## Was auf dem Rechner vorhanden sein muss

Vor dem Start muss auf dem Rechner Folgendes vorhanden sein:

1. Docker Desktop oder Docker Engine mit Compose
2. Zugriff auf die Ziel-URL der Testumgebung
3. Lokaler freier Port `24727`

Geeignet sind diese Host-Systeme:

1. Windows mit Docker Desktop
2. Linux x86_64 mit Docker
3. macOS mit Docker Desktop und Linux-Containern

## Wo die Ergebnisse landen

Die Testergebnisse werden in diesen Ordner geschrieben:

- `results2/`

Dort liegen danach zum Beispiel:

- `results2/log.html`
- `results2/report.html`
- `results2/output.xml`
- `results2/xunit.xml`

## Wie das Netzwerk funktioniert

Dieser Punkt ist wichtig.

Die Tests erwarten fuer die AusweisApp den lokalen Pfad:

```text
http://127.0.0.1:24727
```

Die Runtime ist deshalb so gebaut, dass `robot-runtime` denselben Netzwerk-Stack wie `ausweisapp-sdk` benutzt.
Dadurch zeigt `127.0.0.1:24727` im Testcontainer genau auf den AusweisApp-SDK-Container.

Das ist absichtlich so, weil die selfhosted-GitHub-Actions-Pipeline genau mit dieser Annahme erfolgreich laeuft.

Die Ergebnisablage auf dem Host ist ebenfalls absichtlich ueber einen relativen Pfad konfiguriert.
Im Repository zeigt `RESULTS_DIR=../../results2` auf den Projektordner `results2/`.

Wichtig fuer den Ordner selbst:

Docker kann den Zielordner fuer einen Verzeichnis-Mount normalerweise automatisch anlegen,
wenn er auf dem Host noch nicht existiert.
Das gilt auch fuer `results2/`.

Trotzdem ist es sauberer, den Ordner vorher selbst anzulegen,
damit sofort sichtbar ist, wo die Ergebnisse erwartet werden.

## Schnellstart Schritt fuer Schritt

### Schritt 1: In das Projekt wechseln

```bash
cd <projektordner>
```

### Schritt 2: Konfigurationsdatei anlegen

Die Datei `.env.example` nach `.env` kopieren.

Windows PowerShell:

```powershell
Copy-Item docker\test-runtime\.env.example docker\test-runtime\.env
```

Linux oder macOS:

```bash
cp docker/test-runtime/.env.example docker/test-runtime/.env
```

### Schritt 3: `.env` anpassen

Mindestens diese Werte pruefen:

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted,smoke
RESULTS_DIR=../../results2
```

### Schritt 4: Container bauen

```bash
docker compose -f docker/test-runtime/docker-compose.yml build
```

### Schritt 5: Tests starten

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

### Schritt 6: Ergebnisse ansehen

Nach dem Lauf die Dateien in `results2/` oeffnen.

Wichtigste Datei fuer Menschen:

- `results2/log.html`

## Haefige Konfigurationen

### Smoke-Run

`.env`:

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted,smoke
```

Start:

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

### Alle UI-Tests

`.env`:

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted
```

Start:

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

### Nur eine Suite starten

`.env`:

```dotenv
BASE_URL=https://qs-datenschutzcockpit.dsc.govkg.de/spa/
ROBOT_PROFILES=default,ci-selfhosted
ROBOT_BY_LONGNAME=Ui.Ts 06 Register Cards Generic Dom Test
```

Start:

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

## Weitergabe an Kollegen

Hier ist der genaue Weg, wenn der Kollege den Quellcode nicht unbedingt sehen soll.

### Variante A: Images lokal bauen und als Datei weitergeben

#### Schritt 1: Images bauen

```bash
docker compose -f docker/test-runtime/docker-compose.yml build
```

#### Schritt 2: Images in eine TAR-Datei exportieren

```bash
docker image save -o docker/test-runtime/test-runtime-images.tar test-runtime-robot-runtime:latest test-runtime-ausweisapp-sdk:latest
```

#### Schritt 3: Diese Dateien an den Kollegen weitergeben

Weitergeben:

1. `docker/test-runtime/docker-compose.yml`
2. `docker/test-runtime/.env.example`
3. optional schon eine fertige `.env`
4. `docker/test-runtime/test-runtime-images.tar`
5. diese Anleitung oder eine kurze Startanleitung

Wichtig:

Wenn die Dateien spaeter direkt in einen einzelnen Weitergabe-Ordner kopiert werden,
dann muss fuer die Ergebnisdateien der Host-Pfad angepasst werden.

Der Ordner `results2/` muss dabei nicht zwingend manuell angelegt werden.
Docker legt ihn in diesem Fall meistens automatisch an.
Wenn der Ordner aber schon vorher existiert, ist der Zielpfad fuer den Kollegen klarer sichtbar.

#### Schritt 4: Kollege legt `.env` an

Windows PowerShell:

```powershell
Copy-Item docker\test-runtime\.env.example docker\test-runtime\.env
```

Linux oder macOS:

```bash
cp docker/test-runtime/.env.example docker/test-runtime/.env
```

Wenn die Dateien nicht mehr in der urspruenglichen Repository-Struktur liegen,
sondern direkt zusammen in einem Weitergabe-Ordner liegen,
dann in der `.env` diesen Wert setzen:

```dotenv
RESULTS_DIR=./results2
```

Dann schreibt Docker die Ergebnisse in den Ordner `results2/`
direkt neben `docker-compose.yml`.

Empfohlener ist fuer diese Weitergabe aber die portable Compose-Datei,
weil dort `RESULTS_DIR=./results2` schon das Standardverhalten ist.

#### Schritt 5: Kollege laedt die Images

```bash
docker load -i docker/test-runtime/test-runtime-images.tar
```

#### Schritt 6: Kollege startet die Runtime

```bash
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
```

#### Schritt 7: Kollege oeffnet die Ergebnisse

```text
results2/log.html
```

Falls der Ordner leer ist, stimmt fast immer `RESULTS_DIR` nicht.
Dann schreibt Docker an einen anderen Host-Pfad.

### Variante A empfohlen: Portable Compose-Datei

Fuer die Weitergabe ohne Repository-Struktur gibt es auch diese Datei:

- `docker/test-runtime/docker-compose.portable.yml`

Diese Datei benutzt keine lokalen Dockerfiles mehr,
sondern nur die bereits geladenen Images.
Ausserdem schreibt sie standardmaessig nach `./results2`
direkt neben die Compose-Datei.

#### Portable Schritt 1: Diese Dateien weitergeben

1. `docker/test-runtime/docker-compose.portable.yml`
2. `docker/test-runtime/.env.example`
3. optional schon eine fertige `.env`
4. `docker/test-runtime/test-runtime-images.tar`
5. diese Anleitung

#### Portable Schritt 2: `.env` anlegen

Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

Linux oder macOS:

```bash
cp .env.example .env
```

Optional kann dieser Wert explizit gesetzt werden:

```dotenv
RESULTS_DIR=./results2
```

#### Portable Schritt 3: Images laden

```bash
docker load -i test-runtime-images.tar
```

#### Portable Schritt 4: Runtime starten

```bash
docker compose -f docker-compose.portable.yml up --abort-on-container-exit
```

#### Portable Schritt 5: Ergebnisse oeffnen

```text
results2/log.html
```

### Variante B: Interne Registry

Wenn mehrere Kollegen die Runtime oft brauchen, ist eine interne Container-Registry einfacher.

Dann ist der Ablauf meist so:

1. Images zentral bauen
2. Images in Registry pushen
3. Kollege macht nur `docker pull`
4. Danach `docker compose up`

Diese Variante ist besser fuer Teams.

## Fehlerhilfe

### Fall 1: Port 24727 ist schon belegt

Dann kann `ausweisapp-sdk` nicht starten.

Pruefen:

```bash
docker ps -a
```

### Fall 2: Der Login klappt nicht

Dann zuerst pruefen, ob beide Container laufen und das Netzwerkmodell stimmt.

Pruefen:

```bash
docker compose -f docker/test-runtime/docker-compose.yml ps
```

### Fall 3: Chromium startet nicht

Dann pruefen, ob das Image sauber gebaut wurde.

Neu bauen:

```bash
docker compose -f docker/test-runtime/docker-compose.yml build --no-cache robot-runtime
```

### Fall 4: Ergebnisse fehlen

Dann pruefen, ob der Ordner `results2/` beschrieben wurde.

Falls noetig, Containerstatus ansehen:

```bash
docker compose -f docker/test-runtime/docker-compose.yml ps -a
```

## Kurzfassung

Die drei wichtigsten Befehle sind:

```bash
docker compose -f docker/test-runtime/docker-compose.yml build
docker compose -f docker/test-runtime/docker-compose.yml up --abort-on-container-exit
docker image save -o docker/test-runtime/test-runtime-images.tar test-runtime-robot-runtime:latest test-runtime-ausweisapp-sdk:latest
```

## Troubleshooting

- Wenn Login-nahe Suiten sofort skippen, ist meist `CI_SELF_HOSTED` nicht korrekt gesetzt oder der SDK-Container laeuft nicht.
- Wenn Login-nahe Suiten scheitern, zuerst pruefen, ob `robot-runtime` und `ausweisapp-sdk` mit dem validierten Netzwerkmodell laufen und `127.0.0.1:24727` im Runner erreichbar ist.
- Wenn Chromium nicht startet, zuerst pruefen, ob der Runner-Container mit `/usr/bin/chromium` gebaut wurde.
- Wenn eine andere Zielumgebung verwendet wird, `BASE_URL` inklusive abschliessendem `/spa/` setzen.
- Wenn nur Teilmengen laufen sollen, `ROBOT_BY_LONGNAME`, `ROBOT_INCLUDE` oder `ROBOT_EXCLUDE` nutzen.

Diese Punkte decken die haeufigsten Probleme der Runtime ab.

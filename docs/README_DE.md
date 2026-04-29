# Playwright_RobotF

Robot-Framework- und Playwright-basierte End-to-End-Smoke-Tests für die Datenschutzcockpit-SPA.

Dieses Repository konzentriert sich auf automatisierte UI-Prüfungen der Startseite, der Anmelde-/Info-Seite, von Dialogen, FAQ-Inhalten, Impressum, Datenschutzerklärung, Barrierefreiheit, externen Links sowie ausgewählten Login- und Logout-Flows.
Zusätzlich umfasst es eigene Suiten für den authentifizierten Cockpit-Bereich: die Registerauswahl, einen BVA-spezifischen Ergebnis-Flow und einen generischen Registerkarten-Flow, der mehrere Registerkarten über YAML-Fixtures prüfen kann.

## Inhalt dieses Repositories

- `tests/ui/` enthält die Haupt-Smoke-Suiten.
- `tests/helpers/` enthält kleinere Hilfssuiten und fokussierte Prüfungen.
- `tests/examples/` enthält Beispiel- und Explorationssuiten.
- `pages/` enthält Keyword- und Selektor-Definitionen im Page-Object-Stil.
- `resources/` enthält gemeinsames Browser-Setup, Navigations-Keywords und Variablen.
- `docker/` und `docker2/` enthalten Container-Setups für lokale Ausführung und CI-nahe Läufe.
- `scripts/` enthält Hilfsskripte für die Arbeit mit Testergebnissen.
- `results/`, `results2/`, `log.html`, `report.html` und `output.xml` sind generierte Test-Artefakte.

## Zentrale Testabdeckung

Die Suiten decken derzeit ab:

- die Startseite und den FAQ-Dialog
- die Authentifizierungs-/Anmeldungs-Info-Seite
- Barrierefreiheits-Header-Buttons und Footer-Navigation
- die Dialoge für Leichte Sprache und Gebärdensprache
- Impressum, Datenschutzerklärung und Barrierefreiheit
- externe Links zu AusweisApp und kompatiblen Lesegerät-Seiten
- die Registerauswahl-Seite nach erfolgreichem Login inklusive Grid-/Listenansicht, Auswahl-, Dialog-, FAQ-, Timer- und Reload-Verhalten
- den generischen Registerkarten-Ergebnis-Flow nach Login inklusive fixture-basierter Verifikation und kontrollierter First-Run-Generierung
- einen sicheren Cookie-Erfassungs-Flow und zugehörige Login-Helpers

Eine dateiweise Übersicht der Suiten und Keywords findest du in `README_Tests_Overview_DE.md`.
Eine einfache Beschreibung der Registerkarten-Testlogik findest du in `LogikRegisterTests.md`.

## Voraussetzungen

Das Projekt verwendet:

- Python
- Robot Framework
- `robotframework-browser`
- weitere Bibliotheken wie `robotframework-requests`, `robotframework-jsonlibrary`, `robotframework-seleniumlibrary`, `robotframework-sshlibrary` und `robotframework-databaselibrary`

Die Python-Abhängigkeiten installierst du mit:

```bash
pip install -r requirements.txt
```

Falls die Laufzeitumgebung der Browser-Library noch nicht eingerichtet ist, sollte vor dem Ausführen der Suiten die übliche Robot-Framework-Browser-Installation für die jeweilige Plattform durchgeführt werden.

## Konfiguration

Gemeinsame Laufzeit-Einstellungen liegen in `resources/dsc_variables.robot`.

Wichtige Variablen sind:

- `BASE_URL` für die Basisroute der Datenschutzcockpit-SPA
- `AUTH_INFO_URL` für die Anmelde-/Info-Seite
- `BROWSER` zur Auswahl des Browsers
- `HEADLESS` für sichtbaren oder Headless-Betrieb
- `TIMEOUT` für Wartezeiten und Prüfungen
- `SLOW_MOTION` für langsamere lokale Läufe
- `AUSWEISAPP_URL` für den AusweisApp-SDK-Endpunkt
- `CHROMIUM_EXECUTABLE` für eine lokal installierte Chromium-Binary

Die Standard-URL in diesem Repository zeigt auf die Qualitätsumgebung:

```text
https://qs-datenschutzcockpit.dsc.govkg.de/spa/
```

## Tests ausführen

Die Haupt-Smoke-Suiten liegen in `tests/ui/`.

Typische Beispiele:

```bash
robot tests/ui
```

Eine einzelne Suite starten, wenn nur ein Bereich geprüft werden soll:

```bash
robot tests/ui/ts_01_smoke_test_landing_page.robot
robot tests/ui/ts_02_smoke_test_auth_info_page.robot
robot tests/ui/ts_03_smoke_test_register_selection.robot
robot tests/ui/ts_04_smoke_test_register_selection_BVA.robot
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Nur die generische Registerkarten-Verifikation starten:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Den generischen First-Run explizit starten:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Bereits abgeschlossene Fixtures bewusst neu erzeugen:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Die kleineren Suiten in `tests/helpers/` sind nützlich für fokussierte Prüfungen und Debugging.

### Ausführung über Tags

Die Suiten verwenden Tags wie `smoke`, `landing`, `auth`, `faq`, `accessibility`, `accordion`, `external-link`, `e2e` und `cookies`. Mit der Tag-Filterung von Robot Framework lässt sich ein gezielter Lauf starten.
Für die Registerauswahl kommen zusätzlich Tags wie `register-auswahl`, `interaction`, `selection`, `toggle`, `list-view`, `all-registers`, `dialog`, `security`, `session`, `timer` und `reload` hinzu.

## Docker- und CI-Optionen

Dieses Repository enthält mehrere Container-Setups:

- `docker/` stellt den AusweisApp-SDK-Simulator-Stack bereit.
- `docker2/` stellt einen lokalen Test-Stack mit `ausweisapp-sdk` und `robot-tests` sowie eine Konfiguration für einen selbst gehosteten GitHub-Actions-Runner bereit.

Der Docker-basierte Testlauf verwendet typischerweise `CI=True`, `HEADLESS=True`, `BROWSER=chromium` und `AUSWEISAPP_URL=http://127.0.0.1:24727` oder eine passende Host-Gateway-Variante.

Um nach einem Workflow-Lauf die Ergebnisse aus dem Runner-Container zu kopieren, verwende:

```bash
./scripts/get-results.sh
```

## Generierte Artefakte

Nach einem Lauf schreibt Robot Framework die Standard-Reports und Logs, zum Beispiel:

- `report.html`
- `log.html`
- `output.xml`

Wenn Artefakte bewusst im Unterordner `results/` abgelegt werden sollen, kann der Lauf mit `robot --outputdir results ...` gestartet werden.

Die Verzeichnisse `results/` und `results2/` enthalten gespeicherte Artefakte früherer Läufe und eignen sich für Debugging oder Vergleiche.

## Projektstruktur auf einen Blick

- `tests/ui/` - Haupt-Smoke-Suiten
- `tests/helpers/` - fokussierte Hilfssuiten
- `tests/examples/` - Beispiel- und Explorationssuiten
- `pages/` - Page Objects und Assertions
- `resources/` - gemeinsames Setup, Navigation und Variablen
- `docker*/` - Docker- und CI-Hilfsdateien
- `scripts/` - Hilfen für Ergebnisverarbeitung

## Verwandte Dokumentation

- `README_Tests_Overview_EN.md`
- `README_Tests_Overview_DE.md`
- `LogicRegisterTests.md`
- `LogikRegisterTests.md`

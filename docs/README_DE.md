# Playwright_RobotF

Dieses Repository automatisiert Tests fuer die Datenschutzcockpit-SPA mit Robot Framework, Python und der Browser Library auf Basis von Playwright.
Der Schwerpunkt liegt auf UI-Tests fuer oeffentliche Seiten, Login-nahe Cockpit-Flows, Registerauswahl sowie Ergebnis- und Registerdialoge nach erfolgreicher AusweisApp-Anmeldung.

## Kurzueberblick

- `tests/ui/` enthaelt die sieben zentralen UI-Suiten.
- `tests/helpers/` enthaelt kleine Hilfssuiten fuer Basischecks und Cookie-Analyse.
- `tests/api/` enthaelt eine Demo-Suite fuer den InterceptCrypt-Ansatz.
- `tests/lup/` enthaelt Last- und Parallel-Probes fuer die Produktiv-Landingpage.
- `pages/` bildet das Page Object Model fuer Seiten, Dialoge und Ergebnisfluesse.
- `resources/` kapselt Setup, Teardown, gemeinsame Navigation, Variablen und Python-Hilfsbibliotheken.
- `test_data/registers/` enthaelt YAML- und JSON-Fixtures fuer generische Registertests.
- `docker/sdk/`, `docker/tests/`, `docker/test-runtime/` und `docker/runner/` bilden die Docker-Stacks fuer SDK, CI/CD-Testausfuehrung, lokale Kollegen-Runtime und Self-hosted-Runner.

## Tech-Stack

- Python 3.11 als Laufzeit fuer Robot Framework und die Projektbibliotheken
- Robot Framework als Keyword-Driven-Testframework
- `robotframework-browser` als Playwright-basierte Browser-Anbindung
- `robotframework-requests`, `robotframework-jsonlibrary`, `robotframework-seleniumlibrary`, `robotframework-sshlibrary`, `robotframework-databaselibrary`, `robotframework-pabot`
- `PyYAML` fuer YAML-Fixtures und `pypdf` fuer PDF-Pruefungen im BVA-Flow

## Wichtige UI-Suiten

- `ts_01_landing_page.robot`: Landingpage, Dialoge, FAQ, Footer und kompletter oeffentlicher Journey-Flow
- `ts_02_auth_info_page.robot`: Authentifizierungs-Info-Seite, FAQ, externe Links und AusweisApp-Startbutton
- `ts_03_register_selection.robot`: Registerauswahl nach Login, Grid-/Listenansicht, Dialoge, Timer, Feedback und Stabilitaet
- `ts_04_register_selection_bva_ui.robot`: fester BVA-Workflow inkl. Ergebnisseite, Dialog, PDF-Download und Ruecknavigation
- `ts_05_register_selection_bva_ui_api.robot`: BVA-Workflow plus API-Response-Verifikation gegen JSON-Fixture
- `ts_06_register_cards_generic_dom_test.robot`: generische Registerkarten-Pruefung gegen YAML-Fixtures
- `ts_07_register_cards_generic_api_test.robot`: generische Registerkarten-Pruefung gegen entschluesselte API-Responses in JSON-Fixtures

## Typische Befehle

Abhaengigkeiten installieren:

```bash
pip install -r requirements.txt
```

Alle UI-Suiten ausfuehren:

```bash
robotcode --profile default robot
```

Kuratierte Smoke-Auswahl ausfuehren:

```bash
robotcode --profile default --profile smoke robot
```

Nur die generische Dialog-/YAML-Pruefung ausfuehren:

```bash
robotcode --profile default robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

YAML-First-Run explizit aktivieren:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

API-First-Run explizit aktivieren:

```bash
robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

GitHub-hosted CI gegen Prod ausfuehren:

```bash
robotcode --profile default --profile ci-github-hosted robot
```

Self-hosted CI gegen QS ausfuehren:

```bash
robotcode --profile default --profile ci-selfhosted robot
```

## Docker und CI/CD

- `docker/common/ausweisapp-sdk.Dockerfile` definiert das gemeinsame Image `ausweisapp-sdk:latest`, das von allen Docker-Compose-Stacks verwendet wird.
- `docker/sdk/docker-compose.yml` baut und startet den gemeinsamen AusweisApp-SDK-Simulator auf Port `24727`.
- `docker/tests/docker-compose.yml` startet `ausweisapp-sdk` und den Non-Root-Container `robot-tests` fuer die CI/CD-Pipeline-Workflows und CI-nahe Testlaeufe.
- `docker/test-runtime/docker-compose.yml` startet `ausweisapp-sdk` und `robot-runtime` fuer lokale Tests, portable Nutzung und die Weitergabe an Kollegen.
- `docker/runner/docker-compose.yml` startet einen gepinnten Self-hosted-GitHub-Actions-Runner als Container.
- `.github/workflows/ci_tests_workflow.yml` fuehrt die UI-Suiten auf `ubuntu-latest` aus, installiert Browser-Abhaengigkeiten und laedt Robot-Artefakte hoch.
- `.github/workflows/ci_tests_workflow_selfhosted.yml` startet auf dem Self-hosted-Runner den Docker-Teststack und kopiert Ergebnisse aus dem `robot-tests`-Container.

## Artefakte und Fixtures

- Standard-Reports: `report.html`, `log.html`, `output.xml`
- Alternative Workflow-Ausgabe: `results/` und `results2/`
- Dialog-Fixtures: `test_data/registers/*.yaml`
- API-Fixtures: `test_data/registers/*.json` und `*_raw.json`

## Weitere Dokumentation

- `README_Tests_Overview_DE.md`: Gesamtueberblick ueber Testbereiche, Pages und Resources
- `README_Tests_UI_Overview_DE.md`: alle UI-Suiten und Testfaelle im Detail
- `LogikRegisterTests.md`: Registertest-Logik fuer YAML- und API-basierte Verifikation
- `README_Test_Runtime.md`: Docker-Test-Runtime fuer lokale Nutzung, Weitergabe an Kollegen und portable Starts ausserhalb der CI/CD-Stacks
- `presentation.md`: kurze Projektpraesentation in einfacher Sprache

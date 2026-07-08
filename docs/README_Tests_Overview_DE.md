# Testuebersicht — Playwright_RobotF

Stand: 2026-06-11

Dieses Dokument beschreibt die Testbereiche des Repositories, die wichtigsten Suite-Zwecke sowie die tragenden Page-Object- und Resource-Dateien.

## Testbereiche

### `tests/ui/`

- `ts_01_landing_page.robot`
  - Oeffentliche Startseite der SPA
  - Dialoge fuer Leichte Sprache, Gebaerdensprache, FAQ, Impressum, Datenschutz und Barrierefreiheit
  - kompletter oeffentlicher Journey-Test
- `ts_02_auth_info_page.robot`
  - Authentifizierungs-Info-Seite vor dem Login
  - externe Links zu AusweisApp und Lesegeraeten
  - FAQ und AusweisApp-Startbutton
- `ts_03_register_selection.robot`
  - Registerauswahl nach erfolgreichem Login
  - Grid- und Listenansicht
  - Auswahl, Abwahl, FAQ, Intro-Dialoge, Feedback, Session-Timer, Reload-Stabilitaet
- `ts_04_register_selection_bva_ui.robot`
  - fester BVA-Workflow von der Registerauswahl bis zum Ergebnisdialog
  - PDF-Dateiname und PDF-Inhalt werden mitgeprueft

- `ts_05_register_selection_bva_ui_api.robot`
  - identischer BVA-Grundworkflow wie `ts_04`
  - zusaetzlich API-Response-Verifikation gegen `test_data/registers/bva.json`
  - enthaelt einen expliziten `first-run-api`-Pfad zum Erzeugen der JSON-Fixture

- `ts_06_register_cards_generic_dom_test.robot`
  - generische Registerkarten-Suite auf Basis von YAML-Fixtures
  - aktuell fuer `bva.yaml` und `dguv.yaml`
  - trennt Normalmodus und expliziten `first-run`

- `ts_07_register_cards_generic_api_test.robot`
  - generische Registerkarten-Suite auf Basis entschluesselter API-Responses
  - aktuell fuer `bva.json` und `dguv.json`
  - trennt Normalmodus und expliziten `first-run-api`

### `tests/helpers/`

- `dsc_basic_test.robot`
  - kleine Einstiegssuite fuer Landingpage und Leichte-Sprache-Dialog
- `dsc_get_cookies_requests.robot`
  - Login-basierter Cookie-Check auf der Authentifizierungsseite

### `tests/api/`

- `interceptcrypt_smoke.robot`
  - Minimalbeispiel fuer den InterceptCrypt-Hook
  - demonstriert das Abfangen und Pruefen entschluesselter Registerdaten im Browser

### `tests/lup/`

- `lup_common.robot`
  - gemeinsame Keywords fuer Landing-Page-Load-Probes gegen die Produktiv-URL
- `load_test_00.robot` bis `load_test_09.robot`
  - parallele Last- und Erreichbarkeitschecks fuer die Landingpage
  - gedacht fuer `pabot`-Ausfuehrung und Performance-Metriken

## Page Objects in `pages/`

- `dsc_landing_page.robot`: Landingpage-Validierung und oeffentliche Einstiegschecks
- `dsc_authentication_info_page.robot`: Auth-Info-Seite, FAQ und externe Linkpruefungen
- `dsc_register_selection_page.robot`: Registerauswahl, Grid/List-Logik, Dialog- und Zustandspruefungen
- `dsc_register_selection_bva.robot`: BVA-spezifische Ergebnis- und Dialogschritte
- `dsc_register_result_page.robot`: generischer Registerdialog-Workflow und YAML-basierte Verifikation
- `dsc_register_result_page_api.robot`: API-basierter Registerdialog-Workflow und JSON-Fixture-Erzeugung
- weitere Dateien wie `dsc_faq_page.robot`, `dsc_easy_language_page.robot`, `dsc_sign_language_page.robot`, `dsc_imprint_legal_notice_page.robot`, `dsc_privacy_page.robot`, `dsc_accessibility_page.robot` kapseln einzelne Dialoge und Seitenpruefungen

## Gemeinsame Ressourcen in `resources/`

- `dsc_setup_teardown.robot`: Browser-Lifecycle, Login-/Logout-Flows und Suite-weite Guards
- `dsc_shared_keywords.robot`: allgemeine Navigations- und Helfer-Keywords fuer wiederverwendbare UI-Aktionen
- `dsc_variables.robot`: Ziel-URLs, Browser- und Timeout-Konfiguration, Seitentitel und technische Konstanten
- `browser_scripts/`: Browser-seitige JavaScript-Erweiterungen fuer Spezialfaelle wie Interception
- `libraries/` und `scripts_py/`: Python-Hilfen fuer Fixture-Verarbeitung und technische Zusatzlogik

## Register-Fixtures

- YAML-Fixtures: `test_data/registers/bva.yaml`, `test_data/registers/dguv.yaml`
- API-Fixtures: `test_data/registers/bva.json`, `test_data/registers/bva_raw.json`, `test_data/registers/dguv.json`, `test_data/registers/dguv_raw.json`

## Wichtige Architekturhinweise

- Page Object Model: Selektoren und UI-Interaktionen liegen zentral in `pages/`, nicht direkt in den Suiten.
- Keyword-Driven: Testfaelle beschreiben fachliche Schritte, waehrend die technische Umsetzung in Keywords gekapselt bleibt.
- Login-abhaengige Suiten nutzen gemeinsame Suite-Setups und Teardowns aus `resources/`.
- Die generischen Registersuiten unterscheiden klar zwischen Dialog-Verifikation mit YAML und API-Verifikation mit JSON.
- `first-run` und `first-run-api` sind bewusst Opt-in und laufen nicht im Standardmodus mit.

## Empfohlener Einstieg

- Fuer den Gesamtueberblick zuerst `tests/ui/` lesen.
- Fuer das technische Muster danach `pages/` und `resources/` ansehen.
- Fuer generische Registerlogik `LogikRegisterTests.md` oeffnen.
- Fuer eine kurze Projektzusammenfassung in einfacher Sprache `presentation.md` verwenden.

# Projektpraesentation — Playwright_RobotF

## Worum geht es?

Dieses Projekt testet das Datenschutzcockpit automatisch.
Es prueft, ob wichtige Seiten, Dialoge und Register-Abfragen im Browser richtig funktionieren.

Das Projekt ist fuer zwei Dinge gedacht:

- schnelle Qualitaetspruefung der Oberflaeche
- technische Absicherung der Registerdaten nach dem Login

## Tech-Stack in einfacher Sprache

### Robot Framework

Robot Framework ist ein Testwerkzeug.
Tests werden dort nicht als lange Programmcodes geschrieben, sondern als lesbare Schritte.

Beispielidee:

- Seite oeffnen
- Button klicken
- Text pruefen

Das nennt man Keyword-Driven.
Ein Keyword ist ein wiederverwendbarer Schritt mit einem klaren Namen.
Dadurch bleiben Tests besser lesbar und leichter wartbar.

### Python

Python ist die technische Basis des Projekts.
Darueber laufen:

- Robot Framework selbst
- Hilfsbibliotheken
- Fixture-Logik fuer YAML und JSON
- PDF-Pruefungen

### Playwright und Robot Framework Browser Library

Die Browser Library ist die Robot-Framework-Anbindung an Playwright.

Kurz gesagt:

- Robot Framework liefert die lesbaren Testschritte
- Playwright steuert den Browser modern und stabil

Vergleich zu Selenium:

- Selenium ist der klassische Webdriver-Ansatz
- Playwright arbeitet moderner und direkter mit dem Browser
- Wartezustaende, Tabs und moderne Web-Apps lassen sich oft robuster testen
- fuer dieses Projekt passt der Playwright-Ansatz gut, weil das Datenschutzcockpit eine SPA ist

### Aufbau nach POM

Das Projekt nutzt das Page Object Model.

Das bedeutet:

- Testfaelle liegen in `tests/`
- Seitenlogik und Selektoren liegen in `pages/`
- gemeinsames Setup liegt in `resources/`

Vorteil:

- Aenderungen an der UI muessen meist nur an einer Stelle gepflegt werden

## Docker-Container im Projekt

Es gibt vier wichtige Docker-Bereiche:

- `docker/sdk/`
  - startet den AusweisApp-SDK-Simulator lokal
- `docker/tests/`
  - startet `ausweisapp-sdk` und `robot-tests`
  - damit laufen die CI/CD-Pipeline-Workflows und andere CI-nahe Testlaeufe in Containern
- `docker/test-runtime/`
  - startet `ausweisapp-sdk` und `robot-runtime`
  - damit lassen sich lokale Tests und portable Runtime-Pakete fuer Kollegen ausfuehren
- `docker/runner/`
  - startet einen Self-hosted GitHub-Actions-Runner als Container

Wichtige Container:

- `ausweisapp-sdk`
- `robot-tests`
- `robot-runtime`
- `github-runner`

## CI/CD mit GitHub Actions

Es gibt zwei vorhandene Pipelines:

### 1. GitHub-hosted Workflow

Datei: `.github/workflows/ci_tests_workflow.yml`

Diese Pipeline:

- checkt das Repository aus
- installiert Python-Abhaengigkeiten
- initialisiert die Browser Library
- installiert Chromium-Abhaengigkeiten
- fuehrt die UI-Suiten aus
- laedt `log.html`, `report.html`, `output.xml` und `xunit.xml` hoch

### 2. Self-hosted Workflow

Datei: `.github/workflows/ci_tests_workflow_selfhosted.yml`

Diese Pipeline:

- laeuft auf einem eigenen Linux-Runner
- startet den Docker-Teststack
- fuehrt die Tests im Container `robot-tests` aus
- kopiert die Ergebnisse aus dem Container nach `results2/`
- laedt die Artefakte hoch

## Testsuiten aus `tests/ui`

### `ts_01_landing_page.robot`

Inhalt:

- prueft die oeffentliche Startseite
- prueft Dialoge und FAQ
- prueft Footer-Inhalte
- enthaelt einen kompletten oeffentlichen Journey-Test

Testfaelle:

- `TC001 - Validate Landing Page`: Grundpruefung der Startseite
- `TC002 - Verify Header Accessibility Buttons Are Present On Landing Page`: Header und Barrierefreiheitsbuttons
- `TC003 - Navigate To Leichte Sprache And Validate`: Dialog Leichte Sprache
- `TC004 - Navigate To Gebärdensprache And Validate`: Dialog Gebaerdensprache
- `TC005 - Navigate To FAQ And Validate`: FAQ-Dialog
- `TC006 - Verify All FAQ Cards Are Rendered On Landing Page`: alle FAQ-Karten sichtbar
- `TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content`: erste FAQ-Karte
- `TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content`: zweite FAQ-Karte
- `TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content`: dritte FAQ-Karte
- `TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content`: vierte FAQ-Karte
- `TC011 - Navigate To Impressum And Validate`: Impressum
- `TC012 - Navigate To Datenschutz And Validate`: Datenschutz
- `TC013 - Navigate To Barrierefreiheit And Validate`: Barrierefreiheit
- `TC014 - Full SPA User Journey`: kompletter oeffentlicher Ablauf

### `ts_02_auth_info_page.robot`

Inhalt:

- prueft die Seite vor dem Login
- prueft FAQ und externe Links
- prueft den Einstieg in die AusweisApp-Anmeldung

Testfaelle:

- `TC001 - Validate Authentication Info Page`: Grundpruefung der Auth-Info-Seite
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present`: Header, FAQ, Footer
- `TC003 - AusweisApp Link Navigates To External Page`: externer AusweisApp-Link
- `TC004 - Kompatibles Lesegerät Link Navigates To External Page`: externer Lesegeraet-Link
- `TC005 - Verify AusweisApp Starten Button Is Accessible`: Startbutton und kontrollierter Login/Logout
- `TC006 - Verify FAQ Card 'Was benötige ich' And Validate Content`: erste FAQ-Karte
- `TC007 - Verify FAQ Card 'Wie melde ich mich' And Validate Content`: zweite FAQ-Karte
- `TC008 - Verify FAQ Card 'Wie sicher ist das Cockpit' And Validate Content`: dritte FAQ-Karte
- `TC009 - Full Login Page User Journey`: kompletter Ablauf auf der Auth-Info-Seite

### `ts_03_register_selection.robot`

Inhalt:

- prueft die Registerauswahl nach erfolgreichem Login
- prueft Auswahl, Listenmodus, Dialoge, Timer und Stabilitaet

Testfaelle:

- `TC001 - Validate Register Selection Page`: Grundpruefung der Registerauswahl
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present`: Header, FAQ, Footer, Version
- `TC003 - Verify Register List Elements Are Rendered`: Grid-Grundzustand
- `TC004 - Verify Intro Content Links Are Present`: Intro-Buttons
- `TC005 - Verify Feedback Button Is Present`: Feedback-Button
- `TC006 - Select Single Register Enables Request Start`: ein Register auswaehlen
- `TC007 - Toggle Single Register Returns Empty State`: Auswahl wieder entfernen
- `TC008 - Toggle All Registers Select And Deselect`: alle Register an- und abwaehlen
- `TC009 - Intro Dialog 'Was sehe ich' Opens And Closes`: erster Intro-Dialog
- `TC010 - Intro Dialog 'Was ist das DSC' Opens And Closes`: zweiter Intro-Dialog
- `TC011 - Floating FAQ Dialog Opens And Closes`: FAQ im Cockpit
- `TC012 - Verify IDNr Is Masked By Default`: maskierte ID-Nummer
- `TC013 - Verify Session Timer Counts Down`: Timer laeuft herunter
- `TC014 - Verify Register Cards Count And More-Info Buttons`: Karten und Mehr-Info-Buttons
- `TC015 - Verify Register List View Elements Are Rendered`: Listenansicht
- `TC016 - Select Single Register In List View Enables Request Start`: Auswahl im Listenmodus
- `TC017 - Toggle All Registers In List View Select And Deselect`: globale Auswahl im Listenmodus
- `TC018 - Reload Keeps Registerauswahl Stable`: Stabilitaet nach Reload

### `ts_04_register_selection_bva_ui.robot`

Inhalt:

- prueft einen festen BVA-Workflow Ende-zu-Ende
- inklusive Ergebnisseite, Detaildialog und PDF

Testfaelle:

- `TC001 - Select Test BVA Register Card Enables Anfrage Starten`: BVA auswaehlen
- `TC002 - Deselect Test BVA Register Card Returns Empty Selection State`: BVA wieder abwaehlen
- `TC003 - Start BVA Request Navigates To Results Page`: Ergebnisseite erreichen
- `TC004 - Verify Results Page Shows Correct Statistics For BVA`: Statistik pruefen
- `TC005 - Verify Test BVA Result Entry Is Visible And Collapsed`: Ergebnisblock eingeklappt
- `TC006 - Expand Test BVA Result Entry Shows Data Tables`: Ergebnisblock geoeffnet
- `TC007 - Open First Protokolldaten Dialog Shows Initial State`: Dialog initial
- `TC008 - Request Personal Data Shows Inhaltsdaten In Dialog`: persoenliche Daten laden
- `TC009 - Verify PDF Download Filename Matches Pattern And Timestamp`: PDF-Dateiname
- `TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading`: PDF-Inhalt
- `TC011 - Close Protokolldaten Dialog Returns To Results View`: Dialog schliessen
- `TC012 - Navigate Back To Register Auswahl Restores Correct URL`: zurueck zur Registerauswahl

### `ts_05_register_selection_bva_ui_api.robot`

Inhalt:

- nimmt den BVA-Workflow aus `ts_04`
- erweitert ihn um API-Verifikation gegen eine JSON-Referenz

Testfaelle:

- `TC001` bis `TC012`: dieselben fachlichen Schritte wie in `ts_04`
- `TC013 - Verify Test BVA Personal Data API Response Matches Fixture`: Live-API gegen `bva.json`
- `API First Run: Capture BVA Personal Data API Response Fixture`: JSON-Referenz erzeugen oder erneuern

### `ts_06_register_cards_generic_dom_test.robot`

Inhalt:

- generische Registerpruefung ueber sichtbare Dialogdaten
- Vergleich gegen YAML-Fixtures

Testfaelle:

- `Verify Register Card Workflow: Test BVA`: BVA gegen `bva.yaml`
- `Verify Register Card Workflow: Test-DGUV`: DGUV gegen `dguv.yaml`
- `First Run: Capture And Generate Fixture For Test BVA`: `bva.yaml` erzeugen oder erneuern
- `First Run: Capture And Generate Fixture For Test-DGUV`: `dguv.yaml` erzeugen oder erneuern

### `ts_07_register_cards_generic_api_test.robot`

Inhalt:

- generische Registerpruefung ueber API-Responses
- Vergleich gegen JSON-Fixtures

Testfaelle:

- `Verify Register Api Workflow: Test BVA`: BVA-API gegen `bva.json`
- `Verify Register Api Workflow: Test-DGUV`: DGUV-API gegen `dguv.json`
- `API First Run: Capture And Generate Fixture For Test BVA`: `bva.json` und `bva_raw.json` erzeugen oder erneuern
- `API First Run: Capture And Generate Fixture For Test-DGUV`: `dguv.json` und `dguv_raw.json` erzeugen oder erneuern

## Kurzfazit

- `ts_01` und `ts_02` decken die oeffentlichen Seiten ab.
- `ts_03` deckt die Registerauswahl nach Login ab.
- `ts_04` und `ts_04b` sichern den festen BVA-Fall ab.
- `ts_05` und `ts_05b` machen daraus wiederverwendbare Registertests.

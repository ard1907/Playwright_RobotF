# Testübersicht — Playwright_RobotF Projekt
Generiert: 2026-04-23

## Zweck
Dieses Dokument fasst die Robot Framework Testsuiten, Testfälle sowie die wichtigsten Page-Object- und Resource-Keywords des Repositories zusammen. Es soll neuen Leser:innen einen schnellen Überblick darüber geben, welche Funktionalität getestet wird und wo die Implementierung zu finden ist.

---

## Inhaltsverzeichnis
- Testsuiten
- Page-Objekte (pages/)
- Gemeinsame Ressourcen (resources/)
- Schnell einsteigen: Tests lesen
- Hinweise & Empfehlungen

---

## 1) Testsuiten (nach Datei)

- `tests/ui/ts_01_smoke_test_landing_page.robot`
  - Suite-Setup: `Open Application Browser`
  - Test-Setup: `Navigate To Landing Page`
  - Suite-Teardown: `Close Application Browser`
  - Testfälle:
    - TC001 — Validate Landing Page
      - Prüft Seitentitel, H1, Einleitungstext, primäre CTA, FAQ-Bereich, Footer-Navigation, Floating-FAQ-Button und Versionsstring.
    - TC002 — Verify Header Accessibility Buttons Are Present On Landing Page
      - Stellt sicher, dass Logo und Barrierefreiheits-Buttons sichtbar und aktivierbar sind.
    - TC003 — Navigate To Leichte Sprache And Validate
      - Öffnet den 'Leichte Sprache'-Dialog und validiert Überschriften, Inhaltsanker und Links.
    - TC004 — Navigate To Gebaerdensprache And Validate
      - Öffnet den Gebärdensprach-Dialog, prüft Überschrift, eingebettetes Video und zugehörige Links.
    - TC005 — Navigate To FAQ And Validate
      - Öffnet das FAQ-Dialog und prüft Dialogtitel, Abschnittsüberschriften und Karteninhalte.
    - TC006 — Verify All FAQ Cards Are Rendered On Landing Page
      - Bestätigt, dass alle FAQ-Akkordeon-Karten auf der Landingpage vorhanden sind.
    - TC007..TC010 — Per-FAQ-card checks
      - Klickt jede FAQ-Karte an und validiert Inhalt und Tab-Titel.
    - TC011 — Navigate To Impressum And Validate
      - Öffnet Impressum-Dialog und validiert Überschriften, Organisationseinträge und E-Mail-Links.
    - TC012 — Navigate To Datenschutz And Validate
      - Öffnet Datenschutz-Dialog und prüft nummerierte Abschnitte und gesetzliche Referenzen.
    - TC013 — Navigate To Barrierefreiheit And Validate
      - Öffnet Barrierefreiheits-Dialog und prüft Überschriften, Kontaktangaben und externe Links.
    - TC014 — Full SPA User Journey
      - End-to-end Rauchtest: öffnet Dialoge nacheinander, führt Stichprobenprüfungen durch und schließt Dialoge, erweitert FAQ-Karten.

- `tests/ui/ts_02_smoke_test_auth_info_page.robot`
  - Suite-Setup: `Open Application Browser ${AUTH_INFO_URL}`
  - Test-Setup: `Navigate To Authentication Info Page`
  - Suite-Teardown: `Close Application Browser`
  - Testfälle:
    - TC001 — Validate Authentication Info Page
      - Prüft Seitentitel, H1, Logo, Barrierefreiheits-Buttons, Footer-Navigation, Versionsstring, AusweisApp-Links und eingebettete FAQ-Elemente.
    - TC002 — Verify Header Accessibility And Navigation Buttons Are Present
      - Prüft Header-Buttons, Floating-FAQ und Footer-Navigation auf Sichtbarkeit und Funktion.
    - TC003 — AusweisApp Link Navigates To External Page
      - Öffnet die externe AusweisApp-Seite in neuem Tab und validiert URL und Titel.
    - TC004 — Kompatibles Lesegerät Link Navigates To External Page
      - Öffnet die externe Seite zur Lesegeräte-Kompatibilität und validiert Navigation und Titel.
    - TC005 — Verify AusweisApp Starten Button Is Accessible
      - Prüft den `AusweisApp starten`-Button auf Anwesenheit/Zustand und führt einen sicheren Klickfluss inkl. Login/Logout-Helpers durch.
    - TC006..TC008 — Per-FAQ-card checks
      - Validiert Inhalt und Links jeder FAQ-Karte auf der Auth-Info-Seite.
    - TC009 — Full Login Page User Journey
      - End-to-end-Lauf für Auth-Info-Interaktionen und FAQ/Karten-Flows.

- `tests/ui/ts_03_smoke_test_register_selection.robot`
  - Suite-Setup: `Open Browser And Login For AusweisApp Suite ${AUTH_INFO_URL}`
  - Test-Setup: `Navigate To Register Auswahl Page`
  - Suite-Teardown: `Close Browser After AusweisApp Suite`
  - Testfälle:
    - TC001 — Validate Register Selection Page
      - Prüft Kernelemente der Registerauswahl: Titel, H1/H2, IDNr-Anzeige, Session-Timer, Logout-Button und Einleitungstext.
    - TC002 — Verify Header Accessibility And Navigation Buttons Are Present
      - Prüft Header-Buttons, Floating-FAQ, Footer-Navigation und Versionsstring.
    - TC003 — Verify Register List Elements Are Rendered
      - Validiert den Grid-Standardzustand der Registerliste, Toggle-Controls und Empty-State-Hinweise.
    - TC004 — Verify Intro Content Links Are Present
      - Prüft die beiden Intro-Verweise zu Datenschutzcockpit-Inhalten.
    - TC005 — Verify Feedback Button Is Present
      - Validiert den cockpit-spezifischen Feedback-Button.
    - TC006 — Select Single Register Enables Request Start
      - Wählt ein Register aus und prüft, dass `Anfrage starten` sichtbar/aktiv wird.
    - TC007 — Toggle Single Register Returns Empty State
      - Entfernt die Registerauswahl erneut und validiert die Rückkehr in den Empty State.
    - TC008 — Toggle All Registers Select And Deselect
      - Prüft den globalen Auswahl-/Abwahl-Flow aller Register.
    - TC009 — Intro Dialog 'Was sehe ich' Opens And Closes
      - Öffnet den Intro-Dialog, sofern die Umgebung den Verweis klickbar rendert; sonst kontrollierter Warn-Fallback.
    - TC010 — Intro Dialog 'Was ist das DSC' Opens And Closes
      - Öffnet den zweiten Intro-Dialog mit demselben Guard-/Fallback-Verhalten.
    - TC011 — Floating FAQ Dialog Opens And Closes
      - Öffnet das FAQ-Overlay im Cockpit und validiert Titel/Schließen.
    - TC012 — Verify IDNr Is Masked By Default
      - Prüft die maskierte IDNr-Anzeige und den Anzeigen-Button.
    - TC013 — Verify Session Timer Counts Down
      - Liest den Session-Timer zweimal und validiert die Zustandsänderung.
    - TC014 — Verify Register Cards Count And More-Info Buttons
      - Prüft, dass Registerkarten und `Mehr zum Register lesen`-Buttons in passender Anzahl vorhanden sind.
    - TC015 — Reload Keeps Registerauswahl Stable
      - Lädt die Seite neu und validiert, dass Kerninhalte stabil sichtbar bleiben.
    - TC016 — Verify Register List View Elements Are Rendered
      - Wechselt in die Listenansicht und prüft die listenansichtsspezifischen Controls sowie die Empty-State-Hinweise.
    - TC017 — Select Single Register In List View Enables Request Start
      - Wechselt in die Listenansicht, wählt ein Register aus und prüft, dass `Anfrage starten` sichtbar und aktiv wird.
    - TC018 — Toggle All Registers In List View Select And Deselect
      - Wechselt in die Listenansicht und validiert das globale Auswahl- und Abwahlverhalten.

- `tests/ui/ts_04_smoke_test_register_selection_BVA.robot`
  - Suite-Setup: `Open Browser And Login For BVA Suite`
  - Test-Setup: `Open Register Auswahl In Default Grid View`
  - Suite-Teardown: `Close Browser After AusweisApp Suite`
  - Testfälle:
    - TC001..TC002 — BVA-Auswahl und Toggle-Prüfungen
      - Validieren das Auswählen und Abwählen der Test-BVA-Karte.
    - TC003..TC006 — BVA-Ergebnisseite
      - Validieren Ergebnisroute, Statistik-Zähler, eingeklappten Zustand und geöffneten Zustand.
    - TC007..TC012 — BVA-Detaildialog und PDF-Prüfungen
      - Validieren Protokolldaten-Dialog, Abruf personenbezogener Daten, PDF-Prüfungen, Schließen des Dialogs und Rücknavigation.

- `tests/ui/ts_05_smoke_test_register_cards_generic.robot`
  - Suite-Setup: `Open Browser And Login For Generic Register Suite`
  - Test-Setup: `Open Register Auswahl In Default Grid View`
  - Suite-Teardown: `Close Browser After Generic Register Suite`
  - Zweck:
    - Prüft Registerkarten generisch über YAML-Fixtures in `test_data/registers/`.
    - Nutzt pro Registerkarte einen Testfall für die normale Verifikation.
    - Nutzt separate First-Run-Tests, um Fixture-Daten zu erzeugen oder zu aktualisieren.
  - Laufmodi:
    - Normalmodus: `robot tests/ui/ts_05_smoke_test_register_cards_generic.robot`
      - Lädt ein Fixture, überspringt bei `first_run.completed = false` und prüft den Live-Dialog gegen die erwarteten Daten.
    - First-Run-Modus: `robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot`
      - Erfasst Live-Sender- und Felddaten und schreibt daraus Fixture-Inhalt.
      - Unvollständige Fixtures werden automatisch neu erzeugt.
      - Bereits abgeschlossene Fixtures werden nur mit `FIXTURE_FORCE_REGENERATE=True` überschrieben.
  - Testfälle:
    - Verify Register Card Workflow: Test BVA
      - Prüft das generische BVA-Register gegen `bva.yaml`.
    - Verify Register Card Workflow: Test-DGUV
      - Prüft das generische DGUV-Register gegen `dguv.yaml`.
    - First Run: Capture And Generate Fixture For Test BVA
      - Erfasst Live-Daten des BVA-Dialogs und schreibt das Fixture.
    - First Run: Capture And Generate Fixture For Test-DGUV
      - Erfasst Live-Daten des DGUV-Dialogs und schreibt das Fixture.

- `tests/helpers/dsc_basic_test.robot`
  - Suite-Setup: `Open Application Browser`
  - Test-Setup: `Navigate To Landing Page`
  - Suite-Teardown: `Close Application Browser`
  - Testfälle:
    - TC001 — Validate Landing Page
      - Kleine Suite, validiert Kern-Elemente der Landingpage (Titel, H1, CTA, Basis-Checks).
    - TC002 — Navigate To Leichte Sprache And Validate
      - Öffnet Leichte Sprache-Dialog und führt die zugehörigen Prüfungen aus.

- `tests/helpers/dsc_get_cookies_requests.robot`
  - Suite-Setup: `Open Application Browser For Cookie Testing`
  - Test-Setup: `Navigate To Authentication Info Page`
  - Suite-Teardown: `Close Application Browser`
  - Testfälle:
    - TC001 — Get Cookies From Authentication Info Page
      - Loggt Cookies nach einem (sicheren) Login-Flow; nutzt `Login Into Datenschutzcockpit` und `Logout From Datenschutzcockpit`.

---

## 2) Page-Objekte (pages/)
- `pages/dsc_landing_page.robot` — `Validate Landing Page`
- `pages/dsc_easy_language_page.robot` — `Validate Leichte Sprache Page`
- `pages/dsc_authentication_info_page.robot` — `Validate Authentication Info Page`
- `pages/dsc_faq_page.robot` — `Validate FAQ Page`
- `pages/dsc_imprint_legal_notice_page.robot` — `Validate Impressum Page`
- `pages/dsc_privacy_page.robot` — `Validate Datenschutz Page`
- `pages/dsc_accessibility_page.robot` — `Validate Barrierefreiheit Page`
- `pages/dsc_sign_language_page.robot` — `Validate Gebaerdensprache Page`
- `pages/dsc_register_selection_page.robot` — Registerauswahl-Assertions, Grid-/Listenansicht-Keywords, Auswahl-/Toggle-Helpers, FAQ-/Intro-Dialog-Checks, IDNr-/Timer-Prüfungen und Logout-Helpers
- `pages/dsc_register_result_page.robot` — generischer Register-Ergebnis-Flow: Registerauswahl, Ergebnis öffnen, Protokolldaten-Dialog öffnen/abfragen/schließen, paarige Feld-Prüfung und Fixture-Erzeugung

---

## 3) Gemeinsame Ressourcen (resources/)
- `resources/dsc_setup_teardown.robot` — Browser-Lifecycle-Keywords sowie `Open Browser And Login For AusweisApp Suite` und `Close Browser After AusweisApp Suite` als wiederverwendbares Setup-/Teardown-Paar für künftige AusweisApp-abhängige Suites
- `resources/dsc_shared_keywords.robot` — Navigations-, Sichtbarkeits- und Tab-Helpers inkl. `Navigate To Register Auswahl Page` sowie `Skip Current Test If AusweisApp Environment Is Missing` für einzelne login-abhängige Tests
- `resources/dsc_variables.robot` — Basis-URLs, TIMEOUTs, TITLE_* Strings, `${AUSWEISAPP_URL}`-Override
- `resources/scripts_py/dsc_register_fixture_library.py` — lädt und schreibt YAML-Fixtures, liefert First-Run-Status und erwartete Dialogdaten und unterstützt robuste Schlüssel/Wert-Zuordnung für die generische Registerkarten-Suite

---

## 4) Schnell einsteigen: Tests lesen
- Top-Level-Smoke-Suites befinden sich in `tests/ui/`, Hilfs-Suites in `tests/helpers/` und Beispiele in `tests/examples/`.
- Suchen Sie `Validate ...` Keywords in `pages/` um die konkreten Prüfungen zu sehen.
- Testsuites importieren `resources/dsc_*` und `pages/*` — Ändern Sie Selektoren in `pages/*.robot`.
- Filtern Sie Läufe mit Tags (`smoke`, `landing`, `auth`, `faq`, `accessibility`, `cookies`, `register-auswahl`, `interaction`, `selection`, `toggle`, `list-view`, `all-registers`, `dialog`, `security`, `session`, `timer`, `reload`).

---

## 5) Hinweise & Empfehlungen
- Architektur: Page Object Model — Konsistenz wahren, Selektoren zentral in `pages/` pflegen.
- Neue Tests: Page-Keywords erstellen → Suite anlegen → `Validate ...` aufrufen.
- Für künftige AusweisApp-abhängige Suites wie `ts_04` dieses Muster verwenden, statt CI-Guards in Testfällen oder Page-Objekten zu duplizieren:
  - `Suite Setup     Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}`
  - `Suite Teardown  Close Browser After AusweisApp Suite`
  - `Test Setup      <routenspezifisches Navigations-Keyword>`
- Der temporäre Standard-CI-Skip ist zentral deaktivierbar: dafür die jeweilige `Skip If`-Zeile in `resources/dsc_setup_teardown.robot` für Suite-weites Verhalten bzw. in `resources/dsc_shared_keywords.robot` für einzelne Login-Guards auskommentieren.
- Für externe Links: `Open External Tab And Validate` Helper verwenden.
- Für stabile Cockpit-Tests in `ts_03`: pro Test die Zielroute frisch laden, damit keine UI-Zustände aus dem vorherigen Test vererbt werden.
- Für die generische Registerkarten-Suite den First-Run immer explizit aktivieren. Nicht nur auf das Tag `first-run` verlassen, sondern `ENABLE_FIRST_RUN_TESTS=True` setzen.
- Wenn ein Registerdialog Felder in einer ungewöhnlichen DOM-Struktur rendert, zuerst das generierte YAML prüfen und mit `LogikRegisterTests.md` vergleichen, bevor das Capture-JavaScript angepasst wird.

---

## Fundorte
- Tests: `tests/ui/`; Helfer: `tests/helpers/`; Beispiele: `tests/examples/`
- Page-Objekte: `pages/`
- Ressourcen/Variablen: `resources/`

---

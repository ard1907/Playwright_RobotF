# Testübersicht — Playwright_RobotF Projekt
Generiert: 2026-04-22

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

- `test_helpers/dsc_basic_test.robot`
  - Suite-Setup: `Open Application Browser`
  - Test-Setup: `Navigate To Landing Page`
  - Suite-Teardown: `Close Application Browser`
  - Testfälle:
    - TC001 — Validate Landing Page
      - Kleine Suite, validiert Kern-Elemente der Landingpage (Titel, H1, CTA, Basis-Checks).
    - TC002 — Navigate To Leichte Sprache And Validate
      - Öffnet Leichte Sprache-Dialog und führt die zugehörigen Prüfungen aus.

- `test_helpers/dsc_get_cookies_requests.robot`
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
- `pages/dsc_register_selection_page.robot` — Logout-Helpers

---

## 3) Gemeinsame Ressourcen (resources/)
- `resources/dsc_setup_teardown.robot` — Browser-Lifecycle-Keywords
- `resources/dsc_shared_keywords.robot` — Navigations-, Sichtbarkeits- und Tab-Helpers
- `resources/dsc_variables.robot` — Basis-URLs, TIMEOUTs, TITLE_* Strings, `${AUSWEISAPP_URL}`-Override

---

## 4) Schnell einsteigen: Tests lesen
- Top-Level-Smoke-Suites befinden sich in `tests/ui/` und Hilfs-Suites in `test_helpers/`.
- Suchen Sie `Validate ...` Keywords in `pages/` um die konkreten Prüfungen zu sehen.
- Testsuites importieren `resources/dsc_*` und `pages/*` — Ändern Sie Selektoren in `pages/*.robot`.
- Filtern Sie Läufe mit Tags (`smoke`, `landing`, `auth`, `faq`, `accessibility`, `cookies`).

---

## 5) Hinweise & Empfehlungen
- Architektur: Page Object Model — Konsistenz wahren, Selektoren zentral in `pages/` pflegen.
- Neue Tests: Page-Keywords erstellen → Suite anlegen → `Validate ...` aufrufen.
- Für externe Links: `Open External Tab And Validate` Helper verwenden.

---

## Fundorte
- Tests: `tests/ui/`; Helfer: `test_helpers/`
- Page-Objekte: `pages/`
- Ressourcen/Variablen: `resources/`

---



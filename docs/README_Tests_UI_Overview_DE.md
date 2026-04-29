# UI-Testübersicht — `tests/ui/`
Generiert: 2026-04-23

Dieses Dokument fasst die UI-Testsuiten im Ordner `tests/ui/` zusammen und listet die enthaltenen Testfälle je Suite in kompakter Form auf.

## 1) `tests/ui/ts_01_smoke_test_landing_page.robot`

- `TC001 - Validate Landing Page` - Prüft die Startseite auf Titel, H1, Einleitung, CTA, FAQ-Bereich, Footer-Navigation, Floating-FAQ-Button und Versionsstring.
- `TC002 - Verify Header Accessibility Buttons Are Present On Landing Page` - Prüft Logo und Header-Buttons für Leichte Sprache und Gebärdensprache.
- `TC003 - Navigate To Leichte Sprache And Validate` - Öffnet den Dialog für Leichte Sprache und validiert Inhalt, Links und Rückkehr zur Startseite.
- `TC004 - Navigate To Gebärdensprache And Validate` - Öffnet den Gebärdensprache-Dialog und prüft Überschrift, Video und Links.
- `TC005 - Navigate To FAQ And Validate` - Öffnet den FAQ-Dialog und validiert Titel, Abschnittsüberschriften und Akkordeon-Inhalte.
- `TC006 - Verify All FAQ Cards Are Rendered On Landing Page` - Stellt sicher, dass alle vier FAQ-Karten auf der Landingpage sichtbar sind.
- `TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content` - Öffnet die erste FAQ-Karte und prüft Inhalt und Tab-Titel.
- `TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content` - Öffnet die zweite FAQ-Karte und prüft die angezeigten Inhalte.
- `TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content` - Öffnet die dritte FAQ-Karte und prüft die genannten Organisationen.
- `TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content` - Öffnet die vierte FAQ-Karte und prüft Inhalt, Links und Tab-Titel.
- `TC011 - Navigate To Impressum And Validate` - Öffnet das Impressum und validiert Überschriften, Organisationen und E-Mail-Links.
- `TC012 - Navigate To Datenschutz And Validate` - Öffnet die Datenschutzerklärung und prüft Abschnitte sowie rechtliche Hinweise.
- `TC013 - Navigate To Barrierefreiheit And Validate` - Öffnet die Barrierefreiheit und prüft Überschriften, Kontaktangaben und externe Links.
- `TC014 - Full SPA User Journey` - Führt einen vollständigen Smoke-Flow durch alle wichtigen SPA-Ansichten und FAQ-Karten aus.

## 2) `tests/ui/ts_02_smoke_test_auth_info_page.robot`

- `TC001 - Validate Authentication Info Page` - Prüft die Authentifizierungs-Info-Seite auf Titel, H1, Logo, Barrierefreiheits-Buttons, Footer, Version, AusweisApp-Hinweise und FAQ-Inhalte.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - Prüft Header-Buttons, Floating-FAQ und Footer-Navigation auf Sichtbarkeit und Aktivität.
- `TC003 - AusweisApp Link Navigates To External Page` - Öffnet den AusweisApp-Link in einem neuen Tab und validiert Zielseite, URL und Titel.
- `TC004 - Kompatibles Lesegerät Link Navigates To External Page` - Öffnet den Link zum kompatiblen Lesegerät und validiert die externe Zielseite.
- `TC005 - Verify AusweisApp Starten Button Is Accessible` - Prüft den Button auf Anwesenheit und Zustand; der Login-/Logout-Flow wird kontrolliert mitgeprüft.
- `TC006 - Verify FAQ Card 'Was benötige ich' And Validate Content` - Öffnet die erste FAQ-Karte und prüft den Inhalt sowie externe Referenzen.
- `TC007 - Verify FAQ Card 'Wie melde ich mich' And Validate Content` - Öffnet die zweite FAQ-Karte und validiert die Schritt-für-Schritt-Inhalte.
- `TC008 - Verify FAQ Card 'Wie sicher ist das Cockpit' And Validate Content` - Öffnet die dritte FAQ-Karte und prüft Sicherheitsinhalte sowie Abschnittsüberschriften.
- `TC009 - Full Login Page User Journey` - Führt einen kompletten Smoke-Flow über die Auth-Info-Seite und ihre FAQ-Inhalte aus.

## 3) `tests/ui/ts_03_smoke_test_register_selection.robot`

- `TC001 - Validate Register Selection Page` - Prüft die Registerauswahl auf Titel, H1/H2, maskierte IDNr, Session-Timer, Logout-Button und Einführungstext.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - Prüft Header-Buttons, Floating-FAQ, Footer-Navigation und die Versionsanzeige.
- `TC003 - Verify Register List Elements Are Rendered` - Prüft den Grundzustand der Registerliste inklusive Auswahlsteuerung, Karten und Empty-State-Hinweisen.
- `TC004 - Verify Intro Content Links Are Present` - Prüft die beiden Intro-Buttons zu den Inhalten der Registerauswahl.
- `TC005 - Verify Feedback Button Is Present` - Prüft den Feedback-Button in der Seitenleiste.
- `TC006 - Select Single Register Enables Request Start` - Wählt ein Register aus und prüft, dass `Anfrage starten` sichtbar und aktiv wird.
- `TC007 - Toggle Single Register Returns Empty State` - Wählt ein Register an und wieder ab und prüft die Rückkehr in den Empty State.
- `TC008 - Toggle All Registers Select And Deselect` - Prüft das globale Auswählen und Abwählen aller Register.
- `TC009 - Intro Dialog "Was sehe ich" Opens And Closes` - Öffnet und schließt den Intro-Dialog für „Was sehe ich im Datenschutzcockpit?“, mit robustem Guard/Fallback-Verhalten.
- `TC010 - Intro Dialog "Was ist das DSC" Opens And Closes` - Öffnet und schließt den zweiten Intro-Dialog mit dem gleichen Guard/Fallback-Verhalten.
- `TC011 - Floating FAQ Dialog Opens And Closes` - Öffnet den FAQ-Dialog der Cockpit-Seite und prüft Titel sowie Schließen-Verhalten.
- `TC012 - Verify IDNr Is Masked By Default` - Prüft die maskierte IDNr-Anzeige und den verfügbaren Anzeige-Button.
- `TC013 - Verify Session Timer Counts Down` - Liest den Session-Timer zweimal und prüft, dass er sich verändert.
- `TC014 - Verify Register Cards Count And More-Info Buttons` - Prüft, dass Registerkarten und „Mehr zum Register lesen“-Buttons in passender Anzahl vorhanden sind.
- `TC015 - Reload Keeps Registerauswahl Stable` - Lädt die Seite neu und prüft, dass die Kerninhalte stabil bleiben.
- `TC016 - Verify Register List View Elements Are Rendered` - Wechselt in die Listenansicht und prüft die listenansichtsspezifischen Controls sowie die Empty-State-Hinweise.
- `TC017 - Select Single Register In List View Enables Request Start` - Wechselt in die Listenansicht, wählt ein Register aus und prüft, dass `Anfrage starten` sichtbar und aktiv wird.
- `TC018 - Toggle All Registers In List View Select And Deselect` - Wechselt in die Listenansicht und prüft das globale Auswahl- und Abwahlverhalten.

## Hinweis

Die Registerauswahl-Suite ist nur nach erfolgreichem Login erreichbar. Einzelne Intro- und Mehr-Info-Elemente können je nach Umgebung als nicht-klassische Klickziele gerendert werden; die Suite berücksichtigt das mit kontrollierten Fallbacks. Die Suite deckt außerdem Grid- und Listenansicht ab.

## 4) `tests/ui/ts_04_smoke_test_register_selection_BVA.robot`

- `TC001 - Select Test BVA Register Card Enables Anfrage Starten` - Wählt das BVA-Register aus und prüft den Status des Anfrage-Buttons.
- `TC002 - Deselect Test BVA Register Card Returns Empty Selection State` - Prüft, dass die BVA-Karte sauber wieder abgewählt werden kann.
- `TC003 - Start BVA Request Navigates To Results Page` - Startet eine BVA-Anfrage und prüft die Ergebnisroute.
- `TC004 - Verify Results Page Shows Correct Statistics For BVA` - Prüft die Ergebnis-Zähler des BVA-Flows.
- `TC005 - Verify Test BVA Result Entry Is Visible And Collapsed` - Prüft die BVA-Ergebnisbox im eingeklappten Zustand.
- `TC006 - Expand Test BVA Result Entry Shows Data Tables` - Öffnet den BVA-Eintrag und prüft Tabellenüberschriften.
- `TC007 - Open First Protokolldaten Dialog Shows Initial State` - Öffnet den ersten BVA-Detaildialog und prüft den Initialzustand.
- `TC008 - Request Personal Data Shows Inhaltsdaten In Dialog` - Fragt personenbezogene Daten im BVA-Dialog ab und prüft den geladenen Zustand.
- `TC009 - Verify PDF Download Filename Matches Pattern And Timestamp` - Prüft den Dateinamen der erzeugten PDF.
- `TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading` - Prüft den Inhalt der erzeugten PDF.
- `TC011 - Close Protokolldaten Dialog Returns To Results View` - Prüft das Schließen des Dialogs.
- `TC012 - Navigate Back To Register Auswahl Restores Correct URL` - Prüft den Rückweg von der Ergebnisseite.

## 5) `tests/ui/ts_05_smoke_test_register_cards_generic.robot`

- `Verify Register Card Workflow: Test BVA` - Prüft den generischen BVA-Registerkarten-Flow gegen `test_data/registers/bva.yaml`.
- `Verify Register Card Workflow: Test-DGUV` - Prüft den generischen DGUV-Registerkarten-Flow gegen `test_data/registers/dguv.yaml`.
- `First Run: Capture And Generate Fixture For Test BVA` - Erfasst die BVA-Dialogdaten und kann `bva.yaml` neu erzeugen, wenn First-Run explizit aktiviert wird.
- `First Run: Capture And Generate Fixture For Test-DGUV` - Erfasst die DGUV-Dialogdaten und kann `dguv.yaml` neu erzeugen, wenn First-Run explizit aktiviert wird.

## Hinweis zur generischen Registerkarten-Suite

Die generische Registerkarten-Suite hat zwei Modi:

- Normalmodus prüft Live-Dialogdaten gegen YAML-Fixtures.
- First-Run-Modus liest Dialogdaten aus und schreibt Fixtures.

Der First-Run ist bewusst opt-in und muss mit `--include first-run --variable ENABLE_FIRST_RUN_TESTS:True` gestartet werden.
Unvollständige Fixtures werden im First-Run automatisch neu erzeugt. Bereits abgeschlossene Fixtures werden nur mit `FIXTURE_FORCE_REGENERATE=True` überschrieben.
Eine einfache Gesamterklärung steht in `LogikRegisterTests.md`.
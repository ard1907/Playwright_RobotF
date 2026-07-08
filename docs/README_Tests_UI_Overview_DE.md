# UI-Testuebersicht — `tests/ui/`

Stand: 2026-06-11

Dieses Dokument listet alle UI-Suiten und ihre Testfaelle in kompakter Form auf.

## 1) `tests/ui/ts_01_landing_page.robot`

- `TC001 - Validate Landing Page` - prueft Titel, H1, Einleitung, CTA, FAQ-Bereich, Footer, Floating-FAQ und Versionsanzeige.
- `TC002 - Verify Header Accessibility Buttons Are Present On Landing Page` - prueft Logo sowie Buttons fuer Leichte Sprache und Gebaerdensprache.
- `TC003 - Navigate To Leichte Sprache And Validate` - oeffnet den Leichte-Sprache-Dialog und prueft Inhalte, interne und externe Links.
- `TC004 - Navigate To Gebaerdensprache And Validate` - oeffnet den Gebaerdensprach-Dialog und prueft Inhalte, Video und externe Links.
- `TC005 - Navigate To FAQ And Validate` - oeffnet den FAQ-Dialog und prueft Titel, Hauptbereiche und Accordions.
- `TC006 - Verify All FAQ Cards Are Rendered On Landing Page` - prueft, dass alle FAQ-Karten sichtbar sind.
- `TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content` - prueft die erste FAQ-Karte auf Inhalt und Tab-Titel.
- `TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content` - prueft die zweite FAQ-Karte auf Inhalt und Abschnittsstruktur.
- `TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content` - prueft die dritte FAQ-Karte auf Betreiberhinweise.
- `TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content` - prueft die vierte FAQ-Karte auf Inhalt und externe Links.
- `TC011 - Navigate To Impressum And Validate` - prueft Impressum-Dialog, Organisationen und E-Mail-Links.
- `TC012 - Navigate To Datenschutz And Validate` - prueft Datenschutz-Dialog und rechtliche Referenzen.
- `TC013 - Navigate To Barrierefreiheit And Validate` - prueft Barrierefreiheits-Dialog, Kontaktangaben und externe Links.
- `TC014 - Full SPA User Journey` - fuehrt einen kompletten oeffentlichen Journey-Flow ueber mehrere Dialoge und FAQ-Karten aus.

## 2) `tests/ui/ts_02_auth_info_page.robot`

- `TC001 - Validate Authentication Info Page` - prueft Auth-Info-Seite, Header, Footer, FAQ und externe Hinweistexte.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - prueft Header-, FAQ- und Footer-Navigation.
- `TC003 - AusweisApp Link Navigates To External Page` - prueft den externen Link zur AusweisApp.
- `TC004 - Kompatibles Lesegerät Link Navigates To External Page` - prueft den externen Link zu kompatiblen Lesegeraeten.
- `TC005 - Verify AusweisApp Starten Button Is Accessible` - prueft den AusweisApp-Startbutton und fuehrt den Login-/Logout-Pfad kontrolliert aus.
- `TC006 - Verify FAQ Card 'Was benötige ich' And Validate Content` - prueft die erste FAQ-Karte inklusive externer Verweise.
- `TC007 - Verify FAQ Card 'Wie melde ich mich' And Validate Content` - prueft die zweite FAQ-Karte mit Anmeldeschritten.
- `TC008 - Verify FAQ Card 'Wie sicher ist das Cockpit' And Validate Content` - prueft die dritte FAQ-Karte mit Sicherheitsinhalten.
- `TC009 - Full Login Page User Journey` - fuehrt einen kompletten User-Journey-Test ueber die Auth-Info-Seite aus.

## 3) `tests/ui/ts_03_register_selection.robot`

- `TC001 - Validate Register Selection Page` - prueft Titel, H1/H2, maskierte IDNr, Timer, Logout und Einleitung.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - prueft Header, FAQ, Footer und Versionsanzeige.
- `TC003 - Verify Register List Elements Are Rendered` - prueft den Grid-Standardzustand der Registerauswahl.
- `TC004 - Verify Intro Content Links Are Present` - prueft die beiden Intro-Buttons in der Seitenbeschreibung.
- `TC005 - Verify Feedback Button Is Present` - prueft den Feedback-Button der Cockpit-Seite.
- `TC006 - Select Single Register Enables Request Start` - prueft, dass eine Registerauswahl den Startbutton freischaltet.
- `TC007 - Toggle Single Register Returns Empty State` - prueft Rueckkehr in den Leerzustand nach Abwahl.
- `TC008 - Toggle All Registers Select And Deselect` - prueft das globale Auswaehlen und Abwaehlen aller Register.
- `TC009 - Intro Dialog 'Was sehe ich' Opens And Closes` - prueft den ersten Intro-Dialog mit robustem Guard-Verhalten.
- `TC010 - Intro Dialog 'Was ist das DSC' Opens And Closes` - prueft den zweiten Intro-Dialog mit robustem Guard-Verhalten.
- `TC011 - Floating FAQ Dialog Opens And Closes` - prueft das FAQ-Overlay im Cockpit.
- `TC012 - Verify IDNr Is Masked By Default` - prueft die maskierte Anzeige der IDNr.
- `TC013 - Verify Session Timer Counts Down` - prueft, dass der Session-Timer zaehlt.
- `TC014 - Verify Register Cards Count And More-Info Buttons` - prueft Kartenanzahl und `Mehr zum Register lesen`-Buttons.
- `TC015 - Verify Register List View Elements Are Rendered` - prueft den Listenmodus.
- `TC016 - Select Single Register In List View Enables Request Start` - prueft die Auswahl im Listenmodus.
- `TC017 - Toggle All Registers In List View Select And Deselect` - prueft das globale Auswaehlen und Abwaehlen im Listenmodus.
- `TC018 - Reload Keeps Registerauswahl Stable` - prueft, dass die Seite nach Reload stabil bleibt.

## 4) `tests/ui/ts_04_register_selection_bva_ui.robot`

- `TC001 - Select Test BVA Register Card Enables Anfrage Starten` - prueft die Auswahl der BVA-Karte.
- `TC002 - Deselect Test BVA Register Card Returns Empty Selection State` - prueft die saubere Abwahl der BVA-Karte.
- `TC003 - Start BVA Request Navigates To Results Page` - prueft die Navigation zur Ergebnisseite.
- `TC004 - Verify Results Page Shows Correct Statistics For BVA` - prueft die Ergebniszaehler.
- `TC005 - Verify Test BVA Result Entry Is Visible And Collapsed` - prueft den eingeklappten Ergebnisblock.
- `TC006 - Expand Test BVA Result Entry Shows Data Tables` - prueft den geoeffneten Ergebnisblock samt Tabellen.
- `TC007 - Open First Protokolldaten Dialog Shows Initial State` - prueft den Initialzustand des Detaildialogs.
- `TC008 - Request Personal Data Shows Inhaltsdaten In Dialog` - prueft den geladenen Dialog nach Datenabruf.
- `TC009 - Verify PDF Download Filename Matches Pattern And Timestamp` - prueft PDF-Dateiname und Zeitfenster.
- `TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading` - prueft den PDF-Inhalt.
- `TC011 - Close Protokolldaten Dialog Returns To Results View` - prueft das Schliessen des Dialogs.
- `TC012 - Navigate Back To Register Auswahl Restores Correct URL` - prueft die Ruecknavigation.

## 5) `tests/ui/ts_05_register_selection_bva_ui_api.robot`

- `TC001` bis `TC012` - spiegeln den BVA-Workflow aus `ts_04` als eigenstaendige Suite.
- `TC013 - Verify Test BVA Personal Data API Response Matches Fixture` - vergleicht die Live-API-Response mit `bva.json`.
- `API First Run: Capture BVA Personal Data API Response Fixture` - erzeugt oder aktualisiert `bva.json` gezielt im `first-run-api`-Modus.

## 6) `tests/ui/ts_06_register_cards_generic_dom_test.robot`

- `Verify Register Card Workflow: Test BVA` - prueft den generischen BVA-Dialog gegen `bva.yaml`.
- `Verify Register Card Workflow: Test-DGUV` - prueft den generischen DGUV-Dialog gegen `dguv.yaml`.
- `First Run: Capture And Generate Fixture For Test BVA` - erzeugt oder aktualisiert `bva.yaml` im expliziten `first-run`-Modus.
- `First Run: Capture And Generate Fixture For Test-DGUV` - erzeugt oder aktualisiert `dguv.yaml` im expliziten `first-run`-Modus.

## 7) `tests/ui/ts_07_register_cards_generic_api_test.robot`

- `Verify Register Api Workflow: Test BVA` - prueft die API-Response des generischen BVA-Flows gegen `bva.json`.
- `Verify Register Api Workflow: Test-DGUV` - prueft die API-Response des generischen DGUV-Flows gegen `dguv.json`.
- `API First Run: Capture And Generate Fixture For Test BVA` - erzeugt oder aktualisiert `bva.json` und `bva_raw.json` im expliziten `first-run-api`-Modus.
- `API First Run: Capture And Generate Fixture For Test-DGUV` - erzeugt oder aktualisiert `dguv.json` und `dguv_raw.json` im expliziten `first-run-api`-Modus.

## Gemeinsame Hinweise

- Die Suiten `ts_03` bis `ts_07` benoetigen eine erfolgreiche AusweisApp-Anmeldung.
- `first-run` und `first-run-api` sind absichtlich Opt-in und laufen nicht automatisch bei einem normalen Suite-Start.
- Die generischen Registertests sind in `LogikRegisterTests.md` genauer erklaert.

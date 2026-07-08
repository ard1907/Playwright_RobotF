# Logik der Registertests

Dieses Dokument erklaert die Registertest-Logik fuer drei verwandte Suiten:

- `ts_05_register_selection_bva_ui_api.robot`
- `ts_06_register_cards_generic_dom_test.robot`
- `ts_07_register_cards_generic_api_test.robot`

Der Unterschied ist einfach:

- `ts_04b` prueft den API-Ansatz zuerst an einem festen Beispiel, naemlich BVA.
- `ts_05` prueft Register ueber sichtbare Dialoginhalte und YAML-Fixtures.
- `ts_05b` verallgemeinert den API-Ansatz fuer mehrere Register und nutzt JSON-Fixtures.

## Ziel der Logik

Die Registertests sollen nicht nur klicken, sondern fachlich pruefen:

- wurde das richtige Register ausgewaehlt?
- landet der Nutzer auf der richtigen Ergebnisseite?
- wird der passende Ergebnisblock geoeffnet?
- laesst sich der Protokolldaten-Dialog oeffnen?
- passen die angezeigten oder gelieferten Daten zum erwarteten Register?

## Bausteine

Die wichtigsten Dateien sind:

- `pages/dsc_register_selection_page.robot`
- `pages/dsc_register_result_page.robot`
- `pages/dsc_register_result_page_api.robot`
- `resources/dsc_shared_keywords.robot`
- `test_data/registers/*.yaml`
- `test_data/registers/*.json`
- `test_data/registers/*_raw.json`

Kurz gesagt:

- die Suite steuert den Ablauf
- die Page Objects kapseln die UI-Schritte
- Python-Helfer lesen und schreiben Fixtures
- Fixtures liefern die Vergleichsbasis fuer normale Verifikation

## Variante 1: DOM-basierte Pruefung mit YAML

Die Suite `ts_06_register_cards_generic_dom_test.robot` ist fuer den Alltagslauf gedacht.
Sie arbeitet mit YAML-Dateien wie `bva.yaml` oder `dguv.yaml`.

Der Ablauf ist:

1. Fixture laden.
2. Pruefen, ob `first_run.completed` gesetzt ist.
3. Registerauswahl in einen sauberen Zustand bringen.
4. Ziel-Registerkarte waehlen.
5. Anfrage starten.
6. Richtigen Ergebnisblock oeffnen.
7. Protokolldaten-Dialog oeffnen.
8. Persoenliche Daten anfragen.
9. Sender und Datenfelder mit dem YAML vergleichen.

Die YAML-Datei beschreibt dabei zum Beispiel:

- technischen Tag des Registers
- sichtbaren Register-Namen
- erwarteten Sender
- erwartete Schluessel und optional Werte
- optionale PDF-Pruefung

## Warum ein sauberer Startzustand wichtig ist

Die Anwendung kann UI-Zustand behalten.
Wenn aus einem frueheren Test noch ein anderes Register markiert ist, kann der Test falsche Ergebnisse sehen.

Darum erzwingen die Suiten vor jedem Lauf:

- frische Navigation zur Registerauswahl
- Rueckkehr in die Grid-Ansicht
- leeren Auswahlzustand

Das macht die Tests stabiler.

## Variante 2: API-basierte Pruefung mit JSON

Die API-Variante will weniger das sichtbare Layout pruefen und mehr den fachlichen Dateninhalt.
Sie nutzt den Moment, in dem der Dialog die persoenlichen Daten anfordert.

Wichtig ist dabei:

- die Anwendung bekommt Registerdaten nicht direkt als fertigen Klartext
- die Antwort wird im Browser verarbeitet und entschluesselt
- die Suite haengt sich an diesen Ablauf an

Die JSON-Fixtures speichern danach zwei Sichten:

- `<tag>.json`: aufbereitete, gut vergleichbare Nutzdaten
- `<tag>_raw.json`: rohe, entschluesselte XML-Nutzlast als Nachweis

## Rolle von `ts_04b`

`ts_05_register_selection_bva_ui_api.robot` ist der kontrollierte Einstieg in die API-Pruefung.
Die Suite nimmt genau einen festen Fall, naemlich BVA.

Das ist sinnvoll, weil man den neuen API-Ansatz erst an einem bekannten Register absichert:

- derselbe fachliche Workflow wie in `ts_04`
- dazu ein zusaetzlicher API-Vergleich gegen `bva.json`
- eigener `first-run-api`-Test zum erstmaligen Erzeugen der Referenz

Damit ist `ts_04b` die Bruecke zwischen festem Einzeltest und spaeterer Generalisierung.

## Rolle von `ts_05b`

`ts_07_register_cards_generic_api_test.robot` macht aus dem BVA-Muster einen wiederverwendbaren Standard.
Die Suite arbeitet nicht mehr nur mit BVA, sondern mit beliebigen Registern, solange es eine JSON-Fixture gibt.

Aktuell sind enthalten:

- `bva.json`
- `dguv.json`

Fuer jedes Register gibt es zwei Arten von Testfaellen:

- einen normalen Verifikationstest
- einen `first-run-api`-Test zum Erzeugen oder Aktualisieren der JSON-Dateien

## Warum volatile Felder ausgespart werden

API-Responses enthalten oft Werte, die sich bei jedem Lauf aendern.
Zum Beispiel:

- Tokens
- Zeitstempel
- technische IDs

Wenn man diese Felder 1:1 vergleichen wuerde, waeren die Tests unnoetig instabil.
Darum schliesst die API-Vergleichslogik bekannte volatile Felder beim Vergleich aus.

Ziel ist nicht Bit-fuer-Bit-Gleichheit, sondern fachlich stabile Gleichheit.

## First-Run und First-Run-API

Beide Modi sind absichtlich Opt-in.
Sie laufen also nicht einfach mit, wenn man nur normal testen will.

Dialog-/YAML-First-Run:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 05 Register Cards Generic"
```

API-First-Run:

```bash
robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 05B Register Cards Generic"
```

Optionales Ueberschreiben vorhandener Daten:

- `--profile first-run-force` fuer YAML
- `--profile first-run-api-force` fuer JSON

## Wann welche Suite sinnvoll ist

- `ts_04`: wenn ein fester BVA-End-to-End-Flow mit UI- und PDF-Pruefung gebraucht wird
- `ts_04b`: wenn derselbe BVA-Flow zusaetzlich fachlich ueber die API abgesichert werden soll
- `ts_05`: wenn mehrere Register ueber sichtbare Dialogdaten geprueft werden sollen
- `ts_05b`: wenn mehrere Register fachlich stabil ueber API-Nutzdaten geprueft werden sollen

## Neue Registerkarte aufnehmen

Fuer die dialogbasierte Variante:

1. YAML-Datei unter `test_data/registers/` anlegen.
2. Testfall in `ts_05` anlegen.
3. optionalen `first-run`-Test in `ts_05` anlegen.
4. `first-run` bewusst starten und Ergebnis pruefen.

Fuer die API-basierte Variante:

1. Testfall in `ts_05b` anlegen.
2. `first-run-api`-Test in `ts_05b` anlegen.
3. `first-run-api` bewusst starten.
4. `json` und `raw.json` pruefen und committen.

## Praktische Entscheidung

Wenn das UI-Layout stabil und fachlich ausreichend ist, reicht oft `ts_05`.
Wenn die eigentliche Nutzlast im Mittelpunkt steht und das Layout eher wechseln darf, ist `ts_05b` robuster.

Darum existieren beide Linien nebeneinander.

- First-Run ausfuehren
- YAML kurz lesen
- falls noetig die Felder klar und fachlich sauber korrigieren

## Typische Befehle

Normaler Lauf:

```bash
robotcode --profile default robot --by-longname "Ui.Ts 05 Register Cards Generic"
```

Nur ein normaler Testfall:

```bash
robotcode --profile default robot --test "Verify Register Card Workflow: Test BVA"
```

Expliziter First-Run:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 05 Register Cards Generic"
```

Expliziter First-Run mit Ueberschreiben fertiger Fixtures:

```bash
robotcode --profile default --profile first-run-force robot --by-longname "Ui.Ts 05 Register Cards Generic"
```

## Kurzfassung

Die Registerkarten-Tests arbeiten heute so:

- normale Tests pruefen gegen YAML-Fixtures
- First-Run erzeugt oder aktualisiert Fixtures
- First-Run ist bewusst opt-in
- unvollstaendige Fixtures werden im First-Run automatisch neu erzeugt
- bereits fertige Fixtures werden nur mit Force-Regenerate ersetzt
- Auswahl und Dialogoeffnung sind auf die richtige Registerkarte gebunden
- Schluessel und Werte werden strenger und fachlich sauberer geprueft

## Verwandte Doku

- `README_Tests_Overview_DE.md`
- `README_Tests_UI_Overview_DE.md`
- `LogicRegisterTests.md`

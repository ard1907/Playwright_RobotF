# Logik der Registerkarten-Tests

Dieses Dokument erklärt die Logik der Registerkarten-Tests in einfacher Sprache.
Es ist gleichzeitig Doku und Anleitung.

## Worum geht es?

Im Datenschutzcockpit gibt es Registerkarten.
Eine Registerkarte steht fuer ein Register, zum Beispiel `Test BVA` oder `Test-DGUV`.

Die Tests sollen pruefen:

- Kann die Registerkarte ausgewaehlt werden?
- Kommt man auf die Ergebnisseite?
- Kann der richtige Ergebnis-Eintrag geoeffnet werden?
- Kann der Protokolldaten-Dialog geoeffnet werden?
- Werden die erwarteten Daten im Dialog angezeigt?

Es gibt dafuer zwei Arten von Tests:

- spezifische Tests fuer einen festen Fall, zum Beispiel BVA
- generische Tests fuer mehrere Registerkarten ueber YAML-Dateien

Die generische Suite ist `tests/ui/ts_05_smoke_test_register_cards_generic.robot`.

## Welche Dateien gehoeren zusammen?

Die wichtigste Logik liegt in diesen Dateien:

- `tests/ui/ts_05_smoke_test_register_cards_generic.robot`
- `pages/dsc_register_result_page.robot`
- `pages/dsc_register_selection_page.robot`
- `resources/dsc_shared_keywords.robot`
- `resources/libraries/dsc_register_fixture_library.py`
- `test_data/registers/*.yaml`

Kurz gesagt:

- die Suite startet die Testfaelle
- die Page-Objects klicken durch die Oberflaeche
- die Python-Library liest und schreibt YAML-Fixtures
- die YAML-Dateien enthalten die erwarteten Daten pro Registerkarte

## Grundidee der generischen Suite

Die generische Suite soll nicht fuer jede neue Registerkarte komplett neu gebaut werden.
Stattdessen bekommt jede Registerkarte:

- eine YAML-Datei in `test_data/registers/`
- einen normalen Verifikationstest
- optional einen First-Run-Test zum Erzeugen oder Aktualisieren der YAML-Daten

Beispiel:

- `bva.yaml`
- `dguv.yaml`

## Der normale Lauf

Der normale Lauf ist fuer den Alltag gedacht.
Er vergleicht Live-Daten aus dem Dialog mit den erwarteten Daten aus der YAML-Datei.

Beispiel:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Dabei passiert fuer jede Registerkarte grob dies:

1. Die YAML-Datei wird geladen.
2. Es wird geprueft, ob `first_run.completed` auf `true` steht.
3. Wenn nicht, wird der Test sauber uebersprungen.
4. Die Suite navigiert zur Registerauswahl.
5. Die Auswahl wird zuerst in einen leeren, sauberen Zustand gebracht.
6. Die gewuenschte Registerkarte wird angeklickt.
7. `Anfrage starten` wird geklickt.
8. Auf der Ergebnisseite wird genau der Ergebnis-Eintrag dieser Registerkarte gesucht.
9. Genau dieser Eintrag wird aufgeklappt.
10. Genau der erste Protokolldaten-Button innerhalb dieses Eintrags wird geoeffnet.
11. Die persoenlichen Daten werden abgefragt.
12. Sender und Datenfelder werden geprueft.

## Warum wird die Auswahl vorher geleert?

Das Cockpit kann Zustand behalten.
Zum Beispiel kann aus einem vorherigen Test noch eine andere Registerkarte markiert sein.

Wenn das passiert, wuerde der generische Test vielleicht:

- mehrere Register gleichzeitig abschicken
- den falschen Ergebnis-Eintrag sehen
- den falschen Dialog oeffnen

Darum wird vor der Auswahl jetzt bewusst aufgeraeumt:

- auf Grid-Ansicht schalten
- leeren Auswahlzustand herstellen
- erst dann die Ziel-Registerkarte waehlen

Das macht den Test stabiler.

## Die YAML-Fixtures

Jede YAML-Datei beschreibt eine Registerkarte.

Beispielhafter Aufbau:

```yaml
register:
  name: Test BVA
  tag: bva
first_run:
  completed: true
  captured_at: '2026-04-29T10:15:51'
dialog:
  sender: Bundesverwaltungsamt, Registermodernisierungsbehoerde
  assert_sender: true
  data_fields:
    - key: Identifikationsnummer
      value: '08214967384'
      assert_value: true
pdf:
  verify: false
```

Wichtige Felder:

- `register.name`: exakter Name der Registerkarte im UI
- `register.tag`: kurzer technischer Name
- `first_run.completed`: wurde das Fixture schon erfolgreich befuellt?
- `dialog.sender`: erwarteter Sendertext
- `dialog.data_fields`: erwartete Felder im Dialog

## Wie funktioniert die Feld-Pruefung?

Frueher wurde nur geprueft:

- kommt der Schluesseltext irgendwo vor?
- kommt der Werttext irgendwo vor?

Das war zu schwach.
Ein Wert konnte zum falschen Schluessel gehoeren und der Test waere trotzdem gruen gewesen.

Jetzt ist die Logik strenger.

Es gibt zwei Ebenen:

1. Primaer wird der gesamte sichtbare Dialogtext normalisiert.
2. Darin wird geprueft, ob Schluessel und Wert in der richtigen Reihenfolge vorkommen.

Falls die DOM-Struktur ungewoehnlich ist, gibt es einen Fallback:

- JavaScript liest strukturierte Feldpaare aus dem Dialog
- diese Paare werden dann zusaetzlich fuer die Pruefung genutzt

Dadurch bleibt die Pruefung robust, aber fachlich strenger als vorher.

## Was ist der First-Run?

Der First-Run ist ein besonderer Modus.
Er ist nicht fuer jeden normalen Testlauf gedacht.

Der First-Run macht dies:

1. Er navigiert wie der normale Test bis in den Protokolldaten-Dialog.
2. Er liest Sender und Datenfelder aus dem Live-Dialog.
3. Er schreibt diese Daten in eine YAML-Datei.

Das ist praktisch, wenn:

- eine neue Registerkarte dazukommt
- eine YAML-Datei noch leer ist
- sich echte Dialogdaten geaendert haben

## Wichtige Regel: First-Run ist jetzt Opt-in

Der First-Run startet nicht mehr einfach so im normalen Suite-Lauf.

Das ist Absicht.

Frueher war das Risiko da, dass First-Run-Tests aus Versehen mitlaufen.
Dann wurden Daten capture- oder Schreiblogik ausgefuehrt, obwohl man nur normal pruefen wollte.

Jetzt gilt:

- normales `robot tests/ui/ts_05_smoke_test_register_cards_generic.robot` startet keinen echten First-Run
- First-Run-Tests laufen nur mit expliziter Freigabe

Der notwendige Befehl ist:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Beides ist wichtig:

- `--include first-run`
- `--variable ENABLE_FIRST_RUN_TESTS:True`

Nur das Tag alleine reicht bewusst nicht.

## Was passiert bei unvollstaendigen Fixtures?

Ein Fixture kann existieren, aber noch nicht fertig sein.

Beispiel:

- Datei ist schon da
- `first_run.completed` ist aber `false`

Frueher war das problematisch.
Die Logik hat nur geprueft, ob die Datei existiert.
Dann wurde das Schreiben uebersprungen, obwohl die Datei noch gar nicht fertig war.

Jetzt gilt:

- existiert das Fixture nicht: es wird neu geschrieben
- existiert es und ist unvollstaendig: es wird im First-Run neu erzeugt
- existiert es und ist abgeschlossen: es wird nur mit Force-Regenerate ueberschrieben

## Force-Regenerate

Wenn ein bereits fertiges Fixture bewusst neu geschrieben werden soll, nutze:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Das ist sinnvoll, wenn sich echte Dialogdaten geaendert haben und die vorhandene YAML bewusst ersetzt werden soll.

## Neue Registerkarte hinzufuegen

Wenn eine neue Registerkarte getestet werden soll, gehe so vor:

1. Neue YAML-Datei in `test_data/registers/` anlegen.
2. Dort Name und Tag der Registerkarte eintragen.
3. In `ts_05_smoke_test_register_cards_generic.robot` einen normalen Verifikationstest anlegen.
4. Dort auch einen First-Run-Test anlegen.
5. Den First-Run bewusst starten.
6. Das erzeugte YAML pruefen.
7. Bei Bedarf das YAML manuell sauber nachziehen.
8. Danach den normalen Lauf starten.

## Warum muss man YAML manchmal manuell pruefen?

Nicht jeder Dialog ist im DOM gleich aufgebaut.
Manche Dialoge sind sauber strukturiert.
Andere ziehen mehrere Texte zusammen.

Darum kann ein automatisch erzeugtes Fixture manchmal noch Nacharbeit brauchen.

Typische Faelle:

- ein Abschnittstitel haengt am Schluessel
- ein Wert ist mit dem Schluessel zusammengerutscht
- die Reihenfolge ist technisch korrekt, aber fachlich schwer lesbar

Die Empfehlung ist deshalb:

- First-Run ausfuehren
- YAML kurz lesen
- falls noetig die Felder klar und fachlich sauber korrigieren

## Typische Befehle

Normaler Lauf:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Nur ein normaler Testfall:

```bash
robot --test "Verify Register Card Workflow: Test BVA" tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Expliziter First-Run:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Expliziter First-Run mit Ueberschreiben fertiger Fixtures:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
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
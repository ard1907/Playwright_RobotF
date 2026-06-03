# TA Crypt Intercept Keywords

Dieses Verzeichnis enthaelt ein portables Robot-Framework-Keyword fuer das externe TA-Repository. Es ist bewusst keine vollstaendige TA-Suite in diesem Monorepo, sondern ein uebernehmbarer Baustein.

## Ziel

Die Crypt-Keywords fangen verschluesselte DSC API-Antworten im Browser ab und geben den im Browser entschluesselten Klartext als Robot-kompatibles Dictionary zurueck.

Der Ansatz ist durch den QS-Capture belegt: Die DSC-SPA entschluesselt Registerantworten im Browser ueber `window.crypto.subtle.decrypt` mit `AES-GCM`. Der Hook sieht Klartexte wie:

- `antwortStatus`
- `antwortListeProtokolldaten`
- `antwortInhaltsdaten`

Die Keyword-Namen orientieren sich an BrowserLibrary und ergaenzen die fachliche Aktion um `Crypt`.

## Dateien

- `resources/InterceptCryptLibrary.py` - portable Python Robot Library
- `examples/interceptcrypt_smoke.robot` - minimales Nutzungsbeispiel

## Voraussetzungen im externen TA-Repo

- Robot Framework
- robotframework-browser / BrowserLibrary
- Eine aktive BrowserLibrary-Seite, auf der die DSC-SPA geladen ist
- Der Hook muss vor der UI-Aktion installiert werden, die den verschluesselten API-Call ausloest

## Installation im externen TA-Repo

Kopiere die Library in das TA-Repo, zum Beispiel:

```text
resources/InterceptCryptLibrary.py
```

Import in einer Robot Suite:

```robot
*** Settings ***
Library    Browser
Library    resources/InterceptCryptLibrary.py
```

## Nutzung

```robot
*** Test Cases ***
Registerdaten entschluesselt abfangen
    New Page    https://qs-datenschutzcockpit.dsc.govkg.de/spa/

    # Login und Navigation erfolgen wie in der bestehenden TA-Suite.
    # Wichtig: Hook vor der ausloesenden UI-Aktion installieren.
    Start Crypt Intercept    **/api/register-data/load-data

    # Beispiel: Aktion ausloesen, die Registerdaten anfragt.
    Click    [data-testid="anfrageStartenBtn"]

    ${response}=    Wait For Crypt Response    matcher=**/api/register-data/load-data    timeout=120s    expected_text=antwortListeProtokolldaten
    Should Be Equal    ${response}[algorithm]    AES-GCM
    Should Contain    ${response}[plaintext_xml]    antwortListeProtokolldaten
```

Asynchron wie bei BrowserLibrary `Wait For Response`:

```robot
${promise}=    Promise To    Wait For Crypt Response    matcher=**/api/register-data/load-data    timeout=120s    expected_text=antwortListeProtokolldaten
Click         [data-testid="anfrageStartenBtn"]
${response}=  Wait For    ${promise}
```

## Keywords

### `Start Crypt Intercept`

```robot
Start Crypt Intercept    ${matcher}
```

Installiert im aktuellen Browser-Page-Kontext:

- einen Hook auf `window.fetch`, um passende API-Responses zu sammeln
- einen Hook auf `window.crypto.subtle.decrypt`, um Klartext nach Browser-Entschluesselung zu sammeln

`matcher` filtert Fetch-URLs. Die Syntax ist bewusst an BrowserLibrary `Wait For Response` angelehnt:

- leerer Matcher: sammelt alle Fetch-Responses
- Klartext: Substring-Match, z. B. `/api/register-data/load-data`
- Glob: z. B. `**/api/register-data/load-data`
- Slash-RegExp: z. B. `/register-data\/load-data/i`

### `Wait For Crypt Response`

```robot
${response}=    Wait For Crypt Response    matcher=**/api/register-data/load-data    timeout=120s    expected_text=antwortListeProtokolldaten
```

Wartet, bis sowohl eine passende Fetch-Response als auch mindestens ein Decrypt-Event vorliegt. Optional filtert `expected_text` den Klartext.

Rueckgabe ist ein Dictionary mit u. a.:

```text
matcher
url
method
status
content_type
encrypted_response_body
algorithm
key_type
key_algorithm
plaintext_xml
plaintext_json
decrypt_events
errors
```

### `Get Crypt Events`

Gibt den aktuellen Rohzustand des Browser-Hooks zurueck. Nuetzlich fuer Debugging.

### `Clear Crypt Events`

Leert gesammelte Events, laesst den Hook aber installiert.

## Hinweise zum Timing

Der Hook sieht nur Entschluesselungen, die nach seiner Installation passieren. Deshalb:

1. Seite oeffnen und Login/Navigation bis kurz vor die fachliche Aktion ausfuehren.
2. `Start Crypt Intercept` ausfuehren.
3. UI-Aktion klicken, die den API-Endpunkt triggert.
4. `Wait For Crypt Response` aufrufen.

## Grenzen

- Das Keyword entschluesselt nicht offline aus einem rohen API-Capture.
- Es nutzt die legitime Browser-Session und den Schluessel, den die SPA ohnehin besitzt.
- Wenn eine Umgebung keine Daten liefert, kann es nur Statusdaten oder kein passendes Decrypt-Event geben.
- Bei mehreren parallelen verschluesselten Antworten sollte `expected_text` gesetzt werden, um das richtige Decrypt-Event zu matchen.

## Sicherheit

Die Rueckgabe enthaelt entschluesselte Testdaten. Schreibe `plaintext_xml`, `plaintext_json` oder volle Keyword-Rueckgaben nicht unkontrolliert in CI-Logs oder Git-Artefakte.

Empfehlung fuer das externe TA-Repo:

```text
artifacts/interceptcrypt/
*.interceptcrypt.json
```

in `.gitignore` aufnehmen.

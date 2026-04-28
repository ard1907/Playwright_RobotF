# ==============================================================================
# variables.robot
# Shared variables for the Datenschutzcockpit SPA smoke test suite.
# All page-specific selectors live in their respective page object files.
# ==============================================================================

*** Variables ***

# ── Base Configuration ─────────────────────────────────────────────────────────
${CI}                      ${False}
${CI_SELF_HOSTED}          ${False}
${BASE_URL}                https://qs-datenschutzcockpit.dsc.govkg.de/spa/
# ${BASE_URL}                https://datenschutzcockpit.bund.de/spa/       #ARD: Remove for real DSC Repo.
${BROWSER}                 chromium
${HEADLESS}                ${False}
${CHROMIUM_EXECUTABLE}     %{CHROMIUM_EXECUTABLE=}
${TIMEOUT}                 10s
${SLOW_MOTION}             0:00:00.500
${WIDTH}                   1920
${HEIGHT}                  1080

# ── Landing Page Expected Page Titles ──────────────────────────────────────────
# Used by "Verify Page Title Contains" to assert SPA route changes.
${TITLE_BASE}              Datenschutzcockpit
# ${TITLE_LANDING}           Datenschutzcockpit - Startseite
${TITLE_LANDING}           Datenschutzcockpit
${TITLE_FAQ}               FAQ
${TITLE_IMPRESSUM}         Impressum
${TITLE_DATENSCHUTZ}       Datenschutzerklärung
${TITLE_BARRIEREFREIHEIT}  Barrierefreiheit

# ── Authentication Info / Login Page Expected Page Titles ──────────────────────
${AUTH_INFO_URL}            ${BASE_URL}authentication-info
${TITLE_AUTH_INFO}          Datenschutzcockpit - Anmeldung
${TITLE_LEICHTE_SPRACHE}    Datenschutzcockpit - Leichte Sprache
${TITLE_GEBAERDENSPRACHE}   Datenschutzcockpit - Gebärdensprache

# ── Register Auswahl Page Expected Page Titles ─────────────────────────────────
${REGISTER_AUSWAHL_URL}     ${BASE_URL}cockpit/register-auswahl
${TITLE_REGISTER_AUSWAHL}   Datenschutzcockpit - Registerauswahl

# ── Datenabfrage / Datenansicht Page ──────────────────────────────────────────
${DATENABFRAGE_URL}         ${BASE_URL}cockpit/datenabfrage
${TITLE_DATENABFRAGE}       Datenschutzcockpit - Ergebnisse
${TITLE_DATENANSICHT}       Datenschutzcockpit - Datenansicht

# AusweisApp SDK URL (override via env in CI or compose):
# Set environment variable AUSWEISAPP_URL to e.g. http://ausweisapp-sdk:24727
${AUSWEISAPP_URL}          %{AUSWEISAPP_URL=http://localhost:24727}

# ── App Version ───────────────────────────────────────────────────────────────
${APP_VERSION}              2.17.8

# ── External Links ────────────────────────────────────────────────────────────
${ASWAPP_DWLD_TITLE}         AusweisApp: Download der AusweisApp
${ASWAPP_DWLD_URL}           https://www.ausweisapp.bund.de/download
${ASWAPP_DWLD_H1}            //h1[text()="AusweisApp herunterladen"]
${ASWAPP_DEVICES_TITLE}      AusweisApp: Kartenleser für die Online-Ausweisfunktion
${ASWAPP_DEVICES_URL}        https://www.ausweisapp.bund.de/kompatible-geraete
${ASWAPP_DEVICES_H1}         //h1[text()="Kompatible Geräte"]
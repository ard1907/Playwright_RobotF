# ==============================================================================
# variables.robot
# Shared variables for the Datenschutzcockpit SPA smoke test suite.
# All page-specific selectors live in their respective page object files.
# ==============================================================================

*** Variables ***

# ── Base Configuration ─────────────────────────────────────────────────────────
${CI}                      ${False}
${CI_SELF_HOSTED}          ${False}
${BASE_URL}                https://datenschutzcockpit.dsc.govkg.de/spa/
# ${BASE_URL}                https://datenschutzcockpit.bund.de/spa/       #ARD: Remove for real DSC Repo.
${BROWSER}                 chromium
${HEADLESS}                ${False}
${TIMEOUT}                 10s
${SLOW_MOTION}             0:00:00.500
${WIDTH}                   1920
${HEIGHT}                  1080

# ── Expected Page Titles ───────────────────────────────────────────────────────
# Used by "Verify Page Title Contains" to assert SPA route changes.
${TITLE_BASE}              Datenschutzcockpit
# ${TITLE_LANDING}           Datenschutzcockpit - Startseite
${TITLE_LANDING}           Datenschutzcockpit
${TITLE_FAQ}               FAQ
${TITLE_IMPRESSUM}         Impressum
${TITLE_DATENSCHUTZ}       Datenschutzerklärung
${TITLE_BARRIEREFREIHEIT}  Barrierefreiheit

# ── Authentication Info / Login Page ──────────────────────────────────────────
${AUTH_INFO_URL}            ${BASE_URL}authentication-info
${TITLE_AUTH_INFO}          Datenschutzcockpit - Anmeldung
${TITLE_LEICHTE_SPRACHE}    Datenschutzcockpit - Leichte Sprache
${TITLE_GEBAERDENSPRACHE}   Datenschutzcockpit - Gebärdensprache

# ── External Links ────────────────────────────────────────────────────────────
${ASWAPP_DWLD_TITLE}         AusweisApp: Download der AusweisApp
${ASWAPP_DWLD_URL}           https://www.ausweisapp.bund.de/download
${ASWAPP_DWLD_H1}            //h1[text()="AusweisApp herunterladen"]
${ASWAPP_DEVICES_TITLE}      AusweisApp: Kartenleser für die Online-Ausweisfunktion
${ASWAPP_DEVICES_URL}        https://www.ausweisapp.bund.de/kompatible-geraete
${ASWAPP_DEVICES_H1}         //h1[text()="Kompatible Geräte"]
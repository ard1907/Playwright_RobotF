# ==============================================================================
# variables.robot
# Shared variables for the Datenschutzcockpit SPA smoke test suite.
# All page-specific selectors live in their respective page object files.
# ==============================================================================

*** Variables ***

# ── Base Configuration ─────────────────────────────────────────────────────────
${CI}                      ${False}
${BASE_URL}                https://datenschutzcockpit.dsc.govkg.de/spa/
${BROWSER}                 chromium
${HEADLESS}                ${FALSE}
${TIMEOUT}                 15s
${SLOW_MOTION}             0:00:01.500
${WIDTH}                   1920
${HEIGHT}                  1080

# ── Expected Page Titles ───────────────────────────────────────────────────────
# Used by "Verify Page Title Contains" to assert SPA route changes.
${TITLE_BASE}              Datenschutzcockpit
${TITLE_LANDING}           Datenschutzcockpit
${TITLE_FAQ}               FAQ
${TITLE_IMPRESSUM}         Impressum
${TITLE_DATENSCHUTZ}       Datenschutzerklärung
${TITLE_BARRIEREFREIHEIT}  Barrierefreiheit

# ── Authentication Info / Login Page ──────────────────────────────────────────
${AUTH_INFO_URL}            ${BASE_URL}authentication-info
${TITLE_AUTH_INFO}          Datenschutzcockpit
${TITLE_LEICHTE_SPRACHE}    Datenschutzcockpit - Leichte Sprache
${TITLE_GEBAERDENSPRACHE}   Datenschutzcockpit - Gebärdensprache

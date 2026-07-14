#!/usr/bin/env sh
set -eu

RESULTS_DIR="${ROBOT_OUTPUTDIR:-/app/results2}"
mkdir -p "${RESULTS_DIR}"

if [ "$#" -gt 0 ]; then
    echo "Running explicit command: robotcode $*"
    exec robotcode "$@"
fi

set -- robotcode

PROFILES_RAW="${ROBOT_PROFILES:-default}"
OLD_IFS=$IFS
IFS=', '
set -f
for profile in ${PROFILES_RAW}; do
    [ -n "${profile}" ] || continue
    set -- "$@" --profile "${profile}"
done
set +f
IFS=$OLD_IFS

set -- "$@" robot \
    --outputdir "${RESULTS_DIR}" \
    --report "${RESULTS_DIR}/report.html" \
    --log "${RESULTS_DIR}/log.html" \
    --xunit "${RESULTS_DIR}/xunit.xml"

set -- "$@" \
    --variable "BASE_URL:${BASE_URL:-https://qs-datenschutzcockpit.dsc.govkg.de/spa/}" \
    --variable "BROWSER:${BROWSER:-chromium}" \
    --variable "HEADLESS:${HEADLESS:-True}" \
    --variable "CI:${CI:-True}" \
    --variable "CI_SELF_HOSTED:${CI_SELF_HOSTED:-True}" \
    --variable "AUSWEISAPP_URL:${AUSWEISAPP_URL:-http://127.0.0.1:24727}" \
    --variable "CHROMIUM_EXECUTABLE:${CHROMIUM_EXECUTABLE:-/usr/bin/chromium}"

if [ -n "${ROBOT_BY_LONGNAME:-}" ]; then
    set -- "$@" --by-longname "${ROBOT_BY_LONGNAME}"
fi

if [ -n "${ROBOT_INCLUDE:-}" ]; then
    set -- "$@" -i "${ROBOT_INCLUDE}"
fi

if [ -n "${ROBOT_EXCLUDE:-}" ]; then
    set -- "$@" -e "${ROBOT_EXCLUDE}"
fi

if [ -n "${ROBOT_EXTRA_ARGS:-}" ]; then
    # Intentional shell splitting for raw Robot Framework CLI arguments.
    # shellcheck disable=SC2086
    set -- "$@" ${ROBOT_EXTRA_ARGS}
fi

echo "Running default command: $*"
exec "$@"

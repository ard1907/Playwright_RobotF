#!/usr/bin/env bash
# get-results.sh
# Kopiert die Robot Framework Testergebnisse aus dem laufenden Runner-Container
# in den lokalen Ordner "results2" (relativ zum Repo-Root).
# Voraussetzung: Runner-Container "github-runner" läuft.
# Ausführen: aus dem Workspace-Root-Verzeichnis:
#   ./scripts/get-results.sh

containerName="github-runner"
containerPath="/tmp/runner/work/Playwright_RobotF/Playwright_RobotF/results2/."
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
localPath="$scriptDir/../results2"

# Zielordner sicherstellen
mkdir -p "$localPath"

# Prüfen, ob der Container läuft
running=$(docker inspect --format '{{.State.Running}}' "$containerName" 2>/dev/null || true)
if [ "$running" != "true" ]; then
  echo "Container '$containerName' läuft nicht. Bitte zuerst starten: docker compose -f docker2/docker-compose.runner.yml up -d" >&2
  exit 1
fi

echo "Kopiere Ergebnisse aus Container '$containerName' ..."
docker cp "${containerName}:${containerPath}" "$localPath"
rc=$?
if [ $rc -eq 0 ]; then
  echo "Ergebnisse erfolgreich in '$localPath' kopiert."
  echo
  printf "%-40s %-20s %10s\n" "Name" "LastWriteTime" "Größe"
  shopt -s nullglob
  for f in "$localPath"/*; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    if mtime=$(stat -c '%y' "$f" 2>/dev/null); then
      mtime="${mtime%%.*}"
    else
      mtime=$(stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' "$f" 2>/dev/null || printf '%s' "")
    fi
    size_bytes=$(stat -c '%s' "$f" 2>/dev/null || stat -f '%z' "$f" 2>/dev/null || echo 0)
    size_kb=$(( (size_bytes + 1023) / 1024 ))
    printf "%-40s %-20s %10s\n" "$name" "$mtime" "${size_kb} KB"
  done
else
  echo "Fehler beim Kopieren. Sind bereits Ergebnisse im Container vorhanden?" >&2
  exit 1
fi

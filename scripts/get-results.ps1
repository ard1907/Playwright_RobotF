# get-results.ps1
# Kopiert die Robot Framework Testergebnisse aus dem laufenden Runner-Container
# in den lokalen Windows-Ordner "results2".
#
# Voraussetzung: Runner-Container "github-runner" läuft (docker compose -f docker2/docker-compose.runner.yml up -d).
# Ausführen: aus dem Workspace-Root-Verzeichnis:
#   .\scripts\get-results.ps1

$containerName = "github-runner"
$containerPath = "/tmp/runner/work/Playwright_RobotF/Playwright_RobotF/results2/."
$localPath     = "$PSScriptRoot\..\results2"

# Zielordner sicherstellen
if (-not (Test-Path $localPath)) {
    New-Item -ItemType Directory -Path $localPath | Out-Null
}

# Prüfen, ob der Container läuft
$running = docker inspect --format "{{.State.Running}}" $containerName 2>$null
if ($running -ne "true") {
    Write-Error "Container '$containerName' läuft nicht. Bitte zuerst starten: docker compose -f docker2/docker-compose.runner.yml up -d"
    exit 1
}

Write-Host "Kopiere Ergebnisse aus Container '$containerName' ..."
docker cp "${containerName}:${containerPath}" $localPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "Ergebnisse erfolgreich in '$localPath' kopiert."
    Write-Host ""
    Get-ChildItem -Path $localPath -File | Select-Object Name, LastWriteTime, @{N="Größe";E={"{0:N0} KB" -f ($_.Length / 1KB)}} | Format-Table -AutoSize
} else {
    Write-Error "Fehler beim Kopieren. Sind bereits Ergebnisse im Container vorhanden?"
    exit 1
}

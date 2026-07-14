param(
    [string]$ComposeFile = "docker/test-runtime/docker-compose.yml",
    [string]$ArchivePath = "docker/test-runtime/test-runtime-images.tar",
    [switch]$BuildFirst
)

$ErrorActionPreference = "Stop"

if ($BuildFirst) {
    docker compose -f $ComposeFile build
}

$images = @(
    "test-runtime-robot-runtime:latest",
    "test-runtime-ausweisapp-sdk:latest"
)

foreach ($image in $images) {
    docker image inspect $image | Out-Null
}

docker image save --output $ArchivePath $images
Write-Host "Exported runtime images to $ArchivePath"

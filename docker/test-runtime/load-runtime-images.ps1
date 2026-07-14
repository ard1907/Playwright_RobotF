param(
    [string]$ArchivePath = "docker/test-runtime/test-runtime-images.tar"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ArchivePath)) {
    throw "Archive not found: $ArchivePath"
}

docker load --input $ArchivePath
Write-Host "Loaded runtime images from $ArchivePath"

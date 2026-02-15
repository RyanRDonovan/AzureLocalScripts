$guardianName = "UntrustedGuardian"

$guardian = Get-HgsGuardian -Name $guardianName -ErrorAction SilentlyContinue

if ($null -eq $guardian) {
    Write-Host "Guardian '$guardianName' not found. Creating..."
    New-HgsGuardian -Name $guardianName -GenerateCertificates
    Write-Host "Guardian '$guardianName' created successfully."
} else {
    Write-Host "Guardian '$guardianName' already exists."
}

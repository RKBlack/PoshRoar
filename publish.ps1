param (
    [string] $version,
    [string] $preReleaseTag,
    [string] $apiKey
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Now replace version in psd1
$fileContent = Get-Content "$scriptPath\PoshRoar.psd1.source"
$fileContent = $fileContent -replace '{{version}}', $version
$fileContent = $fileContent -replace '{{preReleaseTag}}', $preReleaseTag 
$fileContent = $fileContent -replace '{{CommitDate}}', $(Get-Date -Format 'yyyy-MM-dd')
Set-Content "$scriptPath\PoshRoar\PoshRoar.psd1" -Value $fileContent -Force
"`r"
Get-Content "$scriptPath\PoshRoar\PoshRoar.psd1"
"`r"

Write-Output 'About to publish module'
$PublishParams = @{
    Path        = "$scriptPath\PoshRoar" 
    NuGetApiKey = $apiKey
    ProjectUri  = 'https://github.com/RKBlack/PoshRoar'
    LicenseUri  = 'https://github.com/RKBlack/PoshRoar/blob/main/LICENSE'
}
Write-Host "Path $($PublishParams.Path)"
Get-ChildItem $PublishParams.Path
Write-Host "ProjectUri $($PublishParams.ProjectUri)"
Write-Host "LicenseUri $($PublishParams.LicenseUri)"

Publish-Module @PublishParams -Force -Verbose

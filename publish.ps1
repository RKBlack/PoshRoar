param (
    [string] $version,
    [string] $preReleaseTag,
    [string] $apiKey
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Now replace version in psd1
$fileContent = Get-Content "$scriptPath\PoshRoar.psd1.source"
$fileContent = $fileContent -replace '{{version}}', $version
$fileContent = $fileContent -replace '{{CommitDate}}', $(Get-Date -Format 'yyyy-MM-dd')
Set-Content "$scriptPath\PoshRoar\PoshRoar.psd1" -Value $fileContent -Force

Write-Output 'Publishing module'
$PublishParams = @{
    Path        = "$scriptPath\PoshRoar" 
    NuGetApiKey = $apiKey
    ProjectUri  = 'https://github.com/RKBlack/PoshRoar'
    LicenseUri  = 'https://github.com/RKBlack/PoshRoar/blob/main/LICENSE'
}

Publish-Module @PublishParams -Force -Verbose

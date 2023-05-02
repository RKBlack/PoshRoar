param (
    [string] $version,
    [string] $preReleaseTag,
    [string] $apiKey
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$srcPath = "$scriptPath\src";
Write-Host "Proceeding to publish all code found in $srcPath"

$outFile = "$scriptPath\Publish\PoshRoar.psm1"
if (Test-Path $outFile) {
    Remove-Item $outFile
}

if (!(Test-Path "$scriptPath\Publish")) {
    New-Item "$scriptPath\Publish" -ItemType Directory
}

$ScriptFunctions = @( Get-ChildItem -Path $srcPath\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$ModulePSM = @( Get-ChildItem -Path $srcPath\*.psm1 -ErrorAction SilentlyContinue -Recurse )
foreach ($FilePath in $ScriptFunctions) {
    Write-Host "Combining file $FilePath"
    $Results = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$null, [ref]$null)
    $Functions = $Results.EndBlock.Extent.Text
    $Functions | Add-Content -Path $outFile
}
foreach ($FilePath in $ModulePSM) {
    $Content = Get-Content $FilePath
    $Content | Add-Content -Path $outFile
}
Write-Output "All functions collapsed in single file $outFile"
'Export-ModuleMember -Function * -Cmdlet *' | Add-Content -Path $outFile

# Now replace version in psd1
$fileContent = Get-Content "$scriptPath\src\PoshRoar.psd1.source"
$fileContent = $fileContent -replace '{{version}}', $version
$fileContent = $fileContent -replace '{{preReleaseTag}}', $preReleaseTag 
Set-Content "$scriptPath\Publish\PoshRoar.psd1" -Value $fileContent -Force
"`r"
Get-Content "$scriptPath\Publish\PoshRoar.psd1"
"`r"

Write-Output 'About to publish module'
$PublishParams = @{
    Path        = "$scriptPath\Publish" 
    NuGetApiKey = $apiKey
    ProjectUri  = 'https://github.com/RKBlack/PoshRoar'
    LicenseUri  = 'https://github.com/RKBlack/PoshRoar/blob/main/LICENSE'
    Verbose     = $true
    Force       = $true
}
Publish-Module @PublishParams

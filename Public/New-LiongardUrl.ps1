function New-LiongardUrl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Url
    )
    if ($null -eq $Url) {
        $Url = Read-Host -Prompt 'Enter the Liongard URL'
    }
    $Global:LiongardUrl = $Url
    Write-Verbose $LiongardUrl
}

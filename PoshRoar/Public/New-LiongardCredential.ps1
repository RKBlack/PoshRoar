function New-LiongardCredential {
    [CmdletBinding()]
    $Credential = Get-Credential
    $Global:LiongardCredential = $Credential
    Write-Verbose $LiongardCredential
}

function New-LiongardSession {
    [CmdletBinding()]
    param (
        [switch]$SkipMfa = $false
    )

    $LoginHeaders = @{
        'accept'       = 'application/json'
        'content-type' = 'application/json'
    }
    $LoginBody = @{
        'Username' = "$($LiongardCredential.UserName)"
        'Password' = "$($($LiongardCredential.Password) | ConvertFrom-SecureString -AsPlainText)"
    }
    $LoginParams = @{
        'Uri'         = "$LiongardUrl/api/v1/authentication/login"
        'Method'      = 'POST'
        'Headers'     = $LoginHeaders
        'ContentType' = 'application/json'
        'Body'        = ($LoginBody | ConvertTo-Json)
    }
    $LoginResponse = Invoke-WebRequest @LoginParams
    $token = ($LoginResponse.Content | ConvertFrom-Json).Token
    
    if ($SkipMfa) {
        $Global:LiongardSession = $LoginResponse
        ($LiongardSession.Content | ConvertFrom-Json).Account.User | Select-Object Username, LastLogin, MfaFactorAuth
        return
    }

    $MfaToken = Read-Host -Prompt 'Enter the MFA Token'
    $MfaHeaders = @{
        'accept'       = 'application/json'
        'content-type' = 'application/json'
        'X-Auth-Token' = "$($token)"
    }
    $MfaBody = @{
        'Token' = "$MfaToken"
    }
    $MfaParams = @{
        'Uri'         = "$LiongardUrl/api/v1/authentication/verify-token"
        'Method'      = 'POST'
        'Headers'     = $MfaHeaders
        'ContentType' = 'application/json'
        'Body'        = ($MfaBody | ConvertTo-Json)
    }

    $MfaResponse = Invoke-WebRequest @MfaParams
    $Global:LiongardSession = $MfaResponse
    Write-Verbose "$(($LiongardSession.Content | ConvertFrom-Json).Account.User.Username) $(($LiongardSession.Content | ConvertFrom-Json).Account.User.status)"

    Get-LiongardEnvironment
    Get-LiongardMetric
    Get-LiongardSystem
    Get-LiongardInspector
}

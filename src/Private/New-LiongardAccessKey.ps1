function New-LiongardAccessKey {
    [CmdletBinding()]
    $token = ($LiongardSession.Content | ConvertFrom-Json).Token
    $headers = @{
        'accept'       = 'application/json'
        'content-type' = 'application/json'
        'X-Auth-Token' = "$($token)"
    }
    $body = @{
        'daysUntilExpiration' = '30'
        'isAgentInstallKey'   = $false
    }
    $params = @{
        'Uri'         = "$LiongardUrl/api/v1/access-keys"
        'Method'      = 'POST'
        'Headers'     = $headers
        'ContentType' = 'application/json'
        'Body'        = ($body | ConvertTo-Json)
    }
    $LiongardAccessKey = Invoke-WebRequest @params
    $Global:LiongardAccessKeyId = ($LiongardAccessKey.Content | ConvertFrom-Json).AccessKeyId
    $LiongardAccessKeySecret = ($LiongardAccessKey.Content | ConvertFrom-Json).AccessKeySecret
    $Base64Key = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($LiongardAccessKeyId):$($LiongardAccessKeySecret)"))
    $Global:LiongardBase64Key = $Base64Key
    $LiongardBase64Key | Out-Null
    Write-Verbose $LiongardAccessKeyId 
}

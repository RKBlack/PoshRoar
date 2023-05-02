function Remove-LiongardAccessKey {
    [CmdletBinding()]
    $headers = @{
        'accept'         = 'application/json'
        'content-type'   = 'application/json'
        'X-ROAR-API-KEY' = "$($LiongardBase64Key)" 
    }
    $params = @{
        'Uri'         = "$LiongardUrl/api/v1/access-keys/$($LiongardAccessKeyId)"
        'Method'      = 'DELETE'
        'Headers'     = $headers
        'ContentType' = 'application/json'
    }
    $response = Invoke-WebRequest @params
    Write-Verbose $response.Content
}

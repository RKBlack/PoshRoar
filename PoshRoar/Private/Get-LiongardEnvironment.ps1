function Get-LiongardEnvironment {

    begin {
        New-LiongardAccessKey
    }

    process {
        $Url = "$LiongardUrl/api/v2/environments"
        $headers = @{
            'accept'         = 'application/json'
            'X-ROAR-API-KEY' = "$($LiongardBase64Key)" 
        }
        $params = @{
            'Uri'     = "$Url"
            'Method'  = 'GET'
            'Headers' = $headers
        }
        Write-Verbose "$Url"
        $response = Invoke-WebRequest @params
        $Global:LiongardEnvironment = ($response.Content | ConvertFrom-Json).Data
        Write-Verbose "$($LiongardEnvironment.Length) environments found"
    }

    end {
        Remove-LiongardAccessKey
    }
}

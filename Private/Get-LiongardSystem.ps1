function Get-LiongardSystem {

    begin {
        New-LiongardAccessKey
    }

    process {

        $Url = "$LiongardUrl/api/v1/systems"

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
        $Global:LiongardSystem = $response.Content | ConvertFrom-Json
        Write-Verbose "$($LiongardSystem.Length) systems found"
    }

    end {
        Remove-LiongardAccessKey
    }
}

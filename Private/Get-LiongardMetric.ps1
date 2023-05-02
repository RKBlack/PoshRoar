function Get-LiongardMetric {

    begin {
        New-LiongardAccessKey
    }

    process {

        $Url = "$LiongardUrl/api/v1/metrics"

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
        $Global:LiongardMetric = $response.Content | ConvertFrom-Json
        Write-Verbose "$($LiongardMetric.Length) metrics found"
    }
    end {
        Remove-LiongardAccessKey
    }
    
}

function Get-LiongardInspector {

    begin {
        New-LiongardAccessKey
    }

    process {

        $Url = "$LiongardUrl/api/v1/inspectors"

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
        $Global:LiongardInspector = $response.Content | ConvertFrom-Json
        Write-Verbose "$($LiongardInspector.Length) inspectors found"
    }

    end {
        Remove-LiongardAccessKey
    }

}

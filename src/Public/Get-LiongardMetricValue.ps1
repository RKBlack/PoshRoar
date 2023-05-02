function Get-LiongardMetricValue {    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Inspector,
        [Parameter(Mandatory = $false)]
        [string]$systems,
        [Parameter(Mandatory = $false)]
        [string]$uuids
    )

    begin {
        New-LiongardAccessKey
    }

    process {

        if (!$uuids) {
            Write-Verbose "Getting UUIDs for $Inspector"
            $uuids = "$(($LiongardMetric | Where-Object { $_.Inspector.Alias -like $Inspector }).UUID -join ',')"
        }
        if (!$systems) {
            Write-Verbose "Getting Systems for $Inspector"
            $systems = "$(($LiongardSystem | Where-Object { $_.Inspector.Alias -like $Inspector }).ID -join ',')"`
        }

        $Url = "$LiongardUrl/api/v1/metrics/bulk"
        Write-Verbose "Url: $Url"
        Write-Verbose "Systems: $systems"
        Write-Verbose "UUIDs: $uuids"
        $MetricValues = @()
        
        $headers = @{
            'accept'         = 'application/json'
            'X-ROAR-API-KEY' = "$($LiongardBase64Key)" 
        }
        $params = @{
            'Uri'     = "$Url/?systems=$($systems)&uuids=$($uuids)"
            'Method'  = 'GET'
            'Headers' = $headers
        }

        $response = Invoke-WebRequest @params

        foreach ($system in ($systems -split ',')) {
            
            $MetricValueObj = New-Object -TypeName PSObject

            Write-Verbose "System: $system"
            $SystemName = $LiongardSystem | Where-Object { $_.Id -eq $system } | Select-Object -ExpandProperty Name
            $MetricValueObj | Add-Member -MemberType NoteProperty -Name 'Liongard: System Name' -Value $SystemName
            foreach ($uuid in ($uuids -split ',')) {
                Write-Verbose "UUID: $uuid"
                $MetricId = $LiongardMetric | Where-Object { $_.uuid -eq $uuid } | Select-Object -ExpandProperty Id
                Write-Verbose "MetricId: $MetricId"
                Write-Verbose "Name $(((($response.Content | ConvertFrom-Json).$system).$MetricId).Metric.Name)"
                Write-Verbose "Value $(((($response.Content | ConvertFrom-Json).$system).$MetricId).Metric.Value)"
                $AddMemberParams = @{
                    'MemberType' = 'NoteProperty'
                    'Name'       = $(((($response.Content | ConvertFrom-Json).$system).$MetricId).Metric.Name)
                    'Value'      = $(((($response.Content | ConvertFrom-Json).$system).$MetricId).Metric.Value)
                }
                $MetricValueObj | Add-Member @AddMemberParams
            }
            $MetricValues += $MetricValueObj
        }
        $Global:LiongardMetricValues = $MetricValues
        $LiongardMetricValues
    }
    
    end {
        Remove-LiongardAccessKey
    }

}

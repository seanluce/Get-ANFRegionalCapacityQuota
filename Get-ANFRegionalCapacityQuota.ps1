## Supply this information from Service Principal ##
$subId = ""
$tenantId = ""
$appId = ""
$password = ""
####

$bodyJson =  @{
    grant_type = "client_credentials"
    client_id = $appId
    client_secret = $password
    resource = "https://management.azure.com"
}
$getTokenParameters = @{
    Method = "POST"
    Uri = 'https://login.microsoftonline.com/' + $tenantId + '/oauth2/token'
    Body = $bodyJson
}
$bearer = Invoke-RestMethod @getTokenParameters
$token = $bearer.access_token
$Header = @{
    "content-type" = "application/json"
    "authorization" = "Bearer $token"
}
####

## Get and display regional quotas for each region ##
$anfRegions = ('australiacentral', 'australiaeast', 'australiasoutheast', 'brazilsouth', 'canadacentral', 'canadaeast', 'centralindia', 'centralus', 'eastus', 'eastus2', 'francecentral', 'germanynorth', 'germanywestcentral', 'japaneast', 'japanwest', 'koreacentral', 'northcentralus', 'northeurope', 'norwayeast', 'norwaywest', 'southcentralus', 'southindia', 'southeastasia', 'uaenorth', 'uaecentral', 'uksouth', 'ukwest', 'westeurope', 'westus', 'westus2')
$regionTable = @()
''
'################################################################'
'#      Azure NetApp Files Regional Capacity Quota Report       #'
'################################################################'
''
'Created by: Sean Luce, Cloud Solutions Architect, NetApp'
'More info: https://azure.microsoft.com/en-us/updates/azure-netapp-files-regional-capacity-quota/'
''
foreach($region in $anfRegions) {
    $Parameters = @{
        Method = "GET"
        Uri = 'https://management.azure.com/subscriptions/' + $subId + '/providers/Microsoft.NetApp/locations/' + $region + '/quotaLimits?api-version=2021-06-01'
        Header = $header
    }
    try {
        $quotas = Invoke-RestMethod @Parameters
    }
    catch {
        "Unable to get info from " + $region + " region."
    }
    $regionTable += [PSCustomObject]@{
        Region = $region;
        'Default Quota' = $quotas.totalTiBsPerSubscription.default;
        'Current Quota' = $quotas.totalTiBsPerSubscription.current
    }
}
$regionTable
####

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $workspaceName = 'default'
)

#Region Set Constants
$baseUri = "https://management.azure.com/subscriptions/"
$apiVersion = '2023-05-01-preview'
#EndRegion Set Constants

"$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$MasterSentinelName/providers/Microsoft.SecurityInsights/workspaceManagerConfigurations?api-version=$apiVersion""

$reponse = invoke-azRestMethod -Method GET -Uri 'https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/quickstarts/microsoft.operationalinsights/operational-insights-workspace/azuredeploy.json' -ContentType 'application/json'
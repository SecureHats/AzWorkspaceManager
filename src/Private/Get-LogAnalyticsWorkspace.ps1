function Get-LogAnalyticsWorkspace {
    <#
    .SYNOPSIS
    Get the Log Analytics workspace properties
    .DESCRIPTION
    This function is used to get the Log Analytics workspace properties
    .EXAMPLE
    Get-LogAnalyticsWorkspace
    .NOTES
    NAME: Get-LogAnalyticsWorkspace
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [string]$ResourceGroupName
    )

    begin {
        Invoke-AzWorkspaceManager -FunctionName $MyInvocation.MyCommand.Name
    }
    process {
        #Region Set Constants
            $apiVersion = '2022-10-01'
        #EndRegion Set Constants

        if ($ResourceGroupName) {
            Write-Host "Resource Group Name: $ResourceGroupName"
            $uri = "$($SessionVariables.baseUri)/resourcegroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        } else {
            Write-Host "No Resource Group Name specified"
            $uri = "$($SessionVariables.baseUri)/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }
        
        # try {
            Write-Host "Trying to get the Log Analytics workspace [$($Name)]"
            $workspace = (
                 Invoke-RestMethod `
                     -Method GET `
                     -Uri $uri `
                     -Headers $($SessionVariables.authHeader)).value `
                     | Where-Object { $_.name -eq $Name }
            if ($workspace.count -eq 0) {
                Write-Error -Exception "The Resource '/Microsoft.OperationalInsights/workspaces/$($Name)'"
            }
        # } catch {
        #     Write-Error -Exception "An error occured while trying to get the Log Analytics workspace [$($Name)]"
        # }
    }
    end {
        if ($workspace.count -gt 1) {
            Write-Warning -Message "Multiple resource '/Microsoft.OperationalInsights/workspaces/$($Name)' found. Please specify the resourcegroup name"
            break
        } else {
            $SessionVariables.workspace = "https://management.azure.com$($workspace.id)"
        }
    }
}
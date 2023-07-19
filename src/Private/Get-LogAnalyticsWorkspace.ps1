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
        $apiVersion = '2015-11-01-preview'
        #EndRegion Set Constants

        if ($ResourceGroupName) {
            Write-Verbose "Resource Group Name: $ResourceGroupName"
            $uri = "$($SessionVariables.baseUri)/resourcegroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }
        else {
            Write-Verbose "No Resource Group Name specified"
            $uri = "$($SessionVariables.baseUri)/providers/Microsoft.OperationalInsights/workspaces?api-version=$apiVersion"
        }
        
        try {
            Write-Verbose "Trying to get the Microsoft Sentinel workspace [$($Name)]"
            $workspace = (
                Invoke-RestMethod `
                    -Method GET `
                    -Uri $uri `
                    -Headers $($SessionVariables.authHeader)).value `
            | Where-Object { $_.name -eq $Name } `
            -ErrorVariable "ErrVar"
                
            switch ($workspace.count) {
                { $_ -eq 1 } { $_workspacePath = ("https://management.azure.com$($workspace.id)").ToLower() }
                { $_ -gt 1 } {
                    $SessionVariables.workspace = $null
                    Write-Warning -Message "Multiple resource '/Microsoft.OperationalInsights/workspaces/$($Name)' found. Please specify the resourcegroup"
                    break
                }
                { $_ -lt 1 } { 
                    $SessionVariables.workspace = $null
                    Write-Host "$($MyInvocation.MyCommand.Name): The Resource '/Microsoft.OperationalInsights/workspaces/$($Name)' was not found" -ForegroundColor Red
                    break
                }
                Default{}
            }
                
            if ($_workspacePath) {
                $uri = "$(($_workspacePath).Split('microsoft.operationalinsights')[0])Microsoft.OperationsManagement/solutions/SecurityInsights($($workspace.name))?api-version=2015-11-01-preview"
                    
                try {
                    $_sentinelInstance = Invoke-RestMethod -Method GET -Uri $uri -Headers $($SessionVariables.authHeader)
                    if ($_sentinelInstance.properties.provisioningState -eq 'Succeeded') {
                        Write-Verbose "Microsoft Sentinel workspace [$($Name)] found"
                        $SessionVariables.workspace = "https://management.azure.com$($workspace.id)"
                    } else {
                        $SessionVariables.workspace = $null
                        Write-Warning -Message "Microsoft Sentinel workspace [$($Name)] was found but is not yet provisioned.."
                    }
                } catch {
                    $SessionVariables.workspace = $null
                    Write-Host "Microsoft Sentinel was not found on workspace [$($Name)]" -ForegroundColor Yellow
                }
            }
        } catch {
            $SessionVariables.workspace = $null
            if ($ErrVar.Message -like '*ResourceGroupNotFound*') {
                Write-Host "$($MyInvocation.MyCommand.Name): Provided resource group does not exist." -ForegroundColor Red
            } else {
                Write-Output -Exception $_.Exception
            }
        }
    }
}
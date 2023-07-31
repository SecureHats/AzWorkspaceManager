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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
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

            $requestParam = @{
                Headers       = $authHeader
                Uri           = $uri
                Method        = 'GET'
                ErrorVariable = "ErrVar"
            }

             $workspace = (
                 Invoke-RestMethod @requestParam -ErrorVariable "ErrVar" ).value | Where-Object { $_.name -eq $Name } 

            switch ($workspace.count) {
                { $_ -eq 1 } { $_workspacePath = ("https://management.azure.com$($workspace.id)").ToLower() }
                { $_ -gt 1 } {
                    $SessionVariables.workspace = $null
                    Write-Message -Message "Multiple resource '/Microsoft.OperationalInsights/workspaces/$($Name)' found. Please specify the resourcegroup" -Severity 'Information'
                    break
                }
                { $_ -lt 1 } { 
                    $SessionVariables.workspace = $null
                    Write-Message "The Resource '/Microsoft.OperationalInsights/workspaces/$($Name)' was not found" -Severity 'Error'
                    break
                }
                Default {}
            }
                
            if ($_workspacePath) {
                $uri = "$(($_workspacePath).Split('microsoft.operationalinsights')[0])Microsoft.OperationsManagement/solutions/SecurityInsights($($workspace.name))?api-version=2015-11-01-preview"
                    
                try {
                    $requestParam = @{
                        Headers = $authHeader
                        Uri     = $uri
                        Method  = 'GET'
                    }

                    $_sentinelInstance = Invoke-RestMethod @requestParam
                    if ($_sentinelInstance.properties.provisioningState -eq 'Succeeded') {
                        Write-Verbose "Microsoft Sentinel workspace [$($Name)] found"
                        $SessionVariables.workspace = "https://management.azure.com$($workspace.id)"
                    }
                    else {
                        $SessionVariables.workspace = $null
                        Write-Message -Message "Microsoft Sentinel workspace [$($Name)] was found but is not yet provisioned.." -Severity 'Information'
                    }
                }
                catch {
                    $SessionVariables.workspace = $null
                    Write-Message "Microsoft Sentinel was not found on workspace [$($Name)]" -Severity 'Information'
                    break
                }
            }
        }
        catch {
            $SessionVariables.workspace = $null
            if ($ErrVar.Message -like '*ResourceGroupNotFound*') {
                Write-Message "$($MyInvocation.MyCommand.Name): Provided resource group does not exist." -Severity 'Error'
            }
            else {
                Write-Message -Message "An error has occured requesting the Log Analytics workspace" -Severity 'Error'
            }
        }
    }
}
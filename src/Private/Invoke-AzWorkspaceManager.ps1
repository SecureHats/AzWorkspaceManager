#requires -module @{ModuleName = 'Az.Accounts'; ModuleVersion = '2.10.0'}
#requires -version 6.2

function Invoke-AzWorkspaceManager {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$FunctionName
    )
    <#
    .SYNOPSIS
    Get prerequisites and validate access to the Microsoft Azure API
    .DESCRIPTION
    This function is called by all functions to validate if the access token in still valid.
    .EXAMPLE
    Invoke-AzWorkspaceManager
    .NOTES
    NAME: Invoke-AzWorkspaceManager
    #>
    
    Write-Verbose "Function Name: $($FunctionName)" 
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
  
    if ($azProfile.Contexts.Count -ne 0) {
        if ([string]::IsNullOrEmpty($script:accessToken)) {
            try {
                Get-AccessToken
            }
            catch {
                Write-Error -Exception $_.Exception.Message
                break
            }
        }
        elseif ($SessionVariables.ExpiresOn - [datetime]::UtcNow.AddMinutes(-5) -le 0) {
            # if token expires within 5 minutes, request a new access token
            try {
                Get-AccessToken  
            }
            catch {
                Write-Error -Exception $_.Exception.Message
                break
            }
        }

        # Set the subscription from AzContext
        $SessionVariables.baseUri = "https://management.azure.com/subscriptions/$($SessionVariables.subscriptionId)"
        $script:authHeader = @{
            'Authorization' = 'Bearer ' + $($SessionVariables.AccessToken | ConvertFrom-SecureString -AsPlainText)
        }
    }
    else {
        Write-Message "$($FunctionName): Run Connect-AzAccount to login" -Severity 'Error'
        break
    }
}
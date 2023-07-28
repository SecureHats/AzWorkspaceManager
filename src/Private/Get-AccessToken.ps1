#requires -module @{ModuleName = 'Az.Accounts'; ModuleVersion = '2.10.0'}
#requires -version 6.2

function Get-AccessToken {
    <#
    .SYNOPSIS
    Get an Access Token
    .DESCRIPTION
    This function is used to get an access token for the Microsoft Azure API
    .EXAMPLE
    Get-AuthToken
    .NOTES
    NAME: Get-AccessToken
    #>

    [CmdletBinding()]
    param (
    )

    try {
        $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile

        Write-Verbose "Current Subscription: $($azProfile.DefaultContext.Subscription.Name) in tenant $($azProfile.DefaultContext.Tenant.Id)"

        $SessionVariables.subscriptionId = $azProfile.DefaultContext.Subscription.Id
        $SessionVariables.tenantId = $azProfile.DefaultContext.Tenant.Id

        $profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new($azProfile)
        
        try {
            $SessionVariables.accessToken = ($profileClient.AcquireAccessToken($SessionVariables.tenantId)).accessToken | ConvertTo-SecureString -AsPlainText -Force
            $SessionVariables.ExpiresOn = ($profileClient.AcquireAccessToken($SessionVariables.tenantId)).ExpiresOn.DateTime
            Write-Verbose "Access Token expires on: $($SessionVariables.ExpiresOn)" 
        }
        catch {
            #Write-Host "**$($MyInvocation.MyCommand.Name):  Run Connect-AzAccount to login**" | ConvertFrom-Markdown -ForegroundColor Red
            Write-Error 'Run Connect-AzAccount to login'
            break
        }
    }
    catch {
        Write-Error -Message 'An error has occured requesting the Access Token'
        break
    }
}
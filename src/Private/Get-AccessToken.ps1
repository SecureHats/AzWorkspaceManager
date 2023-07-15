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

    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile

    Write-Verbose -Message "Current Subscription: $($azProfile.DefaultContext.Subscription.Name) in tenant $($azProfile.DefaultContext.Tenant.Id)"

    $script:subscriptionId = $azProfile.DefaultContext.Subscription.Id
    $script:tenantId = $azProfile.DefaultContext.Tenant.Id

    $profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new($azProfile)
    $script:accessToken = $profileClient.AcquireAccessToken($script:tenantId)

    $script:authHeader = @{
        'Authorization' = 'Bearer ' + $script:accessToken.AccessToken
    }
}
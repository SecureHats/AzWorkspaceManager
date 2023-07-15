#requires -module @{ModuleName = 'Az.Accounts'; ModuleVersion = '2.10.0'}
#requires -version 6.2

function Invoke-AzWorkspaceManager {
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
  
      $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
  
      if ($azProfile.Contexts -ne 0) {
          if ([string]::IsNullOrEmpty($script:accessToken)) {
              try {
                  Get-AccessToken
              } catch {
                    Write-Error -Exception 'Unable to get access token'
                    break
              }
          }
          elseif ($script:accessToken.ExpiresOn.DateTime - [datetime]::UtcNow.AddMinutes(-5) -le 0) {
              # if token expires within 5 minutes, request a new one
              try {
                Get-AccessToken  
              }
              catch {
                Write-Error -Exception 'Unable to get access token'
                break
              }
              
          }
  
          # Set the subscription from AzContext
          $script:subscriptionId = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile.DefaultContext.Subscription.Id
      }
      else {
          Write-Error 'Run Connect-AzAccount to login'
          break
      }
  }
function Format-Result {
    <#
    .SYNOPSIS
    Writes an output message to the console
    .DESCRIPTION
    This function is used internally to prompt messages to the PowerShell console
    .EXAMPLE
    Write-Result -FunctionName $MyInvocation.MyCommand.Name -Message 'This is a message'
    .NOTES
    NAME: Write-Message
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Message,

        [Parameter(Mandatory = $false)]
        [string]$FunctionName
    )

    $split = $Message.id.Split('/')
    $result = [ordered]@{
        Name              = $split[-1]
        ResourceGroupName = $split[-9]
        ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
        ResourceId        = $apiResponse.id
        Tags              = $apiResponse.tags
        Properties        = $apiResponse.properties
    } | ConvertTo-Json | ConvertFrom-Json

    return $result
                    
}
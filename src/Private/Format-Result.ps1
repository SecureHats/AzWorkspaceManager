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
        [Parameter(Mandatory = $true)]
        [array]$Message
    )
        $result = @()

        foreach ($value in $Message) {
        $split = $value.id.Split('/')
            $result += [ordered]@{
                Name              = $split[-1]
                ResourceGroupName = $split[-9]
                ResourceType      = '{0}/{1}' -f $split[-3], $split[-2]
                WorkspaceName     = $split[-5]
                ResourceId        = $value.id
                Tags              = $value.tags
                Properties        = $value.properties
            } | ConvertTo-Json -Depth 10 | ConvertFrom-Json -Depth 10
        }
    return $result
}
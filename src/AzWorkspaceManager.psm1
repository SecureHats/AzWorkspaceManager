# Import private and public scripts and expose the public ones
$privateScripts = @(Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Filter "*.ps1") | Sort-Object Name
$publicScripts = @(Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Filter "*.ps1") | Sort-Object Name

foreach ($script in ($privateScripts + $publicScripts)) {
    Write-Verbose $script
    try {
        . $script.FullName
        Write-Verbose -Message ("Imported function {0}" -f $script)
    } catch {
        Write-Error -Message ("Failed to import function {0}: {1}" -f $script, $_)
    }
}

#region load module variables
$SessionVariables = [ordered]@{
    baseUri           = 'https://management.azure.com/subscriptions/'
    User                = $null
    Customer            = $null
    ApiVersion          = $null
    AuthToken           = $null
    StartTime           = $null
    ElapsedTime         = $null
    LastCommand         = $null
    LastCommandTime     = $null
    LastCommandResults  = $null
    RefreshTime         = $null
}

New-Variable -Name SessionVariables -Value $SessionVariables -Scope Script
#ecdregion  
Export-ModuleMember -Function $publicScripts.BaseName

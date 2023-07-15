#region load module variables
Write-Verbose -Message "Creating modules variables"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$SessionVariables = [ordered]@{
    baseUri           = 'https://management.azure.com/'
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

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$DynDnsHistoryList = [System.Collections.Generic.List[object]]::new()
#endregion load module variables

#region Handle Module Removal
$OnRemoveScript = {
#    Remove-Variable -Name DynDnsSession -Scope Script -Force
}
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $OnRemoveScript
#endregion Handle Module Removal

#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
$ModuleName = $ExecutionContext.SessionState.Module
Write-Verbose -Message "Loading module $ModuleName"
#endregion discover module name

#region dot source public and private function definition files, export publich functions
try {
    foreach ($Scope in 'Public','Private') {
        Get-ChildItem (Join-Path -Path $ScriptPath -ChildPath $Scope) -Filter *.ps1 | ForEach-Object {
            . $_.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function $_.BaseName -ErrorAction Stop
            }
        }
    }
}
catch {
    Write-Error ("{0}: {1}" -f $_.BaseName,$_.Exception.Message)
    exit 1
}
#endregion dot source public and private function definition files, export publich functions

# #region load module variables
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
# #endregion load module variables  

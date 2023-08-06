#region load module variables
Write-Verbose -Message "Creating modules variables"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$SessionVariables = [ordered]@{
    baseUri    = ''
    ExpiresOn  = ''
    workspace  = ''
    apiVersion = '2023-06-01-preview'
}
New-Variable -Name Guid -Value (New-Guid).Guid -Scope Global -Force
New-Variable -Name SessionVariables -Value $SessionVariables -Scope Global -Force
 
#region Handle Module Removal
$OnRemoveScript = {
    Remove-Variable -Name SessionVariables -Scope Global -Force
    Remove-Variable -Name Guid -Scope Global -Force
}
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $OnRemoveScript
#endregion Handle Module Removal

#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
$ModuleName = $ExecutionContext.SessionState.Module
Write-Verbose -Message "Loading module $ModuleName"
#endregion discover module name

#region dot source public and private function definition files
try {
    foreach ($Scope in 'Public', 'Private') {
        Get-ChildItem (Join-Path -Path $ScriptPath -ChildPath $Scope) -Filter *.ps1 | ForEach-Object {
            . $_.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function $_.BaseName -ErrorAction Stop
            }
        }
    }
}
catch {
    Write-Error ("{0}: {1}" -f $_.BaseName, $_.Exception.Message)
    exit 1
}
#endregion dot source public and private function definition files

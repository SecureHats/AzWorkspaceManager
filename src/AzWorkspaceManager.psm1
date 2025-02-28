#region load module variables
Write-Verbose -Message "Creating module variables"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssignments', '')]
$SessionVariables = [ordered]@{
    baseUri    = ''
    ExpiresOn  = ''
    workspace  = ''
    apiVersion = '2023-10-01'
}

Set-Variable -Name Guid -Value (New-Guid).Guid -Scope Script -Force
Set-Variable -Name SessionVariables -Value $SessionVariables -Scope Script -Force
#endregion load module variables

#region Handle Module Removal
$OnRemoveScript = {
    Remove-Variable -Name SessionVariables -Scope Script -Force
    Remove-Variable -Name Guid -Scope Script -Force
}
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $OnRemoveScript
#endregion Handle Module Removal

#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
$ModuleName = $ExecutionContext.SessionState.Module.Name
Write-Verbose -Message "Loading module $ModuleName"
#endregion discover module name

#region dot source public and private function definition files
try {
    foreach ($Scope in 'Public', 'Private') {
        $FunctionFiles = Get-ChildItem -Path (Join-Path -Path $ScriptPath -ChildPath $Scope) -Filter *.ps1
        foreach ($File in $FunctionFiles) {
            . $File.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function $File.BaseName -ErrorAction Stop
            }
        }
    }
}
catch {
    Write-Error ("Error loading function {0}: {1}" -f $_.BaseName, $_.Exception.Message)
    exit 1
}
#endregion dot source public and private function definition files

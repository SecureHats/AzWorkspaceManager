#
# Module manifest for module 'AzWorkspaceManager'
#
# Generated by: Rogier Dijkman
#
# Generated on: 07/01/2023
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'AzWorkspaceManager.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.1'

    # Supported PSEditions
    # CompatiblePSEditions = @('Core')

    # ID used to uniquely identify this module
    GUID              = '67faa800-39f5-40ae-9ee8-6caac6ae1261'

    # Author of this module
    Author            = 'Rogier Dijkman'

    # Company or vendor of this module
    CompanyName       = ''

    # Copyright statement for this module
    Copyright         = '(c) Rogier Dijkman. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Helper module to manage and configure Microsoft Sentinel workspace manager'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Get-AzWorkspaceManagerConfiguration', 
        'Set-AzWorkspaceManagerConfiguration', 'Remove-AzWorkspaceManagerConfiguration',
        'Get-AzWorkspaceManagerMembers', 'Add-AzWorkspaceManagerMembers', 'Remove-AzWorkspaceManagerMembers',
        'Get-AzWorkspaceManagerGroups', 'Add-AzWorkspaceManagerGroups', 'Remove-AzWorkspaceManagerGroups',
        'Get-AzWorkspaceManagerAssignments', 'Add-AzWorkspaceManagerAssignments', 'Remove-AzWorkspaceManagerAssignments',
        'Get-AzWorkspaceManagerAssignmentJobs', 'Add-AzWorkspaceManagerAssignmentJobs', 'Remove-AzWorkspaceManagerAssignmentJobs'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList = 'Private\Get-AccessToken.ps1',
    'Private\Invoke-AzWorkspaceManager.ps1',
    'Private\Format-Result.ps1',
    'Public\Get-LogAnalyticsWorkspace.ps1',
    'Public\Get-AzWorkspaceManagerConfiguration.ps1',
    'Public\Set-AzWorkspaceManagerConfiguration.ps1',
    'Public\Remove-AzWorkspaceManagerConfiguration.ps1',
    'Public\Get-AzWorkspaceManagerMembers.ps1',
    'Public\Add-AzWorkspaceManagerMembers.ps1',
    'Public\Remove-AzWorkspaceManagerMembers.ps1',
    'Public\Get-AzWorkspaceManagerGroups.ps1',
    'Public\Add-AzWorkspaceManagerGroups.ps1',
    'Public\Remove-AzWorkspaceManagerGroups.ps1',
    'Public\Get-AzWorkspaceManagerAssignments.ps1',
    'Public\Add-AzWorkspaceManagerAssignments.ps1',
    'Public\Remove-AzWorkspaceManagerAssignments.ps1',
    'Public\Get-AzWorkspaceManagerAssignmentJobs.ps1',
    'Public\Add-AzWorkspaceManagerAssignmentJobs.ps1',
    'Public\Remove-AzWorkspaceManagerAssignmentJobs.ps1',
    'AzWorkspaceManager.psd1',
    'AzWorkspaceManager.psm1'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        #IsPrerelease of this module
        IsPrerelease = $true

        PSData       = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @("Sentinel", "Microsoft", "Azure", "WorkspaceManager", "ARM")

            # A URL to the license for this module.
            # LicenseUri = 'https://github.com/securehats/AzWorkspaceManager/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/securehats/AzWorkspaceManager'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}

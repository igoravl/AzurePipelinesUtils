@{
    RootModule = 'AzurePipelinesUtils.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'a1234567-b890-c123-d456-e789f0123456'
    Author = 'igoravl'
    CompanyName = 'igoravl'
    Copyright = '(c) 2025 igoravl. All rights reserved.'
    Description = 'PowerShell utilities for Azure DevOps Pipelines tasks'
    PowerShellVersion = '5.1'
    RequiredModules = @()
    RequiredAssemblies = @()
    ScriptsToProcess = @('init.ps1')
    TypesToProcess = @()
    FormatsToProcess = @()
    NestedModules = @()
    FunctionsToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = '*'
    DscResourcesToExport = @()
    ModuleList = @()
    FileList = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Azure', 'DevOps', 'Pipelines', 'Build', 'Automation')
            LicenseUri = 'https://github.com/igoravl/AzurePipelinesUtils/blob/main/LICENSE'
            ProjectUri = 'https://github.com/igoravl/AzurePipelinesUtils'
            IconUri = ''
            Prerelease = ''
            ReleaseNotes = 'Initial release of AzurePipelinesUtils PowerShell module'
            RequireLicenseAcceptance = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI = 'https://github.com/igoravl/AzurePipelinesUtils'
    DefaultCommandPrefix = ''
}

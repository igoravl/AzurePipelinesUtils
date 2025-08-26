@{
    Path = "AzurePipelinesUtils.psd1"
    OutputDirectory = "Build"
    PublicFilter = "Public\*.ps1"
    PrivateFilter = "Private\*.ps1"
    SourceDirectories = @("Public", "Private")
    ModuleVersion = "0.1.0"
    Author = "igoravl"
    CompanyName = "igoravl"
    Copyright = "(c) 2025 igoravl. All rights reserved."
    Description = "PowerShell utilities for Azure DevOps Pipelines tasks"
    PowerShellVersion = "5.1"
    Tags = @("Azure", "DevOps", "Pipelines", "Build", "Automation")
    ProjectUri = "https://github.com/igoravl/AzurePipelinesUtils"
    LicenseUri = "https://github.com/igoravl/AzurePipelinesUtils/blob/main/LICENSE"
}

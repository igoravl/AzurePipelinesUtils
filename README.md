# AzurePipelinesUtils

PowerShell utilities for Azure DevOps Pipelines tasks. This module provides cmdlets to facilitate common actions in Azure DevOps pipelines, such as logging commands, setting variables, and managing build metadata.

## Features

- **Logging Commands**: Write warnings, errors, and progress updates using Azure DevOps logging commands
- **Variable Management**: Set pipeline variables, including secrets and output variables
- **Build Management**: Add tags to builds and organize output with collapsible sections
- **Context Detection**: Detect if code is running within an Azure DevOps Pipeline

## Installation

### From PowerShell Gallery (when published)
```powershell
Install-Module AzurePipelinesUtils -Scope CurrentUser
```

### From Source
```powershell
git clone https://github.com/igoravl/AzurePipelinesUtils.git
cd AzurePipelinesUtils
# Install dependencies
Install-Module InvokeBuild, ModuleBuilder, Pester -Scope CurrentUser
# Build the module
Invoke-Build
```

## Cmdlets

### Logging Commands

- **`Write-AzurePipelinesWarning`** - Write warning messages to pipeline logs
- **`Write-AzurePipelinesError`** - Write error messages to pipeline logs
- **`Write-AzurePipelinesTaskProgress`** - Update task progress indicators
- **`Write-AzurePipelinesSection`** - Create collapsible sections in logs

### Variable Management

- **`Set-AzurePipelinesVariable`** - Set pipeline variables (including secrets and output variables)

### Build Management

- **`Add-AzurePipelinesBuildTag`** - Add tags to the current build

### Utility Functions

- **`Test-AzurePipelinesContext`** (Private) - Detect Azure DevOps Pipeline context

## Examples

### Basic Logging
```powershell
Write-AzurePipelinesWarning "This is a warning message"
Write-AzurePipelinesError "This is an error message"
```

### Advanced Logging with Source Information
```powershell
Write-AzurePipelinesWarning -Message "Deprecated function used" -SourcePath "script.ps1" -LineNumber 42
Write-AzurePipelinesError -Message "Compilation failed" -SourcePath "build.ps1" -LineNumber 25
```

### Setting Variables
```powershell
# Set a regular variable
Set-AzurePipelinesVariable -Name "BuildNumber" -Value "1.0.42"

# Set a secret variable
Set-AzurePipelinesVariable -Name "ApiKey" -Value "secret123" -Secret

# Set an output variable (available to subsequent jobs)
Set-AzurePipelinesVariable -Name "DeploymentTarget" -Value "Production" -Output
```

### Build Management
```powershell
# Add tags to the build
Add-AzurePipelinesBuildTag -Tag "release"
Add-AzurePipelinesBuildTag -Tag "hotfix"
```

### Progress Tracking
```powershell
Write-AzurePipelinesTaskProgress -CurrentOperation "Installing dependencies" -PercentComplete 25
Write-AzurePipelinesTaskProgress -CurrentOperation "Running tests" -PercentComplete 75
```

### Organizing Output with Sections
```powershell
Write-AzurePipelinesSection -Name "Build" -Start
# ... build commands ...
Write-AzurePipelinesSection -Name "Build" -End
```

## Development

### Building the Module

This project uses [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder) and [Invoke-Build](https://github.com/nightroman/Invoke-Build) for the build process.

```powershell
# Clean previous builds
Invoke-Build Clean

# Build the module
Invoke-Build Build

# Run tests
Invoke-Build Test

# Create distribution package
Invoke-Build Pack
```

### Project Structure

```
AzurePipelinesUtils/
├── Source/                    # Source files (ModuleBuilder convention)
│   ├── Public/               # Public functions (exported)
│   ├── Private/              # Private functions (internal)
│   ├── AzurePipelinesUtils.psd1  # Module manifest
│   └── build.psd1            # ModuleBuilder configuration
├── Tests/                    # Pester tests
├── Build/                    # Build output (created by ModuleBuilder)
├── artifacts/                # Distribution packages
└── ib.build.ps1             # Invoke-Build script
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass: `Invoke-Build Test`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [Azure DevOps Logging Commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)
- [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder)
- [Invoke-Build](https://github.com/nightroman/Invoke-Build)
Collection of PowerShell cmdlets for use in Azure Pipelines

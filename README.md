# AzurePipelinesUtils

PowerShell utilities for Azure DevOps Pipelines tasks. This module provides lightweight cmdlets to emit Azure DevOps logging commands, manage variables/secrets, update build & release metadata, structure log output (groups/sections), upload supporting artifacts, and track task progress.

Current module version: `0.1.0`

## Features

### Logging & Formatting

* Warnings, errors, debug, generic command messages
* Collapsible log groups (start/end + convenience wrapper)
* Visual section headers (optionally boxed)
* Task & generic progress reporting

### Variables & Secrets

* Set pipeline variables (supports Secret / Output / ReadOnly flags)
* Mask arbitrary values as secrets at runtime, so they do not appear in logs

### Build / Release Metadata

* Update build number
* Update classic release name
* Add build tags

### Pipeline Output Enhancements

* Upload supplemental log / artifact files to the task log
* Add Markdown summaries to the run (inline content or file-driven)
* Prepend directories to PATH for subsequent steps
* Mark a task as completed with a final status

### Environment Awareness

Gracefully degrades when not running inside an Azure Pipelines agent (writes readable console output instead of logging commands where practical), so that scripts can be tested locally without modification.

## Installation

### From PowerShell Gallery (when published)

```powershell
Install-Module AzurePipelinesUtils -Scope CurrentUser
```

### From Source

```powershell
git clone https://github.com/igoravl/AzurePipelinesUtils.git
cd AzurePipelinesUtils
# Build module locally
./Build.ps1 -InstallDependencies
# Import the module
Import-Module ./out/module/AzurePipelinesUtils.psd1
```

## Public Functions (Cmdlets)

| Function | Purpose |
|----------|---------|
| `Add-PipelineBuildTag` | Add a tag to the current build. |
| `Add-PipelineTaskLogFile` | Upload one or more files into the task log (visible under Attachments). |
| `Add-PipelinePath` | Prepend a directory to PATH for later steps. |
| `Add-PipelineSummary` | Publish a Markdown summary (string or file). |
| `Complete-PipelineTask` | Mark current task as completed with a status other than Succeeded (e.g. Failed, Skipped). |
| `Set-PipelineBuildNumber` | Update the build number. |
| `Set-PipelineReleaseNumber` | Update classic release name. |
| `Set-PipelineSecretValue` | Mask a literal value in logs (does not create a variable). |
| `Set-PipelineVariable` | Create/update a pipeline variable (supports `-Secret`, `-Output`, `-ReadOnly`). |
| `Write-PipelineCommand` | Write a generic command/info log entry. |
| `Write-PipelineDebug` | Write a debug message (alias: `Write-Debug`). |
| `Write-PipelineError` | Emit an error log issue (alias: `Write-Error`). |
| `Write-PipelineWarning` | Emit a warning log issue (alias: `Write-Warning`). |
| `Write-PipelineGroupStart` | Begin a collapsible log group. |
| `Write-PipelineGroupEnd` | End the current collapsible group. |
| `Write-PipelineGroup` | Convenience wrapper executing a script block inside a group. |
| `Write-PipelineSection` | Output a formatted section header (optionally boxed). |
| `Write-PipelineProgress` | Generic progress indicator (percent + activity). |
| `Write-PipelineTaskProgress` | Task progress (operation + optional percent). |

Aliases are only applied when running inside an Azure Pipelines context to avoid overriding local development behavior unnecessarily.

## Usage Examples

### Logging Basics

```powershell
Write-PipelineWarning -Message "This is a warning message"
Write-PipelineError   -Message "This is an error message"
Write-PipelineDebug   -Message "Verbose diagnostic detail"
Write-PipelineCommand -Message "Starting dependency restore"
```

### Warnings / Errors with Source Info

```powershell
Write-PipelineWarning -Message "Deprecated function used" -SourcePath "build.ps1" -LineNumber 42
Write-PipelineError   -Message "Compilation failed"       -SourcePath "build.ps1" -LineNumber 25
```

### Variable & Secret Management

```powershell
# Standard variable
Set-PipelineVariable -Name BuildNumber -Value "1.0.42"

# Secret variable (masked) & output to subsequent jobs
Set-PipelineVariable -Name ApiKey -Value "secret123" -Secret -Output

# Read-only variable (cannot be modified later in run)
Set-PipelineVariable -Name CommitSha -Value $env:BUILD_SOURCEVERSION -ReadOnly

# Mask an arbitrary value (does not store it)
Set-PipelineSecretValue -Value $SomeSensitiveToken
```

### Build / Release Metadata

```powershell
Set-PipelineBuildNumber   -BuildNumber "1.2.$env:BUILD_BUILDID"
Set-PipelineReleaseNumber -ReleaseNumber "Release-$(Get-Date -Format yyyyMMdd)"
Add-PipelineBuildTag -Tag "release"
Add-PipelineBuildTag -Tag "hotfix"
```

### Groups & Sections

```powershell
Write-PipelineGroupStart "Dependency Restore"
# restore commands ...
Write-PipelineGroupEnd

Write-PipelineGroup -Header "Build" -Body {
	msbuild MySolution.sln /t:Build
}

Write-PipelineSection -Text "Unit Tests"
```

### Progress

```powershell
Write-PipelineTaskProgress -CurrentOperation "Installing dependencies" -PercentComplete 25
Write-PipelineProgress     -Activity "Build" -PercentComplete 60
Write-PipelineTaskProgress -CurrentOperation "Running tests" -PercentComplete 75
```

### Summaries & File Uploads

```powershell
Add-PipelineSummary -Content "## Build Completed Successfully"
Add-PipelineSummary -Path   "reports/test-summary.md"

Get-ChildItem -Path .\logs\*.log | Add-PipelineTaskLogFile
```

### PATH Modification

```powershell
Add-PipelinePath -Path "$PSScriptRoot\tools"
```

### Task Completion Override

```powershell
# If earlier commands registered a non-succeeded status globally,
# this will emit the appropriate task.complete command.
Complete-PipelineTask -Status Failed
```

## Development

### Build / Test / Package

This project uses [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder) and [Invoke-Build](https://github.com/nightroman/Invoke-Build).

```powershell
Invoke-Build Clean   # Clean previous artifacts
Invoke-Build Build   # Build module into ./Build
Invoke-Build Test    # Run Pester tests
Invoke-Build Package # Produce distributable artifact (if defined)
```

### Project Structure

```text
AzurePipelinesUtils/
├── Source/                     # Module source
│   ├── Public/                 # Public functions
│   ├── Private/                # Internal helpers
│   ├── AzurePipelinesUtils.psd1 # Manifest
│   └── build.psd1              # ModuleBuilder config
├── Tests/                      # Pester tests
├── Build/                      # Build output
├── artifacts/                  # Packaging output
└── ib.build.ps1                # Invoke-Build script
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Add/adjust tests for new functionality
4. Run `Invoke-Build Test` and ensure all tests pass
5. Open a pull request

## License

MIT License. See [LICENSE](LICENSE).

## References

* [Azure DevOps Logging Commands](https://learn.microsoft.com/azure/devops/pipelines/scripts/logging-commands)
* [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder)
* [Invoke-Build](https://github.com/nightroman/Invoke-Build)

---
Collection of PowerShell cmdlets for use in Azure Pipelines.

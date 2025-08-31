<#
.SYNOPSIS
    Adds a path to the PATH environment variable in Azure Pipelines.

.DESCRIPTION
    The Add-PipelinePath function adds a specified path to the PATH environment variable
    in Azure Pipelines. It uses the task.prependpath command which is available in Azure Pipelines
    to ensure the path is properly set for subsequent tasks.

.PARAMETER Path
    The path to add to the PATH environment variable.

.EXAMPLE
    Add-PipelinePath -Path "C:\tools\bin"
    
    Adds the "C:\tools\bin" directory to the beginning of the PATH environment variable.

.EXAMPLE
    Add-PipelinePath "$(Build.SourcesDirectory)\tools"

    Adds the tools directory from the source repository to the beginning of the PATH environment variable.
#>
function Add-PipelinePath {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Path
    )
    
    $Path = (Resolve-Path -Path $Path).Path

    if (-not (Test-Path -Path $Path -PathType Container)) {
        Write-Error "The specified path '$Path' does not exist or is not a directory."
    }

    if ((Test-PipelineContext)) {
        Write-Host "##vso[task.prependpath]$Path"
    }
    else {
        $env:PATH = "$Path$([System.IO.Path]::PathSeparator)$env:PATH"
    }
}
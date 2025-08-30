<#
.SYNOPSIS
Adds a Markdown summary to Azure DevOps Pipelines.

.DESCRIPTION
This function adds a Markdown formatted summary to the pipeline run using Azure DevOps Pipelines logging commands.
Summaries appear in the pipeline run details and help provide additional information or context about the build.

.PARAMETER Content
The Markdown content to add as a summary.

.PARAMETER Path
Path to a Markdown file whose content will be added as a summary.

.EXAMPLE
Add-PipelineSummary -Content "## Build Completed Successfully"
# Adds a simple header as a summary to the pipeline

.EXAMPLE
Add-PipelineSummary -Path ".\build-report.md"
# Adds the content of build-report.md file as a summary to the pipeline

.EXAMPLE
"## Test Results: Passed" | Add-PipelineSummary
# Adds summary from pipeline input
#>
function Add-PipelineSummary {
    [CmdletBinding(DefaultParameterSetName = 'Content')]
    param(
        # The Markdown content to add as a summary
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Content', ValueFromPipeline = $true)]
        [string]$Content,

        # Path to a Markdown file whose content will be added as a summary
        [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
        [string]$Path
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            if (-not (Test-Path -Path $Path)) {
                throw "The specified path '$Path' does not exist."
            }
        }
        else {
            # Write the content to a temporary file
            $Path = [System.IO.Path]::GetTempFileName() + ".md"
            Set-Content -Path $Path -Value $Content -Encoding UTF8
        }

        if ((Test-PipelineContext)) {
            Write-Host "##vso[task.uploadsummary]$Path"
        }
        else {
            Write-PipelineSection "Pipeline Summary"
            Get-Content -Path $Path | Write-Host
        }
    }
}
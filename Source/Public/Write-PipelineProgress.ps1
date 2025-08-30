<#
.SYNOPSIS
Writes a progress message in Azure DevOps Pipelines.

.DESCRIPTION
This function writes a progress message using Azure DevOps Pipelines logging commands.
It can be used to show progress status during pipeline execution, including 
percentage completion values.

.PARAMETER PercentComplete
The percentage of completion (0-100) for the current operation.

.PARAMETER Activity
The name of the activity for which progress is being reported.

.PARAMETER Status
The current status message for the activity.

.PARAMETER Id
A unique identifier for the progress bar. Useful when tracking multiple 
concurrent operations.

.EXAMPLE
Write-PipelineProgress -PercentComplete 50 -Activity "Deployment" -Status "Installing components"
# Reports 50% completion for the "Deployment" activity

.EXAMPLE
Write-PipelineProgress -PercentComplete 75 -Activity "Build" -Status "Compiling sources" -Id 1
# Reports 75% completion for the "Build" activity with ID 1
#>
function Write-PipelineProgress {
    [CmdletBinding()]
    param(
        # The percentage of completion (0-100)
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateRange(0, 100)]
        [int]$PercentComplete,

        # The name of the activity for which progress is being reported
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Activity
    )

    if ((Test-PipelineContext)) {
        # Using Azure DevOps Pipelines task progress command
        Write-Output "##vso[task.setprogress value=$PercentComplete;]$Activity - $PercentComplete%"
    }
    else {
        # If not in a pipeline, use standard PowerShell Write-Progress
        Write-Progress -Activity $Activity -PercentComplete $PercentComplete
    }
}
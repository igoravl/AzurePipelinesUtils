function Write-PipelineTaskProgress {
    <#
    .SYNOPSIS
    Updates the progress of the current Azure DevOps Pipeline task.
    
    .DESCRIPTION
    This function updates the progress indicator for the current task using Azure DevOps Pipelines logging commands.
    
    .PARAMETER CurrentOperation
    The current operation being performed.
    
    .PARAMETER PercentComplete
    The percentage of completion (0-100).
    
    .EXAMPLE
    Write-PipelineTaskProgress -CurrentOperation "Installing dependencies" -PercentComplete 25
    
    .EXAMPLE
    Write-PipelineTaskProgress -CurrentOperation "Running tests" -PercentComplete 75
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CurrentOperation,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 100)]
        [int]$PercentComplete
    )
    
    $properties = "currentoperation=$CurrentOperation"
    if ($PSBoundParameters.ContainsKey('PercentComplete')) {
        $properties += ";percentcomplete=$PercentComplete"
    }
    
    Write-Output "##vso[task.setprogress $properties]"
}

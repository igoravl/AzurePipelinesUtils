<#
.SYNOPSIS
Sets the build number in Azure DevOps Pipelines.

.DESCRIPTION
This function sets the build number using Azure DevOps Pipelines logging commands.
The build number can be modified during a pipeline run to provide custom versioning.

.PARAMETER BuildNumber
The build number to set for the current pipeline run.

.EXAMPLE
Set-PipelineBuildNumber -BuildNumber "1.0.42"
# Sets the build number to 1.0.42

.EXAMPLE
Set-PipelineBuildNumber -BuildNumber "$(Get-Date -Format 'yyyy.MM.dd').$env:BUILD_BUILDID"
# Sets the build number using a date-based format with the build ID
#>
function Set-PipelineBuildNumber {
    [CmdletBinding()]
    param(
        # The build number to set for the current pipeline
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$BuildNumber
    )

    if ((Test-PipelineContext)) {
        $prefix = '##vso[build.updatebuildnumber]'
    }
    else {
        $prefix = 'Build number: '
    }

    Write-Output "$prefix$BuildNumber"
}
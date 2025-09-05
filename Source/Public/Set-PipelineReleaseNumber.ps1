<#
.SYNOPSIS
Sets the release name in Azure DevOps classic releases.

.DESCRIPTION
This function sets the release name using Azure DevOps Pipelines logging commands.
The release name can be modified during a release run to provide custom naming.

.EXAMPLE
Set-PipelineReleaseNumber -ReleaseName "1.0.42"
# Sets the release name to 1.0.42

.EXAMPLE
Set-PipelineReleaseNumber -ReleaseName "$(Get-Date -Format 'yyyy.MM.dd').$env:RELEASE_RELEASEID"
# Sets the release name using a date-based format with the release ID
#>
function Set-PipelineReleaseNumber {
    [CmdletBinding()]
    param(
        # The release number to set for the current release
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ReleaseNumber
    )

    if ((_TestPipelineContext)) {
        $prefix = '##vso[release.updatereleasename]'
    }
    else {
        $prefix = 'Release name: '
    }

    Write-Output "$prefix$ReleaseNumber"
}
function Add-PipelineBuildTag {
    <#
    .SYNOPSIS
    Adds a tag to the current Azure DevOps Pipeline build.
    
    .DESCRIPTION
    This function adds a tag to the current build using Azure DevOps Pipelines logging commands.
    Tags can be used to categorize and filter builds.
    
    .PARAMETER Tag
    The tag to add to the build.
    
    .EXAMPLE
    Add-PipelineBuildTag -Tag "release"
    
    .EXAMPLE
    Add-PipelineBuildTag -Tag "hotfix"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Tag
    )
    
    Write-Output "##vso[build.addbuildtag]$Tag"
}

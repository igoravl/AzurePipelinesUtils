function Write-PipelineSection {
    <#
    .SYNOPSIS
    Starts or ends a collapsible section in Azure DevOps Pipeline logs.
    
    .DESCRIPTION
    This function creates collapsible sections in the pipeline logs to organize output.
    Each section must be started and ended with the same section name.
    
    .PARAMETER Name
    The name of the section.
    
    .PARAMETER Start
    Indicates this is the start of a section.
    
    .PARAMETER End
    Indicates this is the end of a section.
    
    .EXAMPLE
    Write-PipelineSection -Name "Build" -Start
    # ... build commands ...
    Write-PipelineSection -Name "Build" -End
    #>
    [CmdletBinding(DefaultParameterSetName = 'Start')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        
        [Parameter(ParameterSetName = 'Start')]
        [switch]$Start,
        
        [Parameter(ParameterSetName = 'End')]
        [switch]$End
    )
    
    if ($Start -or $PSCmdlet.ParameterSetName -eq 'Start') {
        Write-Output "##[section]Starting: $Name"
    }
    else {
        Write-Output "##[section]Finishing: $Name"
    }
}

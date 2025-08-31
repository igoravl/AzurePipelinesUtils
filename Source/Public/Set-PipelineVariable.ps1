function Set-PipelineVariable {
    <#
    .SYNOPSIS
    Sets a variable in Azure DevOps Pipelines.
    
    .DESCRIPTION
    This function sets a pipeline variable using Azure DevOps Pipelines logging commands.
    The variable can be used in subsequent tasks and jobs.
    
    .PARAMETER Name
    The name of the variable to set.
    
    .PARAMETER Value
    The value to assign to the variable.
    
    .PARAMETER Secret
    Indicates whether the variable should be treated as a secret.
    
    .PARAMETER Output
    Indicates whether the variable should be available to subsequent jobs.
    
    .EXAMPLE
    Set-PipelineVariable -Name "BuildNumber" -Value "1.0.42"
    
    .EXAMPLE
    Set-PipelineVariable -Name "ApiKey" -Value "secret123" -Secret
    
    .EXAMPLE
    Set-PipelineVariable -Name "DeploymentTarget" -Value "Production" -Output
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        
        [Parameter(Mandatory = $true)]
        [string]$Value,
        
        [Parameter(Mandatory = $false)]
        [switch]$Secret,
        
        [Parameter(Mandatory = $false)]
        [switch]$Output,
        
        [Parameter(Mandatory = $false)]
        [switch]$ReadOnly
    )
    
    $properties = ''

    if ($Secret) {
        $properties += ";issecret=true"
    }
    if ($Output) {
        $properties += ";isoutput=true"
    }
    if ($ReadOnly) {
        $properties += ";isreadonly=true"
    }

    Write-Output "##vso[task.setvariable variable=$Name$properties]$Value"
}

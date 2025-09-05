# Private helper function to validate Azure Pipelines context
function _TestPipelineContext {
    <#
    .SYNOPSIS
    Tests if the current session is running in an Azure DevOps Pipeline.
    
    .DESCRIPTION
    This private function checks for the presence of Azure DevOps environment variables
    to determine if the code is running within a pipeline context.
    
    .OUTPUTS
    [bool] Returns $true if running in Azure Pipelines, $false otherwise.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()
    
    $azureDevOpsVariables = @(
        'TF_BUILD',
        'AGENT_ID',
        'BUILD_BUILDID'
    )
    
    foreach ($variable in $azureDevOpsVariables) {
        if (Get-Item -Path "Env:$variable" -ErrorAction SilentlyContinue) {
            return $true
        }
    }
    
    return $false
}

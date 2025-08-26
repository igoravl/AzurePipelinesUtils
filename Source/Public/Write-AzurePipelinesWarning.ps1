function Write-AzurePipelinesWarning {
    <#
    .SYNOPSIS
    Writes a warning message to Azure DevOps Pipelines output.
    
    .DESCRIPTION
    This function writes a warning message using Azure DevOps Pipelines logging commands.
    The message will appear as a warning in the pipeline logs.
    
    .PARAMETER Message
    The warning message to display.
    
    .PARAMETER SourcePath
    Optional source file path where the warning occurred.
    
    .PARAMETER LineNumber
    Optional line number where the warning occurred.
    
    .EXAMPLE
    Write-AzurePipelinesWarning -Message "This is a warning"
    
    .EXAMPLE
    Write-AzurePipelinesWarning -Message "Deprecated function used" -SourcePath "script.ps1" -LineNumber 42
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [string]$SourcePath,
        
        [Parameter(Mandatory = $false)]
        [int]$LineNumber
    )
    
    $properties = @()
    if ($SourcePath) {
        $properties += "sourcepath=$SourcePath"
    }
    if ($LineNumber) {
        $properties += "linenumber=$LineNumber"
    }
    
    $propertyString = if ($properties.Count -gt 0) { ";$($properties -join ';')" } else { "" }
    
    Write-Output "##vso[task.logissue type=warning$propertyString]$Message"
}

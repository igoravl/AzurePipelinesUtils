function Write-AzurePipelinesError {
    <#
    .SYNOPSIS
    Writes an error message to Azure DevOps Pipelines output.
    
    .DESCRIPTION
    This function writes an error message using Azure DevOps Pipelines logging commands.
    The message will appear as an error in the pipeline logs and may cause the task to fail.
    
    .PARAMETER Message
    The error message to display.
    
    .PARAMETER SourcePath
    Optional source file path where the error occurred.
    
    .PARAMETER LineNumber
    Optional line number where the error occurred.
    
    .EXAMPLE
    Write-AzurePipelinesError -Message "File not found"
    
    .EXAMPLE
    Write-AzurePipelinesError -Message "Compilation failed" -SourcePath "build.ps1" -LineNumber 25
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
    
    Write-Output "##vso[task.logissue type=error$propertyString]$Message"
}

function Write-PipelineWarning {
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
    Write-PipelineWarning -Message "This is a warning"
    
    .EXAMPLE
    Write-PipelineWarning -Message "Deprecated function used" -SourcePath "script.ps1" -LineNumber 42
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        
        [Parameter()]
        [string]$SourcePath,
        
        [Parameter()]
        [int]$LineNumber,

        [Parameter()]
        [int]$ColumnNumber,

        [Parameter()]
        [Alias('Code')]
        [string]$IssueCode,

        [Parameter()]
        [switch] $DoNotUpdateJobStatus
    )
    
    if ((Test-PipelineContext)) {
        $prefix = '##[warning] ' 
    }
    
    if ($DoNotUpdateJobStatus.IsPresent) {
        Write-Host "${prefix}$Message" -ForegroundColor Yellow
        return
    }
    
    $properties = ''

    if ($SourcePath) { $properties += ";sourcepath=$SourcePath" }
    if ($LineNumber) { $properties += ";linenumber=$LineNumber" }
    if ($ColumnNumber) { $properties += ";columnnumber=$ColumnNumber" }
    if ($IssueCode) { $properties += ";code=$IssueCode" }

    $global:_task_status = 'SucceededWithIssues'
    Write-Host "##vso[task.logissue type=warning$properties]$Message"
}

# Alias
Set-Alias -Name 'Write-Warning' -Value 'Write-PipelineWarning' -Force -Scope Global
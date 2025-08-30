<#
.SYNOPSIS
    Writes a log message to the Azure Pipelines log or console.

.DESCRIPTION
    This advanced function logs messages of type Warning, Error, Info, or Debug to Azure Pipelines or the console. It supports additional metadata such as source file, line, column, and issue code, and can optionally prevent updating the job status. The function is intended for use in CI/CD scenarios to provide rich, contextual logging.

.EXAMPLE
    Write-PipelineLog -Message "An error occurred." -LogType Error
    # Logs an error message to the Azure Pipelines log.

.EXAMPLE
    Write-PipelineLog -Message "File not found." -LogType Warning -SourcePath "src/app.ps1" -LineNumber 42
    # Logs a warning message with source file and line number metadata.

.EXAMPLE
    Write-PipelineLog -Message "Debugging info." -LogType Debug -DoNotUpdateJobStatus
    # Logs a debug message and does not update the job status.

.NOTES
    Author: igoravl
    Date: August 29, 2025
    This function is intended for use in Azure Pipelines and supports rich logging features for CI/CD automation.
#>
function Write-PipelineLog {
    [CmdletBinding()]
    param(
        # The message to log in the pipeline.
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,

        # The type of log message (Warning, Error, Info, Debug).
        [Parameter(Mandatory=$true)]
        [ValidateSet("Warning", "Error", "Info", "Debug", "Command")]
        [string]$LogType,

        # The source file path related to the log message (optional).
        [Parameter()]
        [string]$SourcePath,
        
        # The line number in the source file where the log message applies (optional).
        [Parameter()]
        [int]$LineNumber,

        # The column number in the source file where the log message applies (optional).
        [Parameter()]
        [int]$ColumnNumber,

        # The issue code associated with the log message (optional).
        [Parameter()]
        [Alias('Code')]
        [string]$IssueCode,

        # If set, does not update the job status (optional).
        [Parameter()]
        [switch] $DoNotUpdateJobStatus
    )

    $LogType = $LogType.ToLower()
    $color = 'White'

    if ((Test-PipelineContext)) {
        $prefix = "##[$LogType] "
    }
    else {
        switch($LogType) {
            "error" { $color = 'Red' }
            "warning" { $color = 'Yellow' }
            "info" { $color = 'LightGray' }
            "debug" { $color = 'DarkGray' }
            "command" { $color = 'Cyan' }
        }
    }

    $isIssue = ($LogType -eq 'error' -or $LogType -eq 'warning')

    if ($DoNotUpdateJobStatus.IsPresent -or (-not $isIssue)) {
        Write-Host "${prefix}$Message" -ForegroundColor $color
        return
    }
    
    $properties = ''

    if ($SourcePath) { $properties += ";sourcepath=$SourcePath" }
    if ($LineNumber) { $properties += ";linenumber=$LineNumber" }
    if ($ColumnNumber) { $properties += ";columnnumber=$ColumnNumber" }
    if ($IssueCode) { $properties += ";code=$IssueCode" }

    $global:_task_status = 'SucceededWithIssues'
    Write-Host "##vso[task.logissue type=$LogType$properties]$Message"
}

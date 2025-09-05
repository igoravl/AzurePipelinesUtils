<#
.SYNOPSIS
    Writes a log message to the Azure Pipelines log or console.

.DESCRIPTION
    This advanced function logs messages of type Warning, Error, Info, or Debug to Azure Pipelines or the console. It supports additional metadata such as source file, line, column, and issue code, and can optionally prevent updating the job status. The function is intended for use in CI/CD scenarios to provide rich, contextual logging.

.EXAMPLE
    _WriteLog -Message "An error occurred." -LogType Error
    # Logs an error message to the Azure Pipelines log.

.EXAMPLE
    _WriteLog -Message "File not found." -LogType Warning -SourcePath "src/app.ps1" -LineNumber 42
    # Logs a warning message with source file and line number metadata.

.EXAMPLE
    _WriteLog -Message "Debugging info." -LogType Debug -UpdateTaskStatus
    # Logs a debug message and does not update the job status.

.NOTES
    Author: igoravl
    Date: August 29, 2025
    This function is intended for use in Azure Pipelines and supports rich logging features for CI/CD automation.
#>
function _WriteLog {
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

        # If set, shows the message in the pipeline job summary (optional).
        [Parameter()]
        [switch] $ShowInSummary,

        # If set, does not update the job status (optional).
        [Parameter()]
        [switch] $UpdateTaskStatus
    )

    $LogType = $LogType.ToLower()
    $cmdArgs = @{
        Object = $Message
        ForegroundColor = $null
    }

    if ((_TestPipelineContext)) {
        $prefix = "##[$LogType] "
    }
    else {
        $cmdArgs.ForegroundColor = switch($LogType) {
            "error" { 'Red' }
            "warning" { 'Yellow' }
            "info" { 'LightGray' }
            "debug" { 'DarkGray' }
            "command" { 'Cyan' }
        }
    }

    $isIssue = ($LogType -eq 'error' -or $LogType -eq 'warning')

    if ((-not $isIssue) -and (-not ($UpdateTaskStatus.IsPresent -or $ShowInSummary.IsPresent))) {
        Write-Host @cmdArgs
        return
    }
    
    $properties = ''
    if ($SourcePath) { $properties += ";sourcepath=$SourcePath" }
    if ($LineNumber) { $properties += ";linenumber=$LineNumber" }
    if ($ColumnNumber) { $properties += ";columnnumber=$ColumnNumber" }
    if ($IssueCode) { $properties += ";code=$IssueCode" }

    # Update tasks status only for errors and warnings, and only if UpdateTaskStatus is also specified
    if(($global:_task_status -eq 'Succeeded') -and $UpdateTaskStatus.IsPresent) {
        $global:_task_status = switch($LogType) {
            "error" { 'Failed' }
            "warning" { 'SucceededWithIssues' }
            default { $global:_task_status }
        }
    }

    Write-Host "##vso[task.logissue type=$LogType$properties]$Message"

    if(($LogType -eq 'error') -and ($ErrorActionPreference -eq 'Stop')) {
        exit 1
    }
}

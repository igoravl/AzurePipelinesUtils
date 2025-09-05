function Write-PipelineError {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [string]$SourcePath,
        
        [Parameter(Mandatory = $false)]
        [int]$LineNumber
    )
    
    if ((_TestPipelineContext)) {
        $prefix = '##[warning] ' 
    }
    
    if ($UpdateTaskStatus.IsPresent) {
        Write-Host "${prefix}$Message" -ForegroundColor Yellow
        return
    }
    
    $properties = ''

    if ($SourcePath) { $properties += ";sourcepath=$SourcePath" }
    if ($LineNumber) { $properties += ";linenumber=$LineNumber" }

    Write-Host "##vso[task.logissue type=error$properties]$Message"
}

# Alias
if (_TestPipelineContext) {
    Set-Alias -Name 'Write-Error' -Value 'Write-PipelineError' -Force -Scope Global
}
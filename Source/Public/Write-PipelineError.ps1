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

    Write-Host "##vso[task.logissue type=error$properties]$Message"
}

# Alias
Set-Alias -Name 'Write-Error' -Value 'Write-PipelineError' -Force -Scope Global
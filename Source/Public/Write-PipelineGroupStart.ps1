Function Write-PipelineGroupStart($Text) {
    if (-not [string]::IsNullOrWhiteSpace($Text)) {
        $timestamp = "[$(Get-Date -Format 'HH:mm:ss.fff')] "
    }
    
    Write-Host "##[group]${timestamp}$Text"
}

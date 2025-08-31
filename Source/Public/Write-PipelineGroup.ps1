Function Write-PipelineGroup {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        $Header,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Body
    )

    Write-PipelineGroupBegin $Header

    (& $Body) | ForEach-Object { Write-Log $_ }

    Write-PipelineGroupEnd
}

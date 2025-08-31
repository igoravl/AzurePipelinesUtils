
<#
.SYNOPSIS
Writes a section header to the Azure Pipelines log output.

.DESCRIPTION
This function emits a formatted section header in the Azure Pipelines log, optionally boxed, using the special logging command for sections. It is useful for visually grouping related log output in pipeline runs.

.EXAMPLE
Write-PipelineSection -Text "Build started"
Writes a section header labeled "Build started" to the pipeline log.

.EXAMPLE
Write-PipelineSection -Text "Tests" -Boxed
Writes a boxed section header labeled "Tests" to the pipeline log.

.NOTES
Requires execution within an Azure Pipelines agent environment to have effect in the log output.
#>
Function Write-PipelineSection {
    [CmdletBinding()]
    Param (
        # The text to display as the section header in the pipeline log.
        [Parameter(Mandatory = $true)]
        [string]$Text,

        # If specified, draws a box around the section header.
        [Parameter(Mandatory = $false)]
        [switch]$Boxed
    )

    $msg = "== $Text =="
    $box = "`n"

    if ((Test-PipelineContext)) {
        $prefix = '##[section]'
    }

    if ($Boxed) {
        $box += ("${prefix}$('=' * $msg.Length)`n")
    }    

    Write-Host "${box}${prefix}$msg${box}" -ForegroundColor Cyan
}

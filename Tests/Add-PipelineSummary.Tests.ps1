try {
    $built = Join-Path $PSScriptRoot '../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1'
    if (Test-Path $built) { Import-Module $built -Force } else { Import-Module (Join-Path $PSScriptRoot '../Source/AzurePipelinesUtils.psd1') -Force }
}
catch { Write-Error "Failed to import module: $_"; throw }

Describe 'Add-PipelineSummary' {
    It 'writes summary content (non-pipeline context)' {
        $out = Add-PipelineSummary -Content '# Hello'
    $out | Should -Be $null
    }
}

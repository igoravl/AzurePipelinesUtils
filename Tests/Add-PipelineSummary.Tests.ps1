Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Add-PipelineSummary' {
    It 'writes summary content (non-pipeline context)' {
        $out = Add-PipelineSummary -Content '# Hello'
        $out | Should Be $null
    }
}
